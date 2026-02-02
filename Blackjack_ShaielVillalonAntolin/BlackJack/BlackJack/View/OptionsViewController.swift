//
//  OptionsViewController.swift
//  BlackJack
//
//  Created by Shaiel Villalon Antolin on 5/11/25.
//

import UIKit
import UserNotifications

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var musicSwitch: UISwitch!
    private let viewModel = OptionsViewModel.shared
    
    override func viewDidLoad () {
        super.viewDidLoad()
        musicSwitch.isOn = viewModel.onMusic
        requestNotification()
        
        navigationItem.title = "Opciones"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        
    }
    
    @IBAction func musicSwitchAction(_ sender: UISwitch) {
        
        viewModel.toggle()
    }
    
    private func requestNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if granted {
                print ("Permiso concedido")
            } else {
                print("Permiso denegado")
            }
            
        }
    }
    
}

