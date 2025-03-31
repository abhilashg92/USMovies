//
//  MovieView.swift
//  USMovies
//
//  Created by Abhilash Ghogale on 31/03/25.
//

import SwiftUI

struct MovieView: View {
    
    var movie: Movie
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: movie.getThumbnailUrl())) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 150)
            .background(Color.gray)
            
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.release_date ?? "")
            }
            .padding(5)
        }
    }
}
