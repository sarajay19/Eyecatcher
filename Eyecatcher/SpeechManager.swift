//
//  SpeechManager.swift
//  Eyecatcher
//
//  Created by Sara AlQuwaifli on 19/05/2024.
//

import Foundation
import AVFoundation

class SpeechSynthesizer {
    private var speechSynthesizer = AVSpeechSynthesizer()
    private var languageCode = "en-US"  // Default to English

    // Updates the language code within this instance
    func updateLanguage(to language: String) {
        switch language {
        case "Arabic":
            languageCode = "ar-SA"
        default:
            languageCode = "en-US"
        }
        print("Language updated to: \(languageCode)")
    }

    // Detects the language of the provided label and speaks it
    func detectAndSpeak(label: String) {
        print("Trying to speak label: \(label)")  // Debug print
        let detectedLanguage = detectLanguage(of: label) // Needs implementation
        switch detectedLanguage {
        case "ar":
            updateLanguage(to: "Arabic")
        default:
            updateLanguage(to: "English")
        }
       
        print("label is: \(label)")
        print("detectedLanguage: \(detectedLanguage)")

        speak(text: label)
    }

    // Speaks the text using the current language setting
    func speak(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        speechSynthesizer.speak(speechUtterance)
    }

    // Placeholder function to detect language
    // You need to replace this with actual language detection logic
    private func detectLanguage(of text: String) -> String {
        // Placeholder logic: Assume all text containing Arabic characters is Arabic
        if text.range(of: "\\p{InArabic}", options: .regularExpression) != nil {
            return "ar"
        } else {
            return "en"
        }
    }
}
