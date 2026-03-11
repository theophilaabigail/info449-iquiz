import UIKit

class QuizViewController: UIViewController {
    
    private var tableView: UITableView!
    private var quizzes: [Quiz] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupQuizData()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        title = "iQuiz"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped)
        )
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func setupQuizData() {
        quizzes = [
            Quiz(title: "Mathematics", 
                 description: "Test your math skills with these questions",
                 icon: "x.squareroot",
                 questions: [
                    Question(text: "What is 2 + 2?", answers: ["3", "4", "5", "6"], correctAnswerIndex: 1),
                    Question(text: "What is 10 / 2?", answers: ["5", "4", "3", "2"], correctAnswerIndex: 0),
                    Question(text: "What is 3 x 3?", answers: ["6", "9", "12", "15"], correctAnswerIndex: 1)
                 ]),
            Quiz(title: "Marvel Super Heroes",
                 description: "How well do you know the Marvel universe?",
                 icon: "bolt.fill",
                 questions: [
                    Question(text: "Who is Iron Man?", answers: ["Steve Rogers", "Tony Stark", "Bruce Banner", "Peter Parker"], correctAnswerIndex: 1),
                    Question(text: "What is Thor's hammer called?", answers: ["Mjolnir", "Stormbreaker", "Gungnir", "Excalibur"], correctAnswerIndex: 0),
                    Question(text: "What is Captain America's shield made of?", answers: ["Steel", "Titanium", "Vibranium", "Adamantium"], correctAnswerIndex: 2)
                 ]),
            Quiz(title: "Science",
                 description: "Explore the wonders of science",
                 icon: "flask.fill",
                 questions: [
                    Question(text: "What is H2O?", answers: ["Oxygen", "Hydrogen", "Water", "Carbon Dioxide"], correctAnswerIndex: 2),
                    Question(text: "What planet is closest to the Sun?", answers: ["Venus", "Mercury", "Earth", "Mars"], correctAnswerIndex: 1),
                    Question(text: "What is the speed of light?", answers: ["300,000 km/s", "150,000 km/s", "500,000 km/s", "100,000 km/s"], correctAnswerIndex: 0)
                 ])
        ]
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(QuizTableViewCell.self, forCellReuseIdentifier: "QuizCell")
        tableView.rowHeight = 80
        view.addSubview(tableView)
    }
    
    @objc private func settingsButtonTapped() {
        let alert = UIAlertController(
            title: "Settings",
            message: "Settings go here",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension QuizViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as! QuizTableViewCell
        let quiz = quizzes[indexPath.row]
        cell.configure(with: quiz)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let quiz = quizzes[indexPath.row]
        let questionVC = QuestionViewController(quiz: quiz)
        navigationController?.pushViewController(questionVC, animated: true)
    }
}
