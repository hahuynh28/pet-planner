//
//  EditPetViewController.swift
//  PetPlanner
//
//  Created by Tristan Katwaroo on 2025-12-12.
//

import UIKit
import CoreData

class EditPetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var pet: Pet!

    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var breedField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageOverlay: UIView!
    
    // Pickers
    let datePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    var didPickImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Pet"
        
        setupUI()
        setupInputViews()
        populateData()
        
        // Image Tap Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        petImageView.addGestureRecognizer(tap)
        petImageView.isUserInteractionEnabled = true
        
        nameField.delegate = self
        breedField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func populateData() {
        nameField.text = pet.name
        breedField.text = pet.breed
        
        if let dob = pet.dob {
            datePicker.date = dob
            dateChanged()
        }
        
        if let imgName = pet.imageName {
            if let assetImage = UIImage(named: imgName) {
                petImageView.image = assetImage
            } else {
                let filename = getDocumentsDirectory().appendingPathComponent(imgName)
                if let diskImage = UIImage(contentsOfFile: filename.path) {
                    petImageView.image = diskImage
                    petImageView.contentMode = .scaleAspectFill
                } else {
                    // Fallback if file missing
                    petImageView.image = UIImage(systemName: "pawprint.circle.fill")
                }
            }
        } else {
            // No image set
            petImageView.image = UIImage(systemName: "pawprint.circle.fill")
        }
    }
    
    // MARK: - Save Logic (Update)
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let name = nameField.text, !name.isEmpty else { return }
        
        let context = CoreDataStack.shared.context
        
        // UPDATE existing object
        pet.name = name
        pet.breed = breedField.text
        pet.dob = datePicker.date
        
        // Update Image ONLY if user picked a new one
        if didPickImage, let image = petImageView.image {
            let imageName = UUID().uuidString + ".jpg"
            if let data = image.jpegData(compressionQuality: 0.8) {
                let filename = getDocumentsDirectory().appendingPathComponent(imageName)
                try? data.write(to: filename)
                pet.imageName = imageName
            }
        }
        
        CoreDataStack.shared.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Reuse UI Code (Identical to AddPet)
    func setupUI() {
        petImageView.layer.cornerRadius = 60
        petImageView.clipsToBounds = true
//        petImageView.tintColor = .systemGray3
//        petImageView.backgroundColor = .systemGray6
        
        imageOverlay.layer.cornerRadius = 60
        imageOverlay.clipsToBounds = true
        
        [nameField, breedField, dobField].forEach { $0?.styleInput() }
        
        saveButton.layer.cornerRadius = 25
        saveButton.backgroundColor = UIColor(named: "BrandPurple")
        saveButton.setTitle("Save Changes", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
    }
    
    func setupInputViews() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        dobField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneBtn], animated: true)
        dobField.inputAccessoryView = toolbar
        nameField.inputAccessoryView = toolbar
        breedField.inputAccessoryView = toolbar
    }
    
    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dobField.text = formatter.string(from: datePicker.date)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
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
            petImageView.contentMode = .scaleAspectFill
            didPickImage = true
        }
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
