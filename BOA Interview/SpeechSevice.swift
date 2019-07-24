//
//  SpeechSevice.swift
//  BOA Interview
//
//  Created by DLR on 7/19/19.
//  Copyright © 2019 DLR. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechService {
    
    var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    var voice = AVSpeechSynthesisVoice(language:  "en-US")
    
    private let synthesizer = AVSpeechSynthesizer()
    
    // MARK: - Enter a string of whatever we want to say
    func say(_ phrase: String) {
        
        // MARK: - Determine if VoiceOver is enabled or not
//        guard UIAccessibility.isVoiceOverRunning else { return }
        
        // MARK: - Utterance works with AVSpeechSynthesizer to say what needs to be said
        let utterance = AVSpeechUtterance(string: phrase)
        
        // MARK: - Speed at which the text is spoken aloud
        utterance.rate = rate  // AVSpeechUtteranceDefaultSpeechRate is normal
        
        // MARK: - Selectable language for the spoken text
        utterance.voice = voice
        
        // MARK: - Passing an utterance to it
        synthesizer.speak(utterance)
    }
    
    func getVoices() {
        // MARK: - Print out all possible voices selectable for utterance.voice
        AVSpeechSynthesisVoice.speechVoices().forEach({ print($0) })
        
        // MARK: - Print out all possible languages selectable for utterance.voice
        AVSpeechSynthesisVoice.speechVoices().forEach({ print($0.language) })
    }
}
