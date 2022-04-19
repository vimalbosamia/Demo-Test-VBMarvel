//
//  VBSpinnerCollectionView.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import UIKit

class VBSpinnerCollectionView: UICollectionReusableView {
    var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .large
        view.color = .black
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup(){
        backgroundColor = .clear
        addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        indicator.startAnimating()
    }
}

class Alerts {
    static func showActionsheet(viewController: UIViewController, title: String, message: String, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void) {
    let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    for (index, (title, style)) in actions.enumerated() {
        let alertAction = UIAlertAction(title: title, style: style) { (_) in
            completion(index)
        }
        alertViewController.addAction(alertAction)
     }
     // iPad Support
     alertViewController.popoverPresentationController?.sourceView = viewController.view
     
     viewController.present(alertViewController, animated: true, completion: nil)
    }
}
