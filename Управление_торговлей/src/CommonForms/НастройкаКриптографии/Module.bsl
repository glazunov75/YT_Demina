
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура НастройкиКриптографии(Команда)
	
	ПараметрыФормы = Новый Структура("ПоказыватьНастройкиШифрования", Истина);
	ПараметрыФормы.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ОткрытьФорму("ОбщаяФорма.НастройкиЭЦП", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокСертификатов" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭлектронныеДокументыПереопределяемый.ЕстьПравоНастройкиПараметровЭД() Тогда
		ТекстСообщения = ЭлектронныеДокументыСлужебныйВызовСервера.ТекстСообщенияОНеобходимостиНастройкиСистемы("Доступ");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;

	Если ЗначениеЗаполнено(Константы.ПровайдерЭЦП.Получить()) И ЗначениеЗаполнено(Константы.АлгоритмПодписи.Получить())
		И ЗначениеЗаполнено(Константы.АлгоритмХеширования.Получить()) И ЗначениеЗаполнено(Константы.АлгоритмШифрования.Получить()) Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСертификатыЭЦП;
	КонецЕсли;
		
	Если НЕ ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьЗначениеФункциональнойОпции("ИспользоватьЭлектронныеЦифровыеПодписи") Тогда
		ТекстСообщения = ЭлектронныеДокументыСлужебныйВызовСервера.ТекстСообщенияОНеобходимостиНастройкиСистемы("НастройкаКриптографии");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;
	
	ИнициализироватьНачальныеЗначенияРеквизитов();
	
	ЭтоПодчиненныйУзел = (ПланыОбмена.ГлавныйУзел() <> Неопределено);
	
	Если ЭтоПодчиненныйУзел Тогда // мы в не главном узле
		Элементы.ПровайдерЭЦП.ТолькоПросмотр = Истина;
		Элементы.ТипПровайдераЭЦП.ТолькоПросмотр = Истина;
		Элементы.АлгоритмПодписи.ТолькоПросмотр = Истина;
		Элементы.АлгоритмХеширования.ТолькоПросмотр = Истина;
		Элементы.АлгоритмШифрования.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	// Скроем не разделенные константы в разделенном режиме сервиса
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Элементы.ГруппаКонтекст.Видимость = Ложь;
	КонецЕсли;
	
	ИспользуетсяОбменСоСбербанком = Ложь;
	ЭлектронныеДокументыПереопределяемый.ПроверитьИспользованиеПодсистемыСбербанк(ИспользуетсяОбменСоСбербанком);
	
	Если Не ИспользуетсяОбменСоСбербанком ИЛИ НЕ Константы.ИспользоватьОбменЭДСБанками.Получить() Тогда
		Элементы.СписокСправочникСертификатыЭЦПЗагрузитьСертификатСТокена.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВыполнятьКриптооперацииНаСервере = ЭлектронныеДокументыСлужебныйВызовСервера.ВыполнятьКриптооперацииНаСервере();
	
	Если НЕ ВыполнятьКриптооперацииНаСервере Тогда
		ПодключитьМодульКриптографии();
	КонецЕсли;
		
	ПерсональныеНастройкиРаботыСЭЦП = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьПерсональныеНастройкиРаботыСЭЦП();
	
	ЗаполнитьЗначенияСвойств(
		ЭтаФорма,
		ПерсональныеНастройкиРаботыСЭЦП, 
		"ПровайдерЭЦП, ТипПровайдераЭЦП, АлгоритмПодписи, АлгоритмШифрования, АлгоритмХеширования");
		
	ДобавитьМенеджераКриптографииВСписок("Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider", "", 75);
	ДобавитьМенеджераКриптографииВСписок("Signal-COM CPGOST Cryptographic Provider", "", 75);
	ДобавитьМенеджераКриптографииВСписок("Infotecs Cryptographic Service Provider", "", 2);
	ДобавитьМенеджераКриптографииВСписок("Microsoft Enhanced Cryptographic Provider v1.0", "", 1);
	ДобавитьМенеджераКриптографииВСписок("", "", 75);
	
	Если ВыполнятьКриптооперацииНаСервере Тогда
		ЗаполнитьСпискиВыбораНаСервере();
	Иначе
		ЗаполнитьСпискиВыбораНаКлиенте();
	КонецЕсли;
	
	ЗаполнитьПараметрыНастройкиКриптографииПоУмолчанию();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ТипПровайдераЭЦППриИзменении(Элемент)
	
	ЗаписатьКонстанту(Элемент.Имя, ТипПровайдераЭЦП);
	
	Если ЭлектронныеДокументыСлужебныйВызовСервера.ВыполнятьКриптооперацииНаСервере() Тогда
		ЗаполнитьСпискиВыбораНаСервере();
	Иначе
		ЗаполнитьСпискиВыбораНаКлиенте();
	КонецЕсли;

	ЗаполнитьАлгоритмыПоУмолчанию();
		
КонецПроцедуры

&НаКлиенте
Процедура ПровайдерЭЦППриИзменении(Элемент)
	
	ЗаписатьКонстанту(Элемент.Имя,        ПровайдерЭЦП);
	ЗаписатьКонстанту("ТипПровайдераЭЦП", ТипПровайдераЭЦП);
	
	Если ЭлектронныеДокументыСлужебныйВызовСервера.ВыполнятьКриптооперацииНаСервере() Тогда
		ЗаполнитьСпискиВыбораНаСервере();
	Иначе
		ЗаполнитьСпискиВыбораНаКлиенте();
	КонецЕсли;
	
	ЗаполнитьАлгоритмыПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровайдерЭЦПОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтрокаТипаПровайдера = "";
	Пока Прав(ВыбранноеЗначение, 1) <> "/" Цикл
		СтрокаТипаПровайдера = Прав(ВыбранноеЗначение, 1) + СтрокаТипаПровайдера;
		ВыбранноеЗначение = Лев(ВыбранноеЗначение, СтрДлина(ВыбранноеЗначение) - 1);
	КонецЦикла;
	ВыбранноеЗначение = Лев(ВыбранноеЗначение, СтрДлина(ВыбранноеЗначение) - 1);
	
	ТипПровайдераЭЦП = Число(СтрокаТипаПровайдера);
	
КонецПроцедуры

&НаКлиенте
Процедура АлгоритмШифрованияПриИзменении(Элемент)
	
	ЗаписатьКонстанту(Элемент.Имя, АлгоритмШифрования);
	
КонецПроцедуры

&НаКлиенте
Процедура АлгоритмХешированияПриИзменении(Элемент)
	
	ЗаписатьКонстанту(Элемент.Имя, АлгоритмХеширования);
	
КонецПроцедуры

&НаКлиенте
Процедура АлгоритмПодписиПриИзменении(Элемент)
	
	ЗаписатьКонстанту(Элемент.Имя, АлгоритмПодписи);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтекстАвторизацииПриИзменении(Элемент)
	
	СохранитьЗначениеКонстанты(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтекстКриптографииПриИзменении(Элемент)
	
	СохранитьЗначениеКонстанты(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура АлгоритмШифрованияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура АлгоритмПодписиОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура АлгоритмХешированияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтекстКриптографииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтекстАвторизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПодключитьМодульКриптографии()
	
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		
		ЗаголовокВопроса = НСтр("ru = 'Расширение работы с криптографией'");
		
		ТекстВопроса =
			НСтр("ru = 'Для настройки ЭЦП необходимо установить
			           |расширение работы с криптографией.'");
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(1, НСтр("ru = 'Установить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		Ответ = Вопрос(ТекстВопроса, Кнопки, 60, 1, ЗаголовокВопроса);
		
		Если Ответ <> 1 Тогда
			Возврат;
		КонецЕсли;
		
		УстановитьРасширениеРаботыСКриптографией();
		
		Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпискиВыбораНаКлиенте()
	
	ОчиститьСообщения();
	
	Элементы.АлгоритмПодписи.СписокВыбора.Очистить();
	Элементы.АлгоритмШифрования.СписокВыбора.Очистить();
	Элементы.АлгоритмХеширования.СписокВыбора.Очистить();
	
	Если ЗначениеЗаполнено(ПровайдерЭЦП) Тогда
		ИнформацияМенеджера = СкомпоноватьИнформациюМенеджераКриптографииНаКлиенте(
								ПровайдерЭЦП,
								Неопределено,
								ТипПровайдераЭЦП);
	Иначе
		ИнформацияМенеджера = Неопределено;
	КонецЕсли;
	
	Если ИнформацияМенеджера = Неопределено Тогда
		
		СпискиАлгоритмовУспешноЗаполнены = Ложь;
	Иначе
		СпискиАлгоритмовУспешноЗаполнены = Истина;
		
		Для Каждого Строка Из ИнформацияМенеджера.АлгоритмыПодписи Цикл
			Элементы.АлгоритмПодписи.СписокВыбора.Добавить(Строка);
		КонецЦикла;
		
		Для Каждого Строка Из ИнформацияМенеджера.АлгоритмыШифрования Цикл
			Элементы.АлгоритмШифрования.СписокВыбора.Добавить(Строка);
		КонецЦикла;
		
		Для Каждого Строка Из ИнформацияМенеджера.АлгоритмыХеширования Цикл
			Элементы.АлгоритмХеширования.СписокВыбора.Добавить(Строка);
		КонецЦикла;
		
	КонецЕсли;
	
	Элементы.АлгоритмПодписи.Доступность      = СпискиАлгоритмовУспешноЗаполнены;
	Элементы.АлгоритмШифрования.Доступность   = СпискиАлгоритмовУспешноЗаполнены;
	Элементы.АлгоритмХеширования.Доступность  = СпискиАлгоритмовУспешноЗаполнены;
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Элементы.КонтекстАвторизации.Доступность  = СпискиАлгоритмовУспешноЗаполнены;
		Элементы.КонтекстКриптографии.Доступность = СпискиАлгоритмовУспешноЗаполнены;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбораНаСервере()
		
	Элементы.АлгоритмПодписи.СписокВыбора.Очистить();
	Элементы.АлгоритмШифрования.СписокВыбора.Очистить();
	Элементы.АлгоритмХеширования.СписокВыбора.Очистить();
	
	Если ЗначениеЗаполнено(ПровайдерЭЦП) Тогда
		ИнформацияМенеджера = СкомпоноватьИнформациюМенеджераКриптографииНаСервере(
								ПровайдерЭЦП,
								Неопределено,
								ТипПровайдераЭЦП);
	Иначе
		ИнформацияМенеджера = Неопределено;
	КонецЕсли;
	
	Если ИнформацияМенеджера = Неопределено Тогда
		
		СпискиАлгоритмовУспешноЗаполнены = Ложь;
	Иначе
		СпискиАлгоритмовУспешноЗаполнены = Истина;
		
		Для Каждого Строка Из ИнформацияМенеджера.АлгоритмыПодписи Цикл
			Элементы.АлгоритмПодписи.СписокВыбора.Добавить(Строка);
		КонецЦикла;
		
		Для Каждого Строка Из ИнформацияМенеджера.АлгоритмыШифрования Цикл
			Элементы.АлгоритмШифрования.СписокВыбора.Добавить(Строка);
		КонецЦикла;
		
		Для Каждого Строка Из ИнформацияМенеджера.АлгоритмыХеширования Цикл
			Элементы.АлгоритмХеширования.СписокВыбора.Добавить(Строка);
		КонецЦикла;
		
	КонецЕсли;
	
	Элементы.АлгоритмПодписи.Доступность     = СпискиАлгоритмовУспешноЗаполнены;
	Элементы.АлгоритмШифрования.Доступность  = СпискиАлгоритмовУспешноЗаполнены;
	Элементы.АлгоритмХеширования.Доступность = СпискиАлгоритмовУспешноЗаполнены;
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Элементы.КонтекстАвторизации.Доступность  = СпискиАлгоритмовУспешноЗаполнены;
		Элементы.КонтекстКриптографии.Доступность = СпискиАлгоритмовУспешноЗаполнены;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПараметрыНастройкиКриптографииПоУмолчанию()
	
	Если ЗначениеЗаполнено(ПровайдерЭЦП) Тогда
		Возврат;
	КонецЕсли;
	
	ОбщееКоличествоКриптосредствНаКомпьютере = Элементы.ПровайдерЭЦП.СписокВыбора.Количество();
	ЕстьИсключаемоеКриптосредство = НЕ Элементы.ПровайдерЭЦП.СписокВыбора.НайтиПоЗначению("Microsoft Enhanced Cryptographic Provider v1.0/1")=Неопределено;
	ОжидаемоеКоличествоКриптосредств = ?(ЕстьИсключаемоеКриптосредство, 2, 1);
	Если ОбщееКоличествоКриптосредствНаКомпьютере = ОжидаемоеКоличествоКриптосредств Тогда
		Для Каждого Криптосредство ИЗ Элементы.ПровайдерЭЦП.СписокВыбора Цикл
			Если НЕ Криптосредство.Значение = "Microsoft Enhanced Cryptographic Provider v1.0/1" Тогда
				ПровайдерЭЦП = Криптосредство.Представление;
				СтрокаТипаПровайдера = "";
				ВыбранноеЗначение = Криптосредство.Значение;
				Пока Прав(ВыбранноеЗначение, 1) <> "/" Цикл
					СтрокаТипаПровайдера = Прав(ВыбранноеЗначение, 1) + СтрокаТипаПровайдера;
					ВыбранноеЗначение = Лев(ВыбранноеЗначение, СтрДлина(ВыбранноеЗначение) - 1);
				КонецЦикла;
				ТипПровайдераЭЦП = Число(СтрокаТипаПровайдера);
				Если ЭлектронныеДокументыСлужебныйВызовСервера.ВыполнятьКриптооперацииНаСервере() Тогда
					ЗаполнитьСпискиВыбораНаСервере();
				Иначе
					ЗаполнитьСпискиВыбораНаКлиенте();
				КонецЕсли;
				ЗаполнитьАлгоритмыПоУмолчанию();
			КонецЕсли
		КонецЦикла;
	КонецЕсли;
	
	ЗаписатьКонстанту("ПровайдерЭЦП",        ПровайдерЭЦП);
	ЗаписатьКонстанту("ТипПровайдераЭЦП",    ТипПровайдераЭЦП);
	ЗаписатьКонстанту("АлгоритмПодписи",     АлгоритмПодписи);
	ЗаписатьКонстанту("АлгоритмШифрования",  АлгоритмШифрования);
	ЗаписатьКонстанту("АлгоритмХеширования", АлгоритмХеширования);
	
КонецПроцедуры

&НаКлиенте
Функция СкомпоноватьИнформациюМенеджераКриптографииНаКлиенте(ИмяМодуляКриптографии,
															ПутьМодуляКриптографии,
															ТипМодуляКриптографии,
															СообщатьОшибки = Истина)
	
	Если ПутьМодуляКриптографии = Неопределено Тогда
		ПутьМодуляКриптографии = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьПерсональныеНастройкиРаботыСЭЦП().ПутьМодуляКриптографии;
	КонецЕсли;
	
	ИнформацияМенеджера = Неопределено;
	
	Попытка
		
		МенеджерКриптографии = Новый МенеджерКриптографии(ИмяМодуляКриптографии,
														  ПутьМодуляКриптографии,
														  ТипМодуляКриптографии);
		ИнформацияМенеджера = МенеджерКриптографии.ПолучитьИнформациюМодуляКриптографии();
		
	Исключение
		
		Если СообщатьОшибки Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецЕсли;
		
	КонецПопытки;
	
	Если ИнформацияМенеджера <> Неопределено Тогда
		
		ЗначениеСпискаВыбора = ИнформацияМенеджера.Имя + "/" + ТипМодуляКриптографии;
		
		Если Элементы.ПровайдерЭЦП.СписокВыбора.НайтиПоЗначению(ЗначениеСпискаВыбора) = Неопределено Тогда
			Элементы.ПровайдерЭЦП.СписокВыбора.Добавить(ЗначениеСпискаВыбора, ИнформацияМенеджера.Имя);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИнформацияМенеджера;
	
КонецФункции

&НаСервере
Функция СкомпоноватьИнформациюМенеджераКриптографииНаСервере(ИмяМодуляКриптографии,
															ПутьМодуляКриптографии,
															ТипМодуляКриптографии,
															СообщатьОшибки = Истина)
	
	Если ПутьМодуляКриптографии = Неопределено Тогда
		ПутьМодуляКриптографии = ЭлектроннаяЦифроваяПодпись.ПолучитьПерсональныеНастройкиРаботыСЭЦПСервер().ПутьМодуляКриптографии;
	КонецЕсли;
	
	ИнформацияМенеджера = Неопределено;
	
	Попытка
		
		МенеджерКриптографии = Новый МенеджерКриптографии(ИмяМодуляКриптографии,
														  ПутьМодуляКриптографии,
														  ТипМодуляКриптографии);
		ИнформацияМенеджера = МенеджерКриптографии.ПолучитьИнформациюМодуляКриптографии();
		
	Исключение
		
		Если СообщатьОшибки Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецЕсли;
		
	КонецПопытки;
	
	Если ИнформацияМенеджера <> Неопределено Тогда
		
		ЗначениеСпискаВыбора = ИнформацияМенеджера.Имя + "/" + ТипМодуляКриптографии;
		
		Если Элементы.ПровайдерЭЦП.СписокВыбора.НайтиПоЗначению(ЗначениеСпискаВыбора) = Неопределено Тогда
			Элементы.ПровайдерЭЦП.СписокВыбора.Добавить(ЗначениеСпискаВыбора, ИнформацияМенеджера.Имя);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИнформацияМенеджера;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьМенеджераКриптографииВСписок(ИмяМодуляКриптографии, ПутьМодуляКриптографии, ТипМодуляКриптографии)
	
	Если ЭлектронныеДокументыСлужебныйВызовСервера.ВыполнятьКриптооперацииНаСервере() Тогда
		ДобавитьМенеджераКриптографииВСписокНаСервере(
				ИмяМодуляКриптографии,
				ПутьМодуляКриптографии,
				ТипМодуляКриптографии);
	Иначе
		 СкомпоноватьИнформациюМенеджераКриптографииНаКлиенте(
				ИмяМодуляКриптографии,
				ПутьМодуляКриптографии,
				ТипМодуляКриптографии,
				Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьАлгоритмыПоУмолчанию()
	
	Если Элементы.АлгоритмПодписи.СписокВыбора.Количество() = 1 Тогда
		АлгоритмПодписи = Элементы.АлгоритмПодписи.СписокВыбора[0].Значение;
	Иначе
		МассивАлгоритмов = Новый Массив;
		Для Каждого ЭлементСписка ИЗ Элементы.АлгоритмПодписи.СписокВыбора Цикл
			Если Сред(ЭлементСписка.Значение, 1, 4) = "GOST" Тогда
				МассивАлгоритмов.Добавить(ЭлементСписка.Значение);
			КонецЕсли;
		КонецЦикла;
		Если МассивАлгоритмов.Количество() = 1 Тогда
			АлгоритмПодписи = МассивАлгоритмов[0];
		КонецЕсли;
	КонецЕсли;
		
	Если Элементы.АлгоритмШифрования.СписокВыбора.Количество() = 1 Тогда
		АлгоритмШифрования = Элементы.АлгоритмШифрования.СписокВыбора[0].Значение;
	Иначе
		МассивАлгоритмов = Новый Массив;
		Для Каждого ЭлементСписка ИЗ Элементы.АлгоритмШифрования.СписокВыбора Цикл
			Если Сред(ЭлементСписка.Значение, 1, 4) = "GOST" Тогда
				МассивАлгоритмов.Добавить(ЭлементСписка.Значение);
			КонецЕсли;
		КонецЦикла;
		Если МассивАлгоритмов.Количество() = 1 Тогда
			АлгоритмШифрования = МассивАлгоритмов[0];
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.АлгоритмХеширования.СписокВыбора.Количество() = 1 Тогда
		АлгоритмХеширования = Элементы.АлгоритмХеширования.СписокВыбора[0].Значение;
	Иначе
		МассивАлгоритмов = Новый Массив;
		Для Каждого ЭлементСписка ИЗ Элементы.АлгоритмХеширования.СписокВыбора Цикл
			Если Сред(ЭлементСписка.Значение, 1, 4) = "GOST" Тогда
				МассивАлгоритмов.Добавить(ЭлементСписка.Значение);
			КонецЕсли;
		КонецЦикла;
		Если МассивАлгоритмов.Количество() = 1 Тогда
			АлгоритмХеширования = МассивАлгоритмов[0];
		КонецЕсли;
	КонецЕсли;
	
	ЗаписатьКонстанту("АлгоритмПодписи",     АлгоритмПодписи);
	ЗаписатьКонстанту("АлгоритмШифрования",  АлгоритмШифрования);
	ЗаписатьКонстанту("АлгоритмХеширования", АлгоритмХеширования);
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ЗаписатьКонстанту("КонтекстКриптографии", ПредопределенноеЗначение("Перечисление.КонтекстыРаботыСЭД.НаКлиенте"));
		ЗаписатьКонстанту("КонтекстАвторизации",  ПредопределенноеЗначение("Перечисление.КонтекстыРаботыСЭД.НаКлиенте"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьМенеджераКриптографииВСписокНаСервере(ИмяМодуляКриптографии,
														ПутьМодуляКриптографии,
														ТипМодуляКриптографии)
	
	СкомпоноватьИнформациюМенеджераКриптографииНаСервере(
			ИмяМодуляКриптографии,
			ПутьМодуляКриптографии,
			ТипМодуляКриптографии,
			Ложь);
		
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьНачальныеЗначенияРеквизитов()
	
	// Инициализация набора констант
	НаборКонстантОбъект = РеквизитФормыВЗначение("НаборКонстант");
	НаборКонстантОбъект.Прочитать();
	ЗначениеВРеквизитФормы(НаборКонстантОбъект, "НаборКонстант");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьЗначениеКонстанты(ИмяКонстанты)
	
	Если НЕ ЗначениеЗаполнено(НаборКонстант[ИмяКонстанты]) Тогда
		НаборКонстант[ИмяКонстанты] = Константы[ИмяКонстанты].Получить();
	КонецЕсли;
	
	УстановитьЗначениеКонстантыПоИмени(ИмяКонстанты);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеКонстантыПоИмени(ИмяКонстанты)
	
	Если Константы[ИмяКонстанты].Получить() <> НаборКонстант[ИмяКонстанты] Тогда
		Константы[ИмяКонстанты].Установить(НаборКонстант[ИмяКонстанты]);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьКонстанту(ИмяКонстанты, ЗначениеКонстанты)
	
	Константы[ИмяКонстанты].Установить(ЗначениеКонстанты);
	ОбновитьПовторноИспользуемыеЗначения();
	
конецПроцедуры


