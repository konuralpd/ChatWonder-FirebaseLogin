//
//  RegisterViewController.swift
//  ChatWonder
//
//  Created by Mac on 30.06.2022.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController, UINavigationControllerDelegate {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "user")?.withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = iv.frame.height / 2.0

        
        
        iv.isUserInteractionEnabled = true
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
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 4
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.layer.borderColor = UIColor(red: 75/255, green: 210/255, blue: 249/255, alpha: 1).cgColor
        field.placeholder = "İsim"
        
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
        button.setTitle("Kayıt Ol", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 75/255, green: 210/255, blue: 249/255, alpha: 1)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Kayıt Ol"
        view.backgroundColor = .white
        
        emailField.delegate = self
        passwordField.delegate = self
        tabBarController?.tabBar.isHidden = true
        
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(appNameLabel)
        scrollView.addSubview(emailField)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(gesture)
        scrollView.frame = view.bounds
                
        
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, width: 264, height: view.height/3)
        
        appNameLabel.anchor(top: imageView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 24, height: 52)
        emailField.anchor(top: appNameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.width-20, height: 52)
        
        firstNameField.anchor(top: emailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.width-20, height: 52)
        
        passwordField.anchor(top: firstNameField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.width-20, height: 52)
        
        loginButton.anchor(top: passwordField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.width-20, height: 64)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.height/2.0
    }
    
    @objc func didTapChangeProfilePic() {
        
        presentPhotoActionSheet()
    }
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Hesap Oluştur"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func signUpClicked() {
        
        
        
        guard let firstname = firstNameField.text,
              let email = emailField.text, let password = passwordField.text, !email.isEmpty, !firstname.isEmpty, !password.isEmpty, password.count >= 5 else {
            alertUserLoginError()
            return
        }
        
        //Firebase Uyelik Olusturma İslemleri
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                let alert = UIAlertController(title: "Hata", message: "Üyelik Oluşturma Hatası", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                
            } else {
                
                let chatUser = ChatAppUser(firstName: firstname, email: email)
                DatabaseManager.shared.insertUser(with: chatUser, completion: { succes in
                    if succes {
                        guard let image = self.imageView.image, let data = image.pngData() else {
                            return
                            
                        }
                        let fileName = chatUser.profilePictureFileName
                        StorageManager.shared.uploaadProfilePicture(with: data, fileName: fileName) { result in
                            switch result {
                            case .success(let downloadUrl):
                                UserDefaults.standard.setValue(downloadUrl, forKey: "profile_picture_url")
                                print(downloadUrl)
                            case.failure(let error):
                                print("Storage Manager Error: \(error)")
                            }
                        }
                    }
                })
                
                let vc = ConversationsViewController()
                
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
                //self.navigationController?.pushViewController(ConversationsViewController(), animated: true)
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

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if
        textField == passwordField {
            signUpClicked()
        }
        
        return true
    }
   

}

extension RegisterViewController: UIImagePickerControllerDelegate {
    
    func presentPhotoActionSheet() {
        
        let actionSheet = UIAlertController(title: "Profil Fotosu", message: "Profil Fotoğrafı Seçmek İster Misin?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Fotoğraf Çek", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Fotoğraf Seç", style: .default, handler: { [weak self] _ in }))
        self.presentPhotoPicker()
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated:  true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.imageView.image = selectedImage
    }
}
