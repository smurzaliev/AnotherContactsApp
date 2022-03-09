//
//  DeleteAlertController.swift
//  AnotherContactsApp
//
//  Created by Samat Murzaliev on 07.03.2022.
//

import UIKit
import SnapKit

class DeleteContactAlertController: UIViewController {
    
    weak var delegate: RTCustomAlertDelegate?
    
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var alertLabel: UILabel = {
        let view = UILabel()
        view.text = "Delete contact"
        view.font = .systemFont(ofSize: 16, weight: .bold)
        return view
    }()
    
    var alertDescription: UILabel = {
        let view = UILabel()
        view.text = "Are you sure you want to remove Bobur Mavlonov from your contacts?"
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.numberOfLines = 2
        return view
    }()
    
    private lazy var alertNoButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("NO", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(noPressedAction(view:)), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var alertYesButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("YES", for: .normal)
        view.setTitleColor(.red, for: .normal)
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(yesPressedAction(view:)), for: .touchUpInside)
        return view
    }()

    override func viewDidLoad() {
        view.backgroundColor = .clear
        setSubViews()
    }
    
    private func setSubViews() {
        view.addSubview(alertView)

        alertView.snp.makeConstraints { make in
            make.height.equalTo(140)
            make.width.equalTo(310)
            make.center.equalToSuperview()
        }
        
        alertView.addSubview(alertLabel)
        alertLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
        }
        
        alertView.addSubview(alertDescription)
        alertDescription.snp.makeConstraints { make in
            make.top.equalTo(alertLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-5)
        }
        
        alertView.addSubview(alertYesButton)
        alertYesButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        alertView.addSubview(alertNoButton)
        alertNoButton.snp.makeConstraints { make in
            make.right.equalTo(alertYesButton.snp.left).offset(-30)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    @objc func noPressedAction(view: UIButton) {
        self.dismiss(animated: true, completion: nil)
        print("pressed NO")
        delegate?.noPressed(self)
    }
    
    @objc func yesPressedAction(view: UIButton) {
        self.dismiss(animated: true, completion: nil)
        print("pressed YESS")
        delegate?.yesPressed(self)
    }
}

protocol RTCustomAlertDelegate: AnyObject {
    func yesPressed(_ alert: DeleteContactAlertController)
    func noPressed(_ alert: DeleteContactAlertController)
}
