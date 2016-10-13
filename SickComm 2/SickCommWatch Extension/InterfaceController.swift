//
//  InterfaceController.swift
//  SickCommWatch Extension
//
//  Created by Kathryn Hodge on 10/12/16.
//  Copyright © 2016 blondiebytes. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var waterButton: WKInterfaceButton!
    
    @IBOutlet var foodButton: WKInterfaceButton!
    
    @IBOutlet var medicineButton: WKInterfaceButton!
    
    @IBOutlet var blanketButton: WKInterfaceButton!
    
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
    }
    
    func playAudio(type:String) {
        let options = [WKMediaPlayerControllerOptionsAutoplayKey : "true"]
        let filePath = Bundle.main.path(forResource: type, ofType: "wav")!
        let fileUrl = NSURL.fileURL(withPath: filePath)
        presentMediaPlayerController(with: fileUrl, options: options,
                                     completion: { didPlayToEnd, endTime, error in
                                        if let err = error {
                                            print(err.localizedDescription)
                                        }
        })
    }
    
    @IBAction func waterButtonPressed() {
        // print("Water button pressed")
        playAudio(type: "water")
    }
    
    @IBAction func foodButtonPressed() {
        // print("Food button pressed")
        playAudio(type: "food")
    }

    @IBAction func medicineButtonPressed() {
        //  print("Medicine button pressed")
        playAudio(type: "medicine")
    }
    
    @IBAction func blanketButtonPressed() {
        // print("Blanket button pressed")
        playAudio(type: "blanket")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
