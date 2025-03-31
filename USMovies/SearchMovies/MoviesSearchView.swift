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
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.movies.isEmpty {
                    Text("Start searching for movies!")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.movies) { movie in
                        NavigationLink {
                            MovieDetailView(movie: movie)
                        } label: {
                            MovieView(movie: movie)
                        }
                        .onAppear {
                            if movie == viewModel.movies.last {
                                viewModel.searchMovies()
                            }
                        }
                    }
                    
                }
            }            .searchable(text: $viewModel.query, prompt: "Search Movies")
                .onChange(of: viewModel.query) { newValue in
                    if newValue.isEmpty {
                        viewModel.cancelSearch()
                    }
                }
                .onSubmit(of: .search, viewModel.searchMovies)
                .navigationTitle("Movie Search")
            
            if viewModel.movies.isEmpty {
                Text("No movies found.")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
}

#Preview {
    MovieSearchView()
}
