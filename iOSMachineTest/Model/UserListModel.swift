//
//  UserListModel.swift
//  iOSMachineTest
//
//  Created by Anil Yadav on 12/03/25.
//  Email: anilyadavjnt@gmail.com
//  Contact No: +91-975211420
//


import Foundation

// MARK: - UserListModel
struct UserListModel: Codable {
    let page, perPage, total, totalPages: Int?
    var data: [UserList]?
    let support: Support?

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data, support
    }
}

// MARK: - Datum
struct UserList: Codable {
    let id: Int?
    let email, firstName, lastName: String?
    let avatar: String?
    var isFavorite: Bool?

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar, isFavorite
    }
}

// MARK: - Support
struct Support: Codable {
    let url: String?
    let text: String?
}
