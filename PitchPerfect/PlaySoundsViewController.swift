//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Sarah on 06/01/19.
//  Copyright © 2019 Belluco. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, highPitch, lowPitch, echo, reverb
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        setupAllAudioButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    @IBAction func playSound(_ sender: UIButton) {
        switch ButtonType(rawValue: sender.tag)! {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .highPitch:
            playSound(pitch: 1000)
        case .lowPitch:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
   
    @IBAction func stopSound(_ sender: AnyObject) {
        stopAudio()
    }
    
    // Configura todos os botões de áudio
    private func setupAllAudioButtons() {
        [slowButton, fastButton, highPitchButton, lowPitchButton, echoButton, reverbButton].forEach { (button: UIButton?) in
            setupAudioButton(button: button!, action: #selector(PlaySoundsViewController.playSound(_:)))
        }
        setupAudioButton(button: stopButton, action: #selector(PlaySoundsViewController.stopSound(_:)))
    }
    
    // Configura um botão de áudio
    private func setupAudioButton(button: UIButton, action: Selector) {
        // Altera o modo de apresentação da imagem do botão para evitar que ao mudar para o modo paisagem os botões não fiquem achatados
        button.imageView!.contentMode = .scaleAspectFit
        // Adiciona ação ao botão programaticamente
        button.addTarget(self, action: action, for: UIControl.Event.touchUpInside)
    }
}
