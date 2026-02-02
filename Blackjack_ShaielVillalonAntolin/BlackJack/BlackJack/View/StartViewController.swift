//
//  StartViewController.swift
//  BlackJack
//
//  Created by Shaiel Villalon Antolin on 5/11/25.
//


import UIKit
import UserNotifications

class StartViewController : UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                setup()
        UNUserNotificationCenter.current().delegate = self
    }
    
    
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    

    
    
    private func setup () {
        
        let logo = UIImageView(image: UIImage(named: "blackjackLogo"))
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 90),
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logo.widthAnchor.constraint(equalToConstant: 50),
            logo.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        nameLabel.text = "Blackjack"
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        nameLabel.textAlignment = .center
        
        
        [playButton, optionsButton, historyButton].forEach {
            $0?.layer.cornerRadius = 15
            $0?.clipsToBounds = true
        }
    

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGame",
           let destination = segue.destination as? GameViewController {


            destination.playerNameValue = GameSession.shared.playerName
        }
    }
 
    
}
