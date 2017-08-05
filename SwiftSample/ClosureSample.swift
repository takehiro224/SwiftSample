
//
//  ClosureSample.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/06/20.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation

/**
 [クロージャ]
 ・実行可能なコードと、それが記述された箇所の環境を取り込んで、後から評価できるように保存したもの。
 ・Swiftの言語機能の中心的な存在
 */

class ClosureSample {
   
    func closureBasic() {
        let c1 = { () -> () in print("Zzz") } //クロージャ式
        c1()
        //(エラー){ () -> () in print("hello") }()
        
        //複数行の場合はreturn文が必要
        let c2 = { (a: Int, b: Int) -> Double in
            if b == 0 { return 0.0 }
            return Double(a) / Double (b)
        }
        print(c2(10, 8)) // 1.25と出力
        
        //1行の場合はreturn文が不要
        let c3 = { (a: Int, b: Int) -> Double in
            b == 0 ? 0.0 : Double(a) / Double(b)
        }
        print(c3(10, 8))
    }
    
    func shortcut() {
        _ = { () -> () in print("closure") }
        _ = { () -> Void in print("closure") }
        _ = { () in print("closure") } //戻り値カット
        _ = { print("closure") } //戻り値、inカット
        
        _ = { () -> Double in atan(1.0)*4.0 }() //returnカット
        _ = { atan(1.0)*4.0}()
        
        var _: Int = { //Int型を返すクロージャと推論される
            print("What?")
            return 123
        }()
    }
    
    /**
     クロージャと関数の型
     ・クロージャは関数と同じように実行できる -> 関数とクロージャを区別する必要はない
     */
    
    func type() {
        //クロージャの型
        var c2: (Int, Int) -> Double = { (a: Int, b: Int) -> Double in b == 0 ? 0.0 : Double(a) / Double(b) }
        print(c2) //(Function)と表示される
        func f1(a: Int, b: Int) -> Double {
            return Double(a) / Double(b)
        }
        c2 = f1 //クロージャが格納された変数に関数を格納することが可能
    }
    
    //クロージャの複雑な型宣言
    func declear() {
        var _: (Int, Int) -> Double?
        var _: ((Int, Int) -> Double)? //オプショナル型
        
        //クロージャはインスタンスなので配列に格納することもできる
        var _ = [(Int, Int) -> Double]()
        var _ = Array<(Int, Int) -> Double>()
        
        //クロージャの型が複雑になると扱いにくので型の別名をつける
        typealias MyClosure = (Int, Int) -> Double
        var _ = [MyClosure]()
    }
    
    /**
     [変数のキャプチャ]
     キャプチャ
     ・クロージャは常に同じ機能のインスタンスが作られるわけではない。
     ・インスタンスが生成される際にクロージャの外側にある変数の値を取り込んでインスタンスの一部として、インスタンスが呼び出される
     時はいつでも値を取り出して使うことができる == キャプチャ
     */
    //変数のキャプチャを調べる例
    var globalCount = 0
    //() -> Intという型を持つクロージャのインスタンスを作って返す関数
    func maker(_ a: Int, _ b: Int) -> () -> Int {
        var localvar = a
        return { () -> Int in //クロージャ式
            self.globalCount += 1 //globalCountは参照されるだけ
            localvar += b //localvar, bがキャプチャされる
            return localvar
        }
    }
    func makerTest() {
        let m1 = maker(10, 1)
        print("m1() = \(m1()), globalCount = \(globalCount)") //11, 1
        print("m1() = \(m1()), globalCount = \(globalCount)") //12, 2
        globalCount = 1000
        print("m1() = \(m1()), globalCount = \(globalCount)") //13, 1001
        let m2 = maker(50, 2)
        print("m2() = \(m2()), globalCount = \(globalCount)") //52, 1002
        print("m1() = \(m1()), globalCount = \(globalCount)") //14, 1003
        print("m2() = \(m2()), globalCount = \(globalCount)") //54, 1004
    }
    
    //複数のクロージャが同じローカル変数をキャプチャする場合
    var m1: (() -> ())! = nil //クロージャを代入する変数
    var m2: (() -> ())! = nil
    func makerW(_ a: Int) {
        var localvar = a
        m1 = { localvar += 1; print("m1: \(localvar)") }
        m2 = { localvar += 5; print("m2: \(localvar)") }
        m1()
        print("--: \(localvar)")
        m2()
        print("--: \(localvar)")
    }
    func makerWTest() {
        //ローカル変数localvarがなくなっていても値が保持され、クロージャ間で共有されている
        makerW(10)
        m1() //17
        m2() //22
        m1() //23
    }
    
    //クロージャが参照型の変数をキャプチャする場合
    class MyInt {
        var value = 0
        init(_ v: Int) { value = v }
        deinit { print("deinit: \(value)")} //解放時に表示
    }
    func makerZ(_ a: MyInt, _ s: String) -> () -> () {
        let localvar = a
        return { //クロージャを返す
            localvar.value += 1
            print("\(s): \(localvar.value)")
        }
    }
    func makerXTest() {
        var obj: MyInt! = MyInt(10) //クラスのインスタンス
        var m1: (() -> ())! = makerZ(obj, "m1") //クロージャを変数m1に代入
        m1() //m1: 11 と出力
        var m2: (() -> ())! = makerZ(obj, "m2") //クロージャを変数m2に代入
        obj = nil //MyIntのインスタンスはまだ解放されない
        m2() //m2: 12
        m1() //m1: 13
        m1 = nil
        m2() //m2: 14
        m2 = nil //deinit: 14 -> MyIntのインスタンスが解放された
    }
    
    //ネスト関数とクロージャ
}
