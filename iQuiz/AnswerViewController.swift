import UIKit

protocol AnswerViewControllerDelegate: AnyObject {
    func didTapNext()
}

class AnswerViewController: UIViewController {
    
    private let question: Question
    private let userAnswerIndex: Int
    private let isCorrect: Bool
    weak var delegate: AnswerViewControllerDelegate?
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let correctAnswerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let gestureHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Swipe left to quit • Swipe right for next"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(question: Question, userAnswerIndex: Int, isCorrect: Bool) {
        self.question = question
        self.userAnswerIndex = userAnswerIndex
        self.isCorrect = isCorrect
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupGestures()
        displayResult()
    }
    
    private func setupViews() {
        view.addSubview(questionLabel)
        view.addSubview(resultLabel)
        view.addSubview(correctAnswerLabel)
        view.addSubview(nextButton)
        view.addSubview(gestureHintLabel)
        
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resultLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 40),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            correctAnswerLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 30),
            correctAnswerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            correctAnswerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nextButton.topAnchor.constraint(equalTo: correctAnswerLabel.bottomAnchor, constant: 40),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            
            gestureHintLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            gestureHintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gestureHintLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    private func displayResult() {
        questionLabel.text = question.text
        
        if isCorrect {
            resultLabel.text = "Correct!"
            resultLabel.textColor = .systemGreen
        } else {
            resultLabel.text = "Wrong"
            resultLabel.textColor = .systemRed
        }
        
        correctAnswerLabel.text = "Correct answer: \(question.answers[question.correctAnswerIndex])"
    }
    
    @objc private func nextTapped() {
        delegate?.didTapNext()
    }
    
    @objc private func handleSwipeRight() {
        nextTapped()
    }
    
    @objc private func handleSwipeLeft() {
        navigationController?.popToRootViewController(animated: true)
    }
}
