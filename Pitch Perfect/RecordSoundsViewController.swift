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
    
    // MARK: Variables
    
    var audioRecorder:  AVAudioRecorder!
    var recordedAudio:  RecordedAudio!
    var audioRecordOn:  Bool!
    var stopPressed:    Bool!
    
    // MARK: IBOutlet
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton:  UIButton!
    @IBOutlet weak var recordButton:    UIButton!
    
    // MARK: IBActions
    
    @IBAction func recordAudio(_ sender: UIButton) {
        stopPressed=false
        if (audioRecordOn==true){
            //If you are already recoding
            audioRecorder.stop()
            recordButton.isEnabled=true
            audioRecordOn=false
        } else {
            audioRecordOn = true
            recordLabel.text="Recording in Progess"
            stopButton.isHidden=false
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.string(from: currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath : URL = NSURL.fileURL(withPathComponents: pathArray)!
            print(filePath)
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
                try audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
            } catch {
                fatalError()
            }
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true;
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }
    
    @IBAction func stopRecording(_ sender: UIButton){
        stopPressed=true
        recordLabel.text="Tap to Record"
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            //TODO add alert
        }
    }
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioRecordOn=false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopButton.isHidden=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            //Save recorded audio
            recordLabel.text = "Tap to Record"
            var stringpath:String! = recorder.url.lastPathComponent
            recordedAudio = RecordedAudio(filePathUrl: recorder.url,title: stringpath)
            print(recorder.url.lastPathComponent)
            recordButton.isEnabled = true
            audioRecordOn=false
            
            //Move to next scene
            if (stopPressed==true){
                self.performSegue(withIdentifier: "stoppedRecording", sender: recordedAudio)
            }
            
        } else {
            print("Recording was not successful")
            recordLabel.text = "Recording Failed, Restart Application"
            recordButton.isEnabled = false
            stopButton.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stoppedRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    

}

