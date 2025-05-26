//
//  Constants.swift
//  ATV-AiYiFan
//
//  Created by Tong Miao on 5/25/25.
//
import CryptoKit
import Foundation

struct ServiceConstants{
    let baseUrl = "https://m10.yfsp.tv/api/list/"
    let privatekey = "SqE3JSqE34uDZOrCIusE"
    let publickey = "CJSqE34uDZOrCIusELyggQzDZWkCJarBZ4oE2upCLyp71cn6x4PiHcp6foQ6Z6S73CPCPiSCR4p6hAnCXiS6YzDZOtC3OnPJOmP3WrCZPbC30qDZTaOsPcDZCpOp9XOp4"
    
    private func getmd5(
        queryPath:String,
    ) -> String {
        let lowercasedQuery = queryPath.lowercased()
        debugPrint(lowercasedQuery)
        let baseString = "\(publickey)&\(lowercasedQuery)&\(privatekey)"
        let digest = Insecure.MD5.hash(data: Data(baseString.utf8))
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
    
    func getQueryUrl(
        querySubPath: String,
        queryParamString : String
    ) -> String{
        var sourceUrl = ""
        sourceUrl+=baseUrl
        sourceUrl+=querySubPath
        sourceUrl+=queryParamString
        sourceUrl+="&vv=\(getmd5(queryPath: queryParamString))"
        sourceUrl+="&pub=\(publickey)"
        return sourceUrl
    }
}
