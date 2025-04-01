//
//  MovieView.swift
//  USMovies
//
//  Created by Abhilash Ghogale on 31/03/25.
//

import SwiftUI
import AsynLib

struct MovieView: View {
    
    var movie: Movie
    
    var body: some View {
        HStack {
            AsyncImageLoader(url: URL(string: movie.getThumbnailUrl())) { image in
                image
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 100, height: 150)
            
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.release_date ?? "")
            }
            .padding(5)
        }
    }
}
