//
//  ContactModel.swift
//  AnotherContactsApp
//
//  Created by Samat Murzaliev on 05.03.2022.
//

import Foundation
import RealmSwift

class Contact: Object {
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var number = ""
}
