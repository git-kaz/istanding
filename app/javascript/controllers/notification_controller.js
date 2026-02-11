import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notification"
export default class extends Controller {
  static values = { publicKey: String }

  connect() {
    //許可、拒否済みの場合は通知を確認しない
    if (Notification.permission === 'default') {
      //すこし遅らせてから通知
      setTimeout(() => {
        this.subscribe()
      }, 1000)
    }
  }


  async subscribe() {
    console.log("Starting subscribe...");
    try {
      
      await navigator.serviceWorker.register('/service-worker.js');
      
      const registration = await navigator.serviceWorker.ready
      
      const convertedVapidKey = this.#urlBase64ToUint8Array(this.publicKeyValue)

      const subscription = await registration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: convertedVapidKey
      })

      await this.#sendSubscriptionToServer(subscription)
      console.log("Push通知が有効になりました")
    } catch (error) {
      console.error("Push購読に失敗しました")
      alert("通知許可ができませんした。ブラウザの設定を確認してください")
    }
  }
  //サーバーへajaxで情報送信
  async #sendSubscriptionToServer(subscription) {
    const response = await fetch("/sitting_sessions/subscribe", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        subscription: subscription.toJSON()
      })
    })
    return response
  }

  // 鍵の変換関数
  #urlBase64ToUint8Array(base64String) {
    const padding = '='.repeat((4 - base64String.length % 4) % 4);
    const base64 = (base64String + padding)
      .replace(/-/g, '+')
      .replace(/_/g, '/');

    const rawData = window.atob(base64);
    const outputArray = new Uint8Array(rawData.length);

    for (let i = 0; i < rawData.length; ++i) {
      outputArray[i] = rawData.charCodeAt(i);
    }
    return outputArray;
  }
}
