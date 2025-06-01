//
//  Constants.swift
//  ATV-AiYiFan
//
//  Created by Tong Miao on 5/25/25.
//
import CryptoKit
import Foundation

struct ServiceConstants {
    private let baseUrl = "https://m10.yfsp.tv/"
    let privatekey = "SqE3JSqE34uDZOrCIusE"
    let publickey =
        "CJSqE34uDZOrCIusELyggQzDZWkCJarBZ4oE2upCLyp71cn6x4PiHcp6foQ6Z6S73CPCPiSCR4p6hAnCXiS6YzDZOtC3OnPJOmP3WrCZPbC30qDZTaOsPcDZCpOp9XOp4"

    // Add a map for base paths
    private let basePathMap: [String: String] = [
        "search": "api/list/Search?",
        "genres": "api/list/AllVideoType?",
        "videodetail": "v3/video/detail?",
        "videoplaysourcelist": "v3/video/play?",
        "seriesList": "v3/video/languagesplaylist?",
    ]

    private func getmd5(
        queryPath: String,
    ) -> String {
        let lowercasedQuery = queryPath.lowercased()
        let baseString = "\(publickey)&\(lowercasedQuery)&\(privatekey)"
        let digest = Insecure.MD5.hash(data: Data(baseString.utf8))
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    func getQueryUrl(
        queryParamString: String,
        basePathType: String = "search"
    ) -> String {
        debugPrint("normal query, query: \(queryParamString)")
        let chosenBasePAth = basePathMap[basePathType] ?? ""
        var sourceUrl = ""
        sourceUrl += baseUrl
        sourceUrl += chosenBasePAth
        sourceUrl += queryParamString
        sourceUrl += "&vv=\(getmd5(queryPath: queryParamString))"
        sourceUrl += "&pub=\(publickey)"
        return sourceUrl
    }

    func getCustomizePathUrl(
        queryPath: String,
        queryParamString: String?,
    ) -> String {
        debugPrint(
            "CustomizePath& query: path:\(queryPath), query: \(String(describing: queryParamString))"
        )
        var sourceUrl = ""
        sourceUrl += baseUrl
        sourceUrl += queryPath
        if let queryParamString = queryParamString, !queryParamString.isEmpty {
            sourceUrl += "?" + queryParamString
            sourceUrl += "&vv=\(getmd5(queryPath: queryParamString))"
        } else {
            sourceUrl += "?vv=\(getmd5(queryPath: ""))"
        }
        sourceUrl += "&pub=\(publickey)"
        return sourceUrl
    }
}

struct BaseResponse<T: Codable>: Codable {
    let ret: Int
    let data: BaseData<T>
    let msg: String
    let debug: String
}

struct BaseData<T: Codable>: Codable {
    let code: Int
    let msg: String
    let info: [T]
}
