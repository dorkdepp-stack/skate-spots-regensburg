import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/convo.dart';
import '../models/forum.dart';
import '../models/spot.dart';

/// Ported from `state.screen` — which full-screen (or overlay) is showing.
enum AppScreen { map, spots, spot, form, forum, thread, messages }

/// Ported from the bottom-nav `tabs[].key` — which tab is highlighted.
enum AppTab { you, inbox, spots, map, forum }

/// One-to-one port of the DC `class Component extends DCLogic { state = {...} }`
/// plus its `renderVals()` computed getters and event handlers.
class AppState extends ChangeNotifier {
  AppState() {
    spots = buildMockSpots();
    threads = buildMockThreads();
    posts = buildMockPosts();
    convos = buildMockConvos();
  }

  // ── state ────────────────────────────────────────────────────────
  AppScreen screen = AppScreen.map;
  AppTab tab = AppTab.map;
  String sel = 's1';
  String filter = 'all';
  String board = 'All';

  bool placing = false;
  (double, double)? draft;
  bool editing = false;
  String mapLayer = 'sat'; // 'sat' | 'street'

  String fName = '';
  List<String> fTags = ['ledge'];
  String fBeta = '';
  bool fPriv = false;

  String threadId = 't1';
  String reply = '';

  bool camera = false;
  String? camTarget;
  bool camError = false;
  List<String> shots = [];

  late List<Spot> spots;
  late List<ForumThread> threads;
  late List<Post> posts;
  late List<Convo> convos;

  // ── derived helpers (ported from Component methods) ────────────────
  Spot get selectedSpot =>
      spots.firstWhere((x) => x.id == sel, orElse: () => spots.first);

  List<Spot> get visibleSpots => spots
      .where((x) => filter == 'all' || x.tags.contains(filter))
      .toList();

  ForumThread get currentThread =>
      threads.firstWhere((t) => t.id == threadId, orElse: () => threads.first);

  List<ForumThread> get visibleThreads =>
      threads.where((t) => board == 'All' || t.tag == board).toList();

  static const double _centerLat = 49.0205;
  static const double _centerLng = 12.0965;

  /// `dist(x)` — haversine distance from the Regensburg Altstadt center.
  String distanceLabel(Spot s) {
    const r = 6371.0;
    final dLa = (s.lat - _centerLat) * math.pi / 180;
    final dLo = (s.lng - _centerLng) * math.pi / 180;
    final a = math.pow(math.sin(dLa / 2), 2) +
        math.cos(_centerLat * math.pi / 180) *
            math.cos(s.lat * math.pi / 180) *
            math.pow(math.sin(dLo / 2), 2);
    final km = 2 * r * math.asin(math.sqrt(a));
    return '${km.toStringAsFixed(1)} km';
  }

  /// `coordStr(lat, lng)`.
  String coordStr(double lat, double lng) =>
      '${lat.toStringAsFixed(5)} N · ${lng.toStringAsFixed(5)} E';

  String photoFor(Spot s) =>
      s.photos.isNotEmpty ? s.photos.first : photoFor2(spots.indexOf(s));

  String photoFor2(int i) => photoCycle[i % photoCycle.length];

  String avatarFor(int i) => avatarCycle[i % avatarCycle.length];

  /// `chip(on)` colors — {bg, fg, br}.
  ({Color bg, Color fg, Color br}) chip(bool on) {
    if (on) return (bg: kGColor, fg: kKColor, br: kGColor);
    return (bg: kKColor, fg: kGColor, br: kMidColor);
  }

  // ── navigation ───────────────────────────────────────────────────
  void go(AppScreen next, {AppTab? tabOverride}) {
    screen = next;
    if (tabOverride != null) tab = tabOverride;
    notifyListeners();
  }

  void openSpot(String id) {
    sel = id;
    screen = AppScreen.spot;
    notifyListeners();
  }

  void openThread(String id) {
    threadId = id;
    screen = AppScreen.thread;
    notifyListeners();
  }

  /// `back: () => screen === 'thread' ? 'forum' : (tab === 'spots' ? 'spots' : 'map')`
  void back() {
    if (screen == AppScreen.thread) {
      screen = AppScreen.forum;
    } else {
      screen = tab == AppTab.spots ? AppScreen.spots : AppScreen.map;
    }
    notifyListeners();
  }

  void selectTab(AppTab t, AppScreen s) {
    tab = t;
    screen = s;
    notifyListeners();
  }

  void pickFilter(String f) {
    filter = f;
    notifyListeners();
  }

  void pickBoard(String b) {
    board = b;
    notifyListeners();
  }

  void toggleLayer() {
    mapLayer = mapLayer == 'sat' ? 'street' : 'sat';
    notifyListeners();
  }

  // ── placing / add / edit ────────────────────────────────────────
  void startPlace() {
    screen = AppScreen.map;
    tab = AppTab.map;
    placing = true;
    editing = false;
    fName = '';
    fBeta = '';
    fTags = ['ledge'];
    fPriv = false;
    shots = [];
    camTarget = null;
    notifyListeners();
  }

  void cancelPlace() {
    placing = false;
    notifyListeners();
  }

  /// Map tap while placing — `if (d.sm === 'tap' && this.state.placing)`.
  void onMapTap(double lat, double lng) {
    if (!placing) return;
    placing = false;
    screen = AppScreen.form;
    draft = (lat, lng);
    notifyListeners();
  }

  void openEdit() {
    final s = selectedSpot;
    screen = AppScreen.form;
    editing = true;
    fName = s.name;
    fTags = List.of(s.tags);
    fBeta = s.beta;
    shots = [];
    notifyListeners();
  }

  void setName(String v) {
    fName = v;
    notifyListeners();
  }

  void setBeta(String v) {
    fBeta = v;
    notifyListeners();
  }

  void toggleTag(String k) {
    fTags = fTags.contains(k)
        ? fTags.where((x) => x != k).toList()
        : [...fTags, k];
    notifyListeners();
  }

  void togglePrivate() {
    fPriv = !fPriv;
    notifyListeners();
  }

  void cancelForm() {
    screen = editing ? AppScreen.spot : AppScreen.map;
    draft = null;
    editing = false;
    notifyListeners();
  }

  void saveSpot() {
    final s = selectedSpot;
    if (editing) {
      spots = spots
          .map((x) => x.id == s.id
              ? x.copyWith(
                  name: fName.isNotEmpty ? fName : x.name,
                  tags: List.of(fTags),
                  beta: fBeta.isNotEmpty ? fBeta : x.beta,
                  edits: x.edits + 1,
                  lastEditor: 'you',
                  photos: [...shots, ...x.photos],
                )
              : x)
          .toList();
      screen = AppScreen.spot;
      editing = false;
      shots = [];
    } else {
      final id = 'n${DateTime.now().millisecondsSinceEpoch}';
      final d = draft ?? (_centerLat, _centerLng);
      spots = [
        ...spots,
        Spot(
          id: id,
          name: fName.isNotEmpty ? fName : 'untitled spot',
          tags: List.of(fTags),
          lat: d.$1,
          lng: d.$2,
          status: 'ok',
          by: 'you',
          edits: 1,
          photos: List.of(shots),
          coords: coordStr(d.$1, d.$2),
          confirmed: 'just now',
          lastEditor: 'you',
          beta: fBeta.isNotEmpty
              ? fBeta
              : 'no notes yet — add the surface, run-up and bust risk so the next person knows.',
          specs: const [
            ('surface', '—'),
            ('run-up', '—'),
            ('best hours', '—'),
            ('lighting', '—'),
          ],
        ),
      ];
      sel = id;
      draft = null;
      shots = [];
      screen = AppScreen.spot;
    }
    notifyListeners();
  }

  void setStatus(String key) {
    final s = selectedSpot;
    spots = spots
        .map((x) => x.id == s.id
            ? x.copyWith(status: key, confirmed: 'just now', edits: x.edits + 1)
            : x)
        .toList();
    notifyListeners();
  }

  // ── camera ───────────────────────────────────────────────────────
  void openCamera() {
    camera = true;
    camTarget = null;
    notifyListeners();
  }

  void openSpotCamera(String spotId) {
    camera = true;
    camTarget = spotId;
    shots = [];
    notifyListeners();
  }

  void closeCamera() {
    camera = false;
    notifyListeners();
  }

  void setCamError(bool v) {
    camError = v;
    notifyListeners();
  }

  /// `shutter()` once a photo file path has been produced by the camera.
  void addShot(String path) {
    if (camTarget != null) {
      spots = spots
          .map((x) => x.id == camTarget
              ? x.copyWith(
                  photos: [path, ...x.photos],
                  edits: x.edits + 1,
                  lastEditor: 'you',
                )
              : x)
          .toList();
    }
    shots = [path, ...shots];
    notifyListeners();
  }

  void removeShot(int i) {
    shots = [for (var j = 0; j < shots.length; j++) if (j != i) shots[j]];
    notifyListeners();
  }

  void doneCamera() {
    camera = false;
    notifyListeners();
  }

  // ── forum ────────────────────────────────────────────────────────
  void goThread() => openThread('t1');

  void setReply(String v) {
    reply = v;
    notifyListeners();
  }

  void sendReply() {
    if (reply.trim().isEmpty) return;
    posts = [
      ...posts,
      Post(who: 'you', when: 'now', likes: 0, text: reply.trim()),
    ];
    reply = '';
    notifyListeners();
  }
}

// Re-exported so app_state.dart has no import cycle back into theme.dart
// for the tiny bit of color logic `chip()` needs.
const Color kGColor = Color(0xFFD9D9D9);
const Color kKColor = Color(0xFF000000);
const Color kMidColor = Color(0xFF7C7C7C);
