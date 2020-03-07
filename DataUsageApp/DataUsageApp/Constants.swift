//
//  Constants.swift
//  DataUsageApp
//
//  Created by Nach on 7/3/20.
//

import Foundation

class Constants {
    struct defaultValues {
        static let baseYear = 2004
        static let numberOfQuarters = 4
        static let quartersOffset = 2
    }
    
    struct link {
        static let baseUrl = "https://data.gov.sg"
        static let apiUrl = "/api/action/datastore_search?"
        static let offset = "offset="
        static let limit = "&limit="
        static let resourceid = "&resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
        static let numberOfLimits = 4
    }
    
}
