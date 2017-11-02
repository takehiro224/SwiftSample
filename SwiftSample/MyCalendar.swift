
//
//  MyCalendar.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/05/24.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation

enum Month: Int {
    case jan = 1
    case feb = 2
    case mar = 3
    case apr = 4
    case may = 5
    case jun = 6
    case jul = 7
    case aug = 8
    case sep = 9
    case oct = 10
    case nov = 11
    case dec = 12
    case leap = 99
    
    var days: Int {
        switch self {
        case .jan: return 31
        case .feb: return 28
        case .mar: return 31
        case .apr: return 30
        case .may: return 31
        case .jun: return 30
        case .jul: return 31
        case .aug: return 31
        case .sep: return 30
        case .oct: return 31
        case .nov: return 30
        case .dec: return 31
        case .leap: return 29
        }
    }
    
    mutating func before() ->Void {
        switch self {
        case .jan: self = .dec
        case .feb: self = .jan
        case .mar: self = .feb
        case .apr: self = .mar
        case .may: self = .apr
        case .jun: self = .may
        case .jul: self = .jun
        case .aug: self = .jul
        case .sep: self = .aug
        case .oct: self = .sep
        case .nov: self = .oct
        case .dec: self = .dec
        case .leap: self = .jan
        }
    }
    
    mutating func after() ->Void {
        switch self {
        case .jan: self = .feb
        case .feb: self = .mar
        case .mar: self = .apr
        case .apr: self = .may
        case .may: self = .jun
        case .jun: self = .jul
        case .jul: self = .aug
        case .aug: self = .sep
        case .sep: self = .oct
        case .oct: self = .nov
        case .nov: self = .dec
        case .dec: self = .jan
        case .leap: self = .mar
        }
    }
    
    static func isLeap(_ y: Int) -> Bool {
        return (y % 4 == 0) && (y % 100 != 0 || y % 400 == 0)
    }
}

public class DateUtil {

    // 現在からの経過時間を文字列で作成
    static func pass(date: Date) -> String {
        // 指定日からの経過秒
        switch Date().timeIntervalSince(date) {
        case let t where t < 60: return "\(Int(t))"
        case let t where t < 3600: return "\(Int(t/60))"
        case let t where t < 86400: return "\(Int(t/60/60))"
        case let t where t < 604800: return "\(Int(t/60/60/24))"
        case let t where 604800 < t:
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy年MM月dd日"
            return dateFormatter.string(from: date)
        default: return "不明"
        }
    }

}
