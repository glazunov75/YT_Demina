////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ТАБЛИЦЫ СПИСОК

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование И Типовое Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Если СпособОбменаЭД = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезВебРесурсБанка") Тогда
		ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.Форма.ФормаЭлементаБанк",
					 ,
					 ,
					 УникальныйИдентификатор);
	Иначе
		ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.ФормаОбъекта",
					 Новый Структура("Типовое", Типовое),
					 ,
					 УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Типовое = Параметры.Типовое;
	Список.Параметры.УстановитьЗначениеПараметра("Типовое", Типовое);
	Если Типовое Тогда
		Элементы.Контрагент.Видимость = Ложь;
		ЭтаФорма.Заголовок = НСтр("ru = 'Типовые соглашения об использовании электронных документов'");
		ЭтаФорма.КоманднаяПанель.ПодчиненныеЭлементы.ФормаСправочникСоглашенияОбИспользованииЭДТестНастроекСоглашения.Видимость = Ложь;
	Иначе
		ЭтаФорма.Заголовок = НСтр("ru = 'Соглашения об использовании электронных документов'");
		Элементы.Контрагент.Видимость = (НЕ ЭтаФорма.Параметры.Отбор=Неопределено 
										 И ЭтаФорма.Параметры.Отбор.Свойство("СпособОбменаЭД", СпособОбменаЭД))
										И СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезВебРесурсБанка;
	КонецЕсли;
		
КонецПроцедуры
