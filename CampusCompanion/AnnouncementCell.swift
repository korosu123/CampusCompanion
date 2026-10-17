import UIKit

final class AnnouncementCell: UITableViewCell {

    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    func configure(with announcement: CampusAnnouncement) {
        titleLabel.text = announcement.title ?? "Untitled Announcement"
        dateLabel.text = "\(announcement.category ?? "General") • \(announcement.date ?? "")"

        let isUrgent = (announcement.priority ?? "Normal").lowercased() == "urgent"
        categoryIconImageView.image = UIImage(systemName: isUrgent ? "exclamationmark.circle.fill" : "megaphone.fill")
        categoryIconImageView.tintColor = isUrgent ? .systemRed : .systemBlue

        let titleColor = isUrgent ? UIColor.systemRed : UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1)
        let dateColor = isUrgent ? UIColor(red: 88/255, green: 95/255, blue: 105/255, alpha: 1) : UIColor(red: 75/255, green: 85/255, blue: 99/255, alpha: 1)

        titleLabel.textColor = titleColor
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        dateLabel.textColor = dateColor
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        contentView.backgroundColor = isUrgent ? UIColor.systemRed.withAlphaComponent(0.12) : .white
        backgroundColor = .clear
        selectionStyle = .none
    }
}
