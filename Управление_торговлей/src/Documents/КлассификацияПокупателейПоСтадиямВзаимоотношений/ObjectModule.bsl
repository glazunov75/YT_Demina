Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьТаблицуПечатныхФорм()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура проверяет наличие строк с одинаковыми контрагентами в табличной части
//
// Параметры
//  Отказ - булево
//
// Возвращаемое значение:
//   Строка, список наименований повторяющихся контрагентов
//
Процедура ПроверитьТабличнуюЧасть(Отказ)

	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаКонтрагентов.НомерСтроки            КАК НомерСтроки,
	|	ТаблицаКонтрагентов.Контрагент             КАК Контрагент,
	|	1                                          КАК Количество,
	|	ВЫБОР КОГДА ТаблицаКонтрагентов.СтадияВзаимоотношений = &ПустаяСтадия И ТаблицаКонтрагентов.XYZКлассификация = &ПустойКласс ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК ПустыеЗначения
	|
	|ИЗ
	|	Документ.КлассификацияПокупателейПоСтадиямВзаимоотношений.ТаблицаРаспределенияКонтрагентов КАК ТаблицаКонтрагентов
	|
	|ГДЕ
	|	ТаблицаКонтрагентов.Ссылка = &ТекущийДокумент
	|
	|";
	
	Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
	Запрос.УстановитьПараметр("ПустаяСтадия", Перечисления.СтадииВзаимоотношенийСПокупателями.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустойКласс", Перечисления.XYZКлассификация.ПустаяСсылка());
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	ТаблицаЗапроса.Индексы.Добавить("ПустыеЗначения");
	
	СтрокаОшибок = "";
	
	СтрокиСПустымиЗначениями = ТаблицаЗапроса.НайтиСтроки(Новый Структура("ПустыеЗначения", Истина));
	Если СтрокиСПустымиЗначениями.Количество() > 0 Тогда
		Отказ = Истина;
		Для каждого СтрокаПустыхЗначений Из СтрокиСПустымиЗначениями Цикл
			СтрокаОшибок = СтрокаОшибок + ?(НЕ ПустаяСтрока(СтрокаОшибок), Символы.ПС, "") + "В строке " + СтрокаПустыхЗначений.НомерСтроки + " не указаны стадия и класс контрагента!";
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаЗапроса.Свернуть("Контрагент", "Количество");
	СписокКонтрагентов = "";
	Для каждого СтрокаТаблицы Из ТаблицаЗапроса Цикл
		Если СтрокаТаблицы.Количество > 1 Тогда
			СписокКонтрагентов = СписокКонтрагентов + Символы.ПС + СтрокаТаблицы.Контрагент;
		КонецЕсли; 
	КонецЦикла;
	
	Если НЕ ПустаяСтрока(СписокКонтрагентов) Тогда
		Отказ = Истина;
		СтрокаОшибок = СтрокаОшибок + "Найдены строки с повторяющимися контрагентами!" + СписокКонтрагентов;
	КонецЕсли; 
	
	Если НЕ ПустаяСтрока(СтрокаОшибок) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаОшибок, Отказ);
	КонецЕсли; 
	
КонецПроцедуры // ПроверитьТабличнуюЧасть()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, Режим)

	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	
	ПроверитьТабличнуюЧасть(Отказ);
	
	Для Каждого ТекСтрокаТаблицаРаспределенияКонтрагентов Из ТаблицаРаспределенияКонтрагентов Цикл
		Движение = Движения.СтадииВзаимоотношенийСПокупателями.Добавить();
		Движение.Период                     = Дата;
		Движение.Контрагент                 = ТекСтрокаТаблицаРаспределенияКонтрагентов.Контрагент;
		Движение.Стадия                     = ТекСтрокаТаблицаРаспределенияКонтрагентов.СтадияВзаимоотношений;
		Движение.КлассПостоянногоПокупателя = ТекСтрокаТаблицаРаспределенияКонтрагентов.XYZКлассификация;
	КонецЦикла;

	Попытка
		Движения.СтадииВзаимоотношенийСПокупателями.Записать();
	Исключение
		Отказ = Истина;
		ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(), Отказ);
	КонецПопытки;

КонецПроцедуры


// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	мУдалятьДвижения = НЕ ЭтоНовый();

КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);

КонецПроцедуры
