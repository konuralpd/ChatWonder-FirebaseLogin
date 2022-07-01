//
//  ViewController.swift
//  ChatWonder
//
//  Created by Mac on 30.06.2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD

class ConversationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Murat"
        cell.imageView?.image = UIImage(named: "man")
        cell.imageView?.layer.cornerRadius = 40/2
        cell.imageView?.layer.masksToBounds = true
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title = "Murat"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    private let spinner = JGProgressHUD(style: .dark)
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noChatLabel: UILabel = {
       let label = UILabel()
        label.text = "Hiç Mesajlaşma Yok!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    private let newChatButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "add"), for: .normal)
        button.addTarget(self, action: #selector(didtapNewChat), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(noChatLabel)
        setupTableView()
        fetchConversations()
        view.addSubview(newChatButton)
        newChatButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 40, paddingRight: 18, width: 64, height: 64)
        
        let rightButton = UIBarButtonItem(title: "Çıkış", style: .plain, target: self, action: #selector(logoutTapped))
        self.navigationItem.rightBarButtonItems = [rightButton]
        
       
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
      
        
        
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }


    private func fetchConversations() {
        tableView.isHidden = false
    }
    @objc func logoutTapped() {
        do {
            
            try FirebaseAuth.Auth.auth().signOut()
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    @objc private func didtapNewChat() {
        let vc = NewConversationViewController()
        
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}




