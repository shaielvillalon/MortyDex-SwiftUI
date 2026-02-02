//
//  OptionsViewModel.swift
//  BlackJack
//
//  Created by Shaiel Villalon Antolin on 8/11/25.
//

import Foundation
import AVFoundation
import UserNotifications

class OptionsViewModel {
    static let shared = OptionsViewModel()
    private var player: AVAudioPlayer?
    var onMusic = false
    
    func toggle() {
        onMusic.toggle()
        if onMusic {
            startMusic()
            sendMusicNotification(activated: true)
        } else {
            stopMusic()
            sendMusicNotification(activated: false)

        }
    }
    
    private func startMusic () {
        guard let url = Bundle.main.url(forResource: "background", withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.play()
            print("Musica iniciada")
        } catch {
            print ("Error al reproducir")
        }
    }
    
    private func stopMusic () {
        player?.stop()
        print("Musica detenida")
    }
    
    private func sendMusicNotification (activated: Bool) {
        let content = UNMutableNotificationContent()
        content.title = activated ? "Musica activada" : "Musica desactivada"
        content.body = activated ? "La musica ha comenzado" : "Has desactivado la musica"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger (timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print ("Error al enviar notificacion")
            } else {
                print("Notificacion enviada correctamente")
            }
            
        }
        
        
    }
    
    
    
}



