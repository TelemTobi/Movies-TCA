//
//  MoviesHomepage.swift
//  Presentation
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import SwiftData
import ComposableArchitecture
import Models
import DesignSystem

@Reducer
public struct MoviesHomepage {
    
    @ObservableState
    public struct State: Equatable {
        var viewState: ViewState
        var lists: [MovieListType: MovieList] = [:]
        
        @Shared(.watchlist) var watchlist: IdentifiedArrayOf<Movie> = []
        
        public init(viewState: ViewState = .loading) {
            self.viewState = viewState
        }
    }
    
    public enum Action: ViewAction, Equatable {
        @CasePathable
        public enum View: Equatable {
            case onFirstAppear
            case onMovieTap(Movie, TransitionSource)
            case onSectionHeaderTap(HomepageSection)
            case onGenreTap(Genre)
            case onMovieLike(Movie)
        }
        
        @CasePathable
        public enum Navigation: Equatable {
            case movieDetails(Movie, TransitionSource)
            case expandSection(HomepageSection, MovieList)
            case genreDetails(Genre)
        }
        
        case view(View)
        case navigation(Navigation)
        case fetchMovieLists
        case movieListsResult([MovieListType: Result<MovieList, TmdbError>])
    }
    
    @Dependency(\.interactor) private var interactor
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case .fetchMovieLists:
                state.viewState = .loading
                
                return .run { send in
                    let result = await interactor.fetchMovieLists(
                        ofTypes: .nowPlaying, .upcoming, .popular, .topRated
                    )
                    await send(.movieListsResult(result))
                }
                
            case let .movieListsResult(result):
                state.lists = result
                    .compactMapValues { try? $0.get() }
                    .filter { $0.value.movies?.isEmpty == false }
                
                state.viewState = .loaded(createSections(outOf: &state))
                return .none
                
            case .navigation:
                return .none
            }
        }
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case .onFirstAppear:
            return .send(.fetchMovieLists)
            
        case let .onMovieTap(movie, transitionSource):
            return .send(.navigation(.movieDetails(movie, transitionSource)))
            
        case let .onSectionHeaderTap(section):
            let movieList: MovieList? = switch section {
            case .nowPlaying: state.lists[.nowPlaying]
            case .watchlist: MovieList(movies: state.watchlist.elements)
            case .upcoming: state.lists[.upcoming]
            case .popular: state.lists[.popular]
            case .genres: nil
            case .topRated: state.lists[.topRated]
            }
            
            guard let movieList else { return .none }
            return .send(.navigation(.expandSection(section, movieList)))
            
        case let .onGenreTap(genre):
            return .send(.navigation(.genreDetails(genre)))
            
        case let .onMovieLike(movie):
            return .run { _ in
                await interactor.toggleWatchlist(for: movie)
            }
        }
    }
    
    private func createSections(outOf state: inout State) -> [HomepageSection] {
        [
            state.lists[.nowPlaying] != nil ? .nowPlaying : nil,
            state.watchlist.isNotEmpty ? .watchlist : nil,
            state.lists[.upcoming] != nil ? .upcoming : nil,
            state.lists[.popular] != nil ? .popular : nil,
            .genres,
            state.lists[.topRated] != nil ? .topRated : nil,
        ]
        .compactMap { $0 }
    }
}

public extension MoviesHomepage {
    enum ViewState: Equatable {
        case loading
        case loaded([HomepageSection])
    }
}

extension DependencyValues {
    fileprivate var interactor: MoviesHomepageInteractor {
        get { self[MoviesHomepageInteractor.self] }
    }
}
