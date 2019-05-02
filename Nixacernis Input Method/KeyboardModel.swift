//
//  KeyboardModel.swift
//  Nixacernis Keyboard
//
//  Created by CHEN Yifeng on 8/3/19.
//
//

import Foundation

class KeyboardModel {
    func transliterate(_ key_list: [String]) -> String {
        return key_list.joined(separator: "-")
    }
    
    
}
