////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбъектСсылка = Неопределено;
	Если Параметры.Свойство("ОбъектСсылка") Тогда
		ОбъектСсылка = Параметры.ОбъектСсылка;
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Подписать ""%1""'"), Строка(ОбъектСсылка));
	
	Если ЭлектронныеДокументыСлужебныйВызовСервера.ВыполнятьКриптооперацииНаСервере() Тогда
		МассивСтруктурСертификатов = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьМассивСтруктурСертификатов(Истина);
		ЗаполнитьСписокСертификатов(МассивСтруктурСертификатов);
	КонецЕсли;
	
	ЭтаФорма.ЗакрыватьПриВыборе = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЭлектронныеДокументыСлужебныйВызовСервера.ВыполнятьКриптооперацииНаСервере() Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		Если ЭлектронныеДокументыСлужебныйКлиент.УстановитьРасширениеРаботыСКриптографиейНаКлиенте() Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Попытка
		МенеджерКриптографии = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМенеджерКриптографии();
	Исключение
		ТекстСообщения = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьСообщениеОбОшибке("100");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		Возврат;
	КонецПопытки;
	МассивСтруктурСертификатов = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМассивСтруктурСертификатов(Истина);

	ЗаполнитьСписокСертификатов(МассивСтруктурСертификатов);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СертификатыЭЦП

&НаКлиенте
Процедура СертификатыЭЦПВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработкаВыбора();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОбработкаВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификат(Команда)
	
	СтрокаСертификата = Элементы.СертификатыЭЦП.ТекущиеДанные;
	Если СтрокаСертификата = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЭлектронныеДокументыСлужебныйВызовСервера.ВыполнятьКриптооперацииНаСервере() Тогда
		ВыбранныйСертификат = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьСертификатПоОтпечатку(
																			СтрокаСертификата.Отпечаток);
	Иначе
		ВыбранныйСертификат = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьСертификатПоОтпечатку(СтрокаСертификата.Отпечаток);
	КонецЕсли;
	
	СтруктураСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(ВыбранныйСертификат);
	Если СтруктураСертификата <> Неопределено Тогда
		ПараметрыФормы = Новый Структура(
								"СтруктураСертификата, Отпечаток",
								СтруктураСертификата,
								СтрокаСертификата.Отпечаток);
		ОткрытьФорму("ОбщаяФорма.СертификатЭЦП", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбработкаВыбора()
	
	СтрокаСертификата = Элементы.СертификатыЭЦП.ТекущиеДанные;
	Если СтрокаСертификата = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ВыбранныйПароль = ?(ЗначениеЗаполнено(Пароль), Пароль, Элементы.Пароль.ТекстРедактирования);
	
	РезультатВыбора = Новый Структура;
	
	РезультатВыбора.Вставить("Комментарий", Комментарий);
	РезультатВыбора.Вставить("Пароль",      ВыбранныйПароль);
	РезультатВыбора.Вставить("Отпечаток",   СтрокаСертификата.Отпечаток);
	
	ОповеститьОВыборе(РезультатВыбора);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокСертификатов(Знач МассивСтруктурСертификатов)
	
	Для Каждого СтруктураСертификата Из МассивСтруктурСертификатов Цикл
		НоваяСтрока = СертификатыЭЦП.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураСертификата, "КомуВыдан, КемВыдан, ДействителенДо, Отпечаток");
		ЭлектроннаяЦифроваяПодпись.ЗаполнитьНазначениеСертификата(СтруктураСертификата.Назначение, НоваяСтрока.Назначение);
	КонецЦикла;
	
КонецПроцедуры