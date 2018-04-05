////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ТекстСообщения.Заголовок = Параметры.ТекстСообщения;
	Элементы.РекомендуемаяВерсияПлатформы.Заголовок = Параметры.РекомендуемаяВерсияПлатформы;
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Элементы.Версия.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Элементы.Версия.Заголовок, СистемнаяИнформация.ВерсияПриложения);
	Если Параметры.ЗавершитьРаботу Тогда
		Элементы.ТекстВопроса.Видимость = Ложь;
		Элементы.ФормаНет.Видимость     = Ложь;
	КонецЕсли;
	
	БазаФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	Если БазаФайловая Тогда
		МакетПорядокОбновления = Обработки.НерекомендуемаяВерсияПлатформы.ПолучитьМакет("ПорядокОбновленияДляФайловойБазы");
	Иначе
		МакетПорядокОбновления = Обработки.НерекомендуемаяВерсияПлатформы.ПолучитьМакет("ПорядокОбновленияДляКлиентСервернойБазы");
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ТекстСсылкиНажатие(Элемент)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Обработка.НерекомендуемаяВерсияПлатформы.Форма.ПорядокОбновленияПлатформы");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПродолжитьРаботу(Команда)
	
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

