//
//  APIService.swift
//  GithubClone
//
//  Created by Soumya Mishra on 16/07/25.
//

import Foundation
import Combine

final class APIService {
    static let shared = APIService()

    /// Fetch Data
    func fetch<T: Decodable>(_ url: String) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: url) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, resp in
                guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { $0 as? NetworkError ?? .decodingError }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
