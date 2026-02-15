self.addEventListener('push', function (event) {
    
    
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
    //通知のurl
    const rootUrl = new URL('/', self.location.origin).href
    const urlToOpen = new URL(event.notification.data.url || '/', self.location.origin).href;
    //指定されたurlを開く
    event.waitUntil(
        //開いているブラウザのタブを確認
        clients.matchAll({ type: 'window', includeUncontrolled: true })
            .then(function (windowClients) {
                //アプリのタブを探す
                for (let i = 0; i < windowClients.length; i++) {
                    const client = windowClients[i]

                    if (client.url.startsWith(rootUrl) && 'focus' in client) {
                        //あればフォーカス
                        return client.focus()
                    }
                }
                //なければ新しいタブを開く
                if (clients.openWindow) {
                    return clients.openWindow(urlToOpen)
                }
        })
    )
})