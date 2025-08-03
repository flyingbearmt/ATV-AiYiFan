//
//  WebUI.swift
//  ATV-AiYiFan
//
//  Created by Tong Miao on 7/31/25.
//

import SwiftUI
import Combine
import Foundation

// MARK: - HTML Parser Service
class HTMLParserService {
    // A static shared instance for convenience
    static let shared = HTMLParserService()
    
    // Fetch and parse HTML from a URL
    func fetchAndExtractPConfig(from urlString: String, completion: @escaping (Result<[String: Any]?, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))            
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let htmlString = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "InvalidData", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to decode HTML data"])))
                return
            }
            
            // Extract pConfig using regex
            if let pConfig = self.extractPConfig(from: htmlString) {
                completion(.success(pConfig))
            } else {
                completion(.success(nil)) // No pConfig found, but not an error
            }
        }
        
        task.resume()
    }
    
    // Parse HTML content directly
    func extractPConfig(from htmlString: String) -> [String: Any]? {
        do {
            // Look for the exact format you provided on line 50
            let exactPattern = "\"pConfig\"\\s*:\\s*\\{\"publicKey\"\\s*:\\s*\"([^\"]+)\"\\s*,\\s*\"privateKey\"\\s*:\\s*(\\[[^\\]]+\\])\\}"
            let exactRegex = try NSRegularExpression(pattern: exactPattern, options: [.dotMatchesLineSeparators])
            
            if let match = exactRegex.firstMatch(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.utf16.count)) {
                if let publicKeyRange = Range(match.range(at: 1), in: htmlString),
                   let privateKeyRange = Range(match.range(at: 2), in: htmlString) {
                    let publicKey = String(htmlString[publicKeyRange])
                    let privateKeyStr = String(htmlString[privateKeyRange])
                    
                    // Parse privateKey as JSON array
                    if let data = privateKeyStr.data(using: .utf8),
                       let privateKeyArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                        return ["publicKey": publicKey, "privateKey": privateKeyArray]
                    } else {
                        return ["publicKey": publicKey, "privateKey": privateKeyStr]
                    }
                }
            }
            
            // Fall back to general injectJson pattern
            let pattern = "injectJson\\s*=\\s*([\\{\\[].+?[\\}\\]]);" // Match injectJson = {...};
            let regex = try NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
            
            if let match = regex.firstMatch(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.utf16.count)) {
                // Extract the JSON string
                if let range = Range(match.range(at: 1), in: htmlString) {
                    let jsonString = String(htmlString[range])
                    
                    // Parse the JSON
                    if let jsonData = jsonString.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                       let config = json["config"] as? [[String: Any]],
                       let firstConfig = config.first,
                       let pConfig = firstConfig["pConfig"] as? [String: Any] {
                        return pConfig
                    } else {
                        // Try an alternative approach if the JSON structure is different
                        return nil
                    }
                }
            }
        
        } catch {
            print("Regex error: \(error)")
            return nil
        }
        return nil
    }
}

// MARK: - ViewModel
class HTMLParserViewModel: ObservableObject {
    @Published var pConfig: [String: Any]? = nil
    @Published var isLoading: Bool = true
    @Published var error: Error? = nil
    
    private let parserService = HTMLParserService.shared
    
    func fetchConfig(from url: String = "https://www.yfsp.tv") {
        isLoading = true
        error = nil
        
        parserService.fetchAndExtractPConfig(from: url) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let config):
                    if let config = config {
                        self.pConfig = config
                        print("✅ pConfig extracted: \(config)")
                    } else {
                        print("⚠️ No pConfig found in the HTML")
                    }
                    
                case .failure(let error):
                    self.error = error
                    print("❌ Error extracting pConfig: \(error)")
                }
            }
        }
    }
    
    func getPublicKey() -> String? {
        return pConfig?["publicKey"] as? String
    }
    
    func getPrivateKey() -> String? {
        return pConfig?["privateKey"] as? String
    }
}
