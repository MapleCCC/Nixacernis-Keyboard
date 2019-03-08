//
//  ViewController.swift
//  Nixacernis Keyboard
//
//  Created by CHEN Yifeng on 7/3/19.
//
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        
        let textField = UITextField(frame: CGRect(x: screenWidth/2, y: screenHeight/2, width: screenWidth/3, height: screenHeight/3))
        self.view.addSubview(textField)
        textField.placeholder = "Write something here!"
        textField.isEnabled = true
        textField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

