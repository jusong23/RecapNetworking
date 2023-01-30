//
//  GetAPI.swift
//  Networking
//
//  Created by mobile on 2023/01/20.
//  Copyright © 2023 Keun young Kim. All rights reserved.
//

import Foundation

class GetAPI_CompletionHandler {
    func sendRequest(completion: @escaping (BookList) -> ()) { // 🔩 model struct name
        let booksUrlStr = "https://kxcoding-study.azurewebsites.net/api/books" // 🔩 url

        // [1st] URL instance 작성
        guard let url = URL(string: booksUrlStr) else {
            fatalError("Invaild URL")
        }

        // [2nd] Task 작성(.resume)
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
//                    guard let self = self else { return } // 순환 참조 방지

            // error: 에러처리
            if let error = error {
//                        self.showErrorAlert(with: error.localizedDescription)
                print(error)
                return
            }

            // response: 서버 응답 정보
            guard let httpResponse = response as? HTTPURLResponse else {
//                        self.showErrorAlert(with: "Invalid Response")
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
//                        self.showErrorAlert(with: "\(httpResponse.statusCode)")
                return
            }

            // data: 서버가 읽을 수 있는 Binary 데이터
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
                let bookList = try decoder.decode(BookList.self, from: data) // 🔩 model struct name
                
                if bookList.code == 200 {
                    completion(bookList) // ✅ Decoding된 데이터를 Model에 넣어줌
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
        task.resume() // suspend 상태의 task 깨우기
    }
}

