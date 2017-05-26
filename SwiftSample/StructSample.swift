//
//  StructSample.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/05/24.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation
import UIKit

/**
 構造体
 ・値型のデータ -> 代入などの際には新しいインスタンスを生成
 ・「プロパティ」「メソッド」を合わせて「メンバ」と呼ぶ
 */


/** 
 「構造体の基本的な定義方法」
 */
struct BasicStruct {
    var year: Int
    var month: Int
    var day: Int
}

/**
 「既定イニシャライザ(default initializer)」
 ・各プロパティの全てに初期値が設定されている場合に利用可能
 ・イニシャライザを1つも定義しない場合にのみ利用可能
 ・型名に引数なしのリストを続けた形の式でインスタンスを生成
 */
struct SimpleDate {
    var year = 2010
    var month = 7
    var day = 28
}

/**
 「全項目イニシャライザ(memberwise initializar)」
 ・個々のプロパティの値を指定してインスタンスを生成するイニシャライザ
 ・プロパティの初期値が設定されている必要はない
 var camp = SimpleDate(year: 2017, month: 5, day: 24)
 */

/**
 「定数に代入した構造体」
 ・定数に代入した構造体のインスタンスは、プロパティの値を変更できない
 */

/**
 「構造体の定数プロパティ」
 ・定義内で初期値を与えられた定数プロパティは全項目イニシャライザで改めて初期値を指定することはできない
 ・構造体の定数プロパティは初期値を指定しないでおくことができる(classはできない)
 */
struct Time {
    let in24h: Bool
    var hour = 0, min = 0
}

/**
 「イニシャライザの定義」
 ・イニシャライザは値を返さない関数のような形で構造体内部に定義
 ・イニシャライザ内では初期化のための手続きを記述する
 ・イニシャライザ内で構造体のメソッドを使用することができるのは全てのプロパティの初期設定が済んでから
 */
struct SimpleDateInit {
    var year, month, day: Int
    init() {
        year = 2017; month = 5; day = 24
    }
}
var simpleDateInit = SimpleDateInit() //インスタンス生成と共にカスタムイニシャライザが動作する

/**
 「複数個のイニシャライザ」
 ・self.init()で構造体内の別のイニシャライザを呼び出すことができる
 */
struct TimeMultiInit {
    let in24h: Bool
    var hour = 0, min = 0
    init(hour: Int, min: Int) {
        in24h = false
        self.hour = hour
        self.min = min
    }
    init(hourIn24 h: Int) {
        in24h = true
        hour = h
    }
    init(_ hour: Int) {
        self.init(hourIn24: hour)
        //in24h = false /*既に定数プロパティが初期化されているためこれはエラーになる*/
    }
}

/**
 「他の構造体を含む構造体」
 ・構造体に別の構造体が含まれる場合、含まれている構造体に対してはイニシャライザの呼び出しを行う
 */
struct DateWithTime {
    var date = SimpleDate()
    var time = Time(in24h: false, hour: 14, min: 39)
}
var dateWithTime = DateWithTime() //インスタンスを生成すると各プロパティのイニシャライザが機能する

/**
 「ネスト型」
 ・ある構造体を構成するために、その構造体と密接に関連する型を定義する場合に使用すること
 ・構造体内のネスト型や別名宣言は、構造体の定義をサポートする従属的な型という役割を持ち、「付属型」と呼ぶ
 */
struct SimpleTime {
    var hour, min: Int
    init(_ hour: Int, _ min: Int) {
        self.hour = hour
        self.min = min
    }
}
struct PointOfTime {
    struct Date { var year, month, day: Int } //ネスト型
    typealias Time = SimpleTime //別名を定義
    var date: Date
    var time: Time
    init(year: Int, month: Int, day: Int, hour: Int, min: Int) {
        date = Date(year: year, month: month, day: day)
        time = Time(hour, min)
    }
}


/**
 [ メソッド ]
 ・構造体のインスタンスに対して行われる計算や操作を構造体の定義にメソッドとして記述できる
 ・メソッドは構造体のインスタンスのプロパティとメソッドにアクセスできる
 */
struct TimeMethod {
    let hour, min: Int
    func advanced(min: Int) -> TimeMethod {
        var m = self.min + min
        var h = self.hour
        if m >= 60 {
            h = (h + m / 60) % 24
            m %= 60
        }
        return TimeMethod(hour: h, min: m)
    }
    func toString() -> String {
        let h = hour < 10 ? " \(hour)" : "\(hour)"
        let m = min < 10 ? "0\(min)" : "\(min)"
        return h + ":" + m
    }
}

/**
 「構造体の内容を変更するメソッド」
 ・構造体は以下の見方がある
 ->(1)データの入れ物
 ->(2)構造を持つ1個のデータ☆
 ・構造体の値を変更する場合、構成要素の書き換えではなく、構造体自体を新しく作る
 ・構造体は整数や文字列と同じ値型であるため、通常はメソッドからプロパティの変更はしないようにする
 ・構造体のプロパティをメソッドから変更する場合はfuncの直前に「mutating」というキーワードを置く
 ・変数に格納された構造体はプロパティの変更はできるが、定数に格納された構造体は変更できない
 */
struct Clock {
    var hour = 0, min = 0
    mutating func advance(min: Int) {
        let m = self.min + min
        if m >= 60 {
            self.min = m % 60
            let t = self.hour + m / 60
            self.hour = t % 24
        } else {
            self.min = m
        }
    }
    mutating func inc() {
        self.advance(min: 1)
    }
    func toString() -> String {
        let h = hour < 10 ? " \(hour)" : "\(hour)"
        let m = min < 10 ? "0\(min)" : "\(min)"
        return h + ":" + m
    }
}

/**
 「タイプメソッド」
 ・(インスタンスメソッド)インスタンスに対して適用されるメソッド
 ・(クラスメソッド、タイプメソッド)全インスタンスから共通して利用される機能
 ・タイプメソッドでは以下を記述する
 ->(1)インスタンスの作り方(シングルトン)
 ->(2)その型を使う上での便利な機能
 ・定義には関数定義の先頭に「static」をつけ、利用には「構造体.タイプメソッド名」で呼び出す
 */
struct SimpleDateTypeMethod {
    var year, month, day: Int
    static func isLeap(_ y: Int) -> Bool { //タイプメソッド
        return (y % 4 == 0) && (y % 100 != 0 || y % 400 == 0)
    }
    static func daysOfMonth(_ m: Int, year: Int) -> Int {
        switch m {
        case 2: return isLeap(year) ? 29 : 28 //self.isLeapでも同じ
        case 4, 6, 9, 11: return 30
        default: return 31
        }
    }
}

/**
 「イニシャライザとメソッド」
 ・イニシャライザ内でインスタンスメソッドを使う際の注意
 -> プロパティの初期設定が完了していない場合はインスタンスメソッドは使用できない
 */
//動作しない例
struct DateWithStringX {
    let string: String
    let year, month, day: Int
    init(_ y: Int, _ m: Int, _ d: Int) {
        year = y; month = m; day = d
        string  = ""
        //string = "\(y)-" + twoDigits(m) + "-" + twoDigits(d) //ここで失敗する
    }
    func twoDigits(_ n: Int) -> String {
        let i = n % 100
        return i < 10 ? "0\(i)" : "\(i)"
    }
}
//動作する例
struct DateWithStringO {
    let string: String
    let year, month, day: Int
    init(_ y: Int, _ m: Int, _ d: Int) {
        year = y; month = m; day = d
        string = "\(y)-" + DateWithStringO.twoDigits(m) + "-" + DateWithStringO.twoDigits(d)
    }
    static func twoDigits(_ n: Int) -> String {
        let i = n % 100
        return i < 10 ? "0\(i)" : "\(i)"
    }
}

/**
 [ プロパティ ]
 ・プロパティの種類
 ->(1)格納型プロパティ(stored property)
 ->(2)計算型プロパティ(computed property)参照と更新の機能を手続きで構成するプロパティ
 ->(3)タイププロパティ(type property)ある型の全てのインスタンスが共有する情報を管理するプロパティ
 */

/**
 「タイププロパティ」
 ・定義の際に先頭に「static」をつける
 ・タイププロパティはその構造体について1つしか存在せず、構造体全体に関係する情報を表す
 */
struct TypePropertyStruct {
    let string: String
    let year , month, day: Int
    static let mons = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"] //タイププロパティ
    static var longFormat = false //タイププロパティ
    init(_ y: Int, _ m: Int, _ d: Int) {
        year = y; month = m; day = d
        string = TypePropertyStruct.longFormat ? //タイププロパティを参照
            TypePropertyStruct.longString(y, m, d) : //タイプメソッドを参照
            TypePropertyStruct.shortString(y, m, d)
    }
    static func twoDigits(_ n: Int) -> String {
        let i = n % 100
        return i < 10 ? "0\(i)" : "\(i)"
    }
    static func longString(_ y: Int, _ m: Int, _ d: Int) -> String {
        return "\(y)-" + twoDigits(m) + "-" + twoDigits(d)
    }
    static func shortString(_ y: Int, _ m: Int, _ d: Int) -> String {
        return twoDigits(d) + mons[m-1] + twoDigits(y)
    }
}

/**
 「格納型プロパティの初期値を式で設定する」
 ・初期値の設定は「リテラルで指定」「イニシャライザで代入」が基本でしたが、「評価可能な式を指定」
 ・タイププロパティの初期化のための式は、値が必要とされて初めて評価され、その後は再評価されない
 let dis1 = LCD(size: LCD.Size(width: 800, height: 600))
 dis1.show() //CZ:2128(800x600)
 LCD.stdHeight = 1200
 let dis2 = LCD()
 dis2.show() //CZ:2129(1920x1200)
 LCD.stdWidth = 2560
 let dis3 = LCD()
 dis3.show() //CZ:2130(1920x1200) <- widthが2560になっていない!!!
 */
var serialNumber = 2127
struct LCD {
    struct Size { //ネスト型
        var width, height: Int
    }
    static var stdHeight = 1080
    static var stdWidth = 1920
    static var stdSize = Size(width: stdWidth, height: stdHeight) //タイププロパティの設定
    static func sn() -> Int {
        serialNumber += 1;
        return serialNumber
    }
    
    let size: Size
    let serial = "CZ:" + String(LCD.sn())
    
    //引数に既定値があるイニシャライザ
    init(size: Size = LCD.stdSize) {
        self.size = size
    }
    
    func show() {
        print(serial, "(\(size.width)x\(size.height))")
    }
}

/**
 「計算型プロパティ」
 ・値の参照と更新の機能を手続きで構成するプロパティ
 ・アクセスする側からは格納型プロパティと区別なく利用できる
 
 var a = Ounce(ounce: 2.0)
 a.ounce += 8.0 //計算型プロパティに対して複合演算代入を行える
 */
struct Ounce {
    var mL: Double = 0.0
    static let ounceUS = 29.5735
    init(ounce: Double) {
        self.ounce = ounce
    }
    var ounce: Double { //計算型プロパティの定義
        get { return mL / Ounce.ounceUS }
        set { mL = newValue * Ounce.ounceUS }
    }
}

/**
 「関数のinout引数にプロパティを渡す」
 関数の内部で、引数として渡した変数の内容を変更する場合、関数側の仮引数には「inout」を、実引数には「&」をつける
 swap関数で構造体を変換することが可能
 */
var ounceA = Ounce(ounce: 2.0)
var ounceB = Ounce(ounce: 10.0)
//swap(&ounceA, &ounceB)


/**
 「計算型プロパティに対する特殊な設定」
 ・計算型プロパティのset節で、同じ構造体が持つ格納型プロパティの値を変更することはよくある
 ・get節の実行中に格納型プロパティの値を変更することもある -> その場合はget節に「mutating」を付ける必要がある
 ・構造体が定数に格納されている場合、計算型プロパティは値を参照できない
 ・set節に「nomutating」を付けると、構造体が定数に格納されていても代入操作が可能
 */
struct ValueWithCounter {
    private let _value: Double //privateは可視性の設定
    var count = 0
    init(_ v: Double) {
        _value = v
    }
    var value: Double {
        mutating get {
            count += 1
            return _value
        }
    }
}

struct ValueInLine {
    private static var _pool: [Double] = [] //タイププロパティ
    let index: Int
    init(_ v: Double) {
        index = ValueInLine._pool.count //その時の配列の長さ
        ValueInLine._pool.append(v)
    }
    var value: Double {
        get {
            return ValueInLine._pool[index]
        }
        nonmutating set {
            ValueInLine._pool[index] = newValue
        }
    }
    static func clear() {
        for i in 0 ..< self._pool.count {
            self._pool[i] = 0.0
        }
    }
}

/**
 「グローバルなスコープを持つ計算型プロパティの定義」
 型や関数の定義にも属さずトップレベルに置かれる変数をグローバル変数と呼ぶ
 */
//横長(ランドスケープ)か判定する計算型プロパティ
var landscape: Bool {
    let size = UIScreen.main.bounds.size
    return size.width > size.height
}

/**
 「プロパティオブザーバ」
 格納型プロパティの値が更新される時に手続きを起動させることができる。これをプロパティオブザーバと呼ぶ
 (1)willSet: 値が格納される直前
 (2)didSet: 値が格納された直後
 */
struct Stock {
    let buyingPrice: Int
    var high = false
    var count = 0
    init(price: Int) {
        buyingPrice = price
        self.price = price
    }
    var price: Int {
        willSet {
            count += 1
            high = newValue > buyingPrice
        }
        didSet {
            print("\(oldValue) => \(price)")
        }
    }
}

/**
 [ 添字付け(subscript) ]
 複数個のプロパティがある時、配列の要素に対してするように添字を使ってアクセスできるようにする機能
 */
struct FoodMenu {
    let menu = ["Steak", "Pizza", "Hamburger"]
    var submenu = ["potate", "beer", "coke"]
    let count = 6
    subscript(i: Int) -> String {
        get {
            return i < 3 ? menu[i] : submenu[i-3]
        }
        set {
            if i > 2 && i < 6 {
                submenu[i - 3] = newValue
            }
        }
    }
}





/**
 「考察」
 ・カスタムイニシャライザを生成すると「既定イニシャライザ」「全項目イニシャライザ」は利用できない
 */
