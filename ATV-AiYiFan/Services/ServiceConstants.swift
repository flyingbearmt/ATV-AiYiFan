//
//  Constants.swift
//  ATV-AiYiFan
//
//  Created by Tong Miao on 5/25/25.
//
import CryptoKit
import Foundation

struct ServiceConstants {
    let baseUrl = "https://m10.yfsp.tv/"
    let privatekey = "SrCpJSrCpapCJCqCIurC"
    let publickey =
        "CJSrCpapCJCqCIurCZ5VLLDVDZWkCJarBZ4oE2upCLyp69eP7BCO6R4QcRCQC9YQCJ2minkmiJASCncOifoQcgzCJKsD6GtOsCoC6CoPc9XC6OvPJWuPZLcCcCoEMGpOp5"

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
}

struct BaseData<T: Codable>: Codable {
    let code: Int
    let msg: String
    let info: [T]
}
