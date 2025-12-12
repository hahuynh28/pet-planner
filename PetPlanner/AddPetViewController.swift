//
//  AddPetViewController.swift
//  PetPlanner
//
//  Created by Tristan Katwaroo on 2025-12-12.
//

import UIKit
import CoreData

class AddPetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var breedField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // Pickers
    let datePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add New Pet"
        
        setupUI()
        setupInputViews()
        
        // Image Tap Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        petImageView.addGestureRecognizer(tap)
        petImageView.isUserInteractionEnabled = true
        
        // Delegates
        nameField.delegate = self
        breedField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup UI
    func setupUI() {
        // Image Style
        petImageView.layer.cornerRadius = 60 // 120x120
        petImageView.clipsToBounds = true
        petImageView.contentMode = .scaleAspectFill
        petImageView.backgroundColor = .systemGray6
        petImageView.layer.borderWidth = 1
        petImageView.layer.borderColor = UIColor.systemGray4.cgColor
        
        // Inputs
        [nameField, breedField, dobField].forEach { $0?.styleInput() }
        
        // Save Button
        saveButton.layer.cornerRadius = 25
        saveButton.backgroundColor = UIColor(named: "BrandPurple")
        saveButton.setTitle("Save Pet", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
    }
    
    func setupInputViews() {
        // Date Picker for Birthday
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date() // Can't be born in the future
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        dobField.inputView = datePicker
        
        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneBtn], animated: true)
        dobField.inputAccessoryView = toolbar
        nameField.inputAccessoryView = toolbar
        breedField.inputAccessoryView = toolbar
    }
    
    // MARK: - Actions
    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dobField.text = formatter.string(from: datePicker.date)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Image Picker
    @objc func pickImage() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            petImageView.image = image
        }
        dismiss(animated: true)
    }

    // MARK: - Save Logic
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let name = nameField.text, !name.isEmpty else {
            // Simple validation
            return
        }
        
        let context = CoreDataStack.shared.context
        let newPet = Pet(context: context)
        
        newPet.name = name
        newPet.breed = breedField.text
        newPet.dob = datePicker.date
        
        // SAVE IMAGE TO DISK
        if let image = petImageView.image {
            let imageName = UUID().uuidString + ".jpg" // Unique ID
            if let data = image.jpegData(compressionQuality: 0.8) {
                let filename = getDocumentsDirectory().appendingPathComponent(imageName)
                try? data.write(to: filename)
                newPet.imageName = imageName // Save ONLY the filename to database
            }
        }
        
        CoreDataStack.shared.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    // Helper to find where to save images
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
