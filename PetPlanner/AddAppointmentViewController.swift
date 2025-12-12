//
//  AddAppointmentViewController.swift
//  PetPlanner
//
//  Created by Amara Hussain on 2025-12-03.
//

import UIKit
import CoreData

class AddAppointmentViewController: UIViewController, UITextFieldDelegate {

//    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var petField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var clinicField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var bookButton: UIButton!
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let petPicker = UIPickerView()
    
    // Data source for the dropdown (Using the struct from Models.swift for now)
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
        self.title = "Book Appointment"
        
        loadDummyData()
        setupUI()
        setupInputViews()
        setupButton()
        
        [clinicField, notesField].forEach {
            $0?.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        }
        
        [petField, dateField, timeField].forEach { $0?.delegate = self }
    }
    
    @objc func textDidChange() {
        validateForm()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // FORCE the nav bar to show on this screen (since it's hidden on Dashboard)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // HIDE it again when going back to the previous screen
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Setup
    func loadDummyData() {
        // Temporary mock data until Pet Core Data entity is created
        pets = [
            Pet(name: "Milo", imageName: "milo-avatar"),
            Pet(name: "Whiskers", imageName: "whiskers-avatar")
        ]
    }
    
    func setupButton() {
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        bookButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // FIX: Use Configuration to set the shape, not the layer
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(named: "BrandPurple")
        config.cornerStyle = .capsule // This guarantees a perfect pill shape
        
        // Force Bold Font
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 18)
        config.attributedTitle = AttributedString("Book Appointment", attributes: container)
        
        bookButton.configuration = config
        
        validateForm()
    }
    
    func validateForm() {
        // We update the background color manually because 'isEnabled' logic
        // can sometimes conflict with Configuration styles if not handled carefully.
        if isFormValid {
            bookButton.isEnabled = true
            bookButton.configuration?.baseBackgroundColor = UIColor(named: "BrandPurple")
        } else {
            bookButton.isEnabled = false
            bookButton.configuration?.baseBackgroundColor = UIColor.systemGray5
        }
    }

    func setupUI() {
        // Apply the "Figma-style" inputs defined in Extensions.swift
        // Note: Ensure you added the `styleInput()` extension to Extensions.swift!
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // If the field is empty when the user taps it, fill it with the CURRENT picker value immediately.
        // This solves the "I have to scroll away and back" issue.
        
        if textField == dateField && textField.text?.isEmpty ?? true {
            dateChanged()
        } else if textField == timeField && textField.text?.isEmpty ?? true {
            timeChanged()
        } else if textField == petField && textField.text?.isEmpty ?? true {
            if !pets.isEmpty {
                // Default to the first pet if nothing selected
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

        let context = CoreDataStack.shared.context
        let newAppt = Appointment(context: context)

//        newAppt.titleText  = titleField.text
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

extension AddAppointmentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        validateForm()
    }
}
