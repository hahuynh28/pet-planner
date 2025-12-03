//
//  EditAppointmentViewController.swift
//  PetPlanner
//
//  Created by Amara Hussain on 2025-12-03.
//

import UIKit

class EditAppointmentViewController: UIViewController {

    // injected from AppointmentsViewController in prepare(for segue:)
    var appointment: Appointment!

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var petField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var clinicField: UITextField!
    @IBOutlet weak var notesField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAppointmentData()
    }

    private func loadAppointmentData() {
        titleField.text  = appointment.titleText
        petField.text    = appointment.petName
        dateField.text   = appointment.dateText
        timeField.text   = appointment.timeText
        clinicField.text = appointment.clinicName
        notesField.text  = appointment.notes
    }

    @IBAction func saveChangesTapped(_ sender: UIButton) {
        appointment.titleText  = titleField.text
        appointment.petName    = petField.text
        appointment.dateText   = dateField.text
        appointment.timeText   = timeField.text
        appointment.clinicName = clinicField.text
        appointment.notes      = notesField.text

        CoreDataStack.shared.saveContext()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteTapped(_ sender: UIButton) {
        let context = CoreDataStack.shared.context
        context.delete(appointment)
        CoreDataStack.shared.saveContext()
        navigationController?.popViewController(animated: true)
    }
}
