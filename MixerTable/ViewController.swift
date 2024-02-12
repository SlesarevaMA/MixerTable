//
//  ViewController.swift
//  MixerTable
//
//  Created by Margarita Slesareva on 10.02.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    private var dataSource: UITableViewDiffableDataSource<Int, CellViewModel>!
    
    private let numbers = Array<Int>(0...30)
    private lazy var cellViewModels = numbers.map { CellViewModel(isCheckmarked: false, title: "\($0)") }
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        addSubviews()
        addConstraints()
        configureViews()
        configureDataSource()
        createSnapshot()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
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
        tableView.delegate = self
    }
    
    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(cellViewModels, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, CellViewModel>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "TableViewCell",
                for: indexPath
            ) as? TableViewCell 
                else {
                return UITableViewCell()
            }
            
            cell.configure(with: item)

            return cell
        })
    }
    
    @objc private func shuffleTapped() {
        var snapshot = dataSource.snapshot()
        let items = snapshot.itemIdentifiers
        snapshot.deleteItems(items)
        let newIndeces = items.shuffled()
        snapshot.appendItems(newIndeces)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellViewModel>()
        snapshot.appendSections([0])

        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            cellViewModels[indexPath.row] = CellViewModel(isCheckmarked: false, title: "\(cellViewModels[indexPath.row].title)")
            snapshot.appendItems(cellViewModels, toSection: 0)
            dataSource?.apply(snapshot, animatingDifferences: true)
        } else {
            cell.accessoryType = .checkmark
            cellViewModels.insert(cellViewModels.remove(at: indexPath.row), at: 0)
            
            snapshot.appendItems(cellViewModels, toSection: 0)
            dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
}
