//
//  KeyboardModel.swift
//  Nixacernis Keyboard
//
//  Created by CHEN Yifeng on 28/11/2018.
//
//

import Foundation

class KeyboardModel {
//    private var candidateList = [String](repeating: "", count: 4)
//    
//    init() {
//        return
//    }
//    
//    func getQueryResult(_ query: String)-> [String] {
//        return [""]
//    }
    
    //MARK: Properties
    private var pressedKeySequence = [String]()
    
    private var typingSequenceText = ""
    
    private var candidateListText = [String]()
    
    //MARK: Public Interface
    func passQuery(_ preKeySeq: [String]) {
        pressedKeySequence = preKeySeq
    }
    
    func getTypingSequenceText() -> String {
        return typingSequenceText
    }
    
    func getCandidateListText() -> [String] {
        return candidateListText
    }
    
    //MARK: Member functions
    func inferTypingSequenceText() {
        for key in pressedKeySequence {
            typingSequenceText = typingSequenceText + String(key[key.startIndex])
        }
    }
    
    func inferCandidateListText() {
        candidateListText.append(typingSequenceText)
    }
}
