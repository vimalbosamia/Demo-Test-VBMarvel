//
//  VBErrorView.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import UIKit

struct VBErrorViewModel {
    var text: String? = "Ups, something went wrong"
    var buttonText: String? = "Try again"
    var delegate: VBErrorViewDelegate?
}

protocol VBErrorViewDelegate: AnyObject {
    func tryAgain()
}

class VBErrorView: UIView {
    private weak var delegate: VBErrorViewDelegate?

    @IBOutlet private weak var stackView: UIStackView!

    @IBOutlet private weak var tryAgainButton: UIButton!
    @IBOutlet private weak var infoLabel: UILabel!

    static func create(model: VBErrorViewModel) -> VBErrorView? {
        let viewName = String(describing: self)
        guard let nib = Bundle.main.loadNibNamed(viewName, owner: self, options: nil),
              let view = nib.first as? VBErrorView else {
                  return nil
              }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.setContentHuggingPriority(.required, for: .vertical)

        view.setupModel(model: model)
        return view
    }

    private func setupModel(model: VBErrorViewModel) {

        delegate = model.delegate

        if let text = model.text {
            infoLabel.text = text
        } else {
            infoLabel.isHidden = true
        }

        if let buttonText = model.buttonText {
            tryAgainButton.setTitle(buttonText, for: .normal)
        } else {
            tryAgainButton.isHidden = true
        }
    }

    @IBAction private func tryAgain(_ sender: AnyObject?) {
        delegate?.tryAgain()
    }
}
