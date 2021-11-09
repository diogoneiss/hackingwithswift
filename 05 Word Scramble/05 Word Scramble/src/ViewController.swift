import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))

        guard let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") else {
            allWords = ["異世界"]
            return
        }
        guard let startWords = try? String(contentsOf: startWordsURL) else { return }

        allWords = startWords.components(separatedBy: "\n").filter { !$0.isEmpty }

        startGame()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        // cell.textLabel?.text = usedWords[indexPath.row]
        var cellContent = cell.contentConfiguration as? UIListContentConfiguration ?? cell.defaultContentConfiguration()
        cellContent.text = usedWords[indexPath.row]

        cell.contentConfiguration = cellContent

        return cell
    }

    @objc func promptForAnswer() {
        let alertController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        alertController.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] _ in
            guard let answer = alertController?.textFields?[0].text else { return }
            self?.submit(answer)
        }

        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }

    func submit(_ answer: String) {
        let answer = answer.lowercased()

        //if isPossible(word: answer) && isOriginal(word: answer) && isReal(word: answer) {
            //usedWords.insert(answer, at: 0)

            //let indexPath = IndexPath(row: 0, section: 0)
            //tableView.insertRows(at: [indexPath], with: .automatic)
        //}

        let errorTitle: String
        let errorMessage: String

        if isPossible(word: answer) {
            if isOriginal(word: answer) {
                if isReal(word: answer) {
                    usedWords.insert(answer, at: 0)

                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)

                    return
                } else {
                    errorTitle = "Word not recognized"
                    errorMessage = "You can't just make them up you know"
                }
            } else {
                errorTitle = "Word used already!"
                errorMessage = "Be more original!"
            }
        } else {
            guard let title = title?.lowercased() else { return }
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title)"
        }

        let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
    }

    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }

        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }

        return true
    }

    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }

    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
}
