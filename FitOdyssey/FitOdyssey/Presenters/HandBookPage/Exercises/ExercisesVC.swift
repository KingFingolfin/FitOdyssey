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

class ExercisesCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .appTextFieldBackGround
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 140),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    func configure(with meal: Exercise) {
        nameLabel.text = meal.name
        imageView.image = nil

        loadImage(from: meal.image)
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let storageRef = Storage.storage().reference(forURL: urlString)

        let currentTag = tag

        storageRef.getData(maxSize: 10 * 1024 * 1024) { [weak self] data, error in
            guard let self = self else { return }

            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if self.tag == currentTag {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
    
}
