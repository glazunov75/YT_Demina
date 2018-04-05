// 10.3.22.2
Процедура УстановкаПризнаковИспользованияОбменовЭД() Экспорт
	
	// ИспользоватьОбмен1ССеть
	МассивУчетныхЗаписей = ЭлектронныеДокументы.ПолучитьВсеДоступныеУчетныеЗаписиЭлектронногоОбмена();
	Константы.ИспользоватьОбмен1ССеть.Установить(МассивУчетныхЗаписей.Количество() > 0);
	
	// ИспользоватьОбменCommerceML
	Константы.ИспользоватьОбменCommerceML.Установить(Ложь);
	
КонецПроцедуры

Процедура ЗаполнениеРеквизитовУчетныхЗаписейЭП() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(УчетныеЗаписиЭлектроннойПочты.Наименование) КАК Представление
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты";
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаписьЭП = Выборка.Ссылка.ПолучитьОбъект();
			ЗаписьЭП.ИспользоватьДляОтправки  = Истина;
			ЗаписьЭП.ИспользоватьДляПолучения = Истина;
			ЗаписьЭП.ОбменДанными.Загрузка = Истина;
			Попытка
				ЗаписьЭП.Записать();
			Исключение
				ОбщегоНазначения.СообщитьОбОшибке("Для учетной записи электронной почты "+Выборка.Представление+
					" не удалось заполнить реквизиты ""Использовать для отправки"", ""Использовать для получения"". "+
					"Заполните реквизиты вручную.");
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

// 10.3.23.2
Процедура ОбработатьКорректировочныеСчетаФактурыФЗ39() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СчетФактураВыданныйДокументыОснования.Ссылка,
	|	СчетФактураВыданныйДокументыОснования.Ссылка.НомерИсходногоДокумента,
	|	СчетФактураВыданныйДокументыОснования.Ссылка.ДатаИсходногоДокумента,
	|	СчетФактураВыданныйДокументыОснования.Ссылка.УдалитьУчитыватьИсправлениеИсходногоДокумента КАК УчитыватьИсправлениеИсходногоДокумента,
	|	СчетФактураВыданныйДокументыОснования.Ссылка.УдалитьНомерИсправленияИсходногоДокумента КАК НомерИсправленияИсходногоДокумента,
	|	СчетФактураВыданныйДокументыОснования.Ссылка.УдалитьДатаИсправленияИсходногоДокумента КАК ДатаИсправленияИсходногоДокумента,
	|	СчетФактураВыданныйДокументыОснования.Ссылка.СуммаУвеличение,
	|	СчетФактураВыданныйДокументыОснования.Ссылка.СуммаУменьшение,
	|	СчетФактураВыданныйДокументыОснования.Ссылка.СуммаНДСУвеличение,
	|	СчетФактураВыданныйДокументыОснования.Ссылка.СуммаНДСУменьшение
	|ИЗ
	|	Документ.СчетФактураВыданный.ДокументыОснования КАК СчетФактураВыданныйДокументыОснования
	|ГДЕ
	|	СчетФактураВыданныйДокументыОснования.Ссылка.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыВыставленного.Корректировочный)
	|	И (СчетФактураВыданныйДокументыОснования.НомерИсходногоДокумента = """"
	|			ИЛИ СчетФактураВыданныйДокументыОснования.ДатаИсходногоДокумента = ДАТАВРЕМЯ(1, 1, 1))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СчетФактураПолученныйДокументыОснования.Ссылка,
	|	СчетФактураПолученныйДокументыОснования.Ссылка.НомерИсходногоДокумента,
	|	СчетФактураПолученныйДокументыОснования.Ссылка.ДатаИсходногоДокумента,
	|	СчетФактураПолученныйДокументыОснования.Ссылка.УдалитьУчитыватьИсправлениеИсходногоДокумента,
	|	СчетФактураПолученныйДокументыОснования.Ссылка.УдалитьНомерИсправленияИсходногоДокумента,
	|	СчетФактураПолученныйДокументыОснования.Ссылка.УдалитьДатаИсправленияИсходногоДокумента,
	|	СчетФактураПолученныйДокументыОснования.Ссылка.СуммаУвеличение,
	|	СчетФактураПолученныйДокументыОснования.Ссылка.СуммаУменьшение,
	|	СчетФактураПолученныйДокументыОснования.Ссылка.СуммаНДСУвеличение,
	|	СчетФактураПолученныйДокументыОснования.Ссылка.СуммаНДСУменьшение
	|ИЗ
	|	Документ.СчетФактураПолученный.ДокументыОснования КАК СчетФактураПолученныйДокументыОснования
	|ГДЕ
	|	СчетФактураПолученныйДокументыОснования.Ссылка.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыПолученного.Корректировочный)
	|	И (СчетФактураПолученныйДокументыОснования.НомерИсходногоДокумента = """"
	|			ИЛИ СчетФактураПолученныйДокументыОснования.ДатаИсходногоДокумента = ДАТАВРЕМЯ(1, 1, 1))";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			СчетФактура = Выборка.Ссылка.ПолучитьОбъект(); 
			
			Если СчетФактура.ДокументыОснования.Количество() > 1 Тогда 
				Попытка
					СчетФактура.Записать(РежимЗаписиДокумента.Запись);
				Исключение
					ТекстСообщения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
					ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы'"), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
				КонецПопытки;
			Иначе
				ЗаполнитьЗначенияСвойств(СчетФактура.ДокументыОснования[0], Выборка);
				СчетФактура.ОбменДанными.Загрузка = Истина;
				Попытка
					СчетФактура.Записать(РежимЗаписиДокумента.Запись);
				Исключение
					ТекстСообщения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
					ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы'"), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
				КонецПопытки;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

	
КонецПроцедуры

Процедура ОбработатьЖурналУчетаСчетовФактур() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СчетФактураВыданный.Ссылка КАК СчетФактура,
	|	СчетФактураВыданный.Исправление,
	|	СчетФактураВыданный.НомерИсправления,
	|	СчетФактураВыданный.Дата,
	|	СчетФактураВыданный.УдалитьНомерИсправленияИсходногоДокумента КАК НомерИсправленияИсходногоДокумента,
	|	СчетФактураВыданный.УдалитьДатаИсправленияИсходногоДокумента КАК ДатаИсправленияИсходногоДокумента
	|ПОМЕСТИТЬ ВТ_СчФактурыДокументы
	|ИЗ
	|	Документ.СчетФактураВыданный КАК СчетФактураВыданный
	|ГДЕ
	|	СчетФактураВыданный.Проведен = ИСТИНА
	|	И СчетФактураВыданный.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыВыставленного.Корректировочный)
	|	И (СчетФактураВыданный.Исправление
	|			ИЛИ СчетФактураВыданный.ИсправляемыйСчетФактура.Исправление)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СчетФактураПолученный.Ссылка,
	|	СчетФактураПолученный.Исправление,
	|	СчетФактураПолученный.НомерИсправления,
	|	СчетФактураПолученный.Дата,
	|	СчетФактураПолученный.УдалитьНомерИсправленияИсходногоДокумента КАК НомерИсправленияИсходногоДокумента,
	|	СчетФактураПолученный.УдалитьДатаИсправленияИсходногоДокумента КАК ДатаИсправленияИсходногоДокумента
	|ИЗ
	|	Документ.СчетФактураПолученный КАК СчетФактураПолученный
	|ГДЕ
	|	СчетФактураПолученный.Проведен = ИСТИНА
	|	И СчетФактураПолученный.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыВыставленного.Корректировочный)
	|	И (СчетФактураПолученный.Исправление
	|			ИЛИ СчетФактураПолученный.ИсправляемыйСчетФактура.Исправление)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЖурналУчетаСчетовФактур.Регистратор КАК Регистратор,
	|	ВТ_СчФактурыДокументы.Исправление,
	|	ВТ_СчФактурыДокументы.НомерИсправления,
	|	ВТ_СчФактурыДокументы.Дата,
	|	ВТ_СчФактурыДокументы.НомерИсправленияИсходногоДокумента,
	|	ВТ_СчФактурыДокументы.ДатаИсправленияИсходногоДокумента,
	|	ВТ_СчФактурыДокументы.СчетФактура
	|ИЗ
	|	ВТ_СчФактурыДокументы КАК ВТ_СчФактурыДокументы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЖурналУчетаСчетовФактур КАК ЖурналУчетаСчетовФактур
	|		ПО ВТ_СчФактурыДокументы.СчетФактура = ЖурналУчетаСчетовФактур.СчетФактура
	|ГДЕ
	|	(ЖурналУчетаСчетовФактур.НомерИсправления <> ВТ_СчФактурыДокументы.НомерИсправленияИсходногоДокумента
	|			ИЛИ ЖурналУчетаСчетовФактур.ДатаИсправления <> ВТ_СчФактурыДокументы.ДатаИсправленияИсходногоДокумента
	|			ИЛИ ВТ_СчФактурыДокументы.Исправление
	|				И (ЖурналУчетаСчетовФактур.НомерИсправленияКорректировочногоСчетаФактуры <> ВТ_СчФактурыДокументы.НомерИсправления
	|					ИЛИ ЖурналУчетаСчетовФактур.ДатаИсправленияКорректировочногоСчетаФактуры <> ВТ_СчФактурыДокументы.Дата))
	|ИТОГИ ПО
	|	Регистратор";
	
	СчетаФактурыДляКорректировки = Новый ТаблицаЗначений;
	
	СчетаФактурыДляКорректировки.Колонки.Добавить("СчетФактура");
	СчетаФактурыДляКорректировки.Колонки.Добавить("Исправление");
	СчетаФактурыДляКорректировки.Колонки.Добавить("НомерИсправления");
	СчетаФактурыДляКорректировки.Колонки.Добавить("Дата");
	СчетаФактурыДляКорректировки.Колонки.Добавить("НомерИсправленияИсходногоДокумента");
	СчетаФактурыДляКорректировки.Колонки.Добавить("ДатаИсправленияИсходногоДокумента");

	ВыборкаРегистраторы = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);			   
	
	Пока ВыборкаРегистраторы.Следующий()Цикл
		
		НаборЗаписей = РегистрыСведений.ЖурналУчетаСчетовФактур.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаРегистраторы.Регистратор);
		НаборЗаписей.Прочитать();
		
		ВыборкаСчетаФактуры = ВыборкаРегистраторы.Выбрать();
		
		СчетаФактурыДляКорректировки.Очистить();
		Пока ВыборкаСчетаФактуры.Следующий() Цикл
			СчетФактураДляКорректировки = СчетаФактурыДляКорректировки.Добавить();
			ЗаполнитьЗначенияСвойств(СчетФактураДляКорректировки, ВыборкаСчетаФактуры);
		КонецЦикла;
		
		Для каждого СтрокаНабора Из НаборЗаписей Цикл
			
			СчетФактура = СчетаФактурыДляКорректировки.Найти(СтрокаНабора.СчетФактура, "СчетФактура");
			
			Если СчетФактура = Неопределено Тогда 
				Продолжить;	
			КонецЕсли;
			
			Если СчетФактура.Исправление Тогда  	
				СтрокаНабора.НомерИсправленияКорректировочногоСчетаФактуры = СчетФактура.НомерИсправления;
				СтрокаНабора.ДатаИсправленияКорректировочногоСчетаФактуры  = СчетФактура.Дата;
			КонецЕсли;
			
			СтрокаНабора.НомерИсправления = СчетФактура.НомерИсправленияИсходногоДокумента;
			СтрокаНабора.ДатаИсправления  = СчетФактура.ДатаИсправленияИсходногоДокумента;
			
		КонецЦикла;
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПеренестиПрефиксВРегистр() Экспорт
	
	Значение = Константы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Получить();
	
	Если ПустаяСтрока(Значение) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ Первые 1 1
	               |	
	               |ИЗ
	               |	РегистрСведений.ПрефиксыИнформационныхБаз КАК ПрефиксыИнформационныхБаз
				   |ГДЕ
				   |	ПрефиксыИнформационныхБаз.Префикс = &Префикс";
				   
	Запрос.УстановитьПараметр("Префикс", Значение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписейРегистра = РегистрыСведений.ПрефиксыИнформационныхБаз.СоздатьНаборЗаписей();
	
	НаборЗаписейРегистра.Отбор.Префикс.Установить(Значение);
	
	СтрокаРегистра = НаборЗаписейРегистра.Добавить();
	
	СтрокаРегистра.Префикс = Значение;
		
	НаборЗаписейРегистра.Записать();
	
КонецПроцедуры