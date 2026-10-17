//
//  ViewController.swift
//  CampusCompanion
//
//  Created by FRANZ NATHANIEL SANTIAGO on 9/19/26.
//

import UIKit

private enum DefaultsKey {
    static let studentName = "studentName"
    static let notificationsEnabled = "notificationsEnabled"
    static let selectedRoleIndex = "selectedRoleIndex"
}

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notifySwitch: UISwitch!
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var guestStepper: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "Campus Companion"
        restorePreferences()
    }

    @IBAction func exploreButtonTapped(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        savePreferences()
        performSegue(withIdentifier: "ShowDetailSegue", sender: self)
    }

    @IBAction func resetPreferencesTapped(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: DefaultsKey.studentName)
        UserDefaults.standard.removeObject(forKey: DefaultsKey.notificationsEnabled)
        UserDefaults.standard.removeObject(forKey: DefaultsKey.selectedRoleIndex)

        nameTextField.text = ""
        notifySwitch.isOn = false
        roleSegmentedControl.selectedSegmentIndex = 0
    }

    private func savePreferences() {
        UserDefaults.standard.set(nameTextField.text ?? "", forKey: DefaultsKey.studentName)
        UserDefaults.standard.set(notifySwitch.isOn, forKey: DefaultsKey.notificationsEnabled)
        UserDefaults.standard.set(roleSegmentedControl.selectedSegmentIndex,
                                  forKey: DefaultsKey.selectedRoleIndex)
    }

    private func restorePreferences() {
        nameTextField.text = UserDefaults.standard.string(forKey: DefaultsKey.studentName) ?? ""
        notifySwitch.isOn = UserDefaults.standard.bool(forKey: DefaultsKey.notificationsEnabled)
        roleSegmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: DefaultsKey.selectedRoleIndex)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowDetailSegue",
              let destination = segue.destination as? DetailViewController else {
            return
        }

        let enteredName = nameTextField.text ?? ""
        destination.studentName = enteredName.isEmpty ? "Student" : enteredName
        destination.notificationsEnabled = notifySwitch.isOn
        destination.selectedRole = roleSegmentedControl.selectedSegmentIndex == 0 ? "Student" : "Faculty"
        destination.preferredEventDate = datePicker.date
        destination.guestCount = max(1, Int(guestStepper.value))
    }
}
