//
//  PublisherObservableObject.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 10/01/2024.
//

import Foundation
import Combine

final class PublisherObservableObject: ObservableObject {
    
    var subscriber: AnyCancellable?
    
    init(publisher: AnyPublisher<Void, Never>) {
        subscriber = publisher
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
    }
}
