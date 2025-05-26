//
//  Constants.swift
//  ATV-AiYiFan
//
//  Created by Tong Miao on 5/25/25.
//
import CryptoKit
import Foundation

struct ServiceConstants{
    private let baseUrl = "https://m10.yfsp.tv/"
    let privatekey = "SqE3JSqE34uDZOrCIusE"
    let publickey = "CJSqE34uDZOrCIusELyggQzDZWkCJarBZ4oE2upCLyp71cn6x4PiHcp6foQ6Z6S73CPCPiSCR4p6hAnCXiS6YzDZOtC3OnPJOmP3WrCZPbC30qDZTaOsPcDZCpOp9XOp4"
    
    // Add a map for base paths
    private let basePathMap: [String: String] = [
        "search": "api/list/Search?",
        "genres":"api/list/AllVideoType?",
        "videodetail":"v3/video/detail?",
        "videoplay":"v3/video/play?"
    ]
    
    private func getmd5(
        queryPath:String,
    ) -> String {
        let lowercasedQuery = queryPath.lowercased()
        let baseString = "\(publickey)&\(lowercasedQuery)&\(privatekey)"
        let digest = Insecure.MD5.hash(data: Data(baseString.utf8))
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
    
    func getQueryUrl(
        queryParamString : String,
        basePathType: String = "default"
    ) -> String{
        let chosenBasePAth = basePathMap[basePathType] ?? baseUrl
        var sourceUrl = ""
        sourceUrl += baseUrl
        sourceUrl += chosenBasePAth
        sourceUrl += queryParamString
        sourceUrl += "&vv=\(getmd5(queryPath: queryParamString))"
        sourceUrl += "&pub=\(publickey)"
        return sourceUrl
    }
}

