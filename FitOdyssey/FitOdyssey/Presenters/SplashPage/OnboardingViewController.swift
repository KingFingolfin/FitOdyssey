//
//  OnboardingViewController.swift
//  FitOdyssey
//
//  Created by Giorgi on 01.02.25.
//

import UIKit
import SwiftUI

class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private var pages: [UIViewController] = []
    private let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        setupPageControl()
        dataSource = self
        delegate = self
    }
    
    private func setupPages() {
        let page1 = OnboardingPageViewController(
            imageName: "figure.walk",
            title: "Get Stronger & Healthier",
            description: "Achieve your fitness goals with personalized workouts and nutrition plans."
        )
        
        let page2 = OnboardingPageViewController(
            imageName: "target",
            title: "Reach Your Goals",
            description: "Stay motivated and track your progress to reach your fitness milestones."
        )
        
        let page3 = OnboardingPageViewController(
            imageName: "chart.bar.fill",
            title: "Track Progress",
            description: "Monitor your workouts, weight, and achievements to see how far you've come."
        )
        
        page3.isLastPage = true
        page3.onGetStartedTapped = { [weak self] in
            self?.dismissOnboardingAndShowLogin()
        }
        
        pages = [page1, page2, page3]
        
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .blue
        
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = index
        }
    }
    
    private func dismissOnboardingAndShowLogin() {
        dismiss(animated: true) {
            let loginView = UIHostingController(rootView: LoginView())
            loginView.modalPresentationStyle = .fullScreen
            loginView.modalTransitionStyle = .crossDissolve
            self.present(loginView, animated: true, completion: nil)
        }
    }
}
