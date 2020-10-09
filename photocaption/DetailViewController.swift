//
//  DetailViewController.swift
//  photocaption
//
//  Created by Kristoffer Eriksson on 2020-10-08.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    var name: String?
    var image: UIImage?
    var caption: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let nameToLoad = name else {return}
        guard let imageToLoad = image else {return}
        guard let textToLoad = caption else {return}
        
        title = nameToLoad
        imageView.image = imageToLoad
        textView.text = textToLoad
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view did load")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
