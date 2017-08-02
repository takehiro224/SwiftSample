//
//  ErrorSample.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/06/19.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation

/**
 Swiftにおけるエラー処理3種
 1.Optional<Wrapped>型
 2.Result<T, Error>型
 3.do-catch文
 */

/**
 「1. Optional<Wrapped型>」
 ・値があることを成功、値がないことを失敗とするエラー処理
 */
private struct User {
    let id: Int
    let name: String
    let email: String

    func findUser(byID id: Int) -> User? {
        let users = [
            User(id: 1, name: "Oda Nobunaga", email: "nobunaga@gmail.com"),
            User(id: 2, name: "Tokugawa Ieyasu", email: "ieyasu@gmail.com")
        ]
        for user in users {
            if user.id == id {
                return user
            }
        }
        return nil
    }

    func test() {
        let id = 1
        if let user = findUser(byID: id) {
            print("Name: \(user.name)")
        } else {
            print("Error:")
        }
    }
}

//失敗可能イニシャライザ
private struct FailInit {
    let id: Int
    let name: String
    let email: String

    init?(id: Int, name: String, email: String) {
        let component = email.components(separatedBy: "@")
        guard component.count == 2 else {
            return nil
        }
        self.id = id
        self.name = name
        self.email = email
    }

    func test() {
        if let user = FailInit(id: 0, name: "Oda Nobunaga", email: "nobunaga.com") {
            print(user.name)
        } else {
            print("Error: Invalid data")
        }
    }
}


/**
 「assert」は検証、デバッグ用の機能
 ・プログラムの動作を確認したい部分に記述する。
 ・正しく動作させるための条件を記述する。
 */
class AssertSample {
    
    func sample() {
        let dataArray = [1, 2, 3]
        let index = 0
        assert(index >= 0, "Illegal index for dataArray")
        let elm = dataArray[index]
        print(elm)
    }
}
