//
//  AppointmentsViewController.swift
//  PetPlanner
//
//  Created by Amara Hussain on 2025-12-03.
//

import UIKit
import CoreData

class AppointmentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    // data source from Core Data
    var appointments: [Appointment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    // Refresh list every time screen appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAppointments()
    }

    private func fetchAppointments() {
        let request: NSFetchRequest<Appointment> = Appointment.fetchRequest()
        let context = CoreDataStack.shared.context

        do {
            appointments = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching appointments: \(error)")
        }
    }

    // This will be called by cell selection segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditAppointment",
           let indexPath = tableView.indexPathForSelectedRow,
           let destination = segue.destination as? EditAppointmentViewController {

            destination.appointment = appointments[indexPath.row]
        }
    }
}

// MARK: - Table View Data Source / Delegate
extension AppointmentsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell",
                                                 for: indexPath)

        let appt = appointments[indexPath.row]

        // You can customize later with custom labels
        let title = appt.titleText ?? "Appointment"
        let pet   = appt.petName ?? ""
        let date  = appt.dateText ?? ""
        let time  = appt.timeText ?? ""
        let clinic = appt.clinicName ?? ""

        cell.textLabel?.text = title
        cell.detailTextLabel?.text = "\(pet) • \(date) • \(time) • \(clinic)"

        return cell
    }
}
