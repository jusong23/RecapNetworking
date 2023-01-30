//: [Previous](@previous)

import Foundation

enum EncodingError: Error {
    case unknown
    case invaildRange
}

struct Person: Codable {
   var firstName: String
   var lastName: String
   var age: Int
   var address: String? // 값 없으면 nil 출력함
   
   // 대상 속성(address)만 Custom Key Mapping
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case age
        case address = "homeAddress"
    }
}

let jsonStr = """
{
"firstName" : "John",
"age" : 20,
"lastName" : "Doe",
"homeAddress" : "Seoul",
}
"""

guard let jsonData = jsonStr.data(using: .utf8) else {
   fatalError()
}

let decoder = JSONDecoder()

do {
   let p = try decoder.decode(Person.self, from: jsonData)
   dump(p)
} catch {
   print(error)
}



//: [Next](@next)
