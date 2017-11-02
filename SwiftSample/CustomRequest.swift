//
//  CustomRequest.swift
//  SwiftSample
//
//  Created by tkwatanabe on 2017/11/01.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation

//
public class Request {

    /// クレデンシャル作成
    func createCredential(username name: String, password pw: String) -> String? {
        guard let credentialData = "\(name):\(pw)".data(using: String.Encoding.utf8) else { return nil }
        return credentialData.base64EncodedString(options: [])
    }

    /// multiformdata作成
    func createMultiFormData(postData: [String: Data], mineType: String) -> Data? {
        var multiData = Data()

        let boundary = "POST-boundary-\(arc4random())-\(arc4random())"
        let prefixString = "--\(boundary)\r\n"
        let prefixData = prefixString.data(using: .utf8)!

        let seperator = "\r\n".data(using: .utf8)!

        // Prefixを追加
        multiData.append(prefixData)
        let utf8_Content_Disposition = "Content-Disposition: form-data; name=\"utf8\"\r\n"
        let utf8Data = utf8_Content_Disposition.data(using: .utf8)!
        multiData.append(utf8Data)
        multiData.append(seperator)

        // 取得したデータをmultiFormDataに加える
        for (key, value) in postData {
            let content_disposition = "Content-Disposition: form-data; name=\"\(key)\";\(value)\r\n"
            let contentData = content_disposition.data(using: String.Encoding.utf8)!
            multiData.append(contentData)
            multiData.append(seperator)
        }

        // ContentTypeを追加
        let mineType_Content_Disposition = "Content-Type: \(mineType)\r\n"
        let mineTypeData = mineType_Content_Disposition.data(using: .utf8)!
        multiData.append(mineTypeData)
        multiData.append(seperator)

        multiData.append(prefixData)

        return multiData
    }

    /// リクエストオブジェクト作成
    func createRequest(auth: String? = nil, boundary: String, url: URL, multipartFormData: Data) -> URLRequest {
        // リクエストオブジェクト作成
        var request = URLRequest(url: url)
        // contentType作成
        let contentType = "multipart/form-data; boundary=\(boundary)"
        // HTTP Method指定
        request.httpMethod = "POST"
        // Authorizationヘッダー設定
        if let at = auth {
            request.setValue("Basic \(at)", forHTTPHeaderField: "Authorization")
        }
        // コンテントタイプ設定
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        // コンテントレングス設定
        request.setValue("\(multipartFormData.count)", forHTTPHeaderField: "Content-Length")
        // HTTPボディー設定
        request.httpBody = multipartFormData
        //
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return request

    }

    /// リクエスト処理
    func resume(request: URLRequest, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void = { _ in }) {
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in completion(data, response, error)}).resume()
    }

}
