//
//  UserViewModel.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 18.10.2021.
//

import Foundation

class UserViewModel: ObservableObject {
    private static let userNameKey = "userName"
    
    @Published var userName: String {
        didSet {
            UserDefaults.standard.set(userName, forKey: UserViewModel.userNameKey)
        }
    }
    
    init() {
        userName = UserDefaults.standard.string(forKey: UserViewModel.userNameKey) ?? ""
    }
}
