//
//  VBErrorReusableView.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import UIKit

class VBErrorReusableView: UICollectionReusableView {
        
    var delegate: VBErrorViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup(){
      
        let errorModel = VBErrorViewModel(delegate: self)

        guard let errorView = VBErrorView.create(model: errorModel) else { return }
        backgroundColor = .clear
        addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.widthAnchor.constraint(equalTo: widthAnchor),
            errorView.heightAnchor.constraint(equalTo: heightAnchor),
            errorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

extension VBErrorReusableView: VBErrorViewDelegate {
    func tryAgain() {
        delegate?.tryAgain()
    }
}
