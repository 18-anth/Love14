'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "bf3386e3189a518a7f1b3e9012dba187",
"version.json": "fbfdd3379cb9d9dd2cd91034b82ee9f3",
"index.html": "a149889f3d00eff850be382a9487c7ca",
"/": "a149889f3d00eff850be382a9487c7ca",
"main.dart.js": "6ff2265a5e77c9ffd7440575c0d06a35",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"git.txt": "99be3a67bb031a343449c5fde92a5142",
"README.md": "ed3734612a624cb2f484d4d32d085e43",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "48626e2ca2fd488641a776e87016cb6b",
"icons/Icon-maskable-192.png": "48626e2ca2fd488641a776e87016cb6b",
"icons/Icon-maskable-512.png": "b6ba30826241cda81255cd58a62f1c76",
"icons/image.png": "15f36083b07f337c6942460c35e962c7",
"icons/Icon-512.png": "b6ba30826241cda81255cd58a62f1c76",
"manifest.json": "83728e31b21aa970ef8e950df8ba499b",
".git/config": "e446b0857d9bd3c0fe2c4e10b122c079",
".git/objects/0c/bca88584fa4b9cc07332a5a73123b58b5e4cae": "53e509d54b290456fd48887874ea0109",
".git/objects/68/abbe6b945c888d5098b3a6ac62c26511939f69": "527d25d956ef015a24d151e785893e44",
".git/objects/9b/d3accc7e6a1485f4b1ddfbeeaae04e67e121d8": "dc1d3b6ac68817e26c52a2b7aca98a10",
".git/objects/3d/3f7d3a511f11688a16deff9522c80fbd810b4e": "20d11f2e72722c129dd2a2ac37ae9590",
".git/objects/34/3b9c4db1fef22238d0c601f65031db43fa282b": "7a44477481dd9ab88c13f0b67c9a5230",
".git/objects/ad/2f90b78480aeb6608226d9db4ecbd3ec06aaeb": "5110ec697534feee9d97421c47d78964",
".git/objects/d7/962e3c80507fa982765b5970ee3b412454c16f": "8726ff74b1d4903f25572c179037331e",
".git/objects/d0/0b945a5bfa7405eb6999e916102cc50b10f949": "76346cb09653d684fd3f411cd7a3d4b5",
".git/objects/a5/b453e8e5913b22af7e37c8957427a37c96c512": "62fb6327f29ba6b7d7729c2c887caf48",
".git/objects/c7/03dd3b2eca0a40cbdc4af7f60b7a54bb8eb247": "e1cbd762191a374ae8a1a8f54131b5c5",
".git/objects/ee/0e319c5539dbb17d9167d3b7194b5e1a963b42": "ab44c9734516beeebec6230aeae5d2ce",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "aa30b45014e5ab878c26ecce9ea89743",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "fb2ee964a7fc17b8cba79171cb799fa3",
".git/objects/c8/08fb85f7e1f0bf2055866aed144791a1409207": "0c4bbf647e92f25144f535178c7f7f15",
".git/objects/7d/c169c2580b02569aaa28c29e810c9e7d21517a": "e31133ec51cad8fe37a002decbd42e29",
".git/objects/1f/984480b298b60e9f5009c9490ca04cf5a08d4e": "2ca240ec510e2c328a73039d7517044a",
".git/objects/73/c63bcf89a317ff882ba74ecb132b01c374a66f": "e14aa589bb7e68e3a524c297a802bde9",
".git/objects/1a/d7683b343914430a62157ebf451b9b2aa95cac": "dee38288e294701bf8f665ae546a43e3",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "b25b26893b8f92a4f583677ba27f0a7f",
".git/objects/86/6501a22de88d046af5e729672970a7252fef16": "24082441a44d68017ca35626b7241a35",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "9524d053d0586a5f9416552b0602a196",
".git/objects/07/b447e1030ee951ce5344ed755f59d431abb708": "3ccd135a41fcc2dd5dc780d6953eb077",
".git/objects/6e/da2975c81076cfac0ec852205af45f38d1f61f": "492cb106b5b644bf8d00a93b5195f04e",
".git/objects/09/b1262c25eb013e1d1a8a12bc7cd6f139ea38e4": "c4b6db51d66905c2597ee8221a3487be",
".git/objects/53/18a6956a86af56edbf5d2c8fdd654bcc943e88": "23e8f7ce2c2856c1943e6cb51334416e",
".git/objects/53/3d2508cc1abb665366c7c8368963561d8c24e0": "6d57e2d4816384a5236f4a52d9f1014b",
".git/objects/37/104ea5b02f786a554d56763ac676e34f5ffe4c": "2d545ee40b21844f7a49a5a0ade9524f",
".git/objects/37/21ff64034cda4d0ee4f8c1f941155b602951c8": "2ccbdad9fd8db9a8b646cc79869eb0bd",
".git/objects/0a/1286d9b580d35af1d35307b02fef88cadea24e": "87a6c8357a675b551369a310922fc63f",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "9dbf5b01e391c548c8343be8d1d4b04e",
".git/objects/dd/5edb1a7e46855a8138b7028913a7aed7e07a26": "6e9c97fa8e93a6aa5ba45802bd0c8331",
".git/objects/dc/508baf399cfbea32f51b9542fe69f91cfae884": "32bd74a0b35702588e7b68155321149b",
".git/objects/dc/11fdb45a686de35a7f8c24f3ac5f134761b8a9": "6a4baf0ee5d7f24d01892e880c87e9b5",
".git/objects/a9/91f51138ffe059d588003dc7936aff059a0428": "eb3281696880d690bdce53639613dde5",
".git/objects/d5/eb49fb0996dfb0ea8a9e48a1c8e5fb5ffc3b99": "574b7fdbc9f43d1d3aa937892ca4bb73",
".git/objects/d5/e5e511aa7aabacb375b8c9d37d7e7499ed8d3f": "34e9e576c470abb9f498c4f6836ba00b",
".git/objects/b9/6a5236065a6c0fb7193cb2bb2f538b2d7b4788": "a488dd5b768f3e95bb3ded676201c413",
".git/objects/a1/f77f91db47fcf0adbd3b2146932712376c9f61": "6d9db9e49673edc7d3abb076e3a46177",
".git/objects/cc/fab74c1f56c330985060e2247607eaedb3c7d7": "89d33e0dd661f2efa9067d9bb6202d62",
".git/objects/e6/e8753f1a22f7d39fb8dd31d4ff295dc9b362a9": "d1f0d655fd5bad6cef68c76fb4f2b206",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "c3694958e54483a81b3e32ab9f84ece2",
".git/objects/f1/d37be5a442a0f2795eb4118b767d9d84804f6d": "ee4e8b2e412dad4e6e957f321866d86e",
".git/objects/f1/5cf59cb838afb5e12331d1bdd4d928ceab035e": "83c6f6dba45333d47a5b6d2ca1bb96aa",
".git/objects/e0/7ac7b837115a3d31ed52874a73bd277791e6bf": "eaf69ee68e07ccd33759fba4b5e36d4e",
".git/objects/2c/6777d2007491a35a39ce54057724d55497ea8e": "fca09a6e83585555e7b8af07ef74fe4f",
".git/objects/41/2132f1d96de1054cfae1a6bb28961c9baf6f89": "e1120968f7bd71be491503afa091450f",
".git/objects/1b/db4f497a62460b2a0efc6f3cd06fc5a85ae59e": "a620ba4808e365cdef558d80cdf4f907",
".git/objects/48/0c079177848ffa259b73a38e42067e35c83b8c": "bf208f8d7d149de0b578169733b341a8",
".git/objects/70/a234a3df0f8c93b4c4742536b997bf04980585": "6dc767ec6498faa598b6dd7d00386498",
".git/objects/70/a3b3cfcb1bbcce1fa85a38a9332b6e6e371706": "20f626d45eb3c9e3f81b2b860aa28f84",
".git/objects/4f/d2def6f249534ed4232a18c0699dbfb66eee3c": "61fbcf265ec49c401ee69aa570337e54",
".git/objects/12/0fed16d5278de902f810f00422ffd135ceeb26": "aaa295de78ea81d08aef9ce32869d7bc",
".git/objects/82/a87873c09aebe249adafba179227b9bdcb03fb": "495b571e8a625e2835d4089047c71194",
".git/objects/78/839c37a896929886ec8ccabbe7b4f89763f28c": "1395dc3a62fcc44b28b8f5daab306e75",
".git/objects/7f/f0ef229b6c1801fedc62e669470554ebb55faa": "2efbdd158b7b00068f381892590f8266",
".git/objects/7a/5da11cf0191e6649fa09020e33c127ec69bd56": "c560ad1b1722c41661677431f30b42ef",
".git/HEAD": "6bf18e9e3b6344d0dc431b44a76eb623",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "206107905e624185856a0df050e0345b",
".git/logs/refs/heads/proyecto": "4b6dc0e7a50074490f45f607e5ce916a",
".git/logs/refs/remotes/origin/proyecto": "f7730951a1a7a523faf8f73ed598c713",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/refs/heads/proyecto": "d252e9290f82b8c3751ac5862ed7b609",
".git/refs/remotes/origin/proyecto": "d252e9290f82b8c3751ac5862ed7b609",
".git/index": "03380eaabc6fd6ce8e0fa05a11c55519",
".git/COMMIT_EDITMSG": "a8297d555dd34879e8e48e1cf12acefa",
"assets/AssetManifest.json": "579b1ddc264ac2bf7a2d806767cb6a14",
"assets/NOTICES": "3c5557e82b822b64034b4b4febe751b8",
"assets/FontManifest.json": "1b1e7812d9eb9f666db8444d7dde1b20",
"assets/AssetManifest.bin.json": "a04907f37e5691968e93c4ad8c9302fb",
"assets/packages/material_design_icons_flutter/lib/fonts/materialdesignicons-webfont.ttf": "3759b2f7a51e83c64a58cfe07b96a8ee",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/flutter_3d_controller/assets/model_viewer.min.js": "11f3833db561a92ac9100cd43d28899b",
"assets/packages/flutter_3d_controller/assets/model_viewer_template.html": "d370dc1bc2b1dd29090c1946dbef646a",
"assets/packages/flutter_inappwebview_web/assets/web/web_support.js": "509ae636cfdd93e49b5a6eaf0f06d79f",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/model_viewer_plus/assets/model-viewer.min.js": "dd677b435b16f44e4ca08a9f354bac24",
"assets/packages/model_viewer_plus/assets/template.html": "8de94ff19fee64be3edffddb412ab63c",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "0dfc31d62ed6a59c0f950eba0805e3f4",
"assets/fonts/MaterialIcons-Regular.otf": "4956b6e580d8617b523730b40c067ca0",
"assets/assets/env.txt": "cd37c73018ca646aa146bbce1959153f",
"assets/assets/image/image.png": "15f36083b07f337c6942460c35e962c7",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
