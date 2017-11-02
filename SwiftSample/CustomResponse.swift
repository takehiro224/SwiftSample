//
//  CustomResponse.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/11/01.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation

public class Response {

    // JSONデータ(Date)を辞書型に変換
    public class func comvertJson(json data: Data?) -> [String: AnyObject]? {
        guard let json = data else { return nil }
        do {
            // JSONを辞書型に変換
            let jsonData = try (JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String: AnyObject])
            return jsonData
        } catch {
            return nil
        }
    }
}
