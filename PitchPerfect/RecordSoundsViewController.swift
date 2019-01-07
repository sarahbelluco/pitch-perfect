//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Sarah on 05/01/19.
//  Copyright © 2019 Belluco. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    enum RecordingState { case recording, notRecording }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(.recording)
        startRecordingAudio()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(.notRecording)
        stopRecordingAudio()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not sucessful")
        }
    }
    
    private func startRecordingAudio() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        //try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        try! session.setCategory(.playAndRecord, mode: .default, options: [])
        
        // Sobrescreve a saída de áudio para o speaker (viva-voz)
        try! session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    private func stopRecordingAudio() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    private func configureUI(_ playState: RecordingState) {
        switch(playState) {
        case .recording:
            recordingLabel.text = "Recording in Progress"
        case .notRecording:
            recordingLabel.text = "Tap to Record"
        }
        
        toggleBothButtonStates()
    }
    
    // inverte os estados de disponibilidade dos botões
    private func toggleBothButtonStates() {
        toggleButtonState(button: recordButton)
        toggleButtonState(button: stopRecordingButton)
    }
    
    // Inverte o estado de disponibilidade do botão
    private func toggleButtonState(button: UIButton) {
        button.isEnabled = !button.isEnabled
    }
    
}

