//
//  ViewController.swift
//  MixerTable
//
//  Created by Margarita Slesareva on 10.02.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        configureViews()
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
    }
}
