//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

class SessionDelegateTableViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    var session: URLSession!

    // Code Input Point #3
    var buffer: Data?
    // Code Input Point #3

    @IBAction func sendReqeust(_ sender: Any) {
        guard let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/books/3") else {
            fatalError("Invalid URL")
        }

        // Code Input Point #1
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        // 본 ViewController가 Delegate로 설정 (URLSession이 혼자서는 못하는 역할을 위임받음)

        buffer = Data() // 인스턴스 저장

        let task = session.dataTask(with: url) // completion handler 없는거 사용(URLSessionDelegate)
        task.resume()
        // Code Input Point #1
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Code Input Point #6
        // session.finishTasksAndInvalidate() // 종료될 때 까지 기다렸다가 리소스 정리
        session?.invalidateAndCancel() // 바로 리소스 정리하고 실행중인 Task 취소 - 뷰 벗어날 때 종료하기 위함
        // URLSession <-> Delegate가 서로를 참조(강한참조 발생)
        // Code Input Point #6
    }
}

// Code Input Point #2
extension SessionDelegateTableViewController: URLSessionDataDelegate {
    // response: 성공 시 allow
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            completionHandler(.cancel)
            return
        }

        completionHandler(.allow)
    }

    // data: 전달된 데이터 누적 & 요청 시 초기화
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer?.append(data)
    }

    // error: 에러 처리
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            showErrorAlert(with: error.localizedDescription)
        } else {
            parse() // 성공 시에 Parsing
        }
    }
}
// Code Input Point #2

extension SessionDelegateTableViewController {
    func parse() {
        // Code Input Point #4
        guard let data = buffer else {
            fatalError("Invalid Error")
        }
        // Code Input Point #4

        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
            return formatter.date(from: dateStr)!
        })

        // Code Input Point #5
        do {
            let bookDetail = try decoder.decode(BookDetail.self, from: data)

            // JSON 중 iso형식의 데이터가 있는 경우

            if bookDetail.code == 200 {
                titleLabel.text = bookDetail.book.title // Decoding된 데이터를 본격적으로 사용
                descLabel.text = bookDetail.book.description
                tableView.reloadData()
            } else {
                self.showErrorAlert(with: bookDetail.message ?? "Error")
            }

        } catch {
            print(error)
            self.showErrorAlert(with: error.localizedDescription)
        }
        // Code Input Point #5
    }
}
