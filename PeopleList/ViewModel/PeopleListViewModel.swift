//
//  PeopleListViewModel.swift
//  PeopleList
//
//  Created by EnsarKoseoglu on 21.01.2023.
//  Copyright © 2023 Ensar Koseoglu. All rights reserved.
//

import Foundation

protocol IPeopleList: AnyObject {
  var onSuccess: (() -> Void)? { get set }
  var onFailure: ((FetchError?) -> Void)? { get set }

  func getPersonList()
}

class PeopleListViewModel: IPeopleList {
  var onSuccess: (() -> Void)?
  var onFailure: ((FetchError?) -> Void)?

  var people: [Person] = []
  var page: String?

  func getPersonList() {
    DataSource.fetch(next: page) { result, error in
      guard error == nil else {
        self.onFailure?(error)
        return
      }

      guard let result else {
        self.onFailure?(FetchError(description: "Data source result error"))
        return
      }

      self.page = result.next
      self.people.append(contentsOf: result.people)
      self.people = self.people.unique(map: { $0.id })
      self.onSuccess?()
    }
  }
}

extension Array {
  func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
    var set = Set<T>()
    var arrayOrdered = [Element]()
    for value in self {
      if !set.contains(map(value)) {
        set.insert(map(value))
        arrayOrdered.append(value)
      }
    }
    return arrayOrdered
  }
}
