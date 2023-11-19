//
//  Result+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 18/11/2023.
//

import Foundation

extension Result where Failure : Errorable {
    
    static var unknownError: Result<Success, Failure> {
        .failure(Failure(.unkownError))
    }
}
