import '../models/convo.dart';
import '../models/forum.dart';
import '../models/spot.dart';

/// Regensburg, Germany mock data — ported verbatim from the
/// `state.spots` / `state.threads` / `state.posts` / `state.convos`
/// arrays in SpotApp Sharpie.dc.html.

List<Spot> buildMockSpots() => [
      Spot(
        id: 's1',
        name: 'Donaumarkt ledges',
        tags: const ['ledge', 'slappy', 'hangout'],
        lat: 49.02255,
        lng: 12.09985,
        status: 'ok',
        by: 'lena.h',
        edits: 12,
        coords: '49.02255 N · 12.09985 E',
        confirmed: '2 days ago',
        lastEditor: 'basti_rgb',
        beta:
            'Four granite ledges by the museum, knee height, waxed. Smooth run-up from the river side; the south end has a drain you will feel. Museum staff only mind it during opening hours.',
        specs: const [
          ('surface', 'polished granite'),
          ('run-up', '12 m, flat'),
          ('best hours', 'after 18:00'),
          ('lighting', 'street-lit'),
        ],
      ),
      Spot(
        id: 's2',
        name: 'Dultplatz banks',
        tags: const ['bank', 'gap'],
        lat: 49.02594,
        lng: 12.09772,
        status: 'watch',
        by: 'j_wagner',
        edits: 7,
        coords: '49.02594 N · 12.09772 E',
        confirmed: '5 hours ago',
        lastEditor: 'lena.h',
        beta:
            'Two brick banks into a flat wall in Stadtamhof. Bricks loose at the top right. Fenced off for the Dult and for markets — check the board before you ride out.',
        specs: const [
          ('surface', 'brick, patched'),
          ('run-up', '6 m, downhill'),
          ('best hours', 'weekends'),
          ('lighting', 'none'),
        ],
      ),
      Spot(
        id: 's3',
        name: 'Arnulfsplatz rail',
        tags: const ['rail', 'curb'],
        lat: 49.01924,
        lng: 12.08927,
        status: 'closed',
        by: 'tobi.k',
        edits: 21,
        coords: '49.01924 N · 12.08927 E',
        confirmed: 'yesterday',
        lastEditor: 'tobi.k',
        beta:
            'Skate stoppers welded on in March. Kept here for the record and for anyone tracking the city’s stoppers — do not ride out for it.',
        specs: const [
          ('surface', 'round steel'),
          ('run-up', '8 m'),
          ('best hours', '—'),
          ('lighting', 'overhead'),
        ],
      ),
      Spot(
        id: 's4',
        name: 'Jahninsel bench + tap',
        tags: const ['hangout', 'dork stuff'],
        lat: 49.02261,
        lng: 12.09231,
        status: 'ok',
        by: 'community',
        edits: 3,
        coords: '49.02261 N · 12.09231 E',
        confirmed: 'last week',
        lastEditor: 'mira.s',
        beta:
            'Drinking tap runs from April to October, benches and shade under the trees. Default meet point before a session on the island.',
        specs: const [
          ('type', 'tap + benches'),
          ('access', 'public'),
          ('best hours', 'daylight'),
          ('lighting', 'park lamp'),
        ],
      ),
      Spot(
        id: 's5',
        name: 'Ostentor gap',
        tags: const ['gap', 'manny pad'],
        lat: 49.01836,
        lng: 12.10322,
        status: 'ok',
        by: 'basti_rgb',
        edits: 9,
        coords: '49.01836 N · 12.10322 E',
        confirmed: '3 days ago',
        lastEditor: 'basti_rgb',
        beta:
            'Three-stair gap over a planter, landing resurfaced in June. Bikes cut through from the Ostengasse — post a spotter.',
        specs: const [
          ('surface', 'asphalt'),
          ('run-up', '15 m'),
          ('best hours', 'sunday am'),
          ('lighting', 'street-lit'),
        ],
      ),
    ];

List<ForumThread> buildMockThreads() => [
      ForumThread(
        id: 't1',
        tag: 'City',
        title: 'stoppers in the altstadt — what is still standing?',
        by: 'tobi.k',
        when: '2h',
        replies: 34,
        likes: 121,
      ),
      ForumThread(
        id: 't2',
        tag: 'Gear',
        title: 'wheels for altstadt cobbles — soft enough, still fast?',
        by: 'mira.s',
        when: '5h',
        replies: 18,
        likes: 44,
      ),
      ForumThread(
        id: 't3',
        tag: 'Sessions',
        title: 'saturday 10:00, donaumarkt — all levels',
        by: 'lena.h',
        when: '1d',
        replies: 52,
        likes: 88,
      ),
      ForumThread(
        id: 't4',
        tag: 'Builds',
        title: 'diy quarter pipe under the nibelungenbrücke: permit or not?',
        by: 'basti_rgb',
        when: '2d',
        replies: 27,
        likes: 60,
      ),
      ForumThread(
        id: 't5',
        tag: 'Buy / sell',
        title: 'selling an 8.25 complete, barely ridden',
        by: 'j_wagner',
        when: '3d',
        replies: 6,
        likes: 9,
      ),
    ];

List<Post> buildMockPosts() => [
      Post(
        who: 'tobi.k',
        when: '2h',
        op: true,
        likes: 41,
        text:
            'Rode a loop from the Steinerne Brücke down to the Ostentor. Arnulfsplatz is stoppered, the ledges at the museum survived. Adding what I saw to the map now.',
        spot: 'Arnulfsplatz rail',
      ),
      Post(
        who: 'lena.h',
        when: '1h',
        likes: 12,
        text: 'Donaumarkt is untouched. Re-confirmed the status this morning.',
      ),
      Post(
        who: 'mira.s',
        when: '52m',
        likes: 5,
        text:
            'Anyone checked the banks? Last time there was a fence up for the market.',
      ),
      Post(
        who: 'basti_rgb',
        when: '30m',
        likes: 8,
        text:
            'Fence is down. Bricks still loose top right, so I marked it bust risk rather than knobbed.',
        spot: 'Dultplatz banks',
      ),
    ];

List<Convo> buildMockConvos() => [
      Convo(
        who: 'lena.h',
        when: '9:41',
        last: 'donaumarkt at 10, bring the wide angle',
        unread: true,
      ),
      Convo(
        who: 'regensburg ledges crew',
        when: '9:02',
        last: 'basti_rgb: added three photos to ostentor gap',
        unread: true,
      ),
      Convo(
        who: 'tobi.k',
        when: 'yst',
        last: 'sent you the stopper overlay for the altstadt',
      ),
      Convo(
        who: 'mira.s',
        when: 'yst',
        last: 'jahninsel is a good meet point, agreed',
      ),
      Convo(
        who: 'j_wagner',
        when: 'mon',
        last: 'board is still available if you want it',
      ),
      Convo(
        who: 'mods',
        when: 'sun',
        last: 'your edit to arnulfsplatz rail was approved',
      ),
    ];

const List<String> boardNames = [
  'All',
  'City',
  'Gear',
  'Sessions',
  'Builds',
  'Buy / sell',
];

/// `av(i)` — avatar cycle.
const List<String> avatarCycle = [
  'assets/images/ph-2.png',
  'assets/images/ph-4.png',
  'assets/images/ph-3.jpg',
  'assets/images/ph-6.jpg',
  'assets/images/ph-1.jpg',
  'assets/images/ph-7.png',
];

/// `photo(i)` — spot photo cycle.
const List<String> photoCycle = [
  'assets/images/ph-5.png',
  'assets/images/ph-1.jpg',
  'assets/images/ph-7.png',
  'assets/images/ph-6.jpg',
  'assets/images/ph-3.jpg',
];

String avatarFor(int i) => avatarCycle[i % avatarCycle.length];
String photoFor(int i) => photoCycle[i % photoCycle.length];
