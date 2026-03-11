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
                 icon: "x.squareroot"),
            Quiz(title: "Marvel Super Heroes",
                 description: "How well do you know the Marvel universe?",
                 icon: "bolt.fill"),
            Quiz(title: "Science",
                 description: "Explore the wonders of science",
                 icon: "flask.fill")
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
    }
}
