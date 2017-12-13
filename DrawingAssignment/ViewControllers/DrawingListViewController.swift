//
//  DrawingListViewController.swift
//  DrawingAssignment
//
//  Created by Ofir Ron on 14/12/2017.
//  Copyright © 2017 Ofir Ron. All rights reserved.
//

import UIKit

final class DrawingListViewController: BaseViewController {

    // MARK: - Outlets

    /// Table view for showing the list of drawing
    @IBOutlet weak var tableView: UITableView!
   
    // MARK: - Variables
    
    /// The table data (of drawings)
    fileprivate var data = [DrawingItem]()
    /// date formatter
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Consts.dateFormat
        return formatter
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = DrawingItemCell.nib()
        tableView.register(nib, forCellReuseIdentifier: Consts.CellIdentifiers.common)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    // MARK: -  Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, identifier == Consts.Segues.edit, let drawingVC = segue.destination as? DrawingViewController, let drawingItem = sender as? DrawingItem else { return }
        drawingVC.drawingItem = drawingItem
    }
}

// MARK: -
// MARK: - Private
// MARK: -

// MARK: - Data
private extension DrawingListViewController {
    
    /// Get drawings list
    private func getData() {
        showSpinner()
        DispatchQueue.main.async { [weak self] in
            Facade.shared.loadDrawings(success: { [weak self] (items) in
                self?.data = items
                self?.tableView.reloadData()
                self?.hideSpinner()
            }) { [weak self] (error) in
                self?.hideSpinner()
                Alert().showFailureAlert(error, on: self)
            }
        }
    }
    
}

// MARK: -

// MARK: -
// MARK: - Delegates
// MARK: -

// MARK: - UITableViewDelegate
extension DrawingListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let drawingItem = data[indexPath.row]
        performSegue(withIdentifier: Consts.Segues.edit, sender: drawingItem)
    }
    
}

// MARK: - UITableViewDataSource
extension DrawingListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Consts.CellIdentifiers.common, for: indexPath) as! DrawingItemCell
        cell.createDateLabel.text = dateFormatter.string(from: item.creatingDate)
        if let lastEditDate = item.lastEditDate {
            cell.editDateLabel.text = dateFormatter.string(from: lastEditDate)
        } else {
            cell.editDateLabel.text = NSLocalizedString("listCell.edit.never", comment: "")
        }
        cell.thumbnailImageView.image = Facade.shared.getThumbnail(for: item)
        return cell
    }
}

// MARK: -
