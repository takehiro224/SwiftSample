//
//  MyExtension.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/11/01.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation
import UIKit

/// String
extension String {

    // 正規表現検索
    func match(pattern: String, options: NSRegularExpression.Options = []) -> Bool {

        let length = NSRange(location: 0, length: (self as NSString).length)

        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else { return false }

        let matches = regex.matches(in: self, options: [], range: length)

        return 0 < matches.count

    }

}

extension UIImageView {

    // URLから画像をセット
    func loadImage(url: URL) {

        // リクエスト作成
        let request = URLRequest(url: url)

        // セッション作成
        let session = URLSession.shared

        // リクエスト実行内容
        session.dataTask(with: request, completionHandler: { (data, urlresponse, error) -> Void in
            // 実行後処理
            if error != nil { self.image = nil; return }
            // 
            guard let data = data else { self.image = nil; return }
            //
            self.image = UIImage(data: data)
        }).resume() // リクエスト実行
    }
}

extension UIColor {

    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}
