//
//  GetAPI.swift
//  Networking
//
//  Created by mobile on 2023/01/20.
//  Copyright Β© 2023 Keun young Kim. All rights reserved.
//

import Foundation

class GetAPI_CompletionHandler {
    func sendRequest(completion: @escaping (BookList) -> ()) { // π© model struct name
        let booksUrlStr = "https://kxcoding-study.azurewebsites.net/api/books" // π© url

        // [1st] URL instance μμ±
        guard let url = URL(string: booksUrlStr) else {
            fatalError("Invaild URL")
        }

        // [2nd] Task μμ±(.resume)
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
//                    guard let self = self else { return } // μν μ°Έμ‘° λ°©μ§

            // error: μλ¬μ²λ¦¬
            if let error = error {
//                        self.showErrorAlert(with: error.localizedDescription)
                print(error)
                return
            }

            // response: μλ² μλ΅ μ λ³΄
            guard let httpResponse = response as? HTTPURLResponse else {
//                        self.showErrorAlert(with: "Invalid Response")
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
//                        self.showErrorAlert(with: "\(httpResponse.statusCode)")
                return
            }

            // data: μλ²κ° μ½μ μ μλ Binary λ°μ΄ν°
            guard let data = data else {
                fatalError("Invalid Data")
            }

            do {
                let decoder = JSONDecoder()

                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateStr = try container.decode(String.self)
                    let formatter = ISO8601DateFormatter()
                    formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
                    return formatter.date(from: dateStr)!
                })
                let bookList = try decoder.decode(BookList.self, from: data) // π© model struct name
                
                if bookList.code == 200 {
                    completion(bookList) // β Decodingλ λ°μ΄ν°λ₯Ό Modelμ λ£μ΄μ€
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//                            }
                } else {
//                            self.showErrorAlert(with: bookList.message ?? "Error")
                }

            } catch {
                print(error)
//                        self.showErrorAlert(with: error.localizedDescription)
            }
        }
        task.resume() // suspend μνμ task κΉ¨μ°κΈ°
    }
}

