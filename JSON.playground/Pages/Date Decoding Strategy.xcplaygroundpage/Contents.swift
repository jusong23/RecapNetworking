//: [Previous](@previous)

import Foundation

struct Product: Codable {
   var name: String
   var releaseDate: Date
}

let jsonStr = """
{
"name" : "iPad Pro",
"releaseDate" : "2018-10-30T23:00:00Z"
}
""" // iso8601 형식으로 저장되어있는 문자열 -> 이에 따른 디코딩 전략 변경

guard let jsonData = jsonStr.data(using: .utf8) else {
   fatalError()
}

let decoder = JSONDecoder()

//
//decoder.dateDecodingStrategy = .iso8601
//

do {
   let p = try decoder.decode(Product.self, from: jsonData)
   dump(p)
} catch {
   print(error)
}



//: [Next](@next)

