//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by James Jongsurasithiwat on 5/31/15.
//  Copyright (c) 2015 James Jongs. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder:  AVAudioRecorder!
    var recordedAudio:  RecordedAudio!
    var audioRecordOn:  Bool!
    var stopPressed:    Bool!
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton:  UIButton!
    @IBOutlet weak var recordButton:    UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        audioRecordOn=false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden=true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func recordAudio(sender: UIButton) {
        stopPressed=false
        if (audioRecordOn==true){
            //If you are already recoding
            audioRecorder.stop()
            recordButton.enabled=true
            audioRecordOn=false
        } else {
            audioRecordOn = true
            println("In record audio")
            recordLabel.text="Recording in Progess"
            stopButton.hidden=false
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error:nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings:nil, error:nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            //Save recorded audio
            recordLabel.text = "Tap to Record"
            var stringpath:String! = recorder.url.lastPathComponent
            recordedAudio = RecordedAudio(filePathUrl: recorder.url,title: stringpath)
            println(recorder.url.lastPathComponent)
            recordButton.enabled = true
            audioRecordOn=false

            //Move to next scene
            if (stopPressed==true){
                self.performSegueWithIdentifier("stoppedRecording", sender: recordedAudio)
            }
            
        } else {
            println("Recording was not successful")
            recordLabel.text = "Recording Failed, Restart Application"
            recordButton.enabled=false
            stopButton.hidden=true
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stoppedRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    
    @IBAction func stopRecording(sender: UIButton){
        stopPressed=true
        recordLabel.text="Tap to Record"
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        println("Reached the end of stopRecording button")
    }
}

