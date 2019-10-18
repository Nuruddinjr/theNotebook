//
//  NoteDetailTableViewController.swift
//  theNotebook
//
//  Created by Nuruddin on 5/1/17.
//  Copyright © 2017 IUTlab. All rights reserved.
//

import UIKit
import CoreData

class NoteAddDetailTableViewController: UITableViewController, UINavigationControllerDelegate {

    @IBOutlet weak var NoteImage: UIImageView!
    
    @IBOutlet weak var NoteTitle: UITextField!
    
    @IBOutlet weak var NoteTextView: UITextView!
    
    var managedObjectContext : NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSaveBarButton()
    }
    
    func setSaveBarButton() {
        let saveBarButton = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(NoteAddDetailTableViewController.saveNote)
        )
        navigationItem.rightBarButtonItem = saveBarButton
        navigationItem.title = "TEST"
    }

    @IBAction func addNotePicture(_ sender: UITapGestureRecognizer) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(
            title: "Add a Picture",
            message: "Choose From",
            preferredStyle: .actionSheet
        )
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        }

        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    @objc func saveNote() {
        if NoteTitle.text!.isEmpty || NoteTextView.text!.isEmpty || NoteImage.image == nil {
            let alertController = UIAlertController(
                title: "OOPS",
                message: "You need to give all the information, check for missing info",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            // Save note goes here
            if let moc = managedObjectContext {
                let note = NoteCD(context: moc)
                note.noteTitle = NoteTitle.text
                note.noteText = NoteTextView.text

                if let image = NoteImage.image {
                    note.noteImage = image.jpegData(compressionQuality: .compressionQuality)
                }

                saveToCoreData() {
                    self.navigationController!.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    func saveToCoreData(completion: @escaping () -> Void) {
        managedObjectContext?.perform {
            do {
                try self.managedObjectContext?.save()
                print("Saved to CoreData")
                completion()
            } catch {
                print("Error to save to Core Data \(error.localizedDescription)")
            }
        }
    }
}

extension NoteAddDetailTableViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.NoteImage.image = image
        }

        self.dismiss(animated: true, completion: nil)
    }
}

private extension CGFloat {
    static let compressionQuality = CGFloat(0.7)
}
