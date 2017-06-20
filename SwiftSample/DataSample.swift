//
//  DataSample.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/06/19.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation


protocol PDataSample {
    /**
     Stride型
     開始点と終了点、刻み幅から構成される構造体
     開始点から終了点まで、指定された刻み幅で飛び飛びに値を取り出すことができる
     */
    //StrideThrough型
    func stride<T>(from: T, through: T, by: T.Stride) -> StrideThrough<T>
    //StrideTo型
    func stride<T>(from: T, to: T, by: T.Stride) -> StrideTo<T>
}

class DataSample {
    func sample() {
        //StrideTo型
        //0から20の直前まで2刻みで
        for x in stride(from: 0, to: 20, by: 2) {
            print(x, terminator: " ") //0 2 4 6 8 10 12 14 16 18
        }
        
        //StrideThrough型
        for x in stride(from: 3.0, through: 0.0, by: -0.5) {
            print(x, terminator: " ") //3.0 2.5 2.0 1.5 1.0 0.5 0.0
        }
        
        /** 
         [配列]
         ・複数個の要素を格納できる
         ・配列は値型のデータ型
         */
        let cons = ["clock", "dark", "element", "create"]
        var tmp1 = cons
        tmp1.insert("origin", at: 0) //コピーを作って先頭に挿入
        _ = ["origin"] + cons//2つの配列から新しい配列を作成
        
        //配列の部分的な置換
        var s = ["春", "夏", "秋", "冬"]
        s[0...0] = ["初春", "仲春", "晩春"]
        print(s) //["初春", "仲春", "晩春", "夏", "秋", "冬"]
        s[1...3] = ["花見", "梅雨", "夏休み"]
        print(s) //["初春", "花見", "梅雨", "夏休み", "夏", "秋", "冬"]
        s[3...4] = [] //削除もできる
        
        //部分配列の型
        //ArraySlice型は元の配列の一部を参照するために作られたデータ
        var days = ["日", "月", "火", "水", "木", "金", "土"]
        let sub: ArraySlice<String> = days[2..<5] //ArraySlice<String>
        print(sub)
        print(sub.count) //3を出力
        print(sub.startIndex) //"火"を出力
        //Array<String>のイニシャライザにArraySliceを使用する
        let subArray = [String](sub)
        print(subArray[0]) //0から使えるようになる
    }
    
    //配列のイニシャライザ
    func arrayInit() {
        let arrayInt = [2, 5, 8, 11, 7] //(1)配列リテラル
        _ = Array<String>() //(2)からの配列を作成
        _ = [Int](0..<10) //(3)Sequence型のデータ型を指定
        _ = [Character]("abcdef".characters)
        _ = [Double](repeating: 0.0, count: 10) //(4)0.0が10個格納された配列を生成
        print(arrayInt.count)
        print(arrayInt.first!)
        print(arrayInt.isEmpty)
        print(arrayInt.last!)
    }
    
    //配列のメソッド
    func arrayFunc() {
        var s = ["0", "1", "2", "3"]
        let one = s.remove(at: 1)
        print("\(one), \(s)") //1, [0, 2, 3]と出力
    }
    
    //引数が可変個の関数の例
    func maxOfInts(_ first: Int, _ params: Int...) -> Int {
        var m = first
        for v in params {
            if m < v {
                m = v
            }
        }
        return m
    }
    
    //可変個の引数列が最後にない関数
    func cards(_ numbers: Int..., label: String) {
        for n in numbers {
            print(label + String(n), terminator: " ")
        }
        print("")
    }
    
    
    /**
     [辞書]
     ・複数のインスタンスを格納できるコレクションの一種
     ・連想配列、ハッシュ表
     ・構造体として実現されている
     ・必要に応じて新しいインスタンスを生成する
     ・キーと値はそれぞれ同一の型
     */
    func basic() {
        let d = ["Swift": 2014, "Objective-C": 1983] //[String: Int]
        _ = [String:Int]() //イニシャライザ呼び出し
        _ = Dictionary<String, Int>() //イニシャライザ呼び出し
        //辞書へのアクセス
        //[キー]で指定する。帰り値はオプショナル型
        if let v = d["Swift"] {print(v)}
        if let v = d["Ruby"] {print(v)} // nil
    }
    
    //辞書のfor-in
    func forinDic() {
        var dic = ["Mars": "火星", "Venus": "金星"]
        for (en, ja) in dic {
            print("\(en) = \(ja)")
        }
        //以下も同様
        for t in dic {
            print("\(t.0) = \(t.1)")
        }
        //置き換え
        dic.updateValue("月", forKey: "moon")
        //削除
        dic.removeValue(forKey: "moon")
    }
}
