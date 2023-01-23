//
//  UITableView+Extension.swift
//  PeopleList
//
//  Created by EnsarKoseoglu on 23.01.2023.
//  Copyright © 2023 Ensar Koseoglu. All rights reserved.
//

import UIKit

extension UITableView {
  func showEmptyMessageIfNeeded(_ message: String, with retryAction: Selector, target: Any) {
    let noRecordView = UIView()

    let lblEmpty = UILabel(frame: self.bounds)
    lblEmpty.text = message
    lblEmpty.textColor = .black
    lblEmpty.numberOfLines = 0
    lblEmpty.textAlignment = .center
    lblEmpty.sizeToFit()

    let btnRefresh = UIButton()
    btnRefresh.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
    btnRefresh.addTarget(target, action: retryAction, for: .touchUpInside)

    noRecordView.addSubview(lblEmpty)
    noRecordView.addSubview(btnRefresh)

    lblEmpty.translatesAutoresizingMaskIntoConstraints = false
    lblEmpty.centerXAnchor.constraint(equalTo: noRecordView.centerXAnchor).isActive = true
    lblEmpty.centerYAnchor.constraint(equalTo: noRecordView.centerYAnchor).isActive = true
    lblEmpty.leftAnchor.constraint(equalTo: noRecordView.leftAnchor, constant: 10.0).isActive = true

    btnRefresh.translatesAutoresizingMaskIntoConstraints = false
    btnRefresh.topAnchor.constraint(equalTo: lblEmpty.bottomAnchor).isActive = true
    btnRefresh.centerXAnchor.constraint(equalTo: noRecordView.centerXAnchor).isActive = true
    btnRefresh.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    btnRefresh.widthAnchor.constraint(equalToConstant: 50.0).isActive = true

    self.backgroundView = noRecordView
    self.separatorStyle = .none
  }

  func removeEmptyMessage() {
    self.backgroundView = nil
    self.separatorStyle = .singleLine
  }
}
