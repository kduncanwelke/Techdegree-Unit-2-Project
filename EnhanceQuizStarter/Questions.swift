//
//  Questions.swift
//  EnhanceQuizStarter
//
//  Created by Kate Duncan-Welke on 10/9/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import GameKit

class Question {
    var title: String
    var type: OptionType
    var answers: [String]
    var correctAnswer: Int
    
    enum OptionType {
        case three, four
    }
    
    init(title: String, type: OptionType, answers: [String], correctAnswer: Int) {
        self.title = title
        self.type = type
        self.answers = answers
        self.correctAnswer = correctAnswer
    }
    
    static func shuffleQuestions() -> [Question]? {
        let questions = loadQuestions()
        let shuffledQuestions = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: questions) as? [Question]
        if let returnedArray = shuffledQuestions {
            return returnedArray
        } else {
            return nil
        }
    }
    
    
    static func loadQuestions() -> [Question] {
       return [
            Question(title: "Which breed's proceeds support tiger conservation?",
                     type: .three,
                     answers: ["Bengal","Toyger", "Cheetoh"],
                     correctAnswer: 1
            ),
            Question(title: "Which breed is not hairless?",
                     type: .four,
                     answers: ["Peterbald", "Sphynx", "Donskoy", "Cornish Rex"],
                     correctAnswer: 3
            ),
            Question(title: "Which type of cat has a double coat?",
                     type: .three,
                     answers: ["Russian Blue","Ocicat", "Korat"],
                     correctAnswer: 0
            ),
            Question(title: "This breed was a result of crossing a Serval with a domestic cat.",
                     type: .four,
                     answers: ["Serengeti", "Savannah", "Bengal", "Dragon Li"],
                     correctAnswer: 1
            ),
            Question(title: "Which feature distinguishes the Munchkin breed?",
                     type: .three,
                     answers: ["Large ears", "Small size", "Short legs"],
                     correctAnswer: 2
            ),
            Question(title: "Which feature do the Turkish Van and Turkish Angora not share in common?",
                     type: .three,
                     answers: ["White fur", "Odd-colored eyes", "Love of water"],
                     correctAnswer: 2
            ),
            Question(title: "Which breed evolved without human intervention?",
                     type: .four,
                     answers: ["Siberian Forest Cat", "Ragdoll", "Oriental Shorthair", "Burmilla"],
                     correctAnswer: 0
            ),
            Question(title: "This cat is also known as the Colorpoint Persian.",
                     type: .four,
                     answers: ["Ragamuffin", "Birman", "Javanese", "Himalayan"],
                     correctAnswer: 3
            ),
            Question(title: "Which breed also has a straight-eared version?",
                     type: .three,
                     answers: ["Scottish Fold", "American Curl", "Foldex"],
                     correctAnswer: 0
            ),
            Question(title: "The Thai name for the Thai Cat (aka Traditonal Siamese), wichianmat, means what?",
                     type: .three,
                     answers: ["White Flower", "Moon Diamond", "Blessed Cat"],
                     correctAnswer: 1
            ),
            Question(title: "This breed has a curly hair mutation.",
                     type: .four,
                     answers: ["Somali", "American Curl", "La Perm", "American Wirehair"],
                     correctAnswer: 2
            )
        ]
    }
}

