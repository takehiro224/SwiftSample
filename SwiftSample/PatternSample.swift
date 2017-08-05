//
//  PatternSample.swift
//  SwiftSample
//
//  Created by 渡邊丈洋 on 2017/07/15.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation

/*
 パターンマッチ = ルールに基づくデータ構造の対応付け
 ・タプルをswitch文と組み合わせる方法
 ・列挙型
 */

class PatternSample {
    var day = (1, 1)
    
    func sample() {
        
        switch day {
        case (1, 1): print("")
        case (2, 11): print("")
        case (5, 3): print("")
        default: break
        }
        
        //範囲演算子を利用してのswitch
        switch day {
        case (1, 1...5): print("正月休み")
        case (5, 3): print("憲法記念日")
        case (4, 29), (5, 2...6): print("連休")
        default: break
        }
        
        //タプルの要素を取り出して処理に使う
        switch day {
        case (5, 3): print("憲法記念日")
        case (8, let d): print("8/\(d)は夏休み")
        case (8, _): print("8月は休み")
        default: break
        }
        
        /*
         「switchでwhere文」
         ・タプルの要素に対して条件をつけることが可能
         ・
         */
        let year = 2017
        switch day {
        case (1, let d) where d >= 8 && d <= 14 && dayOfWeek(year, 1, d) == 1:
            print("成人の日")
        case (8, _):
            print("夏休み")
        case (let m, let d) where dayOfWeek(year, m, d) == 0:
            print("\(m)/\(d)は日曜日")
        default: break
        }
    }
    
    func dayOfWeek(_ y: Int, _ m: Int, _ d: Int) -> Int {
        var y = y, m = m
        if m < 3 {
            m += 12
            y -= 1
        }
        let leep = y + y / 4 - y / 100 + y / 400
        return (leep + (13 * m + 8) / 5 + d) % 7
    }
}
