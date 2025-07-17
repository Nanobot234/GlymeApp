////
////  TextToSpeechManager.swift
////  Glyme
////
////  Created by Nana Bonsu on 6/30/25.
////
//
import Foundation
import AVFoundation


// TextToSpeechManager.swift


struct TextToSpeechManager {
    
    private static var synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    
    static func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4 // Adjust the rate as needed
        utterance.pitchMultiplier = 1.2 // 0.5 (lowest) to 2.0 (highest), default is 1.0
        synthesizer.speak(utterance)
    }
}


//import AVFoundation
//
//class TextToSpeechManager: NSObject, AVSpeechSynthesizerDelegate {
//    private let synthesizer = AVSpeechSynthesizer()
//    private var continuation: CheckedContinuation<Void, Never>?
//
//    // Singleton instance
//    static let shared = TextToSpeechManager()
//
//
//    override init() {
//        super.init()
//        synthesizer.delegate = self
//    }
//
//    func speak(_ text: String) async {
//        if synthesizer.isSpeaking {
//            synthesizer.stopSpeaking(at: .immediate)
//        }
//
//        let utterance = AVSpeechUtterance(string: text)
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//        utterance.rate = 0.5
//
//        await withCheckedContinuation { continuation in
//            self.continuation = continuation
//            synthesizer.speak(utterance)
//        }
//    }
//
//    // Called when speech is done
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        continuation?.resume()
//        continuation = nil
//    }
//
//    // Optional: Cancel if interrupted
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
//        continuation?.resume()
//        continuation = nil
//    }
//}
//
