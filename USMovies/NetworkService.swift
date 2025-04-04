
//
//  NetworkService.swift
//  USMovies
//
//  Created by Abhilash Ghogale on 31/03/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func execute<T: Codable>(endpoint: Endpoint) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    private init() {}

    func execute<T>(endpoint: any Endpoint) async throws -> T where T : Decodable, T : Encodable {
        guard let url = endpoint.url else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            debugPrint(response.description)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}

// MARK: - HTTP Method Enum
enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

// MARK: - Endpoint Protocol
protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
}

extension Endpoint {
    var baseURL: String {  "https://api.themoviedb.org/3" }
    
    var url: URL? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
    
    var headers: [String: String] {
        [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMDRjZDZiNGRkM2ZjOTU5OWJmZDNlZGM4NTk5NGIyYiIsIm5iZiI6MTY5MDYwNTI0OC4xNDEsInN1YiI6IjY0YzQ5NmMwZWVjNWI1MDBjNWYxMjg3ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.wExEQ-h06rpKpFtt_GYD-4jfHF_kkAvnmq0yOu2T_lc"
        ]
    }
}

// MARK: - Network Error
  enum NetworkError: Error {
      case invalidURL
      case requestFailed(Error)
      case invalidResponse
      case decodingError(Error)
  }
