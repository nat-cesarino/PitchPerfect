//
//  RecordSoundsViewController.swift
//  PitchPerfect_NathaliePiresCesarino
//
//  Created by Nathalie Cesarino on 07/11/21.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false

    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        setupUI(state: false)

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        //Set the view controller as the AVAudioRecorderDelegate
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: AnyObject) {
        setupUI(state: true)

        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Checking if that is the segue that we want:
        if segue.identifier == "stopRecording" {
            // Then we take the destination viewcontroller
            // Since destination comes from class UIViewController we force upcasting it to Playsoundsviewcontroller
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            // Next we grab the sender which is the URL of the recorded audio
            let recordedAudioURL = sender as! URL
            // Then we set the URL in the playsoundsviewcontroller
            playSoundsVC.recordedAudioURL = recordedAudioURL
            // We are ready for playback now!
        }
    }
    
    func setupUI(state: Bool) {
        stopRecordingButton.isEnabled = !state
        recordButton.isEnabled = state
        recordingLabel.text = state ? "Tap to Record":
        "Recording in Progress"
    }
    
}


