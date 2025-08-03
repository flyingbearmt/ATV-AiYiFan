//
//  ServiceConfigManager.swift
//  ATV-AiYiFan
//
//  Created by Tong Miao on 8/3/25.
//

import Foundation

/// A simple utility to manage service configuration in UserDefaults
struct ServiceConfigManager {
    
    // MARK: - UserDefault Keys
    private enum Keys {
        static let mainUrl = "com.aiyifan.mainUrl"
        static let mediaBaseUrl = "com.aiyifan.mediaBaseUrl"
        static let privateKey = "com.aiyifan.privateKey"
        static let publicKey = "com.aiyifan.publicKey"
    }
    
    // MARK: - Default Values
    private enum Defaults {
        static let mainUrl = "https://www.yfsp.tv"
        static let mediaBaseUrl = "https://m10.yfsp.tv/"
        static let privateKey = "SrCpJSrCpapCJCqCIurC"
        static let publicKey = "CJSrCpapCJCqCIurCZ5VLLDVDZWkCJarBZ4oE2upCLyp69eP7BCO6R4QcRCQC9YQCJ2minkmiJASCncOifoQcgzCJKsD6GtOsCoC6CoPc9XC6OvPJWuPZLcCcCoEMGpOp5"
    }
    
    // MARK: - Getters
    
    /// Get the main URL
    static var mainUrl: String {
        UserDefaults.standard.string(forKey: Keys.mainUrl) ?? Defaults.mainUrl
    }
    
    /// Get the media base URL
    static var mediaBaseUrl: String {
        UserDefaults.standard.string(forKey: Keys.mediaBaseUrl) ?? Defaults.mediaBaseUrl
    }
    
    /// Get the private key
    static var privateKey: String {
        UserDefaults.standard.string(forKey: Keys.privateKey) ?? Defaults.privateKey
    }
    
    /// Get the public key
    static var publicKey: String {
        UserDefaults.standard.string(forKey: Keys.publicKey) ?? Defaults.publicKey
    }
    
    // MARK: - Setters
    
    /// Update the main URL
    /// - Parameter url: The new main URL
    static func updateMainUrl(_ url: String) {
        UserDefaults.standard.set(url, forKey: Keys.mainUrl)
    }
    
    /// Update the media base URL
    /// - Parameter url: The new media base URL
    static func updateMediaBaseUrl(_ url: String) {
        UserDefaults.standard.set(url, forKey: Keys.mediaBaseUrl)
    }
    
    /// Update the private key
    /// - Parameter key: The new private key
    static func updatePrivateKey(_ key: String) {
        UserDefaults.standard.set(key, forKey: Keys.privateKey)
    }
    
    /// Update the public key
    /// - Parameter key: The new public key
    static func updatePublicKey(_ key: String) {
        UserDefaults.standard.set(key, forKey: Keys.publicKey)
    }
    
    /// Update all service configuration at once
    /// - Parameters:
    ///   - mainUrl: The new main URL (optional)
    ///   - mediaBaseUrl: The new media base URL (optional)
    ///   - privateKey: The new private key (optional)
    ///   - publicKey: The new public key (optional)
    static func updateConfig(
        mainUrl: String? = nil,
        mediaBaseUrl: String? = nil,
        privateKey: String? = nil,
        publicKey: String? = nil
    ) {
        if let mainUrl = mainUrl {
            updateMainUrl(mainUrl)
        }
        
        if let mediaBaseUrl = mediaBaseUrl {
            updateMediaBaseUrl(mediaBaseUrl)
        }
        
        if let privateKey = privateKey {
            updatePrivateKey(privateKey)
        }
        
        if let publicKey = publicKey {
            updatePublicKey(publicKey)
        }
    }
    
    /// Reset all configuration to default values
    static func resetToDefaults() {
        UserDefaults.standard.removeObject(forKey: Keys.mainUrl)
        UserDefaults.standard.removeObject(forKey: Keys.mediaBaseUrl)
        UserDefaults.standard.removeObject(forKey: Keys.privateKey)
        UserDefaults.standard.removeObject(forKey: Keys.publicKey)
    }
}
