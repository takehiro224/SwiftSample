//
//  ClassSample.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/06/21.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation

/**
 「 クラス 」
 
 ・クラスとそのインスタンスはオブジェクト指向における中心的な概念
 ・クラスのインスタンスは参照型
 ・「クラス」システムを構成する構造や、役割を与えられて動作する能動的な単位を実現するために使用する
 ・「構造体」ひとまとまりの意味のあるデータを実現させるために使用する
 
 class 型名: スーパークラス {
    変数/定数
    イニシャライザ定義
    メソッド定義
    その他定義(型定義、プロパティ定義、添え字付け定義など)
 }
 
 */

class Time1 {
    
    var hour = 0, min = 0
    
    init(hour: Int, min: Int) { //全項目イニシャライザは使えない
        self.hour = hour; self.min = min
    }
    
    func advance(min: Int) { //mutatingは不要
        let m = self.min + min
        if 60 <= m {
            self.min = m % 60
            let t = self.hour + m / 60
            self.hour = t % 24
        } else {
            self.min = m
        }
    }
    
    func inc() { //mutatingは不要
        self.advance(min: 1)
    }
    
    func toString() -> String {
        let h = hour < 10 ? " \(hour)" : "\(hour)"
        let m = min < 10 ? "0\(min)" : "\(min)"
        return h + ":" + m
    }
}

/**
 クラスの継承
 ・クラスのみ継承することができる
 ・定義を引き継いで新たに定義されるクラス == サブクラス
 ・定義を参照されるクラス==スーバークラス
 ・サブクラスはスーパークラスの殆どを引き継ぐが、イニシャライザは基本的には継承しない
 */
class Time12: Time1, CustomStringConvertible {
    
    var pm: Bool //新しいインスタンス変数。午後ならtrue
    
    init(hour: Int, min: Int, pm: Bool) { //新しいイニシャライザ
        self.pm = pm
        //スーパークラスのイニシャライザを呼び出して使用
        super.init(hour: hour, min: min)
    }
    
    //スーパークラスのイニシャライザを上書き
    override convenience init(hour: Int, min: Int) {
        let isPm = hour >= 12
        self.init(hour: isPm ? hour - 12 : hour, min: min, pm: isPm)
    }
    
    //メソッドの上書き
    override func advance(min: Int) {
        super.advance(min: min)
        while hour >= 12 {
            hour -= 12 //13 -> 1
            pm = !pm
        }
    }
    
    var description: String {
        return toString() + " " + (pm ? "PM" : "AM")
    }
}

/**
 クラスメソッドとクラスプロパティ
 ・構造体、列挙型はタイプメソッドとタイププロパティ(その型に関係する手続きや値を定義)
 ・クラスメソッド、クラスプロパティはサブクラスで上書きできる
 ・クラスプロパティは計算型プロパティに限定される
 */
class ClassMethodProperty : CustomStringConvertible {
    static var className: String { return "ClassMethodProperty" } //計算型タイププロパティ
    static var total = 0 //格納型タイププロパティ
    class var level: Int { return 1 } //計算型クラスプロパティ
    static func point() -> Int { return 1000 } //タイプメソッド
    class func say() -> String { return "Ah." } //クラスメソッド
    init() {
        ClassMethodProperty.total += 1
    }
    var description: String {
        return "\(ClassMethodProperty.total): \(ClassMethodProperty.className)," + "Level=\(ClassMethodProperty.level), \(ClassMethodProperty.point())pt, \(ClassMethodProperty.say())"
    }
}

class SubClassMethodProperty: ClassMethodProperty {
    override init() {
        super.init()
        SubClassMethodProperty.total += 1
    }
    override var description: String {
        return "\(SubClassMethodProperty.total): \(SubClassMethodProperty.className)," + "Level=\(SubClassMethodProperty.level), \(SubClassMethodProperty.point())pt, \(SubClassMethodProperty.say())"
    }
}
