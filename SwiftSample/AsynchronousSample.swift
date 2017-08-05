//
//  AsynchronousSample.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/07/25.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation

/**
 「非同期処理」
 => 実行中に別の処理を止めない処理のことを非同期処理と言う
 ・ある処理を行っている間に、その終了を待たずに別の処理を実行できる -> 処理の高速化
 ・Swiftでは「スレッド」を利用して非同期処理を実現する
 ・「マルチスレッド処理」複数のスレッドを使用して処理を並列に行うこと
 ・非同期処理を行う3つの方法
 (1)GCDを用いる方法(「非同期処理のための低レベルAPI群」スレッドを直接操作しなくても容易に非同期処理が行える)
 (2)Operation, OperationQueueクラスを用いる方法(「非同期処理を抽象化したクラス」GCDをFoundationとして提供)
 (3)Threadクラスを用いる方法(「手動でのスレッド管理」スレッドを直接操作)
 */




/**
 「GCD」Grand Central Dispatch
 ・非同期処理を容易にするためのC言語ベースの技術
 ・キューを通じて非同期処理を行う
 ・直接スレッドを管理することはない
 ・考えなくていい(並列数)(スケジューリング)(どの処理がどのスレッドで実行されるか)
 ・やること(タスクをキューへと追加することだけ)
 ・GCDのキューはディスパッチキューと呼ばれる
 
 ・ディスパッチキューの種類
  (1)直列ディスパッチキュー
   ・現在実行中の処理の終了を待ってから次の処理を実行する
  (2)並列ディスパッチキュー
   ・現在実行中の処理の終了を待たずに次の処理を並列して実行する
 */
import Dispatch
class Gcd {
    /**
     既存のディスパッチキューの取得
     ・1つのメインキューと、複数のグローバルキューがある
     ・UIの更新は常にメインキュー
     ・他のディスパッチキューで実行した非同期処理の結果をUIに反映させる場合、メインキューを取得すてタスクを追加する
     
     メインキューの取得
     */
    let mainQueue = DispatchQueue.main // メインディスパッチキューを取得
    /**
     グローバルキューを取得
     ・グローバルキューは並列ディスパッチキュー
     ・実行優先度を指定してグローバルキューを取得する
     ・実行優先度 = QoS(Quality of Service)
     ・優先度に応じて実行順序が決定される
     ・専用のディスパッチキューが必要でなければ通常はグローバルキューを使う
     */
    let grobalQueue = DispatchQueue.global(qos: .userInitiated)

    /**
     新規のディスパッチキューの生成
     */

    /**
     ディスパッチキューへのタスクの追加
     ・ディスパッチキューにタスクを追加するにはDispatchQueue型のasyncメソッド
     ・利用=> シンプルな非同期処理を実装する場合に利用する
     */
    func addTaskForQueue() {
        let queue1 = DispatchQueue.global(qos: .userInitiated)
        queue1.async {
            print("非同期の処理")
        }
    }

    /**
     メインスレッドから時間のかかる処理を別スレッドに移し、その処理が終わったらメインスレッドに通知すると言う例
     */
    func useGcd() {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            print("非同期処理")
            print(Thread.isMainThread) // false
            let queue = DispatchQueue.main
            queue.async {
                print("メインスレッドでの処理")
                print(Thread.isMainThread) // true
            }
        }
    }
}
/**
 GCDの利用すべき時
 ・シンプルな非同期処理を実装する場合
 ・タスクをクロージャとして表現できるため、単純な非同期処理の実装に向いている
 */


/**
 「Operation, OperationQueue」
 ・非同期処理を抽象化したクラス
 ・GCDはlibdispatchで実装されていて、OperationはFoundationに実装されている
 ・Operation=実行されるタスクとその情報をカプセル化したもの
 ・OperationQueue=キューの役割
 */

//「タスクの定義」タスクはOperationクラスのサブクラスとして定義
class SomeOperation: Operation {
    let number: Int
    init(number: Int) { self.number = number }

    override func main() {
        //1秒待つ
        Thread.sleep(forTimeInterval: 1)
        print(number)
    }
}
// 「キューの生成」タスクを実行するキューとなるOperationQueueクラスのインスタンスを生成
class SomeOperationQueue {
    let queue = OperationQueue()
    func addqueue() {
        //キューの名前
        queue.name = "com.example.my_operation_queue"
        //最大2つのタスクを並列実行する
        queue.maxConcurrentOperationCount = 2
        //Qos
        queue.qualityOfService = .userInitiated

        // 「キューへのタスクの追加」
        var operations = [SomeOperation]()
        for i in 0 ..< 10 {
            operations.append(SomeOperation(number: i))
        }
        //タスクをキューに追加
        // false = タスクの終了を待たずにそのまま次の処理を実行する
        queue.addOperations(
            operations,
            waitUntilFinished: false) // waitUntilFinished = 全てのタスクの実行が終わるまで呼び出したスレッドをブロックするかどうか
    }
}
/**
 Operation実行手順
 (1)Operationクラスのサブクラスを作成し、mainメソッドをオーバーライドして実行する処理を作成
 (2)OperationQueueクラスのインスタンスを作成
 (3)(2)のインスタンスに「キューの名前」を設定
 (4)(2)のインスタンスに「キューの最大タスク実行数」を設定
 (5)(2)のインスタンスに「キューのQos」を設定
 (6)(2)のインスタンスに「(1)のインスタンス」のタスクをキューに追加
 */


//「タスクのキャンセル」
class CancelOperation: Operation {
    let number: Int
    init(number: Int) { self.number = number }

    override func main() {
        //1秒待つ
        Thread.sleep(forTimeInterval: 1)

        guard !isCancelled else { return }

        print(number)
    }
}

class CancelOperationQueue {
    let queue = OperationQueue()
    func addqueue() {
        //キューの名前
        queue.name = "com.example.my_operation_queue"
        //最大2つのタスクを並列実行する
        queue.maxConcurrentOperationCount = 2
        //Qos
        queue.qualityOfService = .userInitiated

        // 「キューへのタスクの追加」
        var operations = [SomeOperation]()
        for i in 0 ..< 10 {
            operations.append(SomeOperation(number: i))
        }
        //タスクをキューに追加
        // false = タスクの終了を待たずにそのまま次の処理を実行する
        queue.addOperations(
            operations,
            waitUntilFinished: false)
        operations[6].cancel() // タスクを一つキャンセル
    }
}

/**
 「タスクの依存関係の設定」
 ・あるタスクに対して、それよりも先に実行されるべきタスクを指定するにはaddDependency(_:)メソッドで先に実行されるべきタスクを引数に渡す
 */
class DependOperation: Operation {
    let number: Int
    init(number: Int) { self.number = number }
    override func main() {
        Thread.sleep(forTimeInterval: 1)
        if isCancelled { return }
        print(number)
    }
}

class DependOperationQueue {
    let queue = OperationQueue()
    func addQueue() {
        queue.name = "com.example.my_operation_queue"
        queue.maxConcurrentOperationCount = 2
        queue.qualityOfService = .userInitiated
        var operations = [DependOperation]()
        for i in 0 ..< 10 {
            operations.append(DependOperation(number: i))
            if i > 0 {
                operations[i].addDependency(operations[i - 1])
            }
        }
        queue.addOperations(operations, waitUntilFinished: false)
    }
}
/**
 Operation, OperationQueueの利用すべき時
 ・複雑な非同期処理を実装する場合
 ・非同期処理をオブジェクト指向で抽象化したもの。
 ・「タスクのキャンセル」「タスクの依存関係の定義」の機能が備わっているため、複雑な非同期処理に向いている
 */

class AsynchronousSample {

}
