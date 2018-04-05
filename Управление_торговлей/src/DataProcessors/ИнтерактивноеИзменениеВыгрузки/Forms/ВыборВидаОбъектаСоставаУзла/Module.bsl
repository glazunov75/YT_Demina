////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗакрыватьПриЗакрытииВладельца = Истина;
	ЗакрыватьПриВыборе = Ложь;
	
	Объект.УзелИнформационнойБазы = Параметры.УзелИнформационнойБазы;
	
	ДеревоВыбора = РеквизитФормыВЗначение("ДоступныеВидыОбъектов");
	СтрокиДереваВыбора = ДеревоВыбора.Строки;
	СтрокиДереваВыбора.Очистить();
	
	ВсеДанные = ОбменДаннымиСервер.СсылочныеТаблицыСоставаУзла(Объект.УзелИнформационнойБазы);
	// Убираем типовую картинку метаданных для листьев
	ВсеДанные.ЗаполнитьЗначения(-1, "ИндексКартинки");
	
	// Здесь добавляются группы ограничений из модуля менеджера узла,
	// Пример вызова: ДобавитьГруппыОграничений(ВсеДанные, СтрокиДереваВыбора);
	
	ДобавитьВсеОбъекты(ВсеДанные, СтрокиДереваВыбора);
	
	ЗначениеВРеквизитФормы(ДеревоВыбора, "ДоступныеВидыОбъектов");
	
	ВыбираемыеКолонки = "";
	Для Каждого Реквизит Из ПолучитьРеквизиты("ДоступныеВидыОбъектов") Цикл
		ВыбираемыеКолонки = ВыбираемыеКолонки + "," + Реквизит.Имя;
	КонецЦикла;
	ВыбираемыеКолонки = Сред(ВыбираемыеКолонки, 2);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДоступныеВидыОбъектов
//

&НаКлиенте
Процедура ДоступныеВидыОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВыполнитьВыбор(ВыбраннаяСтрока);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
//

&НаКлиенте
Процедура КомандаОК(Команда)
	ВыполнитьВыбор();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

&НаСервере
Функция ЭтотОбъект(НовыйОбъект=Неопределено)
	Если НовыйОбъект=Неопределено Тогда
		Возврат РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	ЗначениеВРеквизитФормы(НовыйОбъект, "Объект");
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Процедура ВыполнитьВыбор(ВыбраннаяСтрока=Неопределено)
	
	ТаблицаФормы = Элементы.ДоступныеВидыОбъектов;
	ДанныеВыбора = Новый Массив;
	
	Если ВыбраннаяСтрока=Неопределено Тогда
		Для Каждого Строка Из ТаблицаФормы.ВыделенныеСтроки Цикл
			ЭлементВыбора = Новый Структура(ВыбираемыеКолонки);
			ЗаполнитьЗначенияСвойств(ЭлементВыбора, ТаблицаФормы.ДанныеСтроки(Строка) );
			ДанныеВыбора.Добавить(ЭлементВыбора);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ВыбраннаяСтрока)=Тип("Массив") Тогда
		Для Каждого Строка Из ВыбраннаяСтрока Цикл
			ЭлементВыбора = Новый Структура(ВыбираемыеКолонки);
			ЗаполнитьЗначенияСвойств(ЭлементВыбора, ТаблицаФормы.ДанныеСтроки(Строка) );
			ДанныеВыбора.Добавить(ЭлементВыбора);
		КонецЦикла;
		
	Иначе
		ЭлементВыбора = Новый Структура(ВыбираемыеКолонки);
		ЗаполнитьЗначенияСвойств(ЭлементВыбора, ТаблицаФормы.ДанныеСтроки(ВыбраннаяСтрока) );
		ДанныеВыбора.Добавить(ЭлементВыбора);
	КонецЕсли;
	
	ОповеститьОВыборе(ДанныеВыбора);
КонецПроцедуры

&НаСервере
Процедура ДобавитьВсеОбъекты(ВсеСсылочныеДанныеУзла, СтрокиПриемника)
	
	ЭтаОбработка = ЭтотОбъект();
	
	ГруппаДокументы = СтрокиПриемника.Добавить();
	ГруппаДокументы.ПредставлениеСписка = НСтр("ru='Все документы'");
	ГруппаДокументы.ПолноеИмяМетаданных = ЭтаОбработка.ИдентификаторВсехДокументов();
	ГруппаДокументы.ИндексКартинки = 7;
	
	ГруппаСправочники = СтрокиПриемника.Добавить();
	ГруппаСправочники.ПредставлениеСписка = НСтр("ru='Все справочники'");
	ГруппаСправочники.ПолноеИмяМетаданных = ЭтаОбработка.ИдентификаторВсехСправочников();
	ГруппаСправочники.ИндексКартинки = 3;
	
	Для Каждого Строка Из ВсеСсылочныеДанныеУзла Цикл
		Если Строка.ВыборПериода Тогда
			ЗаполнитьЗначенияСвойств(ГруппаДокументы.Строки.Добавить(), Строка);
		Иначе
			ЗаполнитьЗначенияСвойств(ГруппаСправочники.Строки.Добавить(), Строка);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

