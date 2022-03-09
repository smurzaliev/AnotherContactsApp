//
//  ContactCell.swift
//  AnotherContactsApp
//
//  Created by Samat Murzaliev on 04.03.2022.
//

import UIKit
import SnapKit

class ContactCell: UITableViewCell {
    
    private lazy var contactLogo: UIImageView = {
        let view = UIImageView(image: UIImage(named: "account_circle"))
        view.contentMode = .scaleAspectFit
        view.tintColor = .darkGray
        return view
    }()
    
    private lazy var contactLabel: UILabel = {
        let view = UILabel()
        view.text = "Contact Name"
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textColor = .black       
        return view
    }()
    
    private lazy var contactNumber: UILabel = {
        let view = UILabel()
        view.text = "+996-700-36-10-17"
        view.font = .systemFont(ofSize: 13, weight: .medium)
        view.textColor = .darkGray
        return view
    }()
    
    private var callButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(named: "call"), for: .normal)
        view.tintColor = UIColor(named: "callColor")
        return view
    }()

    override func layoutSubviews() {
        setSubViews()
    }

    
    private func setSubViews() {
        addSubview(contactLogo)
        contactLogo.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.left.top.equalToSuperview().offset(5)
        }
        
        addSubview(contactLabel)
        contactLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(contactLogo.snp.right).offset(10)
        }
        addSubview(contactNumber)
        contactNumber.snp.makeConstraints { make in
            make.top.equalTo(contactLabel.snp.bottom).offset(3)
            make.left.equalTo(contactLogo.snp.right).offset(10)
        }
        
        addSubview(callButton)
        callButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
    }
    func fill(model: Contact) {
        contactLabel.text = "\(model.firstName) \(model.lastName)"
        contactNumber.text = model.number
    }
}
