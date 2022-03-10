//
//  ContactDetailController.swift
//  AnotherContactsApp
//
//  Created by Samat Murzaliev on 07.03.2022.
//

import UIKit
import SnapKit
import RealmSwift

class ContactDetailController: UIViewController, RTCustomAlertDelegate {
   
    
    let realm = try! Realm()
    
    // Элементы NavigationBar
    private lazy var topNavbarView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        return view
    }()
    
    var sendContact = Contact()
    var sentForEdit = false
    
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
        view.text = "Contacts"
        view.font = .systemFont(ofSize: 20, weight: .medium)
        view.textColor = .black
        return view
    }()
    
    // Элементы экрана детали контакта
    
    private lazy var contactLogo: UIImageView = {
        let view = UIImageView(image: UIImage(named: "contactLogo"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var deleteLogo: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(named: "deleteLogo"), for: .normal)
        view.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(deletePressed(view:)), for: .touchUpInside)
        view.tintColor = .black
        
        return view
    }()
    
    private lazy var editLogo: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(named: "editLogo"), for: .normal)
        view.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(editPressed(view:)), for: .touchUpInside)
        view.tintColor = .black

        return view
    }()
    
    private lazy var contactNameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 22, weight: .medium)
//        view.text = "Bobur Mavlonov"
        return view
    }()
    
    private lazy var numberLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 16, weight: .medium)

        return view
    }()
    
    private lazy var callLogo: UIImageView = {
        let view = UIImageView(image: UIImage(named: "callLogo"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var messageLogo: UIImageView = {
        let view = UIImageView(image: UIImage(named: "messageLogo"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var callHistoryLabel: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.text = "Call history"
        return view
    }()
    
    private lazy var callLabelTime1: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.text = "Apr 27, 14:16"
        return view
    }()
    
    private lazy var callLabelNumber1: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.text = "+996 232 323523"
        return view
    }()
    
    private lazy var callLabelImage1: UIImageView = {
        let view = UIImageView(image: UIImage(named: "callOutLogo"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var callLabelStatus1: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.text = "Didn't connect"
        return view
    }()
    
    private lazy var callLabelTime2: UILabel = {
        let view = UILabel()
        view.textColor = .red
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.text = "Apr 20, 10:35"
        return view
    }()
    
    private lazy var callLabelNumber2: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.text = "+996 232 326323"
        return view
    }()
    
    private lazy var callLabelImage2: UIImageView = {
        let view = UIImageView(image: UIImage(named: "missedCallLogo"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var callLabelStatus2: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.text = "Rang 5 times"
        return view
    }()
    
    private lazy var callLabelTime3: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.text = "Mar 05, 19:23"
        return view
    }()
    
    private lazy var callLabelNumber3: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.text = "+996 232 323236"
        return view
    }()
    
    private lazy var callLabelImage3: UIImageView = {
        let view = UIImageView(image: UIImage(named: "callOutLogo"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var callLabelStatus3: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.text = "Outgoing 15 min 12 sec"
        return view
    }()
    
    private lazy var callLabelTime4: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.text = "Feb 12, 08:03"
        return view
    }()
    
    private lazy var callLabelNumber4: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.text = "+996 555 323235"
        return view
    }()
   
    private lazy var callLabelStatus4: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.text = "Incoming 30 sec"
        return view
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        sentForEdit = false
        setSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if sentForEdit {
            fill(model: sendContact)
        }
        setSubViews()
    }
    
    private func setSubViews() {
        view.addSubview(topNavbarView)
        topNavbarView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeArea.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        topNavbarView.addSubview(navBarBackButton)
        navBarBackButton.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(8)
        }
        
        topNavbarView.addSubview(navBarLabel)
        navBarLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(navBarBackButton.snp.right).offset(15)
        }
     
        view.addSubview(contactLogo)
        contactLogo.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(topNavbarView.snp.bottom).offset(50)
        }
        
        view.addSubview(editLogo)
        editLogo.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(topNavbarView.snp.bottom).offset(120)
        }
        
        view.addSubview(deleteLogo)
        deleteLogo.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.right.equalTo(editLogo.snp.left).offset(-15)
            make.top.equalTo(editLogo.snp.top)
        }
        
        view.addSubview(contactNameLabel)
        contactNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contactLogo.snp.bottom).offset(20)
        }
        
        view.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(contactNameLabel.snp.bottom).offset(35)
        }
        
        view.addSubview(messageLogo)
        messageLogo.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(contactNameLabel.snp.bottom).offset(25)
        }
        
        view.addSubview(callLogo)
        callLogo.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.right.equalTo(messageLogo.snp.left).offset(-15)
            make.top.equalTo(messageLogo.snp.top)
        }
        
        view.addSubview(callHistoryLabel)
        callHistoryLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(numberLabel.snp.bottom).offset(40)
        }
        
        view.addSubview(callLabelTime1)
        callLabelTime1.snp.makeConstraints { make in
            make.left.equalTo(callHistoryLabel.snp.left)
            make.top.equalTo(callHistoryLabel.snp.bottom).offset(20)
        }
        
        view.addSubview(callLabelNumber1)
        callLabelNumber1.snp.makeConstraints { make in
            make.left.equalTo(callHistoryLabel.snp.left)
            make.top.equalTo(callLabelTime1.snp.bottom).offset(7)
        }
        
        view.addSubview(callLabelImage1)
        callLabelImage1.snp.makeConstraints { make in
            make.top.equalTo(callLabelNumber1.snp.top).offset(3)
            make.left.equalTo(callLabelNumber1.snp.right).offset(5)
        }
        
        view.addSubview(callLabelStatus1)
        callLabelStatus1.snp.makeConstraints { make in
            make.top.equalTo(callLabelTime1.snp.bottom)
            make.right.equalToSuperview().offset(-15)
        }
        
        view.addSubview(callLabelTime2)
        callLabelTime2.snp.makeConstraints { make in
            make.left.equalTo(callHistoryLabel.snp.left)
            make.top.equalTo(callLabelNumber1.snp.bottom).offset(20)
        }
        
        view.addSubview(callLabelNumber2)
        callLabelNumber2.snp.makeConstraints { make in
            make.left.equalTo(callHistoryLabel.snp.left)
            make.top.equalTo(callLabelTime2.snp.bottom).offset(7)
        }
        
        view.addSubview(callLabelImage2)
        callLabelImage2.snp.makeConstraints { make in
            make.top.equalTo(callLabelNumber2.snp.top).offset(3)
            make.left.equalTo(callLabelNumber2.snp.right).offset(5)
        }
        
        view.addSubview(callLabelStatus2)
        callLabelStatus2.snp.makeConstraints { make in
            make.top.equalTo(callLabelTime2.snp.bottom)
            make.right.equalToSuperview().offset(-15)
        }
        
        view.addSubview(callLabelTime3)
        callLabelTime3.snp.makeConstraints { make in
            make.left.equalTo(callHistoryLabel.snp.left)
            make.top.equalTo(callLabelNumber2.snp.bottom).offset(20)
        }
        
        view.addSubview(callLabelNumber3)
        callLabelNumber3.snp.makeConstraints { make in
            make.left.equalTo(callHistoryLabel.snp.left)
            make.top.equalTo(callLabelTime3.snp.bottom).offset(7)
        }
        
        view.addSubview(callLabelImage3)
        callLabelImage3.snp.makeConstraints { make in
            make.top.equalTo(callLabelNumber3.snp.top).offset(3)
            make.left.equalTo(callLabelNumber3.snp.right).offset(5)
        }
        
        view.addSubview(callLabelStatus3)
        callLabelStatus3.snp.makeConstraints { make in
            make.top.equalTo(callLabelTime3.snp.bottom)
            make.right.equalToSuperview().offset(-15)
        }
        
        view.addSubview(callLabelTime4)
        callLabelTime4.snp.makeConstraints { make in
            make.left.equalTo(callHistoryLabel.snp.left)
            make.top.equalTo(callLabelNumber3.snp.bottom).offset(20)
        }
        
        view.addSubview(callLabelNumber4)
        callLabelNumber4.snp.makeConstraints { make in
            make.left.equalTo(callHistoryLabel.snp.left)
            make.top.equalTo(callLabelTime4.snp.bottom).offset(7)
        }
                       
        view.addSubview(callLabelStatus4)
        callLabelStatus4.snp.makeConstraints { make in
            make.top.equalTo(callLabelTime4.snp.bottom)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    @objc func backPressed(view: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func editPressed(view: UIButton) {
        let destVC = AddContactController()
        destVC.fill(model: sendContact, fromEdit: true)
        sentForEdit = true
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    @objc func deletePressed(view: UIButton) {
        let alert = DeleteContactAlertController(title: " Titleeee", message: "Message", preferredStyle: .alert)
        alert.alertDescription.text = "Are you sure you want to remove \(contactNameLabel.text ?? "Name") from your contacts?"
        alert.delegate = self
        present(alert, animated: true)
    }
    
    func deleteContact() {
        
        try! realm.write {
            realm.delete(sendContact)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func yesPressed(_ alert: DeleteContactAlertController) {

        try! realm.write {
            realm.delete(sendContact)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func noPressed(_ alert: DeleteContactAlertController) {
    }
    
    func fill(model: Contact) {
        sendContact = model
        contactNameLabel.text = "\(model.firstName) \(model.lastName)"
        numberLabel.text = model.number
    }
}


