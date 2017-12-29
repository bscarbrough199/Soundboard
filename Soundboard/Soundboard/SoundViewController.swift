//
//  SoundViewController.swift
//  Soundboard
//
//  Created by Brent Scarbrough on 12/28/17.
//  Copyright © 2017 Brent Scarbrough. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupRecorder()
        
        playButton.isEnabled = false
        addButton.isEnabled = false
        
    }
    
    func setupRecorder() {
        
        do {
            
            // Create an audio session.
            
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            
            try session.setActive(true)
            
            
            // Create URL for audio file (url).
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            print("########################")
            print (audioURL)
            print("########################")
            
            
            // Create settings for the audioRecorder (settings).
            
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
            
            // Create audioRecorder object.
            try audioRecorder = AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        } catch let error as NSError {
            print(error)
            
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording{
            // Stop Recording
            
            audioRecorder?.stop()
            playButton.isEnabled = true
            addButton.isEnabled = true
            
            // Change button title to 'Record'
            
            recordButton.setTitle("Record", for: .normal)
            
        } else {
            // Start the Recording
            
            audioRecorder?.record()
            
            // Change button title to 'Stop'
            
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    @IBAction func playTapped(_ sender: Any) {
        do {
        try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        }
        catch{
            
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        
        sound.name = textField.text
        sound.audio = NSData(contentsOf: audioURL!) as! Data
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
        
    }
    
}
