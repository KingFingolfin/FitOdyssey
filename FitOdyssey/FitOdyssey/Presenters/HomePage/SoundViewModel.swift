//
//  SoundViewModel.swift
//  FitOdyssey
//
//  Created by Giorgi on 25.01.25.
//


import AVFoundation

class SoundViewModel: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    
    func playSound(named soundName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Sound file \(soundName) not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
