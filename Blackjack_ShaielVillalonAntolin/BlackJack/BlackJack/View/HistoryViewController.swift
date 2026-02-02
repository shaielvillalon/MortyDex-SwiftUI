//
//  HistoryViewController.swift
//  BlackJack
//
//  Created by Shaiel Villalon Antolin on 5/11/25.
//



import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = HistoryViewModel()



    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        navigationItem.title = "Historial"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let destination = segue.destination as? HistoryDetailViewController,
           let indexPath = sender as? IndexPath {
            
            destination.game = viewModel.history[indexPath.row]
        }
    }



    @IBAction func clearHistoryTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "Borrar historial",
            message: "¿Seguro que quieres borrar todo el historial?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Borrar", style: .destructive) { _ in
            self.viewModel.clearHistory()
            self.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.history.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let r = viewModel.history[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)


        cell.textLabel?.text = "\(emoji(for: r.result))  \(r.playerName)"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        cell.textLabel?.textColor = .white

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        let formattedDate = formatter.string(from: r.date)
        
        cell.detailTextLabel?.text = "\(formattedDate) — Jugador: \(r.playerScore) | Bot: \(r.botScore)"
        cell.detailTextLabel?.textColor = .white

        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.contentView.layoutMargins = UIEdgeInsets(top:10, left: 15, bottom: 10, right: 15)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }



    private func emoji(for r: String) -> String {
        
        let lower = r.lowercased()
        
        if lower.contains("ganaste") {
            return "🏆"
        } else if lower.contains("perdiste") {
            return "💀"
        } else if lower.contains("empate") {
            return "🤝"
        } else {
            return "🃏"
        }
    }
}
