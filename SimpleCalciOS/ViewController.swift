//
//  ViewController.swift
//  SimpleCalciOS
//
//  Created by Sam Bender on 10/22/15.
//  Copyright © 2015 Sam Bender. All rights reserved.
//

import UIKit

let darkGrayBG = UIColor(red: 0.21, green: 0.21, blue: 0.21, alpha: 1.0)

class ViewController: UIViewController {
    @IBOutlet var label: UILabel!
    var mathFunctionToApply: ((Double) -> (Double))?
    var result : Double = 0.0
    var lastNum : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = darkGrayBG
        self.label!.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    /***********/
    /* Actions */
    /***********/
     
    @IBAction func buttonTouchUp(sender: UIButton) {
        
        switch sender.titleLabel!.text! {
            case ".":
                self.addToLabel(".")
            case "0":
                self.addToLabel("0")
            case "1":
                self.addToLabel("1")
            case "2":
                self.addToLabel("2")
            case "3":
                self.addToLabel("3")
            case "4":
                self.addToLabel("4")
            case "5":
                self.addToLabel("5")
            case "6":
                self.addToLabel("6")
            case "7":
                self.addToLabel("7")
            case "8":
                self.addToLabel("8")
            case "9":
                self.addToLabel("9")
            case "+":
                mathFunctionToApply = add
                result = self.stringToDouble(self.label!.text!)!
            case "=":
                if mathFunctionToApply == nil {
                    return
                }
                let stringValue : String = (self.label?.text)!
                let currentValue = self.stringToDouble(stringValue)
                result = mathFunctionToApply!(currentValue!)
                self.label!.text = result.description
            default:
                return
        }
    }
    
    func addToLabel(var string: String)
    {
        if label!.text == nil || label!.text == ""
        {
            if string == "." {
                string = "0."
            }
            
            label!.text = string
        }
        else
        {
            label!.text! += string
        }
    }
    
    /********/
     // Math
    /********/
    
    func stringToDouble(incoming:String) -> Double?
    {
        return Double(incoming)
    }
    
    func add(num : Double) -> Double
    {
        return result + num
    }
    
    func fact(number:Double)
    {
        if number < 0 || floor(number) != number
        {
            print("Factorial is not defined for non-natural numbers")
            return
        }
        
        let result = factRecursive(number)
        print("= \(result)")
    }
    
    func factRecursive(number:Double) -> Double
    {
        
        
        // remember:  0! = 1
        if number < 2
        {
            return 1
        }
        
        return number * factRecursive(number - 1)
    }
    
    func average(numbers:[Double]) -> Double
    {
        var sum = 0.0
        for number in numbers
        {
            sum += number
        }
        return sum / Double(numbers.count)
    }
}

