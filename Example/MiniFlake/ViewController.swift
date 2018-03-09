//
//  ViewController.swift
//  MiniFlake
//
//  Copyright © Sasmito Adibowo
//  http://cutecoder.org
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Cocoa
import MiniFlake

class ViewController: NSViewController {

    @IBOutlet weak var generateCountTextField: NSTextField!
    
    @IBOutlet var outputTextView: NSTextView!
    
    @IBAction func startGenerate(_ sender: Any) {
        let generateCountStr = generateCountTextField.stringValue
        guard let generateCount = Int(generateCountStr), generateCount > 0 else {
            if let window = view.window {
                let alert = NSAlert()
                alert.messageText = NSLocalizedString("Please enter a positive number of identifiers to generate", comment: "Error message")
                alert.addButton(withTitle: NSLocalizedString("Okay", comment: "Error message"))
                alert.beginSheetModal(for: window, completionHandler: nil)
            }
            return
        }
        var outputStr = String()
        outputStr.reserveCapacity(17 *  generateCount)
        for _ in 0..<generateCount {
            let value = Thread.current.nextFlakeID()
            outputStr.append("\(value)\n")
        }
        outputTextView.string = outputStr
    }
}

