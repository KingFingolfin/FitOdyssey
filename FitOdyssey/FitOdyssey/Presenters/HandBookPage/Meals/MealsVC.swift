//
//  MealsVC.swift
//  FitOdyssey
//
//  Created by Giorgi on 16.01.25.
//


import UIKit
import FirebaseFirestore

class MealsVC: UIViewController {
    var handbookViewModel = HandbookViewModel()
    private var meals: [Meal] = []
    private var filteredMeals: [Meal] = []
    private let tableView = UITableView()
    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMeals()
    }

    private func setupUI() {
        view.backgroundColor = .appBackground
        title = "Meals"

        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search meals by name"
        view.addSubview(searchBar)

        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MealCell")
        view.addSubview(tableView)
        tableView.backgroundColor = .appBackground

        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

    }

    private func fetchMeals() {
        handbookViewModel.fetchMeals { [weak self] fetchedMeals in
            DispatchQueue.main.async {
                self?.meals = fetchedMeals
                self?.filteredMeals = fetchedMeals
                self?.tableView.reloadData()
            }
        }
    }
}

extension MealsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMeals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath)
        let meal = filteredMeals[indexPath.row]
        cell.textLabel?.text = meal.name // Adjust to match the Meal model
        cell.textLabel?.numberOfLines = 0 // Support multiline names
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedMeal = filteredMeals[indexPath.row]
        let detailVC = MealDetailVC()
        detailVC.meal = selectedMeal // Pass the selected meal
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

extension MealsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMeals = meals // Show all meals if search text is empty
        } else {
            filteredMeals = meals.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() 
    }
}

