//
//  ViewController.swift
//  EncryptDecrypt
//
//  Created by Rao-Mac-3 on 26/11/19.
//  Copyright © 2019 Rao-Mac-3. All rights reserved.
//

import UIKit
import CommonCrypto
import CryptoSwift

class ViewController: UIViewController
{
    @IBOutlet weak var txtEncrypt: UITextView!
    
    @IBOutlet weak var txtDecrypt: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func btnEncryptClicked(_ sender: UIButton)
    {
        
        print(aes_Encrypt(AES_KEY: "1234567890123456", value: txtEncrypt.text ?? ""))
//        do {
//            let aes = try AES(keyString: "Test@@123")
//
//            let stringToEncrypt: String = txtEncrypt.text ?? ""
//            print("String to encrypt:\t\t\t\(stringToEncrypt)")
//
//            let encryptedData: Data = try aes.encrypt(stringToEncrypt)
//            print("String encrypted (base64):\t\(encryptedData.base64EncodedString())")
//
//            let decryptedData: String = try aes.decrypt(encryptedData)
//            print("String decrypted:\t\t\t\(decryptedData)")
//
//        } catch {
//            print("Something went wrong: \(error)")
//        }
        
        
    }
    
    @IBAction func btnDecryptClicked(_ sender: UIButton)
    {
        print(aes_Decrypt(AES_KEY: "1234567890123456", value: txtDecrypt.text ?? ""))
    }
    
    // encrypt the string
    func aes_Encrypt(AES_KEY: String,value:String) -> String {
        var result = ""
        do {
            let key: [UInt8] = Array(AES_KEY.utf8) as [UInt8]
            let aes = try! AES(key: key, blockMode: ECB() as BlockMode, padding: .pkcs5)
            let encrypted = try aes.encrypt(value.bytes)
            result = encrypted.toBase64()!
            print("AES Encryption Result: \(result)")
            txtDecrypt.text = result
            txtEncrypt.text = ""
        } catch {
            print("Error: \(error)")
        }
        return result
    }

    // decrypt the string
    func aes_Decrypt(AES_KEY: String,value:String) -> String {
        var result = ""
        do {
            let key: [UInt8] = Array(AES_KEY.utf8) as [UInt8]
            let aes = try! AES(key: key, blockMode: ECB() as BlockMode, padding: .pkcs5) // AES128 .ECB pkcs7
            let decrypted = try aes.decrypt(Array(base64: value))
            result = String(data: Data(decrypted), encoding: .utf8) ?? ""
            print("AES Decryption Result: \(result)")
            txtEncrypt.text = result
            txtDecrypt.text = ""
        } catch {
            print("Error: \(error)")
        }
        return result
    }
   
}

//protocol Cryptable {
//    func encrypt(_ string: String) throws -> Data
//    func decrypt(_ data: Data) throws -> String
//}
//
//struct AES {
//    private let key: Data
//    private let ivSize: Int         = kCCBlockSizeAES128
//    private let options: CCOptions  = CCOptions(kCCOptionPKCS7Padding)
//
//    init(keyString: String) throws {
//        guard keyString.count == kCCKeySizeAES256 else {
//            throw Error.invalidKeySize
//        }
//        self.key = Data(keyString.utf8)
//    }
//}
//
//extension AES {
//    enum Error: Swift.Error {
//        case invalidKeySize
//        case generateRandomIVFailed
//        case encryptionFailed
//        case decryptionFailed
//        case dataToStringFailed
//    }
//}
//
//private extension AES {
//
//    func generateRandomIV(for data: inout Data) throws {
//
//        try data.withUnsafeMutableBytes { dataBytes in
//
//            guard let dataBytesBaseAddress = dataBytes.baseAddress else {
//                throw Error.generateRandomIVFailed
//            }
//
//            let status: Int32 = SecRandomCopyBytes(
//                kSecRandomDefault,
//                kCCBlockSizeAES128,
//                dataBytesBaseAddress
//            )
//
//            guard status == 0 else {
//                throw Error.generateRandomIVFailed
//            }
//        }
//    }
//}
//
//extension AES: Cryptable {
//
//    func encrypt(_ string: String) throws -> Data {
//        let dataToEncrypt = Data(string.utf8)
//
//        let bufferSize: Int = ivSize + dataToEncrypt.count + kCCBlockSizeAES128
//        var buffer = Data(count: bufferSize)
//        try generateRandomIV(for: &buffer)
//
//        var numberBytesEncrypted: Int = 0
//
//        do {
//            try key.withUnsafeBytes { keyBytes in
//                try dataToEncrypt.withUnsafeBytes { dataToEncryptBytes in
//                    try buffer.withUnsafeMutableBytes { bufferBytes in
//
//                        guard let keyBytesBaseAddress = keyBytes.baseAddress,
//                            let dataToEncryptBytesBaseAddress = dataToEncryptBytes.baseAddress,
//                            let bufferBytesBaseAddress = bufferBytes.baseAddress else {
//                                throw Error.encryptionFailed
//                        }
//
//                        let cryptStatus: CCCryptorStatus = CCCrypt( // Stateless, one-shot encrypt operation
//                            CCOperation(kCCEncrypt),                // op: CCOperation
//                            CCAlgorithm(kCCAlgorithmAES),           // alg: CCAlgorithm
//                            options,                                // options: CCOptions
//                            keyBytesBaseAddress,                    // key: the "password"
//                            key.count,                              // keyLength: the "password" size
//                            bufferBytesBaseAddress,                 // iv: Initialization Vector
//                            dataToEncryptBytesBaseAddress,          // dataIn: Data to encrypt bytes
//                            dataToEncryptBytes.count,               // dataInLength: Data to encrypt size
//                            bufferBytesBaseAddress + ivSize,        // dataOut: encrypted Data buffer
//                            bufferSize,                             // dataOutAvailable: encrypted Data buffer size
//                            &numberBytesEncrypted                   // dataOutMoved: the number of bytes written
//                        )
//
//                        guard cryptStatus == CCCryptorStatus(kCCSuccess) else {
//                            throw Error.encryptionFailed
//                        }
//                    }
//                }
//            }
//
//        } catch {
//            throw Error.encryptionFailed
//        }
//
//        let encryptedData: Data = buffer[..<(numberBytesEncrypted + ivSize)]
//        return encryptedData
//    }
//
//    func decrypt(_ data: Data) throws -> String {
//
//        let bufferSize: Int = data.count - ivSize
//        var buffer = Data(count: bufferSize)
//
//        var numberBytesDecrypted: Int = 0
//
//        do {
//            try key.withUnsafeBytes { keyBytes in
//                try data.withUnsafeBytes { dataToDecryptBytes in
//                    try buffer.withUnsafeMutableBytes { bufferBytes in
//
//                        guard let keyBytesBaseAddress = keyBytes.baseAddress,
//                            let dataToDecryptBytesBaseAddress = dataToDecryptBytes.baseAddress,
//                            let bufferBytesBaseAddress = bufferBytes.baseAddress else {
//                                throw Error.encryptionFailed
//                        }
//
//                        let cryptStatus: CCCryptorStatus = CCCrypt( // Stateless, one-shot encrypt operation
//                            CCOperation(kCCDecrypt),                // op: CCOperation
//                            CCAlgorithm(kCCAlgorithmAES128),        // alg: CCAlgorithm
//                            options,                                // options: CCOptions
//                            keyBytesBaseAddress,                    // key: the "password"
//                            key.count,                              // keyLength: the "password" size
//                            dataToDecryptBytesBaseAddress,          // iv: Initialization Vector
//                            dataToDecryptBytesBaseAddress + ivSize, // dataIn: Data to decrypt bytes
//                            bufferSize,                             // dataInLength: Data to decrypt size
//                            bufferBytesBaseAddress,                 // dataOut: decrypted Data buffer
//                            bufferSize,                             // dataOutAvailable: decrypted Data buffer size
//                            &numberBytesDecrypted                   // dataOutMoved: the number of bytes written
//                        )
//
//                        guard cryptStatus == CCCryptorStatus(kCCSuccess) else {
//                            throw Error.decryptionFailed
//                        }
//                    }
//                }
//            }
//        } catch {
//            throw Error.encryptionFailed
//        }
//
//        let decryptedData: Data = buffer[..<numberBytesDecrypted]
//
//        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
//            throw Error.dataToStringFailed
//        }
//
//        return decryptedString
//    }
//}
//
//


