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
 
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true

        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func slowPlay(sender: UIButton){
        println("Slow play")
        stopAllAudio()
        playAudioAtSpeed(0.5)
        
    }
    
    
    @IBAction func fastPlay(sender: UIButton){
        println("Fast play")
        stopAllAudio()
        playAudioAtSpeed(1.5)
    }
    
    
    @IBAction func stopPlay(sender: UIButton){
        println("Stop play")
        stopAllAudio()
    }
    
    
    @IBAction func chipmunkPlay(sender: UIButton){
        println("Chipmunks")
        stopAllAudio()
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func darthPlay(sender: UIButton){
        println("Sounds like darth")
        stopAllAudio()
        playAudioWithVariablePitch(-1000)
    }
    
    
    func playAudioAtSpeed(speed: Float){
        audioEngine.reset()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format:nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
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
