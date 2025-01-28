//
//  ExercisesVC.swift
//  FitOdyssey
//
//  Created by Giorgi on 16.01.25.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class ExercisesVC: UIViewController {
    var handbookViewModel = HandbookViewModel()
    private var meals: [Exercise] = []
    private var filteredMeals: [Exercise] = []
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMeals()
    }

    private func setupUI() {
        view.backgroundColor = .appBackground
        title = "Meals"
        let textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)

        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            if let leftIconView = textField.leftView as? UIImageView {
                leftIconView.tintColor = .gray
                leftIconView.image = leftIconView.image?.withRenderingMode(.alwaysTemplate)
            }
            
            textField.textColor = .white
            textField.font = UIFont.systemFont(ofSize: 16)
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search meals by name",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
        }

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 2 - 16, height: 200)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ExercisesCell.self, forCellWithReuseIdentifier: "ExercisesCell")
        collectionView.backgroundColor = .appBackground
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func fetchMeals() {
        handbookViewModel.fetchExercises { [weak self] fetchedMeals in
            DispatchQueue.main.async {
                self?.meals = fetchedMeals
                self?.filteredMeals = fetchedMeals
                self?.collectionView.reloadData()
            }
        }
    }
}

extension ExercisesVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMeals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExercisesCell", for: indexPath) as! ExercisesCell
        let meal = filteredMeals[indexPath.row]
        cell.tag = indexPath.row
        cell.configure(with: meal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMeal = filteredMeals[indexPath.row]
        let detailVC = ExercisesDetailVC()
        detailVC.meal = selectedMeal
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ExercisesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMeals = meals
        } else {
            filteredMeals = meals.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

