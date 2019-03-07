//
//  KeyboardViewController.swift
//  Nixacernis Input Method
//
//  Created by CHEN Yifeng on 7/3/19.
//
//
//  References: https://www.appdesignvault.com/ios-8-custom-keyboard-extension/

import UIKit

class KeyboardViewController: UIInputViewController {

    //MARK: Oulets
    //@IBOutlet var nextKeyboardButton: UIButton!
    
    //MARK: Actions
    func didTapButton(sender: AnyObject?) {
        let button = sender as! UIButton
        let title = button.title(for: .normal)! as String
        
        let proxy = textDocumentProxy
        
        switch title {
        case "BP" :
            proxy.deleteBackward()
        case "RETURN" :
            proxy.insertText("\n")
        case "SPACE" :
            proxy.insertText(" ")
        case "CHG" :
            advanceToNextInputMode()
        default :
            proxy.insertText(title)
        }
    }

    //MARK: helper functions
//    func addAttributeTo(_ title: NSString) -> NSAttributedString {
//        //let firstNewline = buttonTitle.firstIndex(of: "\n") ?? buttonTitle.endIndex
//        //let firstLine = buttonTitle[..<firstNewline]
//        
//        var newlineRange: NSRange = title.range(of: "\n")
//        var substring1 = ""
//        var substring2 = ""
//        
//        if (newlineRange.location != NSNotFound) {
//            substring1 = title.substring(to: newlineRange.location)
//            substring2 = title.substring(from: newlineRange.location)
//        }
//        
//        let font1: UIFont? = UIFont(name: "Arial", size: 25.0)
//        let attrString1 = NSMutableAttributedString(
//            string: substring1 as String,
//            attributes: NSDictionary(
//                object: font1!,
//                forKey: NSFontAttributeName) as [NSObject: AnyObject])
//        
//        let font2: UIFont? = UIFont(name: "Arial", size: 15.0)
//        let attrString2 = NSMutableAttributedString(
//            string: substring2 as String,
//            attributes: NSDictionary(
//                object: font2!,
//            forKey: NSFontAttributeName) as [NSObject: AnyObject])
//        
//        return attrString1 + attrString2
//    }
    
    func customizeTitleOfButton( _ title: String, _ button: UIButton) {
        
//        //Simpler solution, if don't need two different font styles.
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)  //ofSize: 15
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.darkGray, for: .normal)
        
        //More complicated solution, for more flexible font styles.
        //
        //We need to bridge between String, NSString and NSAttributedString due to API compatibility issue.
        //Also because the XCode version currently available doesn't support Swift 5, hence a bunch of new syntax.
//        button.titleLabel?.attributedText = addAttributeTo(title as NSString)
//        button.titleLabel?.lineBreakMode = .byWordWrapping
//        button.titleLabel?.textAlignment = .center
    }
    
    func createButtonWithTitleAndImage(title: String, image: UIImage?) -> UIButton {
        let button = UIButton(type: .system)
        
        //button.setImage(image, for: .normal)
        //button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        customizeTitleOfButton(title, button)
        
        button.backgroundColor = UIColor(white: 1.0, alpha:1.0)
        
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        
        return button
    }
    
    func addIndividualButtonConstraints(buttons: [UIButton], mainView: UIView) {
        for (index, button) in buttons.enumerated() {
            
            //to add a 1px constraint to the top and bottom of each key in relation to the view for the row
            let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 1)
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: -1)
            
            //adds a 1px constraint to the left and right of each key in relation to the adjacent keys 
            //(or the row view if it is the first or last key in the row)
            var rightConstraint: NSLayoutConstraint
            
            if index == buttons.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: mainView, attribute: .right, multiplier: 1.0, constant: -1)
            } else {
                let nextButton = buttons[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: nextButton, attribute: .left, multiplier: 1.0, constant: -1)
            }
            
            var leftConstraint: NSLayoutConstraint
            
            if index == 0 {
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: mainView, attribute: .left, multiplier: 1.0, constant: 1)
            } else {
                let prevtButton = buttons[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: prevtButton, attribute: .right, multiplier: 1.0, constant: 1)
                
                //adds constraint to the width of all keys, enforcing them to have equalwidth.
                let firstButton = buttons[0]
                let widthConstraint = NSLayoutConstraint(item: firstButton, attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1.0, constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    func createRowOfButtons(_ buttonTitles: [String]) -> UIView {
        var buttons = [UIButton]()
        let keyboardRowView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        
        for buttonTitle in buttonTitles {
            //let buttonImage = UIImage(named: "a.png")
            let buttonImage: UIImage? = nil
            let button = createButtonWithTitleAndImage(title: buttonTitle, image: buttonImage)
            buttons.append(button)
            keyboardRowView.addSubview(button)
        }
        
        addIndividualButtonConstraints(buttons: buttons, mainView: keyboardRowView)
        
        return keyboardRowView
    }
    
    func addConstraintsToInputView(inputView: UIView, rowViews: [UIView]){
        for (index, rowView) in rowViews.enumerated() {
            
            // adds a 1px constraint to the left and right of the row in relation to the main view
            let rightSideConstraint = NSLayoutConstraint(item: rowView, attribute: .right, relatedBy: .equal, toItem: inputView, attribute: .right, multiplier: 1.0, constant: -1)
            
            let leftConstraint = NSLayoutConstraint(item: rowView, attribute: .left, relatedBy: .equal, toItem: inputView, attribute: .left, multiplier: 1.0, constant: 1)
            
            inputView.addConstraints([leftConstraint, rightSideConstraint])
            
            // adds a 0px constraint between the each row and the next one below and above it.
            var topConstraint: NSLayoutConstraint
            
            if index == 0 {
                topConstraint = NSLayoutConstraint(item: rowView, attribute: .top, relatedBy: .equal, toItem: inputView, attribute: .top, multiplier: 1.0, constant: 0)
            } else{
                let prevRow = rowViews[index-1]
                topConstraint = NSLayoutConstraint(item: rowView, attribute: .top, relatedBy: .equal, toItem: prevRow, attribute: .bottom, multiplier: 1.0, constant: 0)
    
                // adds constraint enforce rows to have equal height.
                let firstRow = rowViews[0]
                let heightConstraint = NSLayoutConstraint(item: firstRow, attribute: .height, relatedBy: .equal, toItem: rowView, attribute: .height, multiplier: 1.0, constant: 0)
                
                inputView.addConstraint(heightConstraint)
            }
            
            inputView.addConstraint(topConstraint)
            
            var bottomConstraint: NSLayoutConstraint
            
            if index == rowViews.count - 1 {
                bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .bottom, relatedBy: .equal, toItem: inputView, attribute: .bottom, multiplier: 1.0, constant: 0)
            }else{
                let nextRow = rowViews[index+1]
                bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .bottom, relatedBy: .equal, toItem: nextRow, attribute: .top, multiplier: 1.0, constant: 0)
            }
            
            inputView.addConstraint(bottomConstraint)
        }
    }
    
    //MARK: Inherited member funtions
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        
        //  keyboard keys UI setup
        let buttonTitles1 = ["HP\na ia ua", "YZ", " O ", " U ", " E ", " S "]
        let buttonTitles2 = [" G ", " A ", " N ", "J L", " I ", "B W"]
        let buttonTitles3 = ["P V", " D ", "M X", "C T", "K Q", "F R"]
        let buttonTitles4 = ["CHG", "SPACE", "RETURN", "BP"]
        
        let row1 = createRowOfButtons(buttonTitles1)
        let row2 = createRowOfButtons(buttonTitles2)
        let row3 = createRowOfButtons(buttonTitles3)
        let row4 = createRowOfButtons(buttonTitles4)
        
        self.view.addSubview(row1)
        self.view.addSubview(row2)
        self.view.addSubview(row3)
        self.view.addSubview(row4)
        
        row1.translatesAutoresizingMaskIntoConstraints = false
        row2.translatesAutoresizingMaskIntoConstraints = false
        row3.translatesAutoresizingMaskIntoConstraints = false
        row4.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintsToInputView(inputView: self.view, rowViews: [row1, row2, row3, row4])
        
//        // nextKeyboardButton UI setup
//        self.nextKeyboardButton = UIButton(type: .system)
//        
//        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
//        self.nextKeyboardButton.sizeToFit()
//        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
//        
//        self.view.addSubview(self.nextKeyboardButton)
//        
//        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
//        var textColor: UIColor
//        let proxy = self.textDocumentProxy
//        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
//            textColor = UIColor.white
//        } else {
//            textColor = UIColor.black
//        }
//        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
