//
//  UserPostTableViewCell.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/20.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit
import TextToSpeechV1
import AVFoundation

class UserPostTableViewCell: UITableViewCell {
    
    let textToSpeech = TextToSpeech(username: YOUR_USER_NAME, password: YOUR_PASS_WORD)
    var audioPlayer = AVAudioPlayer()
    var postText = "can i speak something"

    @IBOutlet weak var userPostLabel: UILabel!
    
    @IBOutlet weak var userHeadImageView: UIImageView!
    
    @IBOutlet weak var userPostTimeLabel: UILabel!
    
    @IBAction func get_voice(_ sender: AnyObject) {
        let button = sender as! UIButton
        button.isEnabled = false
        
        let failure2 = { (error: Error) in
            DispatchQueue.main.async {
                self.postText = "Text could not be processed"
            }
            print(error)
        }
        
        self.postText = userPostLabel.text!
        
        print("the postText is: \(self.postText)")
        self.textToSpeech.synthesize(self.postText, failure: failure2) { data in
            self.audioPlayer = try! AVAudioPlayer(data: data)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
        }
        
        button.isEnabled = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
