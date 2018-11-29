//
//  KeyboardViewController.swift
//  Nixacernis
//
//  Created by CHEN Yifeng on 28/11/2018.
//
//

import UIKit

//// The header of UIInputViewController class, comment here for convenient reference.
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
    
    //MARK: Actions
    @IBAction func touchCandidateButton(_ sender: UIButton) {
        textDocumentProxy.insertText(sender.currentTitle!)
        resetDisplay()
    }
    
    @IBAction func touchEnterButton(_ sender: UIButton) {
        if userIsTyping == true {
            let firstCandidate = candidateList.arrangedSubviews[0] as! UIButton
            textDocumentProxy.insertText(firstCandidate.currentTitle!)
            resetDisplay()
        } else {
            textDocumentProxy.insertText("\n")
        }
    }
    
    @IBAction func touchBackspaceButton(_ sender: UIButton) {
        if userIsTyping == true {
            var sequence = typingSequence.text!
            sequence.remove(at: sequence.index(before: sequence.endIndex))
            typingSequence.text = sequence
            updateCandidateList()
        } else {
            textDocumentProxy.deleteBackward()
        }
    }
    
    @IBAction func touchKey(_ sender: UIButton) {
        if userIsTyping == true {
            typingSequence.text = typingSequence.text! + sender.currentTitle!
            updateCandidateList()
        } else {
            typingSequence.text = sender.currentTitle!
            updateCandidateList()
        }
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
    
    func resetDisplay() {
        let candidates = candidateList.arrangedSubviews
        for candidate in candidates {
            candidate.isHidden = true
        }
        
        typingSequence.isHidden = true
    }
    
    //MARK: Member functions
    func updateCandidateList() {
        
        var queryResult = keyboardModel.getQueryResult(typingSequence)
        var candidates = candidateList.arrangedSubviews
        for candidate in candidates {
            candidate.title = queryResult[]
        }
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
