//
//  PersistenceKey+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 20/04/2024.
//

import Sharing
import IdentifiedCollections
import Core
import Models

extension SharedKey where Self == InMemoryKey<[Genre]> {
    static var genres: Self { .inMemory("genres") }
}

extension SharedKey where Self == AppStorageKey<Constants.Appearance> {
    static var appearance: Self { .appStorage("appearance") }
}

extension SharedKey where Self == AppStorageKey<Bool> {
    static var adultContent: Self { .appStorage("isAdultContentOn") }
}

extension SharedKey where Self == FileStorageKey<IdentifiedArrayOf<Movie>> {
    static var likedMovies: Self { .fileStorage(.applicationDirectory.appending(path: "likedMovies.json")) }
}
