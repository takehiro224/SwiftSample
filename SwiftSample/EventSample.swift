//
//  EventSample.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/05/30.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation

/* 
 [ Notification ]
 ・名前付きのメッセージを送受信する仕組み
 ・オブザーバパターン: 状態変化を別オブジェクトへ通知する
 ・1つのイベントの結果を複数のオブジェクトが知る必要がある場合に有用
 (1)通知を受け取るオブジェクトにNotification型の値を引数に持つメソッドを実装する
 (2)NotificationCenterクラスに通知を受け取るオブジェクトを登録する
 (3)NotificationCenterクラスに通知を投稿する
 */
class Poster { //通知を発生させる
    static let notificationName = Notification.Name("SomeNotification")
    func post() {
        //(3)通知を投稿する
        NotificationCenter.default.post(name: Poster.notificationName, object: nil)
    }
}
class Observer { //通知を受け取る
    init() {
        //(2)通知を受け取るオブジェクトを登録する
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(_:)),
                                               name: Poster.notificationName,
                                               object: nil)
        
        NotificationCenter.default.addObserver(forName: .apiLoadComplete,
                                               object: nil,
                                               queue: nil,
                                               using: { notification in})
        
        NotificationCenter.default.addObserver(forName: .apiLoadStart,
                                               object: nil,
                                               queue: nil) {
                                                (notification) -> Void in
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //(1)通知を受け取った際の処理
    @objc func handleNotification(_ notification: Notification) {
        print("通知を受け取りました")
    }
    
    let receiveNotification = {(_ notification: Notification) in
    }
}


//
public extension Notification.Name {
    //読み込み開始Notification
    public static let apiLoadStart = Notification.Name("ApiLoadStart")
    //読み込み完了Notification
    public static let apiLoadComplete = Notification.Name("ApiLoadComplete")
}

class NotificationPostSameple {
    func start() {
        NotificationCenter.default.post(name: .apiLoadStart, object: nil)
    }
    func endFail() {
        NotificationCenter.default.post(name: .apiLoadComplete, object: nil, userInfo: ["error": "errorMsg"])
    }
    func endSuccess() {
        NotificationCenter.default.post(name: .apiLoadComplete, object: nil)
    }
}

class NotificationReceive {
    var loadDataObserver: NSObjectProtocol?
    var refreshObserver: NSObjectProtocol?
}
