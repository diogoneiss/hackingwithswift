import UIKit

class ViewController: UIViewController {
    let labels: [(text: String, color: UIColor)] = [
        ("THESE", .red),
        ("ARE", .red),
        ("SOME", .red),
        ("AWESOME", .red),
        ("LABELS", .red),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        var uiLabels = [UILabel]()
        var viewsDictionary = [String: UILabel]()

        labels.enumerated().forEach { (id, labelProps) in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = labelProps.color
            label.text = labelProps.text
            label.sizeToFit()

            uiLabels.append(label)

            let textId = "label" + String(id + 1)
            viewsDictionary[textId] = label

            view.addSubview(label)
        }

        viewsDictionary.keys.forEach { label in
            view.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[\(label)]|",
                options: [],
                metrics: nil,
                views: viewsDictionary
            ))
        }

        //view.addConstraints(NSLayoutConstraint.constraints(
        //    withVisualFormat: "V:|[label1]-[label2]-[label3]-[label4]-[label5]",
        //    options: [],
        //    metrics: nil,
        //    views: viewsDictionary
        //))

        //view.addConstraints(NSLayoutConstraint.constraints(
            //withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|",
            //options: [],
            //metrics: ["labelHeight": 80],
            //views: viewsDictionary
        //))

        var previous: UILabel?

        for label in uiLabels {
            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 88).isActive = true

            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }

            previous = label
        }
    }
}
