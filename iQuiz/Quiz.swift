import Foundation

struct Quiz {
    let title: String
    let description: String
    let icon: String
    let questions: [Question]
}

struct Question {
    let text: String
    let answers: [String]
    let correctAnswerIndex: Int
}
