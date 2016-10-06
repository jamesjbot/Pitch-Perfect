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
    
    var audioPlayer:    AVAudioPlayer!
    var receivedAudio:  RecordedAudio!
    var audioEngine:    AVAudioEngine!
    var audioFile:  AVAudioFile!
    
    
    @IBOutlet weak var slowButton: UIButton!
    
    @IBOutlet weak var fastButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var chipmunkButton: UIButton!
    
    @IBOutlet weak var darthButton: UIButton!
    
    @IBOutlet weak var echoButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            try audioPlayer = AVAudioPlayer (contentsOf: receivedAudio.filePathUrl)
        } catch {
            fatalError()
        }
        audioPlayer.enableRate = true

        audioEngine = AVAudioEngine()
        do {
            audioFile = try AVAudioFile(forReading: receivedAudio.filePathUrl)
        } catch {
            fatalError()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    func playAudioAtSpeed(_ speed: Float){
        audioEngine.reset()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    
    func playAudioWithVariablePitch(_ pitch: Float){
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
            fatalError()
        }
        
        audioPlayerNode.play()
    }
    

    func stopAllAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
