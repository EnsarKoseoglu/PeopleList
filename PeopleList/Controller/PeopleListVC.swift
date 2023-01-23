//
//  PeopleListVC.swift
//  PeopleList
//
//  Created by EnsarKoseoglu on 21.01.2023.
//  Copyright © 2023 Ensar Koseoglu. All rights reserved.
//

import UIKit

class PeopleListVC: UIViewController {
  private let cellId = "personCellId"
  private var viewModel: PeopleListViewModel!

  private var safeArea: UILayoutGuide!
  private lazy var peopleTableView: UITableView = { [unowned self] in
    $0.dataSource = self
    $0.delegate = self
    $0.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    return $0
  }(UITableView())

  private lazy var peopleRefreshControl: UIRefreshControl = { [unowned self] in
    $0.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
    return $0
  }(UIRefreshControl())

  override func viewDidLoad() {
    super.viewDidLoad()
    pageSetup()
  }

  private func pageSetup() {
    viewModelSetup()
    viewSetup()
    refresh()
  }

  private func viewModelSetup() {
    viewModel = PeopleListViewModel()

    viewModel.onSuccess = { [weak self] () in
      DispatchQueue.main.async {
        guard let view = self else { return }
        view.hideLoading()
        view.peopleRefreshControl.endRefreshing()
        if view.viewModel.people.isEmpty {
          view.peopleTableView.showEmptyMessageIfNeeded("No one here :)", with: #selector(view.refresh), target: view)
        } else {
          view.peopleTableView.removeEmptyMessage()
          view.peopleTableView.reloadData()
        }
      }
    }

    viewModel.onFailure = { [weak self] (error) in
      DispatchQueue.main.async {
        guard let view = self, let error else { return }
        view.hideLoading()
        view.peopleRefreshControl.endRefreshing()
        view.peopleTableView.reloadData()
        view.showError(with: error.errorDescription) { willRetry in
          if willRetry { view.refresh() }
        }
      }
    }
  }

  private func viewSetup() {
    self.navigationItem.title = "People"
    self.view.backgroundColor = .white

    safeArea = view.layoutMarginsGuide
    self.view.addSubview(peopleTableView)
    peopleTableView.translatesAutoresizingMaskIntoConstraints = false
    peopleTableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    peopleTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    peopleTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    peopleTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    peopleTableView.addSubview(peopleRefreshControl)
  }

  @objc private func refresh() {
    viewModel.people.removeAll()
    peopleTableView.removeEmptyMessage()
    peopleTableView.reloadData()
    showLoading()
    viewModel.getPersonList()
  }

  private func getNextPage() {
    showLoading()
    viewModel.getPersonList()
  }
}

extension PeopleListVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.people.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    let person = viewModel.people[indexPath.row]
    cell.textLabel?.text = "\(person.fullName) (\(person.id))"
    cell.selectionStyle = .none
    return cell
  }
}

extension PeopleListVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == viewModel.people.count - 1 && viewModel.page != nil {
      getNextPage()
    }
  }
}
