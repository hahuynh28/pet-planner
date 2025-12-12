//
//  EditAppointmentViewController.swift
//  PetPlanner
//
//  Created by Amara Hussain on 2025-12-03.
//

import UIKit
import CoreData

class EditAppointmentViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Data Injection
    var appointment: Appointment!

    // MARK: - Outlets
    
    // Header (New!)
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petBreedLabel: UILabel!
    
    // Form Fields
    @IBOutlet weak var petField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var clinicField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let petPicker = UIPickerView()
    
    // Data source for the dropdown
    var pets: [Pet] = []
    var selectedPet: Pet?
    
    var isFormValid: Bool {
        return !(petField.text?.isEmpty ?? true) &&
               !(dateField.text?.isEmpty ?? true) &&
               !(timeField.text?.isEmpty ?? true) &&
               !(clinicField.text?.isEmpty ?? true) &&
               !(notesField.text?.isEmpty ?? true)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Appointment"
        
        loadDummyData()
        setupUI()
        setupInputViews()
        setupButton()
        
        // Populate the screen with existing data
        populateFields()
        
        // Listeners
        [clinicField, notesField].forEach {
            $0?.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        }
        
        // Delegates for auto-fill logic
        [petField, dateField, timeField].forEach { $0?.delegate = self }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }
    
    @objc func textDidChange() {
        validateForm()
    }

    // MARK: - Setup & Population
    func populateFields() {
        guard let appt = appointment else { return }
        
        // 1. Populate the Header
        let name = appt.petName ?? "Unknown"
        petNameLabel.text = name
        
        // Simple logic to set image/breed based on name
        if name.lowercased().contains("milo") {
            petImageView.image = UIImage(named: "milo-avatar")
            petBreedLabel.text = "Golden Retriever"
        } else if name.lowercased().contains("whisker") {
            petImageView.image = UIImage(named: "whiskers-avatar")
            petBreedLabel.text = "Tabby Cat"
        } else {
            petImageView.image = UIImage(systemName: "pawprint.circle.fill")
            petBreedLabel.text = "Pet"
        }
        
        // Style the header image
        petImageView.layer.cornerRadius = 30
        petImageView.clipsToBounds = true
        petImageView.contentMode = .scaleAspectFill
        
        // 2. Populate the Form Fields
        petField.text    = appt.petName
        dateField.text   = appt.dateText
        timeField.text   = appt.timeText
        clinicField.text = appt.clinicName
        notesField.text  = appt.notes
        
        // Validate immediately so the button is enabled
        validateForm()
    }
    
    func loadDummyData() {
        pets = [
            Pet(name: "Milo", imageName: "milo-avatar"),
            Pet(name: "Whiskers", imageName: "whiskers-avatar")
        ]
    }
    
    func setupButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(named: "BrandPurple")
        config.cornerStyle = .capsule
        
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 18)
        config.attributedTitle = AttributedString("Save Changes", attributes: container)
        
        saveButton.configuration = config
    }
    
    func validateForm() {
        if isFormValid {
            saveButton.isEnabled = true
            saveButton.configuration?.baseBackgroundColor = UIColor(named: "BrandPurple")
        } else {
            saveButton.isEnabled = false
            saveButton.configuration?.baseBackgroundColor = UIColor.systemGray5
        }
    }

    func setupUI() {
        [petField, dateField, timeField, clinicField, notesField].forEach {
            $0?.styleInput()
        }
    }

    func setupInputViews() {
        // Date Picker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        dateField.inputView = datePicker
        
        // Time Picker
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        timeField.inputView = timePicker
        
        // Pet Picker
        petPicker.delegate = self
        petPicker.dataSource = self
        petField.inputView = petPicker
        
        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneBtn], animated: true)
        
        dateField.inputAccessoryView = toolbar
        timeField.inputAccessoryView = toolbar
        petField.inputAccessoryView = toolbar
    }
    
    // MARK: - Auto-fill on Tap
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateField && (textField.text?.isEmpty ?? true) {
            dateChanged()
        } else if textField == timeField && (textField.text?.isEmpty ?? true) {
            timeChanged()
        } else if textField == petField && (textField.text?.isEmpty ?? true) {
            if !pets.isEmpty {
                // If they decide to change the pet, default to first option
                selectedPet = pets[0]
                petField.text = selectedPet?.name
                validateForm()
            }
        }
    }

    // MARK: - Actions
    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateField.text = formatter.string(from: datePicker.date)
        validateForm()
    }

    @objc func timeChanged() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timeField.text = formatter.string(from: timePicker.date)
        validateForm()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Update the EXISTING object (no new context creation)
        appointment.petName    = petField.text
        appointment.dateText   = dateField.text
        appointment.timeText   = timeField.text
        appointment.clinicName = clinicField.text
        appointment.notes      = notesField.text

        CoreDataStack.shared.saveContext()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Picker Delegate
extension EditAppointmentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pets[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPet = pets[row]
        petField.text = selectedPet?.name
        
        // Update header dynamically if they change the pet dropdown
        petNameLabel.text = selectedPet?.name
        if let name = selectedPet?.name.lowercased() {
            if name.contains("milo") {
                petImageView.image = UIImage(named: "milo-avatar")
                petBreedLabel.text = "Golden Retriever"
            } else if name.contains("whisker") {
                petImageView.image = UIImage(named: "whiskers-avatar")
                petBreedLabel.text = "Tabby Cat"
            }
        }
        
        validateForm()
    }
}
