//
//  HeroStats.swift
//  BOA Interview
//
//  Created by DLR on 7/20/19.
//  Copyright © 2019 DLR. All rights reserved.
//

import UIKit

struct HeroStats: Decodable {
    
    let localized_name: String
    let primary_attr: String
    let attack_type: String
    let legs: Int
    let img: String
}
