import UIKit

class ViewController: UITableViewController {

    let folders = generateRandomData()
    let expenses = [
        Section(title: "Section 1", items: ["One", "Two", "Three"]),
        Section(title: "Section 2", items: ["One", "Two", "Three"]),
        Section(title: "Section 3", items: ["One"]),
        Section(title: "Section 4", items: ["One", "Two", "Three", "Four", "Five"])
        
    ]
    var storedOffsets = [Int: CGFloat]()
    
    override func viewDidLoad() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100))
        view.backgroundColor = .lightGray
        
        let labels = self.expenses.enumerated().map { (index, section) -> UILabel in
            let label = UILabel()
            label.text = section.title
            label.tag = index + 1
            label.textAlignment = NSTextAlignment.center
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(sender:)))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tap)
            
            return label
        }
        
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        self.tableView.tableHeaderView = view
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + expenses.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return folders.count
        } else {
            return expenses[section - 1].items.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
            
            cell.textLabel?.text = expenses[indexPath.section - 1].items[indexPath.row]
            
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? TableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? TableViewCell else { return }

        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section != 0 else {
            return nil
        }
        
        return expenses[section - 1].title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func labelTapped(sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else {
            return
        }
        
        let indexPath = IndexPath(row: 0, section: section)
        
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folders[collectionView.tag].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        cell.backgroundColor = folders[collectionView.tag][indexPath.item]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}
