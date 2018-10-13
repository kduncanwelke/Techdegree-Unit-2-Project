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
    var missedQuestions = 0
    
    // load set of shuffled questions
    var shuffledQuestions = Question.shuffleQuestions()
    
    // timer properties
    var seconds = 15
    var timer = Timer()
    var isTimerOn = false

    
    // MARK: - Outlets
    
    @IBOutlet weak var timeLeftLabel: UILabel!
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load audio files
        Sound.loadSound(resourceName: gameSound.resourceName, type: gameSound.type, number: &gameSound.number)
        Sound.loadSound(resourceName: wrongSound.resourceName, type: wrongSound.type, number: &wrongSound.number)
        Sound.loadSound(resourceName: rightSound.resourceName, type: rightSound.type, number: &rightSound.number)
        Sound.loadSound(resourceName: endSound.resourceName, type: endSound.type, number: &endSound.number)
        
        // play game start sound
        Sound.playSound(number: gameSound.number)
        
        // update UI with question
        displayQuestion()
    }
    
    
    // MARK: - UI Updates
    
    // update stack view of three buttons
    func updateThreeStack(currentQuestion: Question) {
        firstButton3.setTitle(currentQuestion.answers[0], for: .normal)
        secondButton3.setTitle(currentQuestion.answers[1], for: .normal)
        thirdButton3.setTitle(currentQuestion.answers[2], for: .normal)
    }
    
    // update stack view of four buttons
    func updateFourStack(currentQuestion: Question) {
        firstButton4.setTitle(currentQuestion.answers[0], for: .normal)
        secondButton4.setTitle(currentQuestion.answers[1], for: .normal)
        thirdButton4.setTitle(currentQuestion.answers[2], for: .normal)
        fourthButton4.setTitle(currentQuestion.answers[3], for: .normal)
    }
    
    // show individual question
    func displayQuestion() {
        if let questionsArray = shuffledQuestions {
            let currentQuestion = questionsArray[questionIndex]
            
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
            
            // make sure timer label is displayed, then run timer
            timeLeftLabel.isHidden = false
            timeLeftLabel.text = "\(seconds)"
            runTimer() // start timer for question
            
            questionField.text = currentQuestion.title
            playAgainButton.isHidden = true
        }
    }
    
    
    // use bool returned from checkAnswer to display colors to indicate right/wrong answer
    func checkResult(result: Bool, sender: UIButton) {
        if result {
            // if answer was right, change button background to green and play right sound
            Sound.playSound(number: rightSound.number)
            
            sender.backgroundColor = UIColor(red:0.24, green:0.69, blue:0.33, alpha:1.0)
        } else {
            // if answer was wrong, change button background to red and play wrong sound
            sender.backgroundColor = UIColor(red:0.69, green:0.28, blue:0.24, alpha:1.0)
            
            Sound.playSound(number: wrongSound.number)
            showCorrectAnswer() // then show correct answer
        }
        // increase questionIndex to move on to next question
        questionIndex += 1
        loadNextRound(delay: 2)
    }
    
    
    func showCorrectAnswer() {
        // get current question and current answer to then indicate correct answer
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
    
    
    // show score at end of game
    func displayScore() {
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct! You missed \(missedQuestions) question(s)."
        
        // shuffle questions again at new round
        shuffledQuestions = Question.shuffleQuestions()
    }
    
    
    func resetButtons() {
    // reset button backgrounds to wipe correct/incorrect color indicators
        firstButton3.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.69, alpha:1.0)
        secondButton3.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.69, alpha:1.0)
        thirdButton3.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.69, alpha:1.0)
        firstButton4.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.69, alpha:1.0)
        secondButton4.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.69, alpha:1.0)
        thirdButton4.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.69, alpha:1.0)
        fourthButton4.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.69, alpha:1.0)
    }
    
    
    // MARK: - Custom functions
    
    // function for when timer is running
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    // run while timer is active
    @objc func updateTimer() {
        seconds -= 1
        timeLeftLabel.text = "\(seconds)"
        
        // if time runs out reset timer, display correct answer, load next round
        if seconds == 0 {
            timer.invalidate()
            timeLeftLabel.text = "You ran out of time!"
            showCorrectAnswer()
            
            missedQuestions += 1
            questionsAsked += 1
            questionIndex += 1
            
            loadNextRound(delay: 2)
            seconds = 15
        }
    }
    
    // stop timer when answer is selected, hide label during feedback and reset counter
    func hideTimer() {
        timer.invalidate()
        timeLeftLabel.isHidden = true
        seconds = 15
    }
    
    
    // proceed to next round or end of game
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            
            // hide stack views
            threeItemStackView.isHidden = true
            fourItemStackView.isHidden = true
            
            Sound.playSound(number: endSound.number)
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
        // reset all button colors at end of round
        resetButtons()
    }
    
    // load round
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
    
    
    // run when button is selected
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
    
    
    // MARK: - Actions
    
    // action for buttons, passing result to check correctness and hiding timer
    @IBAction func submit(_ sender: UIButton) {
        let result = checkAnswer(chosenAnswer: sender.tag)
        checkResult(result: result, sender: sender)
        hideTimer()
    }
    
    // start new game when play again is pressed, resetting counter values for questions
    @IBAction func playAgain(_ sender: UIButton) {
        questionsAsked = 0
        correctQuestions = 0
        missedQuestions = 0
        questionIndex = 0
        nextRound()
        
        // play game start sound again
        Sound.playSound(number: gameSound.number)
    }

}

