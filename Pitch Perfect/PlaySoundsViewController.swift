//
//  PlaySoundsViewController.swift
//  
//
//  Created by James Jongsurasithiwat on 5/31/15.
//
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // MARK: Variables
    
    internal var receivedAudio:  RecordedAudio!
    private var audioPlayer:    AVAudioPlayer!
    private var audioEngine:    AVAudioEngine!
    private var audioFile:  AVAudioFile!
    
    // MARK: IBOutlets
    
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthButton: UIButton!
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try audioPlayer = AVAudioPlayer (contentsOf: receivedAudio.filePathUrl)
        } catch {
            displayAlertWindow(title: "Player Creation Error", msg: "Please go back and try again", actions: nil)
        }
        
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        
        do {
            audioFile = try AVAudioFile(forReading: receivedAudio.filePathUrl)
        } catch {
            displayAlertWindow(title: "Audio File Error", msg: "Please go back and try again", actions: nil)
        }
    }
    
    @IBAction func slowPlay(_ sender: UIButton){
        stopAllAudio()
        playAudioAtSpeed(0.5)
    }
    
    @IBAction func fastPlay(_ sender: UIButton){
        stopAllAudio()
        playAudioAtSpeed(1.5)
    }
    
    @IBAction func stopPlay(_ sender: UIButton){
        stopAllAudio()
    }
    
    @IBAction func chipmunkPlay(_ sender: UIButton){
        stopAllAudio()
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darthPlay(_ sender: UIButton){
        stopAllAudio()
        playAudioWithVariablePitch(-1000)
    }
    
    private func playAudioAtSpeed(_ speed: Float){
        audioEngine.reset()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    private func playAudioWithVariablePitch(_ pitch: Float){
        stopAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format:nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch {
            displayAlertWindow(title: "Playing Error", msg: "Please go back and try again", actions: nil)
        }
        
        audioPlayerNode.play()
    }
    
    private func stopAllAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    // MARK: Specialized alert displays for UIViewControllers
    private func displayAlertWindow(title: String, msg: String, actions: [UIAlertAction]?){
        DispatchQueue.main.async() { () -> Void in
            let alertWindow: UIAlertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alertWindow.addAction(self.dismissAction())
            if let array = actions {
                for action in array {
                    alertWindow.addAction(action)
                }
            }
            self.present(alertWindow, animated: true, completion: nil)
        }
    }
    
    private func dismissAction()-> UIAlertAction {
        return UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
    }

}
