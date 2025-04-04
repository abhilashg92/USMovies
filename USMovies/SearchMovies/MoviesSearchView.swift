//
//  MoviesSearchView.swift
//  USMovies
//
//  Created by Abhilash Ghogale on 31/03/25.
//

import SwiftUI

struct MovieSearchView: View {
    @StateObject private var viewModel = MoviesViewModel()
    
    var body: some View {
        NavigationView {
            content
        }
        .searchable(text: $viewModel.query, prompt: "Search Movies")
        .onChange(of: viewModel.query) { newValue in
            newValue.isEmpty ? viewModel.cancelSearch() : viewModel.searchMovies()
        }
        .onSubmit(of: .search, viewModel.searchMovies)
        .navigationTitle("Movie Search")
    }
    
    @ViewBuilder
    private var content: some View {
        switch (viewModel.isLoading,
                viewModel.errorMessage,
                viewModel.movies.isEmpty) {
        case (true, _, _):
            ProgressView("Loading...")
                .padding()
        case (_, let error?, _):
            Text(error)
                .foregroundColor(.red)
                .padding()
        case (_, _, true):
            Text("Start searching for movies!")
                .foregroundColor(.gray)
                .padding()
                .font(.title2)
        default:
            List(viewModel.movies.indices, id: \.self) { index in
                let movie = viewModel.movies[index]
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    MovieView(movie: movie)
                }
                .onAppear {
                    if index == viewModel.movies.count - 1 {
                        viewModel.searchMovies()
                    }
                }
            }
        }
    }
}

#Preview {
    MovieSearchView()
}
