//
//  DetailViewController.swift
//  Heroes Marvel
//
//  Created by Borja Gil Herrero on 27/11/2018.
//  Copyright © 2018 Alsis GHE. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detalleLabel: UILabel!
    @IBOutlet weak var fotoImageView: UIImageView!
    @IBOutlet weak var descripcionTextView: UITextView!
    

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detalleLabel {
                label.text = detail.nombre!.description
            }
            if let label = descripcionTextView {
                label.text = detail.descripcion!.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    var detailItem: Heroe? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

