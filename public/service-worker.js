self.addEventListener('push', function (event) {
    console.log('Push received!');
    
    let data = {};
    if (event.data) {
        try {
            // まずはJSONとして解析を試みる
            data = event.data.json();
        } catch (e) {
            // JSONでなければ、そのままテキストとしてbodyに格納
            data = { body: event.data.text() };
        }
    }
    
    const title = data.title || '休憩時間になりました！';

    const options = {
        body: data.body || '身体を動かしましょう！',
        icon: new URL('/icon.png', self.location.origin).href,
        // RailsからURLが指定されていなければ、トップページを表示
        data: { url: data.url || '/' }
    };

    //通知を表示するまでservice workerを終了させない
    event.waitUntil(
        self.registration.showNotification(title, options)
    )
})

//通知をクリックしたら発火
self.addEventListener('notificationclick', function (event) {
    event.notification.close()
    //指定されたurlを開く
    event.waitUntil(clients.openWindow(event.notification.data.url))
})