import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let fileManager = FileManager.default
        let path = Bundle.main.resourcePath!
        for file in try! fileManager.contentsOfDirectory(atPath: path) {
            if !file.hasPrefix("nssl") { continue }

            pictures.append(file)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        // cell.textLabel?.text = pictures[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = pictures[indexPath.row]

        cell.contentConfiguration = content
        return cell
    }
}
