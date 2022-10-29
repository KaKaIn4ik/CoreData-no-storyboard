//
//  TaskViewController.swift
//  CoreData + no storyboard
//
//  Created by Кунгурцев Эдуард Сергеевич on 25.10.2022.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
	// Создаем экземпляр класса appDelegate
	// Нужно добрать до appDelegate до persistentContainer
	
	private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	var delegate: TaskViewControllerDelegate!
	
	
	// Можно сделать так как ниже, но текс филд будет не настроен
//	var taskTextField = UITextField()
	// lazy нужно вызывать когда хотим обратиться к переменной или функции
	private lazy var taskTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "New Task"
		textField.borderStyle = .roundedRect
		return textField
	}()
//	// Закоментил ради примера, сделали более удобней
//	// Создаем кнопку save
//	private lazy var saveButton: UIButton = {
//		// Создаем контейнер, для того что бы присвоить название кнопки и она была не маленькой
//		var attributes = AttributeContainer()
//		// Меняем шрифт и размер его
//		attributes.font = UIFont.boldSystemFont(ofSize: 18)
//
//		var buttonConfiguration = UIButton.Configuration.filled()
//		// Создаем название кнопки
//		buttonConfiguration.attributedTitle = AttributedString("Save Task", attributes: attributes)
//		// Создаем цвет кнопки
//		buttonConfiguration.baseBackgroundColor = UIColor(
//			red: 21/255,
//			green: 101/255,
//			blue: 192/255,
//			alpha: 194/255
//		)
//
//		return UIButton(configuration: buttonConfiguration, primaryAction: UIAction { _ in
//			self.dismiss(animated: true)
//		})
//	}()
//	// Закоментил ради примера, сделали более удобней
//	// Создаем кнопку cancel
//	private lazy var cancelButton: UIButton = {
//		// Создаем контейнер, для того что бы присвоить название кнопки и она была не маленькой
//		var attributes = AttributeContainer()
//		// Меняем шрифт и размер его
//		attributes.font = UIFont.boldSystemFont(ofSize: 18)
//
//		var buttonConfiguration = UIButton.Configuration.filled()
//		// Создаем название кнопки
//		buttonConfiguration.attributedTitle = AttributedString("Cancel", attributes: attributes)
//		// Создаем цвет кнопки
//		buttonConfiguration.baseBackgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
//		return UIButton(configuration: buttonConfiguration, primaryAction: UIAction { _ in
//			self.dismiss(animated: true)
//		})
//	}()
	
	private lazy var saveButton: UIButton = {
		createButton(
			withTitle: "Save task",
			andColor: UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 194/255),
			action: UIAction { _ in
//				self.dismiss(animated: true)
				self.save()
			})
	}()
	
	
	private lazy var cancelButton: UIButton = {
		createButton(
			withTitle: "Cancel",
			andColor: .systemRed,
			action: UIAction { _ in
				self.dismiss(animated: true)
			})
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		//   Добавляем  taskTextField во вью
		// что бы не вызывать его постоянно дял каждой кнопки или текст филда, сделаем приватный метод setupSubviews
//		view.addSubview(taskTextField)
		setupSubview(taskTextField, saveButton, cancelButton)
		setConstrains()
    }
	//  Вариативный параметр это  три точки после  UIView
	private func setupSubview(_ subviews: UIView...) {
		// Перебираем массив с помощью forEach
		subviews.forEach {  subview in
			view.addSubview(subview)
		}
	}
	//  Отключаем важный параметр для нормальной работы констрейтов
	private func setConstrains() {
		taskTextField.translatesAutoresizingMaskIntoConstraints = false
		// Задаем констрейты, верста типо кодом)))
		NSLayoutConstraint.activate([
			taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
			taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
		
		])
		
		saveButton.translatesAutoresizingMaskIntoConstraints = false
		// Задаем констрейты, верста типо кодом)))
		NSLayoutConstraint.activate([
			saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
			saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
			
		])
		
		cancelButton.translatesAutoresizingMaskIntoConstraints = false
		// Задаем констрейты, верста типо кодом)))
		NSLayoutConstraint.activate([
			cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
			cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)

		])
	}
	
	//  Сделаем метод, что бы делать кнопки удобней, объединяем, чтоб не писать два или три.. метода(все в одном)
	
	private func createButton(withTitle title: String, andColor color: UIColor, action: UIAction) -> UIButton {
		var attributes = AttributeContainer()
		attributes.font = UIFont.boldSystemFont(ofSize: 18)
		
		var buttonConfiguration = UIButton.Configuration.filled()
		buttonConfiguration.baseBackgroundColor = color
		buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
		
		return UIButton(configuration: buttonConfiguration, primaryAction: action)
	}
	
	// Создаем метод save для сохранение в базу данных
	
	private func save() {
		let task = Task(context: viewContext)

		task.title = taskTextField.text
		
		//  Делаем проверку через ду кетч
		if viewContext.hasChanges {
			do {
				try viewContext.save()
			} catch {
				print(error.localizedDescription)
			}
		}
		delegate.reloadData()
		dismiss(animated: true)
		
	}
}
