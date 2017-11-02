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
 Result<T, Error>型によるエラー処理
 成功->結果の値
 失敗->エラーの詳細
 (1)エラーの詳細を提供する
 (2)成功か失敗のいずれかであることを保証する
 (3)非同期処理のエラーを扱う
 ->クロージャの引数の型をResult<T, Error>にすれば呼び出し元にエラー情報を伝えることができる
 */
enum Result<T, Error> {
    case success(T)
    case failure(Error)
}

enum DatabaseError {
    case entryNotFound
    case duplicatedEntry
    case invalidEntry(reason: String)
}

struct ResultUser {
    let id: Int
    let name: String
    let email: String
}

class ErrorSample {

    func findUser(byId id: Int) -> Result<ResultUser, DatabaseError> {
        let users = [
            ResultUser(id: 0, name: "oda", email: "oda@gmail.com"),
            ResultUser(id: 1, name: "hashiba", email: "hashiba@gmail.com")
        ]
        for user in users {
            if user.id == id {
                return .success(user)
            }
        }
        return .failure(.entryNotFound)
    }
}

/**
 [do-catch文によるエラー処理]
 Swift標準のエラー処理
 ・エラーが発生する可能性のある処理をdo節内に記述する
 ・エラー詳細を用いたエラー処理を行える
 */
struct DoError: Error {}

enum DoEnumError: Error {
    case error1
    case error2(reason: String)
}

/* 
 Errorプロトコル - エラー情報を表現するプロトコル
 ・throw文のエラーを表現する型はErrorプロトコルに準拠している必要がある
 ・Errorプロトコルに準拠する型は列挙型として定義するのが一般的
 ・エラーの種類ごとに別の型を定義することが一般的
 */
enum NetworkError: Error {
    case timeOut
    case cancelled
}

/*
 throwsキーワード - エラーを発生させる可能性のある処理の定義
 ・「関数」「イニシャライザ」「クロージャ」の定義にthrowsキーワードを追加すると処理の中でdo-catchを使わなくもthrow文によるエラーを発生させられる
 */
enum OperationError: Error {
    case overCapacity
}

enum AgeError: Error {
    case outOfRange
}

struct Teenager {
    let age: Int
    init(age: Int) throws {
        guard case 13...19 = age else {
            throw AgeError.outOfRange
        }
        self.age = age
    }
}

/*
 rethrowsキーワード - 引数のクロージャが発生させるエラーの呼び出し元への伝播
 ・引数のクロージャが発生させるエラーを関数の呼び出し元に伝播させることができる
 ・クロージャが発生させるエラーの処理を関数の呼び出し元に任せる
 */
class RethrowsSample {
    enum RethrowsError: Error {
        case originalError
        case convertedError
    }
    // 関数やメソッドが少なくとも1つのエラーを発生させるクロージャを引数に取る必要がある
    func rethrowingFunction(_ throwingClosure: () throws -> Void) rethrows {
        do {
            try throwingClosure()
        } catch {
            throw RethrowsError.convertedError
        }
    }
    // 
    func doRethrowing() {
        do {
            try rethrowingFunction {
                throw RethrowsError.originalError // ここのエラーをdoRethrowing()に処理させる
            }
        } catch {
            print(error) // convertedError
        }
    }
}

/*
 tryキーワード - エラーを発生させる可能性のある処理の実行
 ・throwキーワードが指定された処理を呼び出す際に使用される
 */
/*
 try!キーワード - エラーを無視した処理の実行
 ・throwキーワードが指定された処理でも、絶対にエラーが発生しないとわかっている場合にわざわざエラー処理を記述したくない場合
 ・do-catch節でなくても使用できる
 ・明示的なエラーの無視
 */
class TrytrySample {
    func triple(of int: Int) throws -> Int {
        if int > Int.max / 3 {
            throw OperationError.overCapacity
        }
        return int * 3
    }
    func trySample() {
        let int = 9
        let tripleOfInt = try! triple(of: int)
        print(tripleOfInt)
    }
}

/*
 try?キーワード
 */

class DoErrorSample {

    func doerrortest() {

        do {
            throw DoError()
            // print("success")
        } catch {
            print("Failure: \(error)")
        }

        do {
            throw DoEnumError.error2(reason: "何かがおかしい")
        } catch DoEnumError.error1 {
            print("error1")
        } catch DoEnumError.error2(let reason) {
            print("error2: \(reason)")
        } catch {
            print("Unknown error: \(error)")
        }
    }

    // 関数にthrowsが付いているのthrowキーワードによるエラーを発生させることができる
    func triple(of int: Int) throws -> Int {
        if int <= Int.max / 3 {
            throw OperationError.overCapacity
        }
        return int * 3
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
