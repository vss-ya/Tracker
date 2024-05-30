// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Добавить категорию
  internal static let addCategory = L10n.tr("Localizable", "AddCategory", fallback: "Добавить категорию")
  /// Все трекеры
  internal static let allTrackers = L10n.tr("Localizable", "AllTrackers", fallback: "Все трекеры")
  /// Отменить
  internal static let cancel = L10n.tr("Localizable", "Cancel", fallback: "Отменить")
  /// Категория
  internal static let category = L10n.tr("Localizable", "Category", fallback: "Категория")
  /// Привычки и события можно
  /// объединить по смыслу
  internal static let categoryEmptyText = L10n.tr("Localizable", "CategoryEmptyText", fallback: "Привычки и события можно\nобъединить по смыслу")
  /// Цвет
  internal static let color = L10n.tr("Localizable", "Color", fallback: "Цвет")
  /// Завершенные
  internal static let completedTrackers = L10n.tr("Localizable", "CompletedTrackers", fallback: "Завершенные")
  /// Создать
  internal static let create = L10n.tr("Localizable", "Create", fallback: "Создать")
  /// Создание трекера
  internal static let createTracker = L10n.tr("Localizable", "CreateTracker", fallback: "Создание трекера")
  /// Удалить
  internal static let delete = L10n.tr("Localizable", "Delete", fallback: "Удалить")
  /// Уверены что хотите удалить трекер?
  internal static let deleteTrackerQuestion = L10n.tr("Localizable", "DeleteTrackerQuestion", fallback: "Уверены что хотите удалить трекер?")
  /// Готово
  internal static let done = L10n.tr("Localizable", "Done", fallback: "Готово")
  /// Редактировать
  internal static let edit = L10n.tr("Localizable", "Edit", fallback: "Редактировать")
  /// Редактирование привычки
  internal static let editHabit = L10n.tr("Localizable", "EditHabit", fallback: "Редактирование привычки")
  /// Emoji
  internal static let emoji = L10n.tr("Localizable", "Emoji", fallback: "Emoji")
  /// Анализировать пока нечего
  internal static let emptyStatText = L10n.tr("Localizable", "EmptyStatText", fallback: "Анализировать пока нечего")
  /// Введите название категории
  internal static let enterCategoryName = L10n.tr("Localizable", "EnterCategoryName", fallback: "Введите название категории")
  /// Введите название трекера
  internal static let enterTrackerName = L10n.tr("Localizable", "EnterTrackerName", fallback: "Введите название трекера")
  /// Каждый день
  internal static let everyDay = L10n.tr("Localizable", "EveryDay", fallback: "Каждый день")
  /// Фильтры
  internal static let filters = L10n.tr("Localizable", "Filters", fallback: "Фильтры")
  /// Привычка
  internal static let habit = L10n.tr("Localizable", "Habit", fallback: "Привычка")
  /// Нерегулярное событие
  internal static let irregularEvent = L10n.tr("Localizable", "IrregularEvent", fallback: "Нерегулярное событие")
  /// Новая категория
  internal static let newCategory = L10n.tr("Localizable", "NewCategory", fallback: "Новая категория")
  /// Новая привычка
  internal static let newHabit = L10n.tr("Localizable", "NewHabit", fallback: "Новая привычка")
  /// Новое нерегулярное событие
  internal static let newIrregularEvent = L10n.tr("Localizable", "NewIrregularEvent", fallback: "Новое нерегулярное событие")
  /// Не завершенные
  internal static let notCompletedTrackers = L10n.tr("Localizable", "NotCompletedTrackers", fallback: "Не завершенные")
  /// Ничего не найдено
  internal static let nothingFound = L10n.tr("Localizable", "NothingFound", fallback: "Ничего не найдено")
  /// Plural format key: "%#@days@"
  internal static func numberOfDays(_ p1: Int) -> String {
    return L10n.tr("Localizable", "numberOfDays", p1, fallback: "Plural format key: \"%#@days@\"")
  }
  /// Вот это технологии!
  internal static let onboardingFinishButtonTitle = L10n.tr("Localizable", "OnboardingFinishButtonTitle", fallback: "Вот это технологии!")
  /// Localizable.strings
  ///   Tracker
  /// 
  ///   Created by vs on 28.05.2024.
  internal static let onboardingPage1Text = L10n.tr("Localizable", "OnboardingPage1Text", fallback: "Отслеживайте только\nто, что хотите")
  /// Даже если это
  /// не литры воды и йога
  internal static let onboardingPage2Text = L10n.tr("Localizable", "OnboardingPage2Text", fallback: "Даже если это\nне литры воды и йога")
  /// Закрепить
  internal static let pin = L10n.tr("Localizable", "Pin", fallback: "Закрепить")
  /// Закрепленные
  internal static let pinned = L10n.tr("Localizable", "Pinned", fallback: "Закрепленные")
  /// Сохранить
  internal static let save = L10n.tr("Localizable", "Save", fallback: "Сохранить")
  /// Расписание
  internal static let schedule = L10n.tr("Localizable", "Schedule", fallback: "Расписание")
  /// Поиск
  internal static let search = L10n.tr("Localizable", "Search", fallback: "Поиск")
  /// Среднее значение
  internal static let statAverageValue = L10n.tr("Localizable", "StatAverageValue", fallback: "Среднее значение")
  /// Лучший период
  internal static let statBestPeriod = L10n.tr("Localizable", "StatBestPeriod", fallback: "Лучший период")
  /// Трекеров завершено
  internal static let statCompletedTrackers = L10n.tr("Localizable", "StatCompletedTrackers", fallback: "Трекеров завершено")
  /// Идеальные дни
  internal static let statIdealDays = L10n.tr("Localizable", "StatIdealDays", fallback: "Идеальные дни")
  /// Статистика
  internal static let statistic = L10n.tr("Localizable", "Statistic", fallback: "Статистика")
  /// Трекеры на сегодня
  internal static let todayTrackers = L10n.tr("Localizable", "TodayTrackers", fallback: "Трекеры на сегодня")
  /// Трекеры
  internal static let trackers = L10n.tr("Localizable", "Trackers", fallback: "Трекеры")
  /// Открепить
  internal static let unpin = L10n.tr("Localizable", "Unpin", fallback: "Открепить")
  /// Что будем отслеживать?
  internal static let whatToTrackQuestion = L10n.tr("Localizable", "WhatToTrackQuestion", fallback: "Что будем отслеживать?")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
