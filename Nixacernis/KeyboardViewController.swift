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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadKeyboardInterface()
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
