//
//  KeyboardViewController.swift
//  Nixacernis
//
//  Created by CHEN Yifeng on 28/11/2018.
//
//

import UIKit

//// The header of UIInputViewController class, as comment here for convenient reference.
//class UIInputViewController : UIViewController, UITextInputDelegate, NSObjectProtocol {
//    
//    var inputView: UIInputView!
//    
//    var textDocumentProxy: NSObject! { get }
//    
//    func dismissKeyboard()
//    func advanceToNextInputMode()
//    
//    // This will not provide a complete repository of a language's vocabulary.
//    // It is solely intended to supplement existing lexicons.
//    func requestSupplementaryLexiconWithCompletion(completionHandler: ((UILexicon!) -> Void)!)
//}

class KeyboardViewController: UIInputViewController {
    
    //MARK: Properties
    var keyboardView: UIView!
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    @IBOutlet weak var candidateList: UIStackView!
    
    @IBOutlet weak var typingSequence: UILabel!
    
    var userIsTyping: Bool = false
    
    var pressedKeySequence = [String]()
    
    var keyboardModel = KeyboardModel()
    
    //MARK: Actions
    @IBAction func touchCandidateButton(_ sender: UIButton) {
        textDocumentProxy.insertText(sender.currentTitle!)
        
        resetKeyboard()
    }
    
    @IBAction func touchEnterButton(_ sender: UIButton) {
        if userIsTyping == true {
            let firstCandidate = candidateList.arrangedSubviews[0] as! UIButton
            textDocumentProxy.insertText(firstCandidate.currentTitle!)
            
            resetKeyboard()
        } else {
            textDocumentProxy.insertText("\n")
        }
    }
    
    @IBAction func touchBackspaceButton(_ sender: UIButton) {
        if userIsTyping == true {
            if pressedKeySequence.count == 1 {
                resetKeyboard()
            } else {
                pressedKeySequence.removeLast()
                updateDisplay()
            }
        } else {
            textDocumentProxy.deleteBackward()
        }
    }
    
    @IBAction func touchKey(_ sender: UIButton) {
        if userIsTyping == false {
            pressedKeySequence = [sender.currentTitle!]
            userIsTyping = true
            beginDisplay()
        } else {
            pressedKeySequence.append(sender.currentTitle!)
            updateDisplay()
        }
    }
    
    //MARK: Member functions
    func beginDisplay() {
        typingSequence.isHidden = false
        
        let candidates = candidateList.arrangedSubviews as! [UIButton]
        for candidate in candidates {
            candidate.isHidden = false
        }
        
        updateDisplay()
    }
    
    func updateDisplay() {
        keyboardModel.passQuery(pressedKeySequence)
        
        typingSequence.text = keyboardModel.getTypingSequenceText()
        
        var candidateListText = keyboardModel.getCandidateListText()
        let candidates = candidateList.arrangedSubviews as! [UIButton]
        
        let length = candidateListText.count < candidates.count ? candidateListText.count : candidates.count
        
        for i in 0...length {
                candidates[i].setTitle(candidateListText[i], for: .normal)
        }
    }
    
    func resetDisplay() {
        let candidates = candidateList.arrangedSubviews as! [UIButton]
        for candidate in candidates {
            candidate.setTitle("", for: .normal)
            candidate.isHidden = true
        }
        
        typingSequence.text = ""
        typingSequence.isHidden = true
    }
    
    func resetKeyboard() {
        pressedKeySequence = []
        userIsTyping = false
        resetDisplay()
    }
    
    
    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadKeyboardInterface()
        
        resetDisplay()
    }
    
    func loadKeyboardInterface() {
        let keyboardNib = UINib(nibName: "KeyboardView", bundle: nil)
        keyboardView = keyboardNib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.addSubview(keyboardView)
        view.backgroundColor = keyboardView.backgroundColor
        
        nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
//    override func textWillChange(_ textInput: UITextInput?) {
//        // The app is about to change the document's contents. Perform any preparation here.
//    }
//    
//    override func textDidChange(_ textInput: UITextInput?) {
//        // The app has just changed the document's contents, the document context has been updated.
//        
//        var textColor: UIColor
//        let proxy = self.textDocumentProxy
//        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
//            textColor = UIColor.white
//        } else {
//            textColor = UIColor.black
//        }
//        self.nextKeyboardButton.setTitleColor(textColor, for: [])
//    }

}
