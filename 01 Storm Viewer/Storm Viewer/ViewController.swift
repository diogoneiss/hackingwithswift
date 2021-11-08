import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true

        let fileManager = FileManager.default
        let path = Bundle.main.resourcePath!
        for file in try! fileManager.contentsOfDirectory(atPath: path) {
            if !file.hasPrefix("nssl") { continue }

            pictures.append(file)
            pictures.append(file)
            pictures.append(file)
        }

        pictures.sort()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        //cell.textLabel?.text = pictures[indexPath.row] // Will be depricated

        var content = cell.defaultContentConfiguration()
        content.text = pictures[indexPath.row]

        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }

        vc.selectedImage = pictures[indexPath.row]
        //vc.totalImages = pictures.count
        //vc.imageIndex = indexPath.row
        vc.imageTitle = "Picture \(indexPath.row + 1) of \(pictures.count)"
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
