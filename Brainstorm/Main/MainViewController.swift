//
//  ViewController.swift
//  Brainstorm

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController()
    private var segmentControl: UISegmentedControl!
    private var data = [Results]()
    private var filteredData = [Results]()
    private var savedUserData = [Results]()
    private var isFiltering: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return searchController.isActive && !text.isEmpty
    }
    private lazy var mainViewModel = MainViewModel()
    private var pageCounter: (extPage:Int, localPage:Int) = (1, 1)
    private var isLoading:Bool = false{
        didSet{
            self.tableView.tableFooterView = isLoading ? createSpiner() : UIView()
            if !isLoading {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UsersTableViewCell", bundle: nil), forCellReuseIdentifier: UsersTableViewCell.identifier)
        
        initSearchController()
        
        //MARK: Read data from external server
        getUserList()
        
        //MARK: Read data from local DB
        LocalDataViewModel.shared.readValues(saved: &savedUserData)
    }
    
    func getUserList(page:Int = 1){
        
        self.mainViewModel.page = page
        self.mainViewModel.bindMainViewModelToController = {
            self.tableView.tableFooterView = UIView()
            self.data += self.mainViewModel.data
            self.isLoading = false
        }
    }
    
    func initSearchController()
    {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let titles = ["Users", "Saved Users"]
        segmentControl = UISegmentedControl(items: titles)
        segmentControl.tintColor = UIColor.white
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.sendActions(for: .valueChanged)
        navigationItem.titleView = segmentControl
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for index in 0...1 {
            segmentControl.setWidth(UIScreen.main.bounds.width/2-24, forSegmentAt: index)
        }
        segmentControl.sizeToFit()
    }
    
    private var currentSegmentData:[Results] {
        return segmentControl?.selectedSegmentIndex == 0 ? data : savedUserData
    }
    
    private var currentData:[Results] {
        if isFiltering {
            return filteredData
        }
        
        return currentSegmentData
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        pageCounter.localPage = 1
        self.tableView.reloadData()
        self.isLoading = false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as? UsersTableViewCell else {return UITableViewCell()}
        let dataItem = currentData[indexPath.row]
        cell.setCellItems(param:dataItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = self.storyboard?.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController else { return }
        detailVC.params = currentData[indexPath.row]
        detailVC.delegate = self
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let visiblePaths = tableView.indexPathsForVisibleRows,
           visiblePaths.contains([0, currentSegmentData.count - 1]) {
            
            let position = scrollView.contentOffset.y
            if position > tableView.contentSize.height - scrollView.frame.size.height && !isLoading {
                loadMoreData()
            }
            
        }
        
    }
    
    private func createSpiner() -> UIView {
        
        let spiner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100))
        spiner.startAnimating()
        return spiner
    }
    
    private func loadMoreData() {
        if !self.isLoading {
            if segmentControl.selectedSegmentIndex == 0 {
                self.isLoading = true
                pageCounter.extPage += 1
                getUserList(page:pageCounter.extPage)
            }else{
                if savedUserData.count < pageCounter.localPage*20 {
                    return
                }
                self.isLoading = true
                pageCounter.localPage += 1
                LocalDataViewModel.shared.readValues(saved: &savedUserData, page: pageCounter.localPage)
                self.isLoading = false
            }
            
        }
        
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    
    
    private func filtered (data:[Results], searchText:String) {
        
        filteredData = data.filter {
            
            var comperabelElements = [String]()
            if let first = $0.name.first?.lowercased() {
                comperabelElements += [first]
            }
            if let last = $0.name.last?.lowercased() {
                comperabelElements += [last]
            }
            if let city = $0.location.city?.lowercased() {
                comperabelElements += [city]
            }
            if let country = $0.location.country?.lowercased() {
                comperabelElements += [country]
            }
            if let street = $0.location.street.name?.lowercased() {
                comperabelElements += [street]
            }
            if let cell = $0.cell?.lowercased() {
                comperabelElements += [cell]
            }
            if let gender = $0.gender?.lowercased() {
                comperabelElements += [gender]
            }
            if let phone = $0.phone?.lowercased() {
                comperabelElements += [phone]
            }
            
            return comperabelElements.joined().contains(searchText.lowercased())
        }
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text ?? ""
        filtered(data:currentSegmentData, searchText:searchText)
        self.tableView.reloadData()
        
    }
    
}

extension MainViewController:DetailsViewControllerDelegate {
    
    func updateUsers(isRemove:Bool, uuid: String) {
        savedUserData.removeAll()
        LocalDataViewModel.shared.readValues(saved: &savedUserData)
        tableView.reloadData()
    }
    
}

