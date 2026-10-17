import UIKit
import CoreData

final class AnnouncementsViewController: UITableViewController {

    private var announcements: [CampusAnnouncement] = []
    private var selectedAnnouncement: CampusAnnouncement?

    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Campus Announcements"
        seedInitialAnnouncementsIfNeeded()
        loadAnnouncements()
    }

    @IBAction func addAnnouncementTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Announcement",
                                      message: "Enter a title and category.",
                                      preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Title" }
        alert.addTextField { $0.placeholder = "Category" }

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let self,
                  let title = alert?.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !title.isEmpty,
                  let category = alert?.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !category.isEmpty else { return }

            let announcement = CampusAnnouncement(context: self.context)
            announcement.title = title
            announcement.category = category
            announcement.date = DateFormatter.localizedString(from: Date(),
                                                               dateStyle: .long,
                                                               timeStyle: .none)
            announcement.priority = "Normal"
            announcement.postedBy = "Student"

            do {
                try self.context.save()
                self.loadAnnouncements()
            } catch {
                self.context.delete(announcement)
                print("Failed to save announcement: \(error)")
            }
        }

        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func seedInitialAnnouncementsIfNeeded() {
        let request: NSFetchRequest<CampusAnnouncement> = CampusAnnouncement.fetchRequest()
        let existingCount = (try? context.count(for: request)) ?? 0
        guard existingCount == 0 else { return }

        let seedData = [
            ("Enrollment Period Extended", "August 3, 2026", "Registrar", "Urgent", "Registrar"),
            ("IT Services Maintenance", "August 7, 2026", "IT Services", "Normal", "IT Services"),
            ("Scholarship Application Deadline", "August 10, 2026", "Student Affairs", "Urgent", "Student Affairs"),
            ("Library Access Updated", "August 12, 2026", "Library", "Normal", "Library Services"),
            ("Orientation Week Schedule", "August 15, 2026", "Admissions", "Normal", "Admissions Office"),
            ("Campus Security Advisory", "August 18, 2026", "Security", "Urgent", "Campus Security")
        ]

        for item in seedData {
            let announcement = CampusAnnouncement(context: context)
            announcement.title = item.0
            announcement.date = item.1
            announcement.category = item.2
            announcement.priority = item.3
            announcement.postedBy = item.4
        }

        do {
            try context.save()
        } catch {
            context.rollback()
            print("Failed to seed announcements: \(error)")
        }
    }

    private func loadAnnouncements() {
        let request: NSFetchRequest<CampusAnnouncement> = CampusAnnouncement.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        announcements = (try? context.fetch(request)) ?? []
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell", for: indexPath) as? AnnouncementCell else {
            return UITableViewCell()
        }

        let announcement = announcements[indexPath.row]
        cell.configure(with: announcement)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedAnnouncement = announcements[indexPath.row]
        performSegue(withIdentifier: "ShowAnnouncementDetailSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowAnnouncementDetailSegue",
              let destination = segue.destination as? DetailViewController,
              let announcement = selectedAnnouncement else {
            return
        }

        destination.announcement = announcement
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let announcement = announcements[indexPath.row]
        context.delete(announcement)

        do {
            try context.save()
            announcements.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            context.rollback()
            print("Failed to delete announcement: \(error)")
        }
    }
}
