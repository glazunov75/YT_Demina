
Функция ЗагрузитьЭлементХМЛ(ОбъектXML, ИмяУзла, Параметры) Экспорт
	
	Если ИмяУзла = "ЗапросКаталога" Тогда
		
	ИначеЕсли ИмяУзла = "ДлительностьОжиданияОтвета" Тогда
		ДлительностьОжиданияОтвета = ЭлектронныеДокументы.ПолучитьДлительностьЭлемента(ОбъектXML);
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция СуществуетИсходящийДокумент(СсылкаНаОтветныйДокумент = Неопределено) Экспорт
	
	СсылкаНаОтветныйДокумент = ЭлектронныеДокументы.НайтиПервыйОтветныйДокумент(Ссылка, "ИсходящийКаталогТоваров");
	
	Возврат ЗначениеЗаполнено(СсылкаНаОтветныйДокумент);
	
КонецФункции // () 

Процедура ПринятьКРаботе(Отказ, Сообщение, ИсходящийДокумент = Неопределено) Экспорт
	
	Если ТипЗнч(Контрагент) <> Тип("СправочникСсылка.Контрагенты") 
		Или НЕ ЗначениеЗаполнено(Контрагент) Тогда
		
		Сообщение = Сообщение + Символы.ПС + "- " + "В документе """ + Ссылка + """ не определен ""Контрагент""!";
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	СсылкаНаИсходныйДокумент = Неопределено;
	Если СуществуетИсходящийДокумент(СсылкаНаИсходныйДокумент) Тогда
		
		Сообщение = Сообщение + Символы.ПС + "- На основании данного документа создан исходящий документ: """ + СсылкаНаИсходныйДокумент + "
		|Необходимо удалить исходящий документ и повторить операцию.";
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	НачатьТранзакцию();
	
	ИсходящийДокумент = Документы.ИсходящийКаталогТоваров.СоздатьДокумент();
	ИсходящийДокумент.Заполнить(Ссылка);
	
	Попытка
		ИсходящийДокумент.Записать();
	Исключение
		Сообщение = Сообщение + Символы.ПС + "- " + ОписаниеОшибки();
		Отказ = Истина;
		ОтменитьТранзакцию();
		Возврат;
	КонецПопытки;
	
	Обработан = Истина;
	
	Попытка
		Записать();
	Исключение
		
		Сообщение = Сообщение + Символы.ПС + "- " + ОписаниеОшибки();
		Отказ = Истина;
		Обработан = Ложь;
		ОтменитьТранзакцию();
		Возврат;
		
	КонецПопытки;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры // () 
