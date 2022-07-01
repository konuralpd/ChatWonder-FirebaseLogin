//
//  NewConversationViewController.swift
//  ChatWonder
//
//  Created by Mac on 30.06.2022.
//

import UIKit
import JGProgressHUD


class NewConversationViewController: UIViewController {
    private let spinner = JGProgressHUD()
    
    private var users = [[String: String]]()
    private var hasFetched = false
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Mesajlaşmak için Kullanıcı Ara"
        return searchBar
        }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "Sonuç Bulunamadı"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Kapat", style: .done, target: self, action: #selector(dissmisSelf))
        
        searchBar.becomeFirstResponder()
       
    }
    @objc private func dissmisSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    func searchUsers(query: String) {
        
        if hasFetched {
            
            
            
        } else {
            DatabaseManager.shared.getAllUsers { [weak self] result in
                switch result {
                case .success(let usersCollection):
                    self?.users = usersCollection
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

}

extension NewConversationViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}
