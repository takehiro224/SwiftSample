//
//  FunctionSample.swift
//  SwiftSample
//
//  Created by 渡邊丈洋 on 2017/07/15.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation
import UIKit


/**
 「関数」
 ・関数はクラスや構造体の要素として定義されるとメソッドとなる
 ・引数を与えて呼び出し、値を返すもの
 */
class FunctionSample {
    
    /**
     単純な関数
     */
    var total = 0
    func count(n: Int) -> Int {
        total += n
        return total
    }
    func reset() {
        total = 0
    }
    
    /**
     「引数ラベルの指定と省略」
     ・関数を呼び出す側はわかりやすい引数ラベル名が良い
     ・関数定義をする側は長い仮引数を使いたくない
     =>引数ラベルと仮引数を分けて記述する
     ・引数ラベルは実引数の役割をわかりやすくすることが目的
     */
    //面積を計算する関数area -> let a = area(h: 10.0, w: 12.5)
    func area(h: Double, w: Double) -> Double {
        return h * w
    }
    
    
    //引数ラベルと仮引数で分ける -> let a = area(height: 10.0, width: 12.5)
    func area(height h: Double, width w: Double) -> Double {
        return h * w
    }
    
    //引数ラベルが不要の場合
    func area(_ h: Double, _ w: Double) -> Double {
        return h * w
    }
    
    /**
     関数定義における様々な設定 -------------------------------------------------------------
     */
    
    /**
     「inout引数」
     ・関数内の処理によって呼び出し側の変数を変更したい場合
     
     * inout引数を使った関数の例
     var x = 100
     var y = 0
     mySwap(&x, &y) //x = 0, y = 100
     */
    func mySwap(_ a: inout Int, _ b: inout Int) {
        let t = a
        a = b
        b = t
    }
    
    /**
     「関数の引数に既定値を指定する」
     ・決まった値が指定される引数
     ・普段は呼び出し時に実引数の指定を省略できるようになる
     
     * 引数に既定値が指定された関数
     */
    func setFont(name: String, size: Float = 12.0, bold: Bool = false) {
        print("\(name) \(size)")
    }
    
    /**
     「引数の値は関数内で変更できない」
     ・呼び出し側の変数を変更したくないが仮引数の値を変更したい場合
     ツェラーの公式(日付から曜日を計算する)
     */
    func dayOfWeek(_ y: Int, _ m: Int, _ d: Int) -> Int {
        var y = y, m = m
        if m < 3 {
            m += 12; y -= 1
        }
        let leap = y + y / 4 - y / 100 + y / 400
        return (leap + (13 * m + 8) / 5 + d) % 7
    }
    
    /**
     関数内の関数
     ・関数は、その関数だけが下請けとして使う別の関数定義を自分自身の定義に含めることができる
     ・関数内関数は外部からアクセスできない
     ・「ネスト関数」内部定義関数
     
     *一月のカレンダーを印字する関数
     */
    func printMonth(first fday: Int, days: Int) {
        var d = 1 - fday //月の始まりの空白は負と0で表す
        func daystr() -> String {
            if d <= 0 {
                return "   "
            } else {
                return (d < 10 ? "  \(d)" : " \(d)")
            }
        }
        while d <= days {
            var line = ""
            for _ in 0 ..< 7 {
                line += daystr()
                d += 1
                if d > days {break}
            }
        }
    }
    
}

/**
 「タプル」
 ・複数個のデータを組みにしてまとめたもの
 ・複数個の値をまとめて扱いたいけれど専用の構造体やクラスを定義するほどでもない状況で使用する
 */
class TapleSample {
    
    func tpl() {
        //文字列と整数を要素とするタプル
        let m = ("monkey.jpg", 151_022)
        //ドット添え字でアクセスすることができる
        print(m.0)
    }
    //タプルを含むタプル
    let pic = ("snake.png", (768, 1024))
    
    func fibonacci() {
        var fibo1 = 0, fibo2 = 1
        print(fibo1, terminator: " ")
        for _ in 0 ..< 50 {
            (fibo1, fibo2) = (fibo2, fibo1 + fibo2)
            print(fibo1, terminator: " ")
        }
    }
    
    /**
     「タプルを返す関数」
     ＊BMIを返す関数
     */
    func BMI(tall: Double, weight: Double) -> (Double, Double) {
        let ideal = 22.0
        let t2 = tall * tall / 10000.0
        let index = weight / t2
        return (index, ideal * t2)
    }
    
    /**
     「キーワード付きのタプル」
     */
    func keywordTaple() {
        let photo = (file: "tiger.jpg", width: 640, height: 800)
        print(photo.0)
        print(photo.file)
    }
    
    /**
     「キーワード付きのタプルと代入」
     ・キーワードの付いたタプルは、同じキーワードの付いたタプルか、キーワードのないタプルとの間でしか代入できない
     ・キーワードの異なるタプル同士は代入できない
     */
    func keywordTaple2() {
        let img = ("phonenix.png", 1200, 800)
        let photo = (file: "tiger.png", width: 640, height: 800)
        var v1: (String, Int, Int) = img
        var v2: (file: String, width: Int, height: Int) = img
        var v3: (image: String, x: Int, y: Int) = img
        v1 = photo
        v2 = photo
        //v3 = photo エラー
    }
}








