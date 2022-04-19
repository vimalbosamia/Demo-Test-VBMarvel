//
//  NoResultCollectionReusableView.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import UIKit

class NoResultCollectionReusableView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup(){
      
        let errorModel = VBErrorViewModel(
                                          text: """
                                          Sorry, we couldn't find anyone with that name.
                                          Try another!
                                          """,
                                          buttonText: nil,
                                          delegate: nil)

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
