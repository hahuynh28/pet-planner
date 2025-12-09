//
//  AddAppointmentViewController.swift
//  PetPlanner
//
//  Created by Amara Hussain on 2025-12-03.
//

import UIKit

class AddAppointmentViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var petField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var clinicField: UITextField!
    @IBOutlet weak var notesField: UITextField!

    @IBAction func saveButtonTapped(_ sender: UIButton) {

        let context = CoreDataStack.shared.context
        let newAppt = Appointment(context: context)

        newAppt.titleText  = titleField.text
        newAppt.petName    = petField.text
        newAppt.dateText   = dateField.text
        newAppt.timeText   = timeField.text
        newAppt.clinicName = clinicField.text
        newAppt.notes      = notesField.text

        CoreDataStack.shared.saveContext()

        // Go back to list
        navigationController?.popViewController(animated: true)
    }
}
