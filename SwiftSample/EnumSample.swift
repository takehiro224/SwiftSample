//
//  File.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/10/08.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation

/**
 列挙型
 「複数の識別子をまとめる型」

*/

enum Direction {
    case up
    case down
    case right
    case left
}

enum Weekday {
    case sunday
    case monday
    case tuesday
    case wendesday
    case thursday
    case friday
    case saturday

    // イニシャライザを定義
    init?(japaneseName: String) {
        switch japaneseName {
        case "日": self = .sunday
        case "月": self = .monday
        case "火": self = .tuesday
        case "水": self = .wendesday
        case "木": self = .thursday
        case "金": self = .friday
        case "土": self = .saturday
        default: return nil
        }
    }

    /*
     プロパティ定義
     - ストアドプロパティは定義できない
     - コンピューテッドプロパティのみ
     */
    var name: String {
        switch self {
        case .sunday: return ""
        case .monday: return ""
        case .tuesday: return ""
        case .wendesday: return ""
        case .thursday: return ""
        case .friday: return ""
        case .saturday: return ""
        }
    }
}

/*
 メソッドの定義
 */

enum Method {
    case up
    case down
    case right
    case left

    // メソッドの定義
    func clockwise() -> Method {
        switch self {
        case .up: return .right
        case .down: return .left
        case .right: return .down
        case .left: return .up
        }
    }
}

/**

 */
class EnumSapmle {

    let direction = Method.up

    func sample() {

        /*
         インスタンス化
         [列挙型名.ケース名] でインスタンス化
         */
        let sunday = Weekday.sunday; print(sunday)
        let sunday1 = Weekday(japaneseName: "日"); print(sunday1!)

        if direction.clockwise() == Method.down { print("true") }
    }
}
