import UIKit

class ViewController: UIViewController {
    // TODO: https://stackoverflow.com/questions/24805180/swift-put-multiple-iboutlets-in-an-array
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!

    var buttons = [UIButton]()

    var countries = [
        "estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria",
        "poland", "russia", "spain", "uk", "us"
    ]
    var score = 0

    func askQuestion() {
        //button1.setImage(UIImage(named: countries[0]), for: .normal)
        //button2.setImage(UIImage(named: countries[1]), for: .normal)
        //button3.setImage(UIImage(named: countries[2]), for: .normal)

        buttons.forEach({ button in
            button.setImage(UIImage(named: countries[0]), for: .normal)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [button1, button2, button3]

        title = "Guess the FREEDOM flag"
        buttons.forEach({ button in
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
        })

        askQuestion()
    }
}
