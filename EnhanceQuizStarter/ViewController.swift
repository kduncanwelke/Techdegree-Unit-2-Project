//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var questionIndex = 0
    
    var gameSound: SystemSoundID = 0
    
    // load set of shuffled questions
    var shuffledQuestions = Question.shuffleQuestions()

    
    // MARK: - Outlets
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBOutlet weak var threeItemStackView: UIStackView!
    @IBOutlet weak var firstButton3: UIButton!
    @IBOutlet weak var secondButton3: UIButton!
    @IBOutlet weak var thirdButton3: UIButton!
    
    @IBOutlet weak var fourItemStackView: UIStackView!
    @IBOutlet weak var firstButton4: UIButton!
    @IBOutlet weak var secondButton4: UIButton!
    @IBOutlet weak var thirdButton4: UIButton!
    @IBOutlet weak var fourthButton4: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction func submitAnswer0(_ sender: UIButton) {
        let result = checkAnswer(chosenAnswer: 0)
        checkResult(result: result, sender: sender)
    }
    
    @IBAction func submitAnswer1(_ sender: UIButton) {
        let result = checkAnswer(chosenAnswer: 1)
        checkResult(result: result, sender: sender)
    }
    
    @IBAction func submitAnswer2(_ sender: UIButton) {
        let result = checkAnswer(chosenAnswer: 2)
        checkResult(result: result, sender: sender)
    }
    
    @IBAction func submitAnswer3(_ sender: UIButton) {
        let result = checkAnswer(chosenAnswer: 3)
        checkResult(result: result, sender: sender)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGameStartSound()
        playGameStartSound()
        
        displayQuestion()
        
    }
    
    // MARK: - Helpers
    
    func loadGameStartSound() {
        let path = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func updateThreeStack(currentQuestion: Question) {
        firstButton3.setTitle(currentQuestion.answers[0], for: .normal)
        secondButton3.setTitle(currentQuestion.answers[1], for: .normal)
        thirdButton3.setTitle(currentQuestion.answers[2], for: .normal)
    }
    
    func updateFourStack(currentQuestion: Question) {
        firstButton4.setTitle(currentQuestion.answers[0], for: .normal)
        secondButton4.setTitle(currentQuestion.answers[1], for: .normal)
        thirdButton4.setTitle(currentQuestion.answers[2], for: .normal)
        fourthButton4.setTitle(currentQuestion.answers[3], for: .normal)
    }
    
    func displayQuestion() {
        
        if let questionsArray = shuffledQuestions {
            var currentQuestion = questionsArray[questionIndex]
            
            func loadButtons() {
                switch currentQuestion.type {
                case .three:
                    threeItemStackView.isHidden = false
                    fourItemStackView.isHidden = true
                    updateThreeStack(currentQuestion: currentQuestion)
                case .four:
                    fourItemStackView.isHidden = false
                    threeItemStackView.isHidden = true
                    updateFourStack(currentQuestion: currentQuestion)
                }
            }
            
            loadButtons()
            questionField.text = currentQuestion.title
            playAgainButton.isHidden = true
            
        }

    }
    
    func displayScore() {
        // Hide the answer buttons
  
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            
            // hide stack views
            threeItemStackView.isHidden = true
            fourItemStackView.isHidden = true
            
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
        resetButtons()
    }
    
    func loadNextRound(delay seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func resetButtons() {
    // reset button backgrounds
        firstButton3.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.69, alpha:1.0)
        secondButton3.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.69, alpha:1.0)
        thirdButton3.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.69, alpha:1.0)
        firstButton4.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.69, alpha:1.0)
        secondButton4.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.69, alpha:1.0)
        thirdButton4.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.69, alpha:1.0)
        fourthButton4.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.69, alpha:1.0)
    }
    
    // MARK: - Actions
    
    func checkAnswer(chosenAnswer: Int) -> Bool {
        // Increment the questions asked counter
        questionsAsked += 1
        
        guard let questionsArray = shuffledQuestions else { return false }
            let currentQuestion = questionsArray[questionIndex]
        
            // compare chosen answer to correct answer, return bool
            if chosenAnswer == currentQuestion.correctAnswer {
                correctQuestions += 1
                return true
            } else {
                return false
            }
    }
    
    // use bool returned from checkAnswer to display colors to indicate right/wrong answer
    func checkResult(result: Bool, sender: UIButton) {
        if result {
            // if answer was right, change button background to green
            sender.backgroundColor = UIColor(red:0.24, green:0.69, blue:0.33, alpha:1.0)
        } else {
            // if answer was wrong, change button background to red
            sender.backgroundColor = UIColor(red:0.69, green:0.28, blue:0.24, alpha:1.0)
            
            // get current question and current answer to then change correct answer button to green
            guard let questionsArray = shuffledQuestions else { return }
            let currentQuestion = questionsArray[questionIndex]
            let rightAnswer = currentQuestion.correctAnswer
            
            // if three-item stack view is in use, change correct answer button there to green
            if threeItemStackView.isHidden == false {
                switch rightAnswer {
                case 0: firstButton3.backgroundColor = UIColor(red:0.24, green:0.69, blue:0.33, alpha:1.0)
                case 1: secondButton3.backgroundColor = UIColor(red:0.24, green:0.69, blue:0.33, alpha:1.0)
                case 2: thirdButton3.backgroundColor = UIColor(red:0.24, green:0.69, blue:0.33, alpha:1.0)
                default: break
                }
                // if four-item stack view is in use, change correct answer button there to green
            } else {
                switch rightAnswer {
                case 0: firstButton4.backgroundColor = UIColor(red:0.24, green:0.69, blue:0.33, alpha:1.0)
                case 1: secondButton4.backgroundColor = UIColor(red:0.24, green:0.69, blue:0.33, alpha:1.0)
                case 2: thirdButton4.backgroundColor = UIColor(red:0.24, green:0.69, blue:0.33, alpha:1.0)
                case 3: fourthButton4.backgroundColor = UIColor(red:0.24, green:0.69, blue:0.33, alpha:1.0)
                default: break
                }
            }
        }
        // increase questionIndex to move on to next question
        questionIndex += 1
        loadNextRound(delay: 2)
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    

}

