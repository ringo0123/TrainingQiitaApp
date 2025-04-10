//
//  QiitaModel.swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/10.
//

import Foundation

struct User: Decodable {
    let id: String
    let name: String?
    let profileImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageUrl = "profile_image_url"
    }
}
