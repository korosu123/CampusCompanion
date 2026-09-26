//
//  ViewController.swift
//  CampusCompanion
//
//  Created by FRANZ NATHANIEL SANTIAGO on 9/19/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var campusImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "Campus Companion"
        campusImageView.image = UIImage(systemName: "building.2.fill")
        campusImageView.tintColor = .systemBlue
        campusImageView.accessibilityLabel = "Campus buildings"
    }

    @IBAction func getStartedTapped(_ sender: UIButton) {
        subtitleLabel.text = "Let's get started!"
    }
}
