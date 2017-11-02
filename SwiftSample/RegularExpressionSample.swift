//
//  RegularExpressionSample.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/11/01.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation

class RESample {

    /// 検索文字列、正規表現を取得しマッチするか判定
    func pregMatch(target: String, pattern: String) -> Bool {
        // (1)検索文字列の範囲を取得
        let length = (target as NSString).length
        let targetRange = NSRange(location: 0, length: length)
        // (2)正規表現オブジェクト取得
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return false }
        // (3)判定
        let match = regex.matches(in: target, options: [], range: targetRange)
        return 0 < match.count
    }

}
