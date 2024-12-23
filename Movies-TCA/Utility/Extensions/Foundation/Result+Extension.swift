//
//  Result+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 18/11/2023.
//

import Foundation
import Flux

extension Result where Failure : DecodableError {
    
    static var unknownError: Result<Success, Failure> {
        .failure(Failure(.unknownError("Unknown error")))
    }
}
