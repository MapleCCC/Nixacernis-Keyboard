//
//  KeyboardModel.swift
//  Nixacernis Keyboard
//
//  Created by CHEN Yifeng on 28/11/2018.
//
//

import Foundation

class KeyboardModel {
    private var candidateList = [String](repeating: "", count: 4)
    
    init() {
        return
    }
    
    func getQueryResult(_ query: String)-> [String] {
        return candidateList
    }
}
