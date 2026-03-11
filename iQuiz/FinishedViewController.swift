import UIKit

class FinishedViewController: UIViewController {
    
    private let score: Int
    private let total: Int
    
    private let performanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let finishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Finish", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(score: Int, total: Int) {
        self.score = score
        self.total = total
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Results"
        navigationItem.hidesBackButton = true
        setupViews()
        displayResults()
    }
    
    private func setupViews() {
        view.addSubview(performanceLabel)
        view.addSubview(scoreLabel)
        view.addSubview(finishButton)
        
        finishButton.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            performanceLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            performanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            performanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            scoreLabel.topAnchor.constraint(equalTo: performanceLabel.bottomAnchor, constant: 20),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            finishButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 40),
            finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finishButton.widthAnchor.constraint(equalToConstant: 200),
            finishButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func displayResults() {
        let percentage = Double(score) / Double(total)
        
        if percentage == 1.0 {
            performanceLabel.text = "Perfect!"
        } else if percentage >= 0.8 {
            performanceLabel.text = "Almost!"
        } else if percentage >= 0.5 {
            performanceLabel.text = "Not Bad!"
        } else {
            performanceLabel.text = "Keep Trying!"
        }
        
        scoreLabel.text = "\(score) of \(total) correct"
    }
    
    @objc private func finishTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
