//
//  LoginViewController.swift
//  ChatWonder
//
//  Created by Mac on 30.06.2022.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .extraLight)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "ChatWonder"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 28.0)
        return label
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 4
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.layer.borderColor = UIColor(red: 75/255, green: 210/255, blue: 249/255, alpha: 1).cgColor
        field.placeholder = "E-Mail"
        
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 4
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.layer.borderColor = UIColor(red: 75/255, green: 210/255, blue: 249/255, alpha: 1).cgColor
        field.placeholder = "Şifre"
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Giriş Yap", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 75/255, green: 210/255, blue: 249/255, alpha: 1)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(loginClicked), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Giriş Yap"
        view.backgroundColor = .white
        
        emailField.delegate = self
        passwordField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "signin")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(didTapRegister))
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(appNameLabel)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.frame = view.bounds
        
        
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, width: 128, height: 128)
        
        appNameLabel.anchor(top: imageView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 24, height: 52)
        emailField.anchor(top: appNameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.width-20, height: 52)
        
        passwordField.anchor(top: emailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.width-20, height: 52)
        
        loginButton.anchor(top: passwordField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.width-20, height: 64)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Hesap Oluştur"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func loginClicked() {
        
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count >= 5 else {
            alertUserLoginError()
            return
        }
        spinner.show(in: view)
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                let alert = UIAlertController(title: "Hata", message: "Giriş Hatası.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            
            let user = result?.user
            UserDefaults.standard.setValue(email, forKey: "email")
            
            let vc = ConversationsViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            
        }
    }
    
    
    func alertUserLoginError() {
        
        let alert = UIAlertController(title: "Hata!", message: "Lütfen bilgilerinizi eksiksiz giriniz.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: nil))
        alert.view.tintColor = UIColor(red: 75/255, green: 210/255, blue: 249/255, alpha: 1)
        present(alert, animated: true)
    }

   
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if
        textField == passwordField {
            loginClicked()
        }
        
        return true
    }
}
