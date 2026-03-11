import UIKit

class QuestionViewController: UIViewController {
    
    private let quiz: Quiz
    private var currentQuestionIndex = 0
    private var score = 0
    private var selectedAnswerIndex: Int?
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let answerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let gestureHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Swipe left to quit • Swipe right to submit"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(quiz: Quiz) {
        self.quiz = quiz
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = quiz.title
        setupViews()
        setupGestures()
        loadQuestion()
    }
    
    private func setupViews() {
        view.addSubview(questionLabel)
        view.addSubview(answerStackView)
        view.addSubview(submitButton)
        view.addSubview(gestureHintLabel)
        
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            answerStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 40),
            answerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            submitButton.topAnchor.constraint(equalTo: answerStackView.bottomAnchor, constant: 40),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
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
    
    private func loadQuestion() {
        let question = quiz.questions[currentQuestionIndex]
        questionLabel.text = question.text
        selectedAnswerIndex = nil
        
        answerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, answer) in question.answers.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(answer, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16)
            button.contentHorizontalAlignment = .left
            button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.layer.cornerRadius = 8
            button.tag = index
            button.addTarget(self, action: #selector(answerSelected(_:)), for: .touchUpInside)
            answerStackView.addArrangedSubview(button)
        }
    }
    
    @objc private func answerSelected(_ sender: UIButton) {
        answerStackView.arrangedSubviews.forEach { view in
            if let button = view as? UIButton {
                button.backgroundColor = .systemBackground
                button.layer.borderColor = UIColor.systemGray4.cgColor
            }
        }
        
        sender.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        sender.layer.borderColor = UIColor.systemBlue.cgColor
        selectedAnswerIndex = sender.tag
    }
    
    @objc private func submitTapped() {
        guard let selectedAnswerIndex = selectedAnswerIndex else {
            let alert = UIAlertController(title: "No Answer Selected", message: "Please select an answer", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let question = quiz.questions[currentQuestionIndex]
        let isCorrect = selectedAnswerIndex == question.correctAnswerIndex
        if isCorrect {
            score += 1
        }
        
        let answerVC = AnswerViewController(
            question: question,
            userAnswerIndex: selectedAnswerIndex,
            isCorrect: isCorrect
        )
        answerVC.delegate = self
        navigationController?.pushViewController(answerVC, animated: true)
    }
    
    @objc private func handleSwipeRight() {
        submitTapped()
    }
    
    @objc private func handleSwipeLeft() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension QuestionViewController: AnswerViewControllerDelegate {
    func didTapNext() {
        currentQuestionIndex += 1
        
        if currentQuestionIndex < quiz.questions.count {
            navigationController?.popViewController(animated: false)
            loadQuestion()
        } else {
            let finishedVC = FinishedViewController(score: score, total: quiz.questions.count)
            navigationController?.pushViewController(finishedVC, animated: true)
        }
    }
}
