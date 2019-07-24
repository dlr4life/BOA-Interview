//
//  Country.swift
//  BOA Interview
//
//  Created by DLR on 7/19/19.
//  Copyright © 2019 DLR. All rights reserved.
//

import UIKit

class Country {
    
    // Propetries for the Counry class
    var country: String
    var capital: String
    var region: String
    var subregion: String
    var population: Int

    // Initializers for class properties
    init(country: String, capital: String, region: String, subregion: String, population: Int) {
        self.country = country
        self.capital = capital
        self.region = region
        self.subregion = subregion
        self.population = population
    }
}
