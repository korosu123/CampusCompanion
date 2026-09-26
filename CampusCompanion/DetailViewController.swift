//
//  DetailViewController.swift
//  CampusCompanion
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!

    var studentName = "Student"
    var notificationsEnabled = false
    var selectedRole = "Student"
    var preferredEventDate = Date()
    var guestCount = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Campus Events"

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let notificationStatus = notificationsEnabled ? "on" : "off"
        messageLabel.text = "Welcome, \(studentName)!\nRole: \(selectedRole)\nNotifications: \(notificationStatus)\nEvent date: \(formatter.string(from: preferredEventDate))\nGuests: \(guestCount)"
    }
}
