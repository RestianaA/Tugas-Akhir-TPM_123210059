// Import workbox untuk caching dan strategi routing
importScripts('https://storage.googleapis.com/workbox-cdn/releases/5.1.2/workbox-sw.js');

// Cek jika workbox berhasil dimuat
if (workbox) {
  console.log(`Workbox berhasil dimuat.`);

  // Konfigurasi cache
  workbox.routing.registerRoute(
    ({request}) => request.destination === 'script' ||
                   request.destination === 'style' ||
                   request.destination === 'font',
    new workbox.strategies.CacheFirst()
  );

  // Menangani pesan notifikasi
  self.addEventListener('push', (event) => {
    const payload = event.data ? event.data.text() : 'no payload';
    event.waitUntil(
      self.registration.showNotification('Tweet Sent!', {
        body: payload,
      })
    );
  });
} else {
  console.log(`Workbox gagal dimuat.`);
}
