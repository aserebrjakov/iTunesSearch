//
//  SearchViewMediator.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 20/06/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation
import UIKit

class SearchViewMediator:NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel: SearchViewModel
    
    init(viewModel:SearchViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.height()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count()
    }
    
    private let cellReuseIdentifier: String = "SearchCell"
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.checkLast(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! SearchCell
        let model = viewModel.model(indexPath.row)
        cell.configureCell(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectItem(index: indexPath.row)
    }
}

// Показывает пустой список с сообщениями.
class MessageViewMediator:NSObject, UITableViewDelegate, UITableViewDataSource {
    var message:String!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    private let notFoundCellIdentifier: String = "NotFoundCell"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: notFoundCellIdentifier, for: indexPath)
        cell.textLabel?.text = self.message
        return cell
    }
}
