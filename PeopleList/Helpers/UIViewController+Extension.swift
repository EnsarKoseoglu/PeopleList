//
//  Alert.swift
//  PeopleList
//
//  Created by EnsarKoseoglu on 22.01.2023.
//  Copyright © 2023 Ensar Koseoglu. All rights reserved.
//

import UIKit

extension UIViewController {
  func showError(with message: String, _ completion: @escaping (_ willRetry: Bool) -> ()) {
    let confirmAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let retry = UIAlertAction(title: "Retry", style: .default) { _ in
      completion(true)
    }

    let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
      completion(false)
    }
    
    confirmAlert.addAction(cancel)
    confirmAlert.addAction(retry)

    self.present(confirmAlert, animated: true, completion: nil)
  }

  func showLoading() {
    guard !self.view.subviews.contains(where: { $0 is UIActivityIndicatorView }) else {
      return
    }

    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    activityIndicator.frame = self.view.frame
    activityIndicator.style = .large
    UIView.transition(
      with: self.view,
      duration: 0.3,
      options: .transitionCrossDissolve,
      animations: {
        self.view.addSubview(activityIndicator)
      }
    )
    activityIndicator.startAnimating()
    self.view.isUserInteractionEnabled = false
  }

  func hideLoading() {
    let views = self.view.subviews.filter { $0 is UIActivityIndicatorView }
    views.forEach { (activity) in
      (activity as? UIActivityIndicatorView)?.removeFromSuperview()
      (activity as? UIActivityIndicatorView)?.stopAnimating()
    }
    self.view.isUserInteractionEnabled = true
  }
}
