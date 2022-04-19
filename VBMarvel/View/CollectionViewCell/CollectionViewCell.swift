//
//  CollectionViewCell.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import UIKit

struct CollectionViewCellModel {
    var name: String?
    var description: String?
    var imageUrl: String?
    var modified: String?
}

protocol CollectionListViewCellProtocol: UICollectionViewCell {
    var model: CollectionViewCellModel? { get set }
}

class CollectionViewCell: UICollectionViewCell , CollectionListViewCellProtocol{

    private var dataTask: URLSessionDataTask?
    private var imageUrl: String?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFill
        }
    }

    var model: CollectionViewCellModel? {
        didSet {
            setModel()
        }
    }
    
    private func setModel() {
        guard let model = model else { return }
        titleLabel.text = model.name
        descriptionLabel.text = model.description
        imageUrl = model.imageUrl
        let dataTask = imageView.download(from: model.imageUrl ?? "") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let networkResult):
                self.setNetworkImage(responseUrl: networkResult.responseUrl, image: networkResult.image)
            default:
                self.imageView.image = nil
            }
        }
        self.dataTask = dataTask
    }
    
    private func setNetworkImage(responseUrl: String?, image: UIImage?) {
        if let image = image,
           let originalUrl = imageUrl,
           originalUrl == responseUrl{
            imageView.image = image
        } else {
            imageView.image = nil
        }
    }

    override func prepareForReuse() {
        titleLabel.text = ""
        descriptionLabel.text = ""
        imageView.image = nil
        dataTask?.cancel()
        dataTask = nil
    }

}
