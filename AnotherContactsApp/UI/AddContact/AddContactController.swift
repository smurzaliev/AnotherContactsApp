//
//  AddContactController.swift
//  AnotherContactsApp
//
//  Created by Samat Murzaliev on 04.03.2022.
//

import UIKit
import SnapKit
import PhoneNumberKit
import RealmSwift

class AddContactController: UIViewController {
    
    private var nameLabel: UILabel = {
        let view = UILabel()
        view.text = "Name"
        view.font = .systemFont(ofSize: 16, weight: .regular)
        return view
    }()
    
    private lazy var editedContact = Contact()
    private lazy var cameFromEdit = false
    
    private var nameField: UITextField = {
        
        let view = UITextField()
        view.tintColor = .black
        view.placeholder = "Enter name"
        view.autocorrectionType = .no
        view.borderStyle = .roundedRect
        view.backgroundColor = UIColor(named: "textFieldBackgroundColor")
        return view
    }()
    
    private var surnameLabel: UILabel = {
        let view = UILabel()
        view.text = "Surname"
        view.font = .systemFont(ofSize: 16, weight: .regular)
        return view
    }()
    
    private var lastnameField: UITextField = {
        
        let view = UITextField()
        view.tintColor = .black
        view.autocorrectionType = .no
        view.placeholder = "Enter surname"
        view.borderStyle = .roundedRect
        view.tintColor = UIColor(named: "textFieldStrokeColor")
        view.backgroundColor = UIColor(named: "textFieldBackgroundColor")
        return view
    }()
    
    private var numberLabel: UILabel = {
        let view = UILabel()
        view.text = "Phone number"
        view.font = .systemFont(ofSize: 16, weight: .regular)
        return view
    }()
    
    private var numberField: PhoneNumberTextField  = {
        
        let view = PhoneNumberTextField ()
        view.tintColor = .black
        view.withExamplePlaceholder = true
        view.withDefaultPickerUI = true
        view.withFlag = true
        view.partialFormatter.defaultRegion = "KG"
        view.isPartialFormatterEnabled = true
        view.partialFormatter.maxDigits = 9
        view.autocorrectionType = .no
        view.keyboardType = .phonePad
        view.borderStyle = .roundedRect
        view.backgroundColor = UIColor(named: "textFieldBackgroundColor")
        
        return view
    }()
    
    let realm = try! Realm()
    
    private lazy var topNavbarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var navBarBackButton: UIButton = {
        
        let view = UIButton(type: .system)
        view.setImage(UIImage(named: "left_arrow"), for: .normal)
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(backPressed(view:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var navBarLabel: UILabel = {
        let view = UILabel()
        view.text = "Add"
        view.font = .systemFont(ofSize: 20, weight: .medium)
        view.textColor = .black
        return view
    }()
    
    private lazy var navDoneButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(named: "check"), for: .normal)
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        view.isEnabled = false
        view.addTarget(self, action: #selector(donePressed(view:)), for: .touchUpInside)
        return view
    }()
    
    @objc func backPressed(view: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func donePressed(view: UIButton) {
        var error = false
        
        if nameField.text?.count == 0 {
            let alert = UIAlertController(title: "Error", message: "Enter contact name!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in }))
            present(alert,animated: true)
            error = true
        }
        
        if lastnameField.text?.count == 0 {
            let alert = UIAlertController(title: "Error", message: "Enter contact surname!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in }))
            present(alert,animated: true)
        }
        
        if numberField.text?.count == 0 {
            let alert = UIAlertController(title: "Error", message: "Enter contact number!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in }))
            present(alert,animated: true)
        }
        
        if !error {
            
            if cameFromEdit {
                try! realm.write {
                    self.editedContact.firstName = nameField.text!
                    self.editedContact.lastName = lastnameField.text!
                    self.editedContact.number = numberField.text!
                }
            } else {
                let newContact = Contact()
                newContact.firstName = nameField.text!
                newContact.lastName = lastnameField.text!
                newContact.number = numberField.text!
                try! realm.write {
                    realm.add(newContact)
                }
                
            }
            
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        setViews()
        setSubViews()
        nameField.delegate = self
        lastnameField.delegate = self
        numberField.delegate = self
        
    }
    
    private func setViews() {
        view.backgroundColor = .white
    }
    
    private func setSubViews() {
        
        view.addSubview(topNavbarView)
        topNavbarView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeArea.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        topNavbarView.addSubview(navBarBackButton)
        navBarBackButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(15)
        }
        
        topNavbarView.addSubview(navBarLabel)
        navBarLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(navBarBackButton.snp.right).offset(35)
        }
        
        topNavbarView.addSubview(navDoneButton)
        navDoneButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-20)
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(topNavbarView.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(10)
        }
        
        view.addSubview(nameField)
        nameField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
        
        view.addSubview(surnameLabel)
        surnameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
        }
        
        view.addSubview(lastnameField)
        lastnameField.snp.makeConstraints { make in
            make.top.equalTo(surnameLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
        
        view.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(lastnameField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
        }
        
        view.addSubview(numberField)
        numberField.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
    }
}

extension AddContactController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        for layer in  textField.layer.sublayers!{
            layer.borderColor = UIColor.black.cgColor
            if ((nameField.text?.count ?? 0>0) && (lastnameField.text?.count ?? 0>0)) ||
                ((nameField.text?.count ?? 0>0) && (numberField.text?.count ?? 0>0)) ||
                ((lastnameField.text?.count ?? 0>0) && (numberField.text?.count ?? 0>0))
            {
                navDoneButton.isEnabled = true
            } else {
                navDoneButton.isEnabled = false
            }
        }
    }
    
    func fill(model: Contact, fromEdit: Bool) {
        self.cameFromEdit = fromEdit
        self.navDoneButton.isEnabled = true
        self.editedContact = model
        nameField.text = model.firstName
        lastnameField.text = model.lastName
        numberField.text = model.number
    }
}

class MyGBTextField: PhoneNumberTextField {
    override var defaultRegion: String {
        get {
            return "KG"
        }
        set {} // exists for backward compatibility
    }
}
