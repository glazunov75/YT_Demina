Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

Процедура ДобавитьДвижение(ЗаполнитьДатуСобытия = истина) Экспорт
	
	мТаблицаДвижений.ЗаполнитьЗначения( мПериод, "Период");
	мТаблицаДвижений.ЗаполнитьЗначения( Истина,  "Активность");
	
	Если мТаблицаДвижений.Колонки.Найти("ДатаСобытия") = Неопределено Тогда
		мТаблицаДвижений.Колонки.Добавить("ДатаСобытия");
		ЗаполнитьДатуСобытия = истина;
	КонецЕсли; 
	
	Если ЗаполнитьДатуСобытия Тогда
		мТаблицаДвижений.ЗаполнитьЗначения( мПериод, "ДатаСобытия");
	КонецЕсли; 
	
	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект);
	
КонецПроцедуры // ДобавитьДвижение()

// Выполняет приход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьПриход(ЗаполнитьДатуСобытия = истина) Экспорт

	Если мТаблицаДвижений.Колонки.Найти("ДатаСобытия") = Неопределено Тогда
		мТаблицаДвижений.Колонки.Добавить("ДатаСобытия");
		ЗаполнитьДатуСобытия = истина;
	КонецЕсли; 
	
	Если ЗаполнитьДатуСобытия Тогда
		мТаблицаДвижений.ЗаполнитьЗначения( мПериод, "ДатаСобытия");
	КонецЕсли; 
	
	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Приход);

КонецПроцедуры // ВыполнитьПриход()

// Выполняет расход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьРасход(ЗаполнитьДатуСобытия = истина) Экспорт

	Если мТаблицаДвижений.Колонки.Найти("ДатаСобытия") = Неопределено Тогда
		мТаблицаДвижений.Колонки.Добавить("ДатаСобытия");
		ЗаполнитьДатуСобытия = истина;
	КонецЕсли; 
	
	Если ЗаполнитьДатуСобытия Тогда
		мТаблицаДвижений.ЗаполнитьЗначения( мПериод, "ДатаСобытия");
	КонецЕсли; 
	
	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Расход);

КонецПроцедуры // ВыполнитьРасход()

// Выполняет движения по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьДвижения() Экспорт

	Загрузить(мТаблицаДвижений);

КонецПроцедуры // ВыполнитьДвижения()
              
