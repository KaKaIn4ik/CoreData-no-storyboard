//
//  TaskListViewController.swift
//  CoreData + no storyboard
//
//  Created by Кунгурцев Эдуард Сергеевич on 23.10.2022.
//

import UIKit
import CoreData

protocol TaskViewControllerDelegate {
	func reloadData()
}

class TaskListViewController: UITableViewController {
	
	
	// Еще раз получаем доступ, но нужно доработать
	private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	// Создаем пустой массив что бы передавать туда данные
	private var taskList: [Task] = []
	// Создаем cellID для ячейки
	private let cellID = "task"

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Зарегистрируем ячейку
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
		
		view.backgroundColor = .white
		setupNavigationBar()
		fetchData()
	}
// Настройка навигешн бара
	private func setupNavigationBar() {
		title = "Task List"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		// Меняем цвета
		
		let navBarAppearance = UINavigationBarAppearance()
		// Метод для полупрозрачности навигешн бара
		navBarAppearance.configureWithOpaqueBackground()
		navBarAppearance.backgroundColor = UIColor(
			red: 21/255,
			green: 101/255,
			blue: 192/255,
			alpha: 194/255
		)
		
		// Изменяем текст Task List в двух состояниях навигешн бара
		navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		
		// Присваиваем цвет навигешн бару в двух состояниях
		navigationController?.navigationBar.standardAppearance = navBarAppearance
		navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
		
		// Делаем плюсик в навигешн баре справа 
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
		// tinColor определяет цвет всех кнопок(плюсика или чего то еще)
		navigationController?.navigationBar.tintColor = .white
	}
	
	// нужен обязательно параметр обжективси
	
	@objc private func addNewTask() {
		// Делаем переход на вью контроллер TaskList
		let taskVC = TaskViewController()
		taskVC.delegate = self
		present(taskVC, animated: true)
		
	}
	
	// Для восстановления данных из базы реализуем метод
	private func fetchData() {
		let fetchRequest = Task.fetchRequest()
		// Наполняем массив taskList
		do {
			taskList = try viewContext.fetch(fetchRequest)
		} catch {
			print(error.localizedDescription)
		}
	}
}

extension TaskListViewController: TaskViewControllerDelegate {
	func reloadData() {
		fetchData()
		tableView.reloadData()
	}
	
	
}

extension TaskListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		taskList.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		// Извлечем элемент из массива
		let task = taskList[indexPath.row]
		// создаем контент
		var content = cell.defaultContentConfiguration()
		content.text = task.title
		cell.contentConfiguration = content
		return cell
		
	}
}
