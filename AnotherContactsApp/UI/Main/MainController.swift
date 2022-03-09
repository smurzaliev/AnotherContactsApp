//
//  ViewController.swift
//  AnotherContactsApp
//
//  Created by Samat Murzaliev on 03.03.2022.
//

import UIKit
import SnapKit
import RealmSwift

class MainController: UIViewController {
    
    let realm = try! Realm()
    
    // Элементы NavigationBar
    
    private lazy var topNavbarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var navBarLabel: UILabel = {
        let view = UILabel()
        view.text = "Contacts"
        view.font = .systemFont(ofSize: 20, weight: .medium)
        view.textColor = .black
        return view
    }()
    
    private lazy var navBarSearchButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(named: "search"), for: .normal)
        view.tintColor = .black
        return view
    }()
    
    private lazy var navBarMoreButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(named: "more_vert"), for: .normal)
        view.tintColor = .black
        
        return view
    }()
    
    private lazy var boxImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "boxImage"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(named: "addButton"), for: .normal)
        view.layer.borderColor = UIColor(named: "addButtonColor")?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.tintColor = .white
        view.backgroundColor = UIColor(named: "addButtonColor")
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 5.0, height: 4.0)
        view.layer.shadowOpacity = 2.0
        view.layer.shadowRadius = 3.0
        view.layer.masksToBounds = false
        view.addTarget(self, action: #selector(addContactPressed(view:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var boxTitle: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.text = "You have no contacts yet"
        view.textColor = .lightGray
        return view
    }()
    
    private lazy var contactsTable: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    @objc func addContactPressed(view: UIButton) {
        navigationController?.pushViewController(AddContactController(), animated: true)
    }
    
    override func viewDidLoad() {
        setSubViews()
        checkStatus() // Проверка на наличие контактов в сохраненных и переключение элементов
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contactsTable.reloadData()
        checkStatus()
    }
    
    private func checkStatus() {
        let contacts = realm.objects(Contact.self)
        boxImage.isHidden = contacts.count==0 ? false : true
        boxTitle.isHidden = contacts.count==0 ? false : true
        contactsTable.isHidden = contacts.count>0 ? false : true
    }
    
    private func setSubViews() {
        
        view.addSubview(topNavbarView)
        topNavbarView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeArea.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        topNavbarView.addSubview(navBarLabel)
        navBarLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(8)
        }
        
        topNavbarView.addSubview(navBarMoreButton)
        navBarMoreButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(5)
        }
        
        topNavbarView.addSubview(navBarSearchButton)
        navBarSearchButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.right.equalTo(navBarMoreButton.snp.left).offset(-10)
        }
        
        view.addSubview(boxImage)
        boxImage.snp.makeConstraints { make in
            make.height.equalTo(view.layer.bounds.height / 4.2)
            make.width.equalTo(view.layer.bounds.width / 2.2)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        
        view.addSubview(boxTitle)
        boxTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(boxImage.snp.bottom).offset(5)
        }

        view.addSubview(contactsTable)
        contactsTable.snp.makeConstraints { make in
            make.top.equalTo(topNavbarView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().offset(-25)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
    }
}

extension MainController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contacts = realm.objects(Contact.self)
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ContactCell()
        let contacts = realm.objects(Contact.self)
        let model = contacts[indexPath.row]
        cell.fill(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contacts = realm.objects(Contact.self)
        let index = indexPath.row
        let destVC = ContactDetailController()
        print(contacts[index])
        destVC.fill(model: contacts[index])
        navigationController?.pushViewController(destVC, animated: true)
    }
}
