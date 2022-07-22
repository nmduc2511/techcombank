//
//  DrinkModel.swift
//  Foody
//
//  Created by minh duc on 22/07/2022.
//

import RxSwift
import Foundation

protocol MenuProtocol {
    var title: String { get set }
    var description: String { get set }
    var url: String { get set }
}

struct DrinkModel: MenuProtocol, Codable {
    var title: String
    var description: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case title = "strDrink"
        case description = "strInstructions"
        case url = "strDrinkThumb"
    }
    
    
}

struct DrinkContainer: Codable {
    var drinks: [DrinkModel]
    
    static func decode(_ data: Data) -> [DrinkModel] {
        let decoder = JSONDecoder()
        let model = try? decoder.decode(DrinkContainer.self, from: data)
        return model?.drinks ?? []
    }
    
//    static func decode(_ data: Data) -> [DrinkModel] {
//        let decoder = JSONDecoder()
//        let model = try? decoder.decode(DrinkContainer.self, from: data)
//        return model?.drinks ?? []
//    }
}
