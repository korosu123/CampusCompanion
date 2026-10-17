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
    var announcement: CampusAnnouncement?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateContent()
    }

    private func updateContent() {
        if let announcement = announcement {
            title = announcement.category ?? "Announcement"
            let announcementTitle = announcement.title ?? "Untitled Announcement"
            let announcementDate = announcement.date ?? ""
            let priority = announcement.priority ?? "Normal"
            let postedBy = announcement.postedBy ?? "Campus Office"
            messageLabel.text = "\(announcementTitle)\n\(announcementDate)\nPriority: \(priority)\nPosted by: \(postedBy)"
            return
        }

        title = "Campus Events"

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let notificationStatus = notificationsEnabled ? "on" : "off"
        messageLabel.text = "Welcome, \(studentName)!\nRole: \(selectedRole)\nNotifications: \(notificationStatus)\nEvent date: \(formatter.string(from: preferredEventDate))\nGuests: \(guestCount)"
    }
}
