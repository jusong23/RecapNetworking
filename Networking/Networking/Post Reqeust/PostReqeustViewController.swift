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

struct PostData: Codable {
   let a: Int
   let b: Int
   let op: String
}

class PostReqeustViewController: UIViewController {
   
   @IBOutlet weak var leftField: UITextField!
   @IBOutlet weak var rightField: UITextField!
   
   func encodedData() -> Data? {
      guard let leftStr = leftField.text, let a = Int(leftStr) else {
         showErrorAlert(with: "Please input only the number.")
         return nil
      }
      
      guard let rightStr = rightField.text, let b = Int(rightStr) else {
         showErrorAlert(with: "Please input only the number.")
         return nil
      }
      
      let data = PostData(a: a, b: b, op: "+")
      
      let encoder = JSONEncoder()
      return try? encoder.encode(data)
   }
   
   @IBAction func sendPostRequest(_ sender: Any) {
      guard let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/calc") else {
         fatalError("Invalid URL")
      }
      
      // Code Input Point #1
       var request = URLRequest(url: url)
       
       request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       // 서버가 json 데이터만 받도록 고정되어있으므로 위와 같이 헤더 설정 (서버: form-data 형태로는 못 받는 상태)
       request.httpMethod = "POST"
       request.httpBody = encodedData()
       
       let task = URLSession.shared.dataTask(with:  request) { (data, response, error) in
           if let error = error {
               self.showErrorAlert(with: error.localizedDescription)
               print(error)
               return
           }
           
           guard let httpResponse = response as? HTTPURLResponse else {
               self.showErrorAlert(with: "Invalid Response")
               return
           }
           
           guard (200...299).contains(httpResponse.statusCode) else {
               self.showErrorAlert(with: "\(httpResponse.statusCode)")
               return
           }
           
           guard let data = data, let str = String(data: data, encoding: .utf8) else {
               fatalError("Invalid Data")
           }
           
           self.showInfoAlert(with: str)
       }
       task.resume()
      // Code Input Point #1
   }
}
