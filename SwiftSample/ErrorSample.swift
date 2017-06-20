//
//  ErrorSample.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/06/19.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation

/**
 「assert」は検証、デバッグ用の機能
 ・プログラムの動作を確認したい部分に記述する。
 ・正しく動作させるための条件を記述する。
 */
class AssertSample {
    
    func sample() {
        let dataArray = [1, 2, 3]
        let index = 0
        assert(index >= 0, "Illegal index for dataArray")
        let elm = dataArray[index]
        print(elm)
    }
}
