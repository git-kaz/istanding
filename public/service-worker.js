self.addEventListener('push', function (event) {
    //サーバーからのJSONを取得
    const data = event.data ? event.data.json() : {}
    
    const title = data.title || '休憩時間になりました！'

    //通知の詳細オプション
    const options = {
        body: data.body || '身体を動かしましょう！',
        icon: 'icon.png',
        data: { url: data.url || '/' }//通知をクリックした遷移先url
    }

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