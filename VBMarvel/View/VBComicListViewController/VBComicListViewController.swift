//
//  ViewController.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import UIKit

protocol VBCComicListViewProtocol: AnyObject {
    func reloadComic()
    func showError()
    func showDetail(model: VBDetailModel)
}

class VBComicListViewController: UIViewController {
    
    private let itemsByRow: CGFloat = 2
    private let sideInset: CGFloat = 5
    private let columnSpacing: CGFloat = 5
    private let rowSpacing: CGFloat = 2
    private let itemHeight: CGFloat = 300
    private lazy var detallModel = VBDetailModel()
    private var flagFilter = false
    private var dateFilterValue = ""
    init(viewModel: VBComicViewModelDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        let viewModel = viewModel ?? VBComicViewModel()
        self.viewModel = viewModel
        viewModel.attachView(view: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private var viewModel: VBComicViewModelDelegate?
    
    @IBOutlet private weak var charactersCollectionView: UICollectionView!
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Marvel Comic"
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = viewModel ?? VBComicViewModel()
        self.viewModel = viewModel
        viewModel.attachView(view: self)
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        charactersCollectionView.backgroundColor = .white
        charactersCollectionView.delegate = self
        charactersCollectionView.dataSource = self
        
        setCollectionLayout()
        
        charactersCollectionView.register(CollectionViewCell.self)
        charactersCollectionView.registerSupplementaryClass(VBSpinnerCollectionView.self,
                                                            kind: UICollectionView.elementKindSectionFooter)
        charactersCollectionView.registerSupplementaryClass(VBErrorReusableView.self,
                                                            kind: UICollectionView.elementKindSectionFooter)
        charactersCollectionView.registerSupplementaryClass(NoResultCollectionReusableView.self,
                                                            kind: UICollectionView.elementKindSectionFooter)
    }
    
    private func setup() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationItem.title = viewModel?.navTitle
        view.backgroundColor = .white
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    
    private func setCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: sideInset,
                                           bottom: 0,
                                           right: sideInset)
        layout.minimumLineSpacing = rowSpacing
        layout.minimumInteritemSpacing = columnSpacing
        let totalWidth = UIScreen.main.bounds.size.width - (sideInset * 2) - columnSpacing
        layout.itemSize = CGSize(width: totalWidth / itemsByRow,
                                 height: itemHeight)
        charactersCollectionView.collectionViewLayout = layout
    }
    
    private func showMoreLoading() {
        charactersCollectionView.collectionViewLayout.invalidateLayout(with: UICollectionViewFlowLayoutInvalidationContext())
    }
    
    private func hideMoreLoading() {
        guard let state = viewModel?.state else {
            return
        }
        
        if state == .noResults || state == .error {
            charactersCollectionView.collectionViewLayout.invalidateLayout(with: UICollectionViewFlowLayoutInvalidationContext())
            if state == .error {
                charactersCollectionView.reloadSections([0])
            }
        }
    }
    
    private func getCharacterCell(_ collectionView: UICollectionView,
                                  indexPath: IndexPath) -> UICollectionViewCell {
        guard let character = viewModel?.character(at: indexPath.item),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionListViewCellProtocol
        else {
            return UICollectionViewCell()
        }
        cell.model = character
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "comic" {
            if let nextViewController = segue.destination as? VBDetailViewController {
                nextViewController.model = detallModel
            }
        }
    }
    @IBAction func btnFilterAction(_ sender: Any) {
        
        var actions: [(String, UIAlertAction.Style)] = []
        actions.append(("Released this week", UIAlertAction.Style.default))
        actions.append(("Released last week", UIAlertAction.Style.default))
        actions.append(("Releasing next week", UIAlertAction.Style.default))
        actions.append(("Release this month", UIAlertAction.Style.default))
        actions.append(("Reset", UIAlertAction.Style.default))
        actions.append(("Cancel", UIAlertAction.Style.cancel))
        //self = ViewController
        Alerts.showActionsheet(viewController: self, title: "VBMarvel", message: "Choose FIlter", actions: actions) { [self] (index) in
            print("call action \(index)")
           
            if index == 0{
                self.dateFilterValue = "thisWeek"
                self.flagFilter = true
            } else if index == 1{
                self.dateFilterValue = "lastWeek"
                self.flagFilter = true
            } else if index == 2{
                self.dateFilterValue = "nextWeek"
                self.flagFilter = true
            }else if index == 3{
                self.dateFilterValue = "thisMonth"
                self.flagFilter = true
            } else {
                self.flagFilter = false
                self.dateFilterValue = ""
            }
            let name = self.searchController.searchBar.text ?? ""
            viewModel?.loadNextPage(name: name ,isFilter: flagFilter , dateDescriptor: self.dateFilterValue)
        
        }
    }
}

extension VBComicListViewController: VBCComicListViewProtocol {
    func reloadComic() {
        DispatchQueue.main.async {
            self.hideMoreLoading()
            self.charactersCollectionView.reloadSections([0])
        }
    }

    func showError() {
        DispatchQueue.main.async {
            self.hideMoreLoading()
        }
    }

    func showDetail(model: VBDetailModel) {
        detallModel = model
        print(model.modified)
        self.performSegue(withIdentifier: "comic", sender: self)
    }
}

extension VBComicListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter,
           let state = viewModel?.state,
           let identifier = state.cellIdentifier {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: identifier,
                for: indexPath
            )

            if let errorFooter = footer as? VBErrorReusableView {
                errorFooter.delegate = self
            }

            return footer
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelect(character: indexPath.item)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewModel = viewModel else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if viewModel.canLoadMore(),
           offsetY > contentHeight - scrollView.frame.size.height {
            showMoreLoading()
            
            let name = searchController.searchBar.text ?? ""
            viewModel.loadNextPage(name: name ,isFilter: flagFilter , dateDescriptor: dateFilterValue)
        }
    }
}

extension VBComicListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel?.charactersCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getCharacterCell(collectionView, indexPath: indexPath)
    }
}

extension VBComicListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        let customHeight: CGFloat = 300
        let height = (viewModel?.charactersCount ?? 0 > 0) ? customHeight : collectionView.frame.size.height / 2
        return shouldShowFooter() ? CGSize(width: UIScreen.main.bounds.size.width, height: height) : CGSize.zero
    }

    private func shouldShowFooter() -> Bool {
        return viewModel?.state != .success
    }
}

extension VBComicListViewController: VBErrorViewDelegate {
    func tryAgain() {
        viewModel?.retry()
        charactersCollectionView.reloadSections([0])
    }
}

extension VBComicListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        self.flagFilter = false
        viewModel?.loadNextPage(name: text ,isFilter: flagFilter , dateDescriptor: dateFilterValue)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.loadNextPage(name: "" ,isFilter: flagFilter , dateDescriptor: dateFilterValue)
    }
}

extension VBComicViewModel.State {
    var cellIdentifier: String? {
        var identifier: String?
        switch self {
        case .loading:
            identifier = VBSpinnerCollectionView.reuseIdentifier

        case .error:
            identifier = VBErrorReusableView.reuseIdentifier

        case .noResults:
            identifier = NoResultCollectionReusableView.reuseIdentifier

        default:
            identifier = nil
        }

        return identifier
    }
}

