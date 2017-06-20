//
//  SwiftSampleTests.swift
//  SwiftSampleTests
//
//  Created by tkwatanabe on 2017/06/12.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import XCTest
@testable import SwiftSample

class SwiftSampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // テストの開始時に最初に一度呼ばれる関数。テストケースを回すために必要な設定やインスタンスの生成などをここで行います。
        print("setUp()")
    }
    
    override func tearDown() {
        // テストの終了時に一度呼ばれる関数。
        super.tearDown()
        print("tearDown()")
    }
    
    let vc = TestTargetViewController()
    
    func testIsNumber() {
        XCTAssertTrue(vc.isNumber(numStr: "123"))
    }
    
    func testExample() {
        // テスト対象の関数です。この関数一つに対してテストケースを一つ書きます。どうやってテストケースとして判別するかというと、関数名の頭文字が "test" で始まる関数かどうかで識別しているようです。
    }
    
    func testPerformanceExample() {
        // パフォーマンスの計測用の関数です。
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
