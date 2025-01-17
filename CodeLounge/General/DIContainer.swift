//
//  DIContainer.swift
//  CodeLounge
//
//  Created by 김동현 on 1/14/25.
//

import Foundation

final class DIContainer: ObservableObject {
    var services: ServiceType
    
    init(services: ServiceType) {
        self.services = services
    }
}

