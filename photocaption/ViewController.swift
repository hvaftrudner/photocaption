//
//  ViewController.swift
//  photocaption
//
//  Created by Kristoffer Eriksson on 2020-10-08.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var pictures = [Picture]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPic))
        
        //load pictures
        load()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let image = pictures[indexPath.row]
        cell.textLabel?.text = image.name
        //setting a "info" button on the tableview row for customization options
        cell.accessoryType = .detailDisclosureButton
        save()
        return cell
        
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //Finds Chosen pic in array
        let chosenPic = pictures[indexPath.row]
        
        //Options to customize name/caption and deleting pic
        let options = UIAlertController(title: "Options", message: "Add info to picture", preferredStyle: .alert)
        options.addAction(UIAlertAction(title: "Name", style: .default){ _ in
            let ac = UIAlertController(title: "NewName", message: "enter new name", preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "rename", style: .default){
                [weak self]_ in
                guard let newName = ac.textFields?[0].text else {return}
                chosenPic.name = newName
                self?.tableView.reloadData()
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(ac, animated: true)
            self.tableView.reloadData()
        })
        options.addAction(UIAlertAction(title: "Caption", style: .default){ _ in
            let ac2 = UIAlertController(title: "New Caption", message: "enter new caption", preferredStyle: .alert)
            ac2.addTextField()
            ac2.addAction(UIAlertAction(title: "OK", style: .default){
                [weak self]_ in
                guard let newCaption = ac2.textFields?[0].text else {return}
                chosenPic.caption = newCaption
                self?.tableView.reloadData()
            })
            ac2.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(ac2, animated: true)
            self.tableView.reloadData()
        })
        options.addAction(UIAlertAction(title: "Delete", style: .default){ _ in
            let ac3 = UIAlertController(title: "DeletePic", message: "Remove picture?", preferredStyle: .alert)
            ac3.addAction(UIAlertAction(title: "Delete", style: .default){
                [weak self] _ in
                self?.pictures.remove(at: indexPath.row)
                self?.tableView.reloadData()
            })
            ac3.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(ac3, animated: true)
            
        })
        present(options, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let chosenPic = pictures[indexPath.row]
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController")as? DetailViewController {
            vc.name = chosenPic.name
            vc.caption = chosenPic.caption
            //get contents from saved image and unwrap it from jpegdata custom method
            let path = getDocumentsDirectory().appendingPathComponent(chosenPic.image)
            vc.image = UIImage(contentsOfFile: path.path)
                
            navigationController?.pushViewController(vc, animated: true)
            print(chosenPic.image)
        }
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        
        let pic = Picture(name: "Unknown", image: imageName, caption: "unknown")
        pictures.append(pic)
        tableView.reloadData()
        
        dismiss(animated: true)
    }
    
    @objc func addNewPic(){
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
            
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        if let savedPictures = try? jsonEncoder.encode(pictures){
            let defaults = UserDefaults.standard
            defaults.set(savedPictures, forKey: "pictures")
        } else {
            print("could not save pictures")
        }
    }
    func load(){
        let defaults = UserDefaults.standard
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            
            let jsonDecoder = JSONDecoder()
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
                    
            } catch {
                print("failed to load pictures")
            }
            
        }
    }
    
}

