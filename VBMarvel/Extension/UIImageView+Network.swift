//
//  UIImageView+Network.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import UIKit

extension UIImageView {
    typealias ImageNetworkResult = (responseUrl: String?, image: UIImage?)
    func download(from url: URL,
                  withActivity: Bool = true,
                  completion: @escaping (Result<ImageNetworkResult, Error>) -> Void) -> URLSessionDataTask {
        if withActivity {
            addIndicatorView()
        }

        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion(.failure(NSError()))
                    self.stopIndicator()
                }
                return
            }
            DispatchQueue.main.async() { [weak self] in
                let result = ImageNetworkResult(responseUrl: httpURLResponse.url?.absoluteString,
                                                image: image)
                completion(.success(result))
                self?.stopIndicator()
            }
        }
        dataTask.resume()
        return dataTask
    }

    private func stopIndicator() {
        guard let indicator = subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView else {
            return
        }
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }

    private func addIndicatorView() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .medium
        activityIndicator.color = .black

        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }

    @discardableResult func download(
        from stringUrl: String,
        completion: @escaping (Result<ImageNetworkResult, Error>) -> Void
    ) -> URLSessionDataTask? {
        guard !stringUrl.isEmpty, let url = URL(string: stringUrl) else { return nil }
        return download(from: url, completion: completion)
    }
}
