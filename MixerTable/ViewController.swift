//
//  ViewController.swift
//  MixerTable
//
//  Created by Margarita Slesareva on 10.02.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    private let numbers = Array<Int>(0...30)
    private lazy var cells = numbers.map { CellViewModel(isCheckmarked: false, title: "\($0)") }
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        addSubviews()
        addConstraint()
        configureViews()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureViews() {
        view.backgroundColor = tableView.backgroundColor
        
        let barButton = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleTapped))
        navigationItem.rightBarButtonItem = barButton
        navigationItem.title = "Task 4"
        navigationController?.navigationBar.backgroundColor = tableView.backgroundColor
        
        tableView.separatorStyle = .singleLine
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func shuffleTapped() {
        cells.shuffle()
        
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell
        else {
            return UITableViewCell()
        }
        
        let model = cells[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else {
            return
        }
        
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            cells[indexPath.row] = CellViewModel(isCheckmarked: false, title: "\(cells[indexPath.row].title)")
        } else {
            cell.accessoryType = .checkmark
            let newNumber = CellViewModel(isCheckmarked: true, title: "\(cells[indexPath.row].title)")
            
            cells[indexPath.row] = newNumber
            cell.configure(with: newNumber)

            cells.remove(at: indexPath.row)
            cells.insert(newNumber, at: 0)
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        }
    }
}
