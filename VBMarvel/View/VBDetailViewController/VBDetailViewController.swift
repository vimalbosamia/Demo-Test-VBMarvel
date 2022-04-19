//
//  VBComicDetailViewController.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import UIKit

struct VBDetailModel {
    var image: String = ""
    var name: String = ""
    var description: String = ""
    var modified: String = ""
}

class VBDetailViewController: UIViewController {
    
    @IBOutlet weak var imgCharacter: UIImageView!
    
    @IBOutlet weak var lblDescription: UILabel!
    


    var model: VBDetailModel? {
        didSet {
            guard let model = model, isViewLoaded else {
                return
            }
            bindModel(model)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let model = model {
            bindModel(model)
        }
    }

    private func bindModel(_ model: VBDetailModel) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = model.name
        lblDescription.text = model.description
        imgCharacter.contentMode = .scaleAspectFill
        imgCharacter.download(from: model.image) { [weak self] result in
            if case let .success(data) = result {
               
                self?.imgCharacter.image = data.image
            }
        }
    }
}
