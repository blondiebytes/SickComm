//
//  ViewController.swift
//  SickComm
//
//  Created by Kathryn Hodge on 10/4/16.
//  Copyright © 2016 blondiebytes. All rights reserved.
//

import UIKit
import AVFoundation

// alert after text message

class ViewController: UIViewController {
    
    @IBOutlet weak var imageButton1: UIButton!
    
    @IBOutlet weak var imageButton2: UIButton!
    
    @IBOutlet weak var imageButton3: UIButton!
    
    @IBOutlet weak var imageButton4: UIButton!
    
    @IBOutlet weak var careTakerButton: UIButton!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var careTakerNumber = ""
    
    var userNumber = "%2B18324954530" // from twilio
    
    var textField: UITextField!
    
    var deviceName: String = "Patient"
    
    override func viewDidLoad() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch let error as NSError {
            print("Error: Could not set audio category: \(error), \(error.userInfo)")
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError {
            print("Error: Could not setActive to true: \(error), \(error.userInfo)")
        }

        
        super.viewDidLoad()
        self.speechSynthesizer.pauseSpeaking(at: .word)
        
        self.careTakerButton.layer.borderWidth = 1.0
        let color = UIColor(red: 255/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)
        self.careTakerButton.layer.borderColor = color.cgColor
        
        let dN = UIDevice.current.name
        let dName = dN.replacingOccurrences(of: "'s iPhone", with: "")
        self.deviceName = dName.replacingOccurrences(of: "'s iPad", with: "")
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //
    }
    
    func sendSMS(textMessage:String)
    {
        let twilioSID = ""
        let twilioSecret = ""
        
        //Note replace + = %2B , for To and From phone number
        let fromNumber = self.userNumber
        let toNumber = self.careTakerNumber
        let message = textMessage
        
        // Build the request
        let request = NSMutableURLRequest(url: NSURL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")! as URL)
        request.httpMethod = "POST"
        request.httpBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".data(using: String.Encoding.utf8)
        
        // Build the completion block and send the request
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            // create the alert
            let textAlert = UIAlertController(title: "Text Message Sent!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            /// Success!
            textAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(textAlert, animated: true, completion: nil)
            
            }).resume()
    }
    
    func createUIAlert(title:String, sayAloud:String, textMessage:String) -> UIAlertController {
        
            // create the alert
        let alert = UIAlertController(title: title, message: "What should I do?", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add the Actions (buttons)
            // Send Text Message
            alert.addAction(UIAlertAction(title: "Send Text Message", style: UIAlertActionStyle.default, handler: { action in
                
                if (self.careTakerNumber.characters.count == 0) {
                    
                    let setAlert = UIAlertController(title: "You need to set your caretaker!", message: "Set your caretaker by pressing the button at the bottom of the screen so we know who to send your message to.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    setAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    
                     self.present(setAlert, animated: true, completion: nil)
                    
                    
                } else {
                    
                    self.sendSMS(textMessage: textMessage)
                }
                
            }))
            
            // Speak Aloud
            alert.addAction(UIAlertAction(title: "Say Aloud", style: UIAlertActionStyle.default, handler: { action in
                
                //Speak
                let utterance = AVSpeechUtterance(string:sayAloud)
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                self.speechSynthesizer.speak(utterance)
                
                
            }))
            
            
            // Cancel Action
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
                
                
            }))
        
        
        return alert

    }
    
    
    @IBAction func imageButton1Pressed(sender: AnyObject) {
       
        
        let alert = createUIAlert(title: "You need water", sayAloud: "I need water.", textMessage: "\(deviceName) needs water")
    
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }

    @IBAction func imageButton2Pressed(sender: AnyObject) {
        let alert = createUIAlert(title: "You need food", sayAloud: "I need food.", textMessage: "\(deviceName) needs food")
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func imageButton3Pressed(sender: AnyObject) {
        let alert = createUIAlert(title: "You need a blanket.", sayAloud: "I need a blanket", textMessage: "\(deviceName) needs a blanket")
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func imageButton4Pressed(sender: AnyObject) {
        let alert = createUIAlert(title: "You need medicine.", sayAloud: "I need medicine", textMessage: "\(deviceName) needs medicine")
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func careTakerButtonPressed(sender: AnyObject) {
        
        // Create Alert
        let alert2 = UIAlertController(title: "Set Your Caretaker", message: "Enter the phone number of your caretaker. Remember the country code!", preferredStyle: UIAlertControllerStyle.alert)
        
        // Set action
        alert2.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { action in
            
            // Set and test number
            if (self.textField!.text!.characters.count == 11) {
                self.careTakerNumber = "%2B\(self.textField!.text!)"
                let success = UIAlertController(title: "Congrats!", message: "You've added a caretaker!", preferredStyle: UIAlertControllerStyle.alert)
                
                /// Success!
                success.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    self.careTakerButton.setTitle("Reset Caretaker?", for: UIControlState.normal)
                    
                    
                    
                }))
                
                self.present(success, animated: true, completion: nil)
            } else {
                let invalid = UIAlertController(title: "Invalid Number!", message: "The number you have given is invalid. Try again. Remember to add the country code!", preferredStyle: UIAlertControllerStyle.alert)
                
                // Prompt User to try again
                invalid.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    
                    
                }))
                
                self.present(invalid, animated: true, completion: nil)
            }

            
        }))

        
        // Add text field
        alert2.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.keyboardType = UIKeyboardType.numberPad
            self.textField = textField
            
        })
        
        self.present(alert2, animated: true, completion: nil)
    
    }
    
    
    
}

