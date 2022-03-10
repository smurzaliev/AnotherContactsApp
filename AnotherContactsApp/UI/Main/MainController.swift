//
//  ViewController.swift
//  AnotherContactsApp
//
//  Created by Samat Murzaliev on 03.03.2022.
//

import UIKit
import SnapKit
import RealmSwift

class MainController: UIViewController  {
    
    let realm = try! Realm()
    var sortedContacts: [Contact] = []
    
    // Элементы NavigationBar
  
    private lazy var topNavbarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var searchField: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.placeholder = "Search..."
        view.autocorrectionType = .no
        view.isHidden = true
        view.isEnabled = false
        return view
    }()
    
    private lazy var clearTextIcon: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(named: "close"), for: .normal)
        view.tintColor = .black
        view.isEnabled = false
        view.isHidden = true
        view.addTarget(self, action: #selector(clearTextPressed(view:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var navbarBackButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(named: "arrowback"), for: .normal)
        view.tintColor = .black
        view.isHidden = true
        view.addTarget(self, action: #selector(navbarBackPressed(view:)), for: .touchUpInside)
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
        view.addTarget(self, action: #selector(searchPressed(view:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var navBarMoreButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(named: "more_vert"), for: .normal)
        view.tintColor = .black
        return view
    }()
    
    //MARK: элементы таблицы и изображения
    
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
    
    @objc func searchPressed(view: UIButton) {
        self.navBarLabel.isHidden = true
        self.navbarBackButton.isHidden = false
        self.searchField.isHidden = false
        self.clearTextIcon.isHidden = false
        self.navBarSearchButton.isHidden = true
        self.searchField.isEnabled = true
    }
    
    @objc func navbarBackPressed(view: UIButton) {
        self.navBarLabel.isHidden = false
        self.navbarBackButton.isHidden = true
        self.searchField.isHidden = true
        self.clearTextIcon.isHidden = true
        self.navBarSearchButton.isHidden = false
        self.clearTextIcon.isEnabled = false
        self.searchField.isEnabled = false
        
        let contacts = realm.objects(Contact.self)
        sortedContacts = []
        for item in contacts {
            sortedContacts.append(item)
        }
        self.contactsTable.reloadData()
    }
    
    @objc func clearTextPressed(view: UIButton) {
        searchField.text = ""
        
        navbarBackButton.isHidden = false
        searchField.snp.remakeConstraints { make in
            make.left.equalTo(navbarBackButton.snp.right).offset(18)
            make.top.equalToSuperview().offset(5)
            make.width.equalTo(240)
        }
        
        let contacts = realm.objects(Contact.self)
        sortedContacts = []
        for item in contacts {
            sortedContacts.append(item)
        }
        self.contactsTable.reloadData()
    }
    
    override func viewDidLoad() {
        setSubViews()
        checkStatus() // Проверка на наличие контактов в сохраненных и переключение элементов

        let sortByAZ = UIAction(title: "Sort A-Z", image: UIImage(systemName: "arrow.up.arrow.down")) { (action) in
            self.getSorted(sort: "AZ")
            self.contactsTable.reloadData()
        }
        
        let sortByZA = UIAction(title: "Sort Z-A", image: UIImage(systemName: "arrow.up.arrow.down")) { (action) in
            self.getSorted(sort: "ZA")
            self.contactsTable.reloadData()
        }
        
        let deleteAll = UIAction(title: "Delete all", image: UIImage(systemName: "xmark.bin")) { (action) in
            let alert = DeleteAllContactsAlertController(title: " Titleeee", message: "Message", preferredStyle: .alert)
            alert.delegate = self
            self.present(alert, animated: true)
        }
        
        let menu = UIMenu(title: "", options: .displayInline, children: [sortByAZ, sortByZA , deleteAll])
        navBarMoreButton.menu = menu
        navBarMoreButton.showsMenuAsPrimaryAction = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let contacts = realm.objects(Contact.self)
        sortedContacts = []
        for item in contacts {
            sortedContacts.append(item)
        }
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
            make.height.equalTo(50)
        }
        
        topNavbarView.addSubview(navBarLabel)
        navBarLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(10)
        }
        
        topNavbarView.addSubview(navbarBackButton)
        navbarBackButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(15)
        }
        
        topNavbarView.addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.left.equalTo(navbarBackButton.snp.right).offset(18)
            make.top.equalToSuperview().offset(5)
            make.width.equalTo(240)
        }

        topNavbarView.addSubview(navBarMoreButton)
        navBarMoreButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-13)
            make.top.equalToSuperview().offset(5)
        }
        
        topNavbarView.addSubview(clearTextIcon)
        clearTextIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalTo(navBarMoreButton.snp.left).offset(-10)
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

extension MainController: UITableViewDelegate, UITableViewDataSource, DCCustomAlertDelegate, UITextFieldDelegate {
    func yesAllPressed(_ alert: DeleteAllContactsAlertController) {
        try! realm.write {
            realm.deleteAll()
        }
        contactsTable.reloadData()
        checkStatus()
    }
    
    func noAllPressed(_ alert: DeleteAllContactsAlertController) {
        
    }
    
    func getSorted(sort: String) {
        let contacts = realm.objects(Contact.self)

        if sort == "AZ" {
            sortedContacts = contacts.sorted { (initial, next) -> Bool in
                return initial.firstName.compare(next.firstName) == .orderedAscending
                }
        } else if sort == "ZA" {
            sortedContacts = contacts.sorted { (initial, next) -> Bool in
                  return initial.firstName.compare(next.firstName) == .orderedDescending
                }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navbarBackButton.isHidden = true
        self.searchField.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(5)
            make.width.equalTo(240)
        }
        self.clearTextIcon.isEnabled = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let contacts = realm.objects(Contact.self)
        sortedContacts = []
        for item in contacts {
            sortedContacts.append(item)
        }
        
        var searchString = ""
        let searchText  = textField.text! + string
            if searchText.count >= 0 {
                sortedContacts = contacts.filter({ (result) -> Bool in
                    searchString = result.firstName + " " + result.lastName
                    return searchString.range(of: searchText, options: .caseInsensitive) != nil
                })
                contactsTable.reloadData()
            }
            else{
                sortedContacts = []
            }
            return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ContactCell()
        let model = sortedContacts[indexPath.row]
        cell.fill(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let destVC = ContactDetailController()
        print(sortedContacts[index])
        destVC.fill(model: sortedContacts[index])
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contacts = realm.objects(Contact.self)
            try! realm.write {
                realm.delete(contacts[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            checkStatus()
        }
    }
}
