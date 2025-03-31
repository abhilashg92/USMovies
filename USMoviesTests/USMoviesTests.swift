//
//  USMoviesTests.swift
//  USMoviesTests
//
//  Created by Abhilash Ghogale on 31/03/25.
//

import XCTest
@testable import USMovies

final class USMoviesTests: XCTestCase {

    var mockService: MockMovieService?
    var viewModel: MoviesViewModel?
    
    let mocMovies = [Movie(id: 0, title: "Test1", overview: "Overview1", posterPath: "path1", release_date: ""),
                     Movie(id: 1, title: "Test2", overview: "Info 2", posterPath: "path2", release_date: "")]

    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try? super.setUpWithError()
        mockService = MockMovieService(movies: mocMovies)
        viewModel =  MoviesViewModel(useCase: self.mockService ?? MockMovieService())
    }
    
    func testSearchMovies_Success() async {
        
        viewModel?.query = "Test"
        await viewModel?.searchMovies()
        
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.3 seconds delay
        
            XCTAssertEqual(viewModel?.movies.count, 2)
            XCTAssertEqual(viewModel?.movies.first?.title, "Test1")
            XCTAssertNil(viewModel?.errorMessage)
            XCTAssertFalse(viewModel?.isLoading ?? false)
        
    }
    
    func testSearchMovies_EmptyQuery() async {

        viewModel?.query = ""
        await viewModel?.searchMovies()
        
        XCTAssertTrue(viewModel?.movies.isEmpty ?? true)
        XCTAssertNil(viewModel?.errorMessage)
    }
    
    func testSearchMovies_Failure() async {
        let mockService = MockMovieService(error: NSError(domain: "TestError", code: -1, userInfo: nil))
        let viewModel = MoviesViewModel(useCase: mockService)

        viewModel.query = "Test"
        await viewModel.searchMovies()
        
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.3 seconds delay

        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func testCancelSearch() async {
        viewModel?.query = "Test"
        viewModel?.movies = [Movie(id: 1, title: "Test Movie", overview: "Test Overview", posterPath: "path", release_date: "")]
        
        await MainActor.run {
            viewModel?.cancelSearch()
            
            XCTAssertEqual(viewModel?.query, "")
            XCTAssertTrue(viewModel?.movies.isEmpty ?? true)
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        mockService = nil
        viewModel = nil
    }


}

class MockMovieService: MovieServiceProtocol {
    func searchMovies(query: String, page: Int) async throws -> [Movie] {
        if let error = error {
            throw error
        }
        return movies
    }
    
    private let movies: [Movie]
    private let error: Error?
    
    init(movies: [Movie] = [], error: Error? = nil) {
        self.movies = movies
        self.error = error
    }
    
}
