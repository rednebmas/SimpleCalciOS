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
    /*************/
    /* Variables */
    /*************/
    
    @IBOutlet var label: UILabel!
    @IBOutlet var functionLabel: UILabel!
    
    var mathFunctionToApply: ((Double) -> (Double))?
    var result : Double = 0.0
    var averageCount : Double = 0.0
    var clearInputOnNextNumber : Bool = false
    
    var countingState : CountingState = CountingState.NotCounting
    enum CountingState {
        case NotCounting
        case First
        case Counting
    }
    
    var averageState = AverageFunctionState.NotAveraging
    enum AverageFunctionState {
        case NotAveraging
        case First
        case Averaging
    }
    
    /*****************************/
    /* View controller lifecycle */
    /*****************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = darkGrayBG
        self.label!.text = ""
        self.functionLabel.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    /*********/
    /* Logic */
    /*********/
     
    @IBAction func buttonTouchUp(sender: UIButton)
    {
        switch sender.titleLabel!.text!
        {
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
                self.setFunctionLabelText("+")
                self.setMathFunc(add)
            case "-":
                self.setFunctionLabelText("-")
                self.setMathFunc(subtract)
            case "*":
                self.setFunctionLabelText("*")
                self.setMathFunc(multiply)
            case "÷":
                self.setFunctionLabelText("÷")
                self.setMathFunc(divide)
            case "fact":
                self.setMathFunc(fact)
                self.applyMathFunction(nil)
            case "count":
                if countingState == CountingState.NotCounting
                {
                    countingState = CountingState.First
                }
                
                self.setFunctionLabelText("count")
                self.setMathFunc(count)
            case "avg":
                if averageState == AverageFunctionState.NotAveraging
                {
                    averageState = AverageFunctionState.First
                    averageCount = 1.0
                }
                
                self.setFunctionLabelText("avg")
                self.setMathFunc(avg)
            case "=":
                self.setFunctionLabelText("=")
                self.applyMathFunction(nil)
            case "clear":
                self.label!.text = nil
                self.functionLabel!.text = nil
                self.mathFunctionToApply = nil
                self.result = 0
                self.clearInputOnNextNumber = false
                self.countingState = CountingState.NotCounting
                self.averageState = AverageFunctionState.NotAveraging
                return
            default:
                return
        }
    }
    
    func addToLabel(var string: String)
    {
        if (clearInputOnNextNumber)
        {
            label.text = nil
            clearInputOnNextNumber = false
        }
        
        self.setFunctionLabelText("")
        
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
    
    func setFunctionLabelText(string : String)
    {
        functionLabel.text = string
    }
    
    func setMathFunc(mathFunc : (Double) -> Double)
    {
        if self.label.text == nil || self.label.text == ""
        {
            return
        }
        
        // this is needed if we pressed equals, then a math function
        applyMathFunction(mathFunc)
        
        // result = self.stringToDouble(self.label!.text!)!
        clearInputOnNextNumber = true
    }
    
    // pass nil for equals operator
    func applyMathFunction(mathFunc : ((Double) -> Double)?)
    {
        // get the value
        let stringValue : String = (self.label?.text)!
        let currentValue = self.stringToDouble(stringValue)
        if (currentValue == nil)
        {
            return
        }
        
        // = operator
        if mathFunc == nil
        {
            if mathFunctionToApply == nil {
                return
            }
            
            result = mathFunctionToApply!(currentValue!)
            self.label!.text = result.description
            mathFunctionToApply = nil
            return
        }
        
        if mathFunctionToApply != nil
        {
            result = mathFunctionToApply!(currentValue!)
            self.label!.text = result.description
        }
        else if countingState == CountingState.First
        {
            result = 1.0
            countingState = CountingState.Counting
        }
        else
        {
            result = currentValue!
        }

        mathFunctionToApply = mathFunc
    }
    
    /********/
    /* Math */
    /********/
    
    func count(num : Double) -> Double
    {
        return result + 1
    }
    
    func stringToDouble(incoming:String) -> Double?
    {
        return Double(incoming)
    }
    
    func add(num : Double) -> Double
    {
        return result + num
    }
    
    func subtract(num : Double) -> Double
    {
        return result - num
    }
    
    func multiply(num : Double) -> Double
    {
        return result * num
    }
    
    func divide(num : Double) -> Double
    {
        // divide by zero
        if num == 0
        {
            print("Divide by zero attempted, returning zero")
            return 0
        }
        
        return result / num
    }
    
    func fact(number:Double) -> Double
    {
        if number < 0 || floor(number) != number
        {
            print("Factorial is not defined for non-natural numbers, returning zero")
            return 0
        }
        
        return factRecursive(number)
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
    
    func avg(number: Double) -> Double
    {
        let average = ((result * averageCount) + number) / (averageCount + 1)
        averageCount += 1
        return average
    }
}

