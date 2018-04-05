Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
	
// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
		
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
		
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		
		Возврат;
		
	КонецЕсли;

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			
			Возврат;
			
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ВыполнитьВыборкуДанных() Экспорт
	
	Перем НовыеПотребности, ТекущиеПотребности;
	
	// Новые потребности
	ЗапросНовыеПотребности = Новый Запрос;
	ЗапросНовыеПотребности.УстановитьПараметр("ДатаДокумента", Дата);
	ЗапросНовыеПотребности.УстановитьПараметр("ПустаяДата", Дата('00010101000000'));
	
	// Планы продаж
	Индекс = 0;
	
	Для каждого Строка из ПланыПродаж Цикл
		
		Если НЕ ЗначениеЗаполнено(Строка.Сценарий.Периодичность) Тогда
			
			ОбщегоНазначения.СообщитьОбОшибке("Для сценария """ + СокрЛП(Строка.Сценарий.Наименование) + """ не указана периодичность.");
			Продолжить;
			
		КонецЕсли;
		
		ДатаНач = Строка.ДатаНач;
		ДатаКон = Строка.ДатаКон;
		
		УправлениеПланированием.ВыровнятьПериод(ДатаНач, ДатаКон, Строка.Сценарий.Периодичность);
		
		ЗапросНовыеПотребности.УстановитьПараметр("ПланыПродажДатаНач" + Формат(Индекс, "ЧГ=0"), ДатаНач);
		ЗапросНовыеПотребности.УстановитьПараметр("ПланыПродажДатаКон" + Формат(Индекс, "ЧГ=0"), ДатаКон);
		
		ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст + "
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&ДатаДокумента КАК Период,
		|	ПланыПродажОбороты.Номенклатура КАК Номенклатура,
		|	ПланыПродажОбороты.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	ПланыПродажОбороты.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
		|	ЗНАЧЕНИЕ(Перечисление.ТоварТара.Товар) КАК ТоварТара,
		|	Ложь КАК Тара,
		|	НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПланыПродажОбороты.Период, ДЕНЬ, -1), ДЕНЬ) КАК ДатаПотребности,
		|	ПланыПродажОбороты.Заказ КАК Заказ,
		|	ПланыПродажОбороты.Проект КАК Проект,
		|	ПланыПродажОбороты.Сценарий КАК Сценарий,
		|	ПланыПродажОбороты.КоличествоОборот КАК Количество
		|ИЗ
		|	РегистрНакопления.ПланыПродаж.Обороты(&ПланыПродажДатаНач" + Формат(Индекс, "ЧГ=0") + ", &ПланыПродажДатаКон" + Формат(Индекс, "ЧГ=0") + ", ДЕНЬ, ";
		
		ЗапросНовыеПотребности.УстановитьПараметр("Сценарий" + Формат(Индекс, "ЧГ=0"), Строка.Сценарий);
		ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст + "Сценарий = &Сценарий" + Формат(Индекс, "ЧГ=0") + " И ВЫБОР КОГДА Номенклатура ССЫЛКА Справочник.Номенклатура ТОГДА Номенклатура.Услуга = Ложь ИНАЧЕ Истина КОНЕЦ";
		
		Если ЗначениеЗаполнено(Строка.Проект) Тогда
			
			ЗапросНовыеПотребности.УстановитьПараметр("Проект" + Формат(Индекс, "ЧГ=0"), Строка.Проект);
			ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст + " И Проект = &Проект" + Формат(Индекс, "ЧГ=0");
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.Подразделение) Тогда
			
			ЗапросНовыеПотребности.УстановитьПараметр("Подразделение" + Формат(Индекс, "ЧГ=0"), Строка.Подразделение);
			ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст + " И Подразделение = &Подразделение" + Формат(Индекс, "ЧГ=0");
			
		КонецЕсли;
		
		ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст +
		") КАК ПланыПродажОбороты
		|";
		
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
	// Внутренние заказы
	Индекс = 0;
	
	Для каждого Строка из ВнутренниеЗаказы Цикл
		
		ЗапросНовыеПотребности.УстановитьПараметр("ВнутреннийЗаказДатаПотребности" + Формат(Индекс, "ЧГ=0"), НачалоДня(Строка.ДатаПотребности));
		
		ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст + "
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&ДатаДокумента КАК Период,
		|	ВнутренниеЗаказыОстатки.Номенклатура КАК Номенклатура,
		|	ВнутренниеЗаказыОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	ВнутренниеЗаказыОстатки.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
		|	ВЫБОР КОГДА	СтатусПартии = ЗНАЧЕНИЕ(Перечисление.СтатусыПартийТоваров.ВозвратнаяТара) ТОГДА
		|		ЗНАЧЕНИЕ(Перечисление.ТоварТара.Тара)
		|	ИНАЧЕ
		|		ЗНАЧЕНИЕ(Перечисление.ТоварТара.Товар)
		|	КОНЕЦ КАК ТоварТара,
		|	ВЫБОР КОГДА	СтатусПартии = ЗНАЧЕНИЕ(Перечисление.СтатусыПартийТоваров.ВозвратнаяТара) ТОГДА
		|		Истина
		|	ИНАЧЕ
		|		Ложь
		|	КОНЕЦ КАК Тара,
		|	&ВнутреннийЗаказДатаПотребности" + Формат(Индекс, "ЧГ=0") + " КАК ДатаПотребности,
		|	ВнутренниеЗаказыОстатки.ВнутреннийЗаказ КАК Заказ,
		|	ЗНАЧЕНИЕ(Справочник.Проекты.ПустаяСсылка) КАК Проект,
		|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.ПустаяСсылка) КАК Сценарий,
		|	ВнутренниеЗаказыОстатки.КоличествоОстаток КАК Количество
		|ИЗ
		|	РегистрНакопления.ВнутренниеЗаказы.Остатки(КОНЕЦПЕРИОДА(&ДатаДокумента, ДЕНЬ), Номенклатура.Услуга = Ложь";
		
		Если ЗначениеЗаполнено(Строка.Заказ) Тогда
			
			ЗапросНовыеПотребности.УстановитьПараметр("ВнутреннийЗаказ" + Формат(Индекс, "ЧГ=0"), Строка.Заказ);
			ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст + " И ВнутреннийЗаказ = &ВнутреннийЗаказ" + Формат(Индекс, "ЧГ=0");
			
		КонецЕсли;
		
		ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст +
		") КАК ВнутренниеЗаказыОстатки
		|
		|ГДЕ ВнутренниеЗаказыОстатки.КоличествоОстаток > 0
		|";
		
		Индекс = Индекс + 1;
		
	КонецЦикла;
			
	// Заказы покупателей
	Индекс = 0;
	
	Для каждого Строка из ЗаказыПокупателей Цикл
		
		ЗапросНовыеПотребности.УстановитьПараметр("ЗаказПокупателяДатаПотребности" + Формат(Индекс, "ЧГ=0"), НачалоДня(Строка.ДатаПотребности));
		
		ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст + "
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&ДатаДокумента КАК Период,
		|	ЗаказыПокупателейОстатки.Номенклатура КАК Номенклатура,
		|	ЗаказыПокупателейОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	ЗаказыПокупателейОстатки.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
		|	ВЫБОР КОГДА	СтатусПартии = ЗНАЧЕНИЕ(Перечисление.СтатусыПартийТоваров.ВозвратнаяТара) ТОГДА
		|		ЗНАЧЕНИЕ(Перечисление.ТоварТара.Тара)
		|	ИНАЧЕ
		|		ЗНАЧЕНИЕ(Перечисление.ТоварТара.Товар)
		|	КОНЕЦ КАК ТоварТара,
		|	ВЫБОР КОГДА	СтатусПартии = ЗНАЧЕНИЕ(Перечисление.СтатусыПартийТоваров.ВозвратнаяТара) ТОГДА
		|		Истина
		|	ИНАЧЕ
		|		Ложь
		|	КОНЕЦ КАК Тара,
		|	&ЗаказПокупателяДатаПотребности" + Формат(Индекс, "ЧГ=0") + " КАК ДатаПотребности,
		|	ЗаказыПокупателейОстатки.ЗаказПокупателя КАК Заказ,
		|	ЗНАЧЕНИЕ(Справочник.Проекты.ПустаяСсылка) КАК Проект,
		|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.ПустаяСсылка) КАК Сценарий,
		|	ЗаказыПокупателейОстатки.КоличествоОстаток КАК Количество
		|ИЗ
		|	РегистрНакопления.ЗаказыПокупателей.Остатки(КОНЕЦПЕРИОДА(&ДатаДокумента, ДЕНЬ), Номенклатура.Услуга = Ложь";
		
		Если ЗначениеЗаполнено(Строка.Заказ) Тогда
			
			ЗапросНовыеПотребности.УстановитьПараметр("ЗаказПокупателя" + Формат(Индекс, "ЧГ=0"), Строка.Заказ);
			ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст + " И ЗаказПокупателя = &ЗаказПокупателя" + Формат(Индекс, "ЧГ=0");
			
		КонецЕсли;
		
		ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст +
		") КАК ЗаказыПокупателейОстатки
		|
		|ГДЕ ЗаказыПокупателейОстатки.КоличествоОстаток > 0
		|";
		
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
	Если ЗапросНовыеПотребности.Текст <> "" Тогда
		
		ЗапросНовыеПотребности.Текст = Сред(ЗапросНовыеПотребности.Текст, 16);
		Результат = ЗапросНовыеПотребности.Выполнить().Выгрузить(ОбходРезультатаЗапроса.Прямой);
		РаспределитьПоНоменклатуре(НовыеПотребности, Результат);
		
	КонецЕсли;
	
	//Текущие потребности
	ЗапросТекущиеПотребности = Новый Запрос;
	ЗапросТекущиеПотребности.УстановитьПараметр("ДатаДокумента", Дата);
	
	// Планы закупок
	Индекс = 0;
	
	Для каждого Строка из ПланыЗакупок Цикл
		
		Если НЕ ЗначениеЗаполнено(Строка.Сценарий.Периодичность) Тогда
			
			ОбщегоНазначения.СообщитьОбОшибке("Для сценария """ + СокрЛП(Строка.Сценарий.Наименование) + """ не указана периодичность.");
			Продолжить;
			
		КонецЕсли;
		
		ДатаНач = Строка.ДатаНач;
		ДатаКон = Строка.ДатаКон;
		
		УправлениеПланированием.ВыровнятьПериод(ДатаНач, ДатаКон, Строка.Сценарий.Периодичность);
		
		ЗапросТекущиеПотребности.УстановитьПараметр("ПланыЗакупокДатаНач" + Формат(Индекс, "ЧГ=0"), ДатаНач);
		ЗапросТекущиеПотребности.УстановитьПараметр("ПланыЗакупокДатаКон" + Формат(Индекс, "ЧГ=0"), ДатаКон);
		
		ЗапросТекущиеПотребности.Текст = ЗапросТекущиеПотребности.Текст + "
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&ДатаДокумента КАК Период,
		|	ПланыЗакупокОбороты.Номенклатура КАК Номенклатура,
		|	ПланыЗакупокОбороты.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	ПланыЗакупокОбороты.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
		|	ЗНАЧЕНИЕ(Перечисление.ТоварТара.Товар) КАК ТоварТара,
		|	Ложь КАК Тара,
		|	НАЧАЛОПЕРИОДА(ПланыЗакупокОбороты.Период, ДЕНЬ) КАК ДатаПотребности,
		|	ПланыЗакупокОбороты.Заказ КАК Заказ,
		|	ПланыЗакупокОбороты.Проект КАК Проект,
		|	ПланыЗакупокОбороты.Сценарий КАК Сценарий,
		|	ПланыЗакупокОбороты.КоличествоОборот КАК Количество
		|ИЗ
		|	РегистрНакопления.ПланыЗакупок.Обороты(&ПланыЗакупокДатаНач" + Формат(Индекс, "ЧГ=0") + ", &ПланыЗакупокДатаКон" + Формат(Индекс, "ЧГ=0") + ", ДЕНЬ, ";
		
		ЗапросТекущиеПотребности.УстановитьПараметр("Сценарий" + Формат(Индекс, "ЧГ=0"), Строка.Сценарий);
		ЗапросТекущиеПотребности.Текст = ЗапросТекущиеПотребности.Текст + "Сценарий = &Сценарий" + Формат(Индекс, "ЧГ=0") + " И ВЫБОР КОГДА Номенклатура ССЫЛКА Справочник.Номенклатура ТОГДА Номенклатура.Услуга = Ложь ИНАЧЕ Истина КОНЕЦ";
		
		Если ЗначениеЗаполнено(Строка.Проект) Тогда
			
			ЗапросТекущиеПотребности.УстановитьПараметр("Проект" + Формат(Индекс, "ЧГ=0"), Строка.Проект);
			ЗапросТекущиеПотребности.Текст = ЗапросТекущиеПотребности.Текст + " И Проект = &Проект" + Формат(Индекс, "ЧГ=0");
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.Подразделение) Тогда
			
			ЗапросТекущиеПотребности.УстановитьПараметр("Подразделение" + Формат(Индекс, "ЧГ=0"), Строка.Подразделение);
			ЗапросТекущиеПотребности.Текст = ЗапросТекущиеПотребности.Текст + " И Подразделение = &Подразделение" + Формат(Индекс, "ЧГ=0");
			
		КонецЕсли;
		
		ЗапросТекущиеПотребности.Текст = ЗапросТекущиеПотребности.Текст +
		") КАК ПланыЗакупокОбороты
		|";
		
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
	Если ЗапросТекущиеПотребности.Текст <> "" Тогда
	
		ЗапросТекущиеПотребности.Текст = Сред(ЗапросТекущиеПотребности.Текст, 16);
		Результат = ЗапросТекущиеПотребности.Выполнить().Выгрузить(ОбходРезультатаЗапроса.Прямой);
		РаспределитьПоНоменклатуре(ТекущиеПотребности, Результат);
		
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеПотребности) = Тип("ТаблицаЗначений") Тогда
		
		Для каждого Строка из ТекущиеПотребности Цикл
			
			УправлениеПланированием.ВыровнятьДатуПоКонцуПериода(Строка.ДатаПотребности, Строка.Сценарий.Периодичность);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТипЗнч(НовыеПотребности) = Тип("ТаблицаЗначений") Тогда
		
		НовыеПотребности.Сортировать("ДатаПотребности ВОЗР");
		НовыеПотребности.Индексы.Добавить("Заказ, Номенклатура, ХарактеристикаНоменклатуры, Тара");
		СкорректироватьПотребности(НовыеПотребности);
		
		Если ТипЗнч(ТекущиеПотребности) = Тип("ТаблицаЗначений") Тогда
			
			СложениеОбъединениеИсточников(ТекущиеПотребности, ОбъединениеИсточников);
			
		КонецЕсли;
		
		УправлениеПланированием.ДополнитьТаблицу(ТекущиеПотребности, НовыеПотребности);
		
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеПотребности) = Тип("ТаблицаЗначений") Тогда
		
		Для каждого Строка из ТекущиеПотребности Цикл
			
			Строка.ДатаПотребности = НачалоДня(Строка.ДатаПотребности);
			
		КонецЦикла;
		
		ТекущиеПотребности.Свернуть("Период, Номенклатура, ХарактеристикаНоменклатуры, ТоварТара, ДатаПотребности, Заказ, Проект", "Количество");
		
		Возврат ТекущиеПотребности;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции // ВыполнитьВыборкуДанных()

Процедура СложениеОбъединениеИсточников(ТаблицаИсточник, Объединение)
	
	Если Объединение = Ложь Тогда
		
		ТаблицаИсточник.Свернуть("Период, Номенклатура, ХарактеристикаНоменклатуры, ТоварТара, ДатаПотребности, Заказ, Проект", "Количество");
		
	Иначе
		
		ТаблицаИсточник.Сортировать("Период, Номенклатура, ХарактеристикаНоменклатуры, ТоварТара, ДатаПотребности, Заказ, Проект, Количество Убыв");
		
		Индекс = 1;
		
		Пока Индекс < ТаблицаИсточник.Количество() Цикл
			
			Если  ТаблицаИсточник[Индекс].Номенклатура = ТаблицаИсточник[Индекс-1].Номенклатура
				И ТаблицаИсточник[Индекс].ХарактеристикаНоменклатуры = ТаблицаИсточник[Индекс-1].ХарактеристикаНоменклатуры
				И ТаблицаИсточник[Индекс].ТоварТара = ТаблицаИсточник[Индекс-1].ТоварТара
				И ТаблицаИсточник[Индекс].ДатаПотребности = ТаблицаИсточник[Индекс-1].ДатаПотребности
				И ТаблицаИсточник[Индекс].Заказ = ТаблицаИсточник[Индекс-1].Заказ
				И ТаблицаИсточник[Индекс].Проект = ТаблицаИсточник[Индекс-1].Проект Тогда
				ТаблицаИсточник.Удалить(Индекс);
				
			Иначе
				
				Индекс = Индекс + 1;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры // СложениеОбъединениеИсточников()

Функция СкорректироватьПотребности(ТаблицаПотребности)
	
	// Корректировка плана потребности с учетом резервов по заказам покупателей и внутренним заказам
	
	// Резервы по заказам покупателей и внутренним заказам
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТоварыВРезервеНаСкладахОстатки.Номенклатура КАК Номенклатура,
	|	ТоварыВРезервеНаСкладахОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ТоварыВРезервеНаСкладахОстатки.ДокументРезерва КАК ДокументРезерва,
	|	ТоварыВРезервеНаСкладахОстатки.КоличествоОстаток КАК ОстатокРезерва
	|
	|ИЗ
	|	РегистрНакопления.ТоварыВРезервеНаСкладах.Остатки(&ДатаДокумента, ДокументРезерва ССЫЛКА Документ.ЗаказПокупателя) КАК ТоварыВРезервеНаСкладахОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТоварыВРезервеНаСкладахОстатки.Номенклатура КАК Номенклатура,
	|	ТоварыВРезервеНаСкладахОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ТоварыВРезервеНаСкладахОстатки.ДокументРезерва КАК ДокументРезерва,
	|	ТоварыВРезервеНаСкладахОстатки.КоличествоОстаток КАК ОстатокРезерва
	|
	|ИЗ
	|	РегистрНакопления.ТоварыВРезервеНаСкладах.Остатки(&ДатаДокумента, ДокументРезерва ССЫЛКА Документ.ВнутреннийЗаказ) КАК ТоварыВРезервеНаСкладахОстатки");
	
	Запрос.УстановитьПараметр("ДатаДокумента", Дата);
	
	РезультатЗапросаРезервыПоЗаказам = Запрос.Выполнить();
	
	Если НЕ РезультатЗапросаРезервыПоЗаказам.Пустой() Тогда
		
		ВыборкаРезервыПоЗаказам = РезультатЗапросаРезервыПоЗаказам.Выбрать();
		
		Пока ВыборкаРезервыПоЗаказам.Следующий() Цикл
		
			// Корректировка товаров
			ОстатокРезерваПоЗаказу = ВыборкаРезервыПоЗаказам.ОстатокРезерва;
			НайденныеСтрокиПотребности = ТаблицаПотребности.НайтиСтроки(Новый Структура("Заказ, Номенклатура, ХарактеристикаНоменклатуры, Тара", ВыборкаРезервыПоЗаказам.ДокументРезерва, ВыборкаРезервыПоЗаказам.Номенклатура, ВыборкаРезервыПоЗаказам.ХарактеристикаНоменклатуры, Ложь));
			
			Для каждого НайденнаяСтрокаПотребности Из НайденныеСтрокиПотребности Цикл
				
				Если ОстатокРезерваПоЗаказу = 0 Тогда
					
					Прервать;
					
				КонецЕсли;
				
				Если НайденнаяСтрокаПотребности.Количество > ОстатокРезерваПоЗаказу Тогда
					
					НайденнаяСтрокаПотребности.Количество = НайденнаяСтрокаПотребности.Количество - ОстатокРезерваПоЗаказу;
					ОстатокРезерваПоЗаказу = 0;
					
				Иначе
					
					ОстатокРезерваПоЗаказу = ОстатокРезерваПоЗаказу - НайденнаяСтрокаПотребности.Количество;
					ТаблицаПотребности.Удалить(НайденнаяСтрокаПотребности);
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если ОстатокРезерваПоЗаказу > 0 Тогда
				
				// Корректировка тары
				НайденныеСтрокиПотребности = ТаблицаПотребности.НайтиСтроки(Новый Структура("Заказ, Номенклатура, ХарактеристикаНоменклатуры, Тара", ВыборкаРезервыПоЗаказам.ДокументРезерва, ВыборкаРезервыПоЗаказам.Номенклатура, ВыборкаРезервыПоЗаказам.ХарактеристикаНоменклатуры, Истина));
				
				Для каждого НайденнаяСтрокаПотребности Из НайденныеСтрокиПотребности Цикл
					
					Если ОстатокРезерваПоЗаказу = 0 Тогда
						
						Прервать;
						
					КонецЕсли;
					
					Если НайденнаяСтрокаПотребности.Количество > ОстатокРезерваПоЗаказу Тогда
						
						НайденнаяСтрокаПотребности.Количество = НайденнаяСтрокаПотребности.Количество - ОстатокРезерваПоЗаказу;
						ОстатокРезерваПоЗаказу = 0;
						
					Иначе
						
						ОстатокРезерваПоЗаказу = ОстатокРезерваПоЗаказу - НайденнаяСтрокаПотребности.Количество;
						ТаблицаПотребности.Удалить(НайденнаяСтрокаПотребности);
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Остатки без резервов
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура,
	|	ТоварыНаСкладахОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ТоварыНаСкладахОстатки.КоличествоОстаток - ЕСТЬNULL(ТоварыВРезервеНаСкладахОстатки.КоличествоОстаток, 0) КАК ОстатокНоменклатуры
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки(&ДатаДокумента, ) КАК ТоварыНаСкладахОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыВРезервеНаСкладах.Остатки(&ДатаДокумента, ) КАК ТоварыВРезервеНаСкладахОстатки
	|		ПО ТоварыНаСкладахОстатки.Номенклатура = ТоварыВРезервеНаСкладахОстатки.Номенклатура
	|			И ТоварыНаСкладахОстатки.ХарактеристикаНоменклатуры = ТоварыВРезервеНаСкладахОстатки.ХарактеристикаНоменклатуры
	|ГДЕ
	|	ТоварыНаСкладахОстатки.КоличествоОстаток - ЕСТЬNULL(ТоварыВРезервеНаСкладахОстатки.КоличествоОстаток, 0) > 0");
	
	Запрос.УстановитьПараметр("ДатаДокумента", Дата);
	ТаблицаОстатковБезРезервов = Запрос.Выполнить().Выгрузить();
	
	// Деление остатков на товары и тару
	ЗапросОстаткиТара = Новый Запрос(
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры,
	|	СУММА(ВложенныйЗапрос.КоличествоОстатокПолученные - ВложенныйЗапрос.КоличествоОстатокПереданные) КАК Количество
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыПолученныеОстатки.Номенклатура КАК Номенклатура,
	|		ТоварыПолученныеОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		ТоварыПолученныеОстатки.КоличествоОстаток КАК КоличествоОстатокПолученные,
	|		0 КАК КоличествоОстатокПереданные
	|	ИЗ
	|		РегистрНакопления.ТоварыПолученные.Остатки(&ДатаДокумента, СтатусПолучения = ЗНАЧЕНИЕ(Перечисление.СтатусыПолученияПередачиТоваров.ВозвратнаяТара)) КАК ТоварыПолученныеОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТоварыПереданныеОстатки.Номенклатура КАК Номенклатура,
	|		ТоварыПереданныеОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		0 КАК КоличествоОстатокПолученные,
	|		ТоварыПереданныеОстатки.КоличествоОстаток КАК КоличествоОстатокПереданные
	|	ИЗ
	|		РегистрНакопления.ТоварыПереданные.Остатки(&ДатаДокумента, СтатусПередачи = ЗНАЧЕНИЕ(Перечисление.СтатусыПолученияПередачиТоваров.ВозвратнаяТара)) КАК ТоварыПереданныеОстатки) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры");
	
	ЗапросОстаткиТара.УстановитьПараметр("ДатаДокумента", Дата);
	ОстаткиТарыДополнительные = ЗапросОстаткиТара.Выполнить().Выгрузить();
	ОстаткиТарыДополнительные.Индексы.Добавить("Номенклатура, ХарактеристикаНоменклатуры");
	
	ТаблицаОстатковБезРезервовКонечная = Новый ТаблицаЗначений;
	ТаблицаОстатковБезРезервовКонечная.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаОстатковБезРезервовКонечная.Колонки.Добавить("ХарактеристикаНоменклатуры", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаОстатковБезРезервовКонечная.Колонки.Добавить("ОстатокНоменклатуры", ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(15,3));
	ТаблицаОстатковБезРезервовКонечная.Колонки.Добавить("Тара", Новый ОписаниеТипов("Булево"));
	ТаблицаОстатковБезРезервовКонечная.Индексы.Добавить("Номенклатура, ХарактеристикаНоменклатуры, Тара");
	
	Для каждого СтрокаОстатковБезРезервов Из ТаблицаОстатковБезРезервов Цикл
	
		СтрокиТары = ОстаткиТарыДополнительные.НайтиСтроки(Новый Структура("Номенклатура, ХарактеристикаНоменклатуры", СтрокаОстатковБезРезервов.Номенклатура, СтрокаОстатковБезРезервов.ХарактеристикаНоменклатуры));
		
		Если СтрокиТары.Количество() = 0 Тогда
			
			НоваяСтрока = ТаблицаОстатковБезРезервовКонечная.Добавить();
			НоваяСтрока.Номенклатура = СтрокаОстатковБезРезервов.Номенклатура;
			НоваяСтрока.ХарактеристикаНоменклатуры = СтрокаОстатковБезРезервов.ХарактеристикаНоменклатуры;
			НоваяСтрока.ОстатокНоменклатуры = СтрокаОстатковБезРезервов.ОстатокНоменклатуры;
			НоваяСтрока.Тара = Ложь;
			Продолжить;
			
		КонецЕсли;
		
		
		СтрокаТары = СтрокиТары[0];
		
		Если СтрокаТары.Количество <= 0 Тогда
			
			НоваяСтрока = ТаблицаОстатковБезРезервовКонечная.Добавить();
			НоваяСтрока.Номенклатура = СтрокаОстатковБезРезервов.Номенклатура;
			НоваяСтрока.ХарактеристикаНоменклатуры = СтрокаОстатковБезРезервов.ХарактеристикаНоменклатуры;
			НоваяСтрока.ОстатокНоменклатуры = СтрокаОстатковБезРезервов.ОстатокНоменклатуры;
			НоваяСтрока.Тара = Ложь;
			
		ИначеЕсли СтрокаТары.Количество >= СтрокаОстатковБезРезервов.ОстатокНоменклатуры Тогда
			
			НоваяСтрока = ТаблицаОстатковБезРезервовКонечная.Добавить();
			НоваяСтрока.Номенклатура = СтрокаОстатковБезРезервов.Номенклатура;
			НоваяСтрока.ХарактеристикаНоменклатуры = СтрокаОстатковБезРезервов.ХарактеристикаНоменклатуры;
			НоваяСтрока.ОстатокНоменклатуры = СтрокаОстатковБезРезервов.ОстатокНоменклатуры;
			НоваяСтрока.Тара = Истина;
			
		ИначеЕсли СтрокаТары.Количество < СтрокаОстатковБезРезервов.ОстатокНоменклатуры Тогда
			
			НоваяСтрока = ТаблицаОстатковБезРезервовКонечная.Добавить();
			НоваяСтрока.Номенклатура = СтрокаОстатковБезРезервов.Номенклатура;
			НоваяСтрока.ХарактеристикаНоменклатуры = СтрокаОстатковБезРезервов.ХарактеристикаНоменклатуры;
			НоваяСтрока.ОстатокНоменклатуры = СтрокаТары.Количество;
			НоваяСтрока.Тара = Истина;
			НоваяСтрока = ТаблицаОстатковБезРезервовКонечная.Добавить();
			НоваяСтрока.Номенклатура = СтрокаОстатковБезРезервов.Номенклатура;
			НоваяСтрока.ХарактеристикаНоменклатуры = СтрокаОстатковБезРезервов.ХарактеристикаНоменклатуры;
			НоваяСтрока.ОстатокНоменклатуры = СтрокаОстатковБезРезервов.ОстатокНоменклатуры - СтрокаТары.Количество;
			НоваяСтрока.Тара = Ложь;
			
		КонецЕсли;
	
	КонецЦикла;
	
	// Теперь скорректируем остатки товарами к передаче со складов
	
	ЗапросТоварыКПередаче = Новый Запрос(
	"ВЫБРАТЬ
	|	ТоварыКПередачеСоСкладовОстатки.Номенклатура КАК Номенклатура,
	|	ТоварыКПередачеСоСкладовОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ТоварыКПередачеСоСкладовОстатки.КоличествоОстаток КАК КоличествоОстатокРезерва
	|ИЗ
	|	РегистрНакопления.ТоварыКПередачеСоСкладов.Остатки(&ДатаДокумента, ) КАК ТоварыКПередачеСоСкладовОстатки");
	
	ЗапросТоварыКПередаче.УстановитьПараметр("ДатаДокумента", Дата);
	ТаблицаТоваровКПередаче = ЗапросТоварыКПередаче.Выполнить().Выгрузить();
	
	Для каждого СтрокаТаблицы Из ТаблицаТоваровКПередаче Цикл
		
		ОстатокКПередаче = СтрокаТаблицы.КоличествоОстатокРезерва;
		
		СтрокиОстатков = ТаблицаОстатковБезРезервовКонечная.НайтиСтроки(Новый Структура("Номенклатура, ХарактеристикаНоменклатуры, Тара", СтрокаТаблицы.Номенклатура, СтрокаТаблицы.ХарактеристикаНоменклатуры, Истина));
		
		Для каждого СтрокаОстатков Из СтрокиОстатков Цикл
			
			Если ОстатокКПередаче = 0 Тогда
				
				Прервать;
				
			КонецЕсли;
			
			Если СтрокаОстатков.ОстатокНоменклатуры >= ОстатокКПередаче Тогда
				
				СтрокаОстатков.ОстатокНоменклатуры = СтрокаОстатков.ОстатокНоменклатуры - ОстатокКПередаче;
				ОстатокКПередаче = 0;
				
			Иначе
				
				ОстатокКПередаче = ОстатокКПередаче - СтрокаОстатков.ОстатокНоменклатуры;
				ТаблицаОстатковБезРезервовКонечная.Удалить(СтрокаОстатков);
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ОстатокКПередаче > 0 Тогда
			
			СтрокиОстатков = ТаблицаОстатковБезРезервовКонечная.НайтиСтроки(Новый Структура("Номенклатура, ХарактеристикаНоменклатуры, Тара", СтрокаТаблицы.Номенклатура, СтрокаТаблицы.ХарактеристикаНоменклатуры, Ложь));
			
			Для каждого СтрокаОстатков Из СтрокиОстатков Цикл
				
				Если ОстатокКПередаче = 0 Тогда
					
					Прервать;
					
				КонецЕсли;
				
				Если СтрокаОстатков.ОстатокНоменклатуры >= ОстатокКПередаче Тогда
					
					СтрокаОстатков.ОстатокНоменклатуры = СтрокаОстатков.ОстатокНоменклатуры - ОстатокКПередаче;
					ОстатокКПередаче = 0;
					
				Иначе
					
					ОстатокКПередаче = ОстатокКПередаче - СтрокаОстатков.ОстатокНоменклатуры;
					ТаблицаОстатковБезРезервовКонечная.Удалить(СтрокаОстатков);
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
	
	КонецЦикла;
	
	// Скорректируем план потребности с учетом остатков на складе
	ТаблицаПотребности.Сортировать("ДатаПотребности ВОЗР, Заказ ВОЗР");
	
	Для каждого СтрокаТаблицыОстатков Из ТаблицаОстатковБезРезервовКонечная Цикл
		
		ОстатокТовара = СтрокаТаблицыОстатков.ОстатокНоменклатуры;
		НайденныеСтрокиПотребности = ТаблицаПотребности.НайтиСтроки(Новый Структура("Номенклатура, ХарактеристикаНоменклатуры, Тара", СтрокаТаблицыОстатков.Номенклатура, СтрокаТаблицыОстатков.ХарактеристикаНоменклатуры, СтрокаТаблицыОстатков.Тара));
		
		Если НайденныеСтрокиПотребности.Количество() > 0 И НЕ ЗначениеЗаполнено(НайденныеСтрокиПотребности[0].Заказ) Тогда
			
			НайденныеСтрокиПотребности.Добавить(НайденныеСтрокиПотребности[0]);
			НайденныеСтрокиПотребности.Удалить(0);
			
		КонецЕсли;
		
		Для каждого НайденнаяСтрокаПотребности Из НайденныеСтрокиПотребности Цикл
			
			Если ОстатокТовара = 0 Тогда
				
				Прервать;
				
			КонецЕсли;
			
			Если НайденнаяСтрокаПотребности.Количество > ОстатокТовара Тогда
				
				НайденнаяСтрокаПотребности.Количество = НайденнаяСтрокаПотребности.Количество - ОстатокТовара;
				ОстатокТовара = 0;
				
			Иначе
				
				ОстатокТовара = ОстатокТовара - НайденнаяСтрокаПотребности.Количество;
				ТаблицаПотребности.Удалить(НайденнаяСтрокаПотребности);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Уберем отрицательные количества потребности
	Индекс = 0;
	
	Пока Истина Цикл
	
		Если Индекс > ТаблицаПотребности.Количество() - 1 Тогда
			
			Прервать;
			
		КонецЕсли;
		
		СтрокаПотребности = ТаблицаПотребности[Индекс];
		
		Если СтрокаПотребности.Количество <= 0 Тогда
			
			ТаблицаПотребности.Удалить(СтрокаПотребности);
			Продолжить;
			
		КонецЕсли;
		
		Индекс = Индекс + 1;
	
	КонецЦикла;
	
	Возврат ТаблицаПотребности;
	
КонецФункции // СкорректироватьПотребности()

Процедура РаспределитьПоНоменклатуре(ТаблицаПриемник, ТаблицаИсточник)

	ИндексСтроки = 0;

	Пока ИндексСтроки < ТаблицаИсточник.Количество() Цикл
		
		Если ТипЗнч(ТаблицаИсточник[ИндексСтроки].Номенклатура) = Тип("СправочникСсылка.НоменклатурныеГруппы") Тогда

			ТаблицаРезультатРаспределения = Новый ТаблицаЗначений;

			Коэффициенты = Новый Массив();
			Значения     = Новый Соответствие();

			Значения.Вставить("Количество", ТаблицаИсточник[ИндексСтроки].Количество * ТаблицаИсточник[ИндексСтроки].Номенклатура.ЕдиницаХраненияОстатков.Коэффициент);

			Номенклатура = Справочники.Номенклатура.Выбрать(,, Новый Структура("НоменклатурнаяГруппа", ТаблицаИсточник[ИндексСтроки].Номенклатура));
			
			Пока Номенклатура.Следующий() Цикл
				
				Если Номенклатура.ВесовойКоэффициентВхождения > 0 Тогда
					
					УправлениеПланированием.ДополнитьТаблицу(ТаблицаРезультатРаспределения, ТаблицаИсточник, , ИндексСтроки);
	                ТаблицаРезультатРаспределения[ТаблицаРезультатРаспределения.Количество() - 1].Номенклатура = Номенклатура.Ссылка;
					Коэффициенты.Добавить(Номенклатура.ВесовойКоэффициентВхождения);
					
				КонецЕсли;
				
			КонецЦикла;

			ТаблицаИсточник.Удалить(ТаблицаИсточник[ИндексСтроки]);
			
			Строки = Новый Массив();
			Для каждого Строка из ТаблицаРезультатРаспределения Цикл
				
				Строки.Добавить(Строка);
				
			КонецЦикла;
			
			Распределить(Строки, Коэффициенты, Значения);
			
			Индекс = 0;
			
			Пока Индекс < ТаблицаРезультатРаспределения.Количество() Цикл
				
				Если ТаблицаРезультатРаспределения[Индекс].Количество <= 0 Тогда
					
					ТаблицаРезультатРаспределения.Удалить(Индекс);
					
				Иначе
					
					ТаблицаРезультатРаспределения[Индекс].Количество = ТаблицаРезультатРаспределения[Индекс].Количество / ТаблицаРезультатРаспределения[Индекс].Номенклатура.ЕдиницаХраненияОстатков.Коэффициент;
					Индекс = Индекс + 1;
					
				КонецЕсли;
				
			КонецЦикла;
			
			УправлениеПланированием.ДополнитьТаблицу(ТаблицаПриемник, ТаблицаРезультатРаспределения);
			
		Иначе
			
			ИндексСтроки = ИндексСтроки + 1;
			
		КонецЕсли;
		
	КонецЦикла;

	УправлениеПланированием.ДополнитьТаблицу(ТаблицаПриемник, ТаблицаИсточник);
	
КонецПроцедуры // РаспределитьПоНоменклатуре()

Процедура Распределить(Строки, Коэффициенты, Значения, ДополнятьЗначения = Ложь)

	СуммаКоэффициентов = 0;
	
	Для каждого Коэффициент из Коэффициенты Цикл
		
		СуммаКоэффициентов = СуммаКоэффициентов + Коэффициент;
		
	КонецЦикла;
	
	Для Индекс = 0 по Строки.Количество() - 1 Цикл
		
		Для каждого Значение из Значения Цикл
			
			Если СуммаКоэффициентов = 0 Тогда
				
				Строки[Индекс][Значение.Ключ] = 0;
				
			Иначе
				
				Если Индекс = Строки.Количество() - 1 Тогда
					
					Строки[Индекс][Значение.Ключ] = ?(ДополнятьЗначения, Строки[Индекс][Значение.Ключ], 0) + Значение.Значение;
					Значения.Вставить(Значение.Ключ, 0);
					
				Иначе
					
					Строки[Индекс][Значение.Ключ] = ?(ДополнятьЗначения, Строки[Индекс][Значение.Ключ], 0) + Окр(Значение.Значение * Коэффициенты[Индекс] / СуммаКоэффициентов, 2);
					
					Если Значение.Значение > 0 Тогда
						
						Значения.Вставить(Значение.Ключ, Значение.Значение - Строки[Индекс][Значение.Ключ]);
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		СуммаКоэффициентов = СуммаКоэффициентов - Коэффициенты[Индекс];
		
	КонецЦикла;

КонецПроцедуры // Распределить()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Процедура ПроверкаРеквизитов(Отказ, Заголовок)
	
	РеквизитыТабПотребности = "ДатаПотребности, Номенклатура, Количество, ЕдиницаИзмерения";
	
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Потребности", Новый Структура(РеквизитыТабПотребности), Отказ, Заголовок);

КонецПроцедуры // ПроверкаРеквизитов()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если мУдалятьДвижения Тогда
		
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
		
	КонецЕсли;

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);
	ПроверкаРеквизитов(Отказ, Заголовок);
	
	Если Отказ Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(&ДатаДокумента, ДЕНЬ) КАК Период,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры,
	|	ВложенныйЗапрос.ДатаПотребности,
	|	ВложенныйЗапрос.Заказ,
	|	ВложенныйЗапрос.Проект,
	|	ВложенныйЗапрос.ТоварТара,
	|	СУММА(ВложенныйЗапрос.Количество) КАК Количество
	|ИЗ
	|	(ВЫБРАТЬ
	|		ФормированиеПотребностейПотребности.Номенклатура КАК Номенклатура,
	|		ФормированиеПотребностейПотребности.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		ФормированиеПотребностейПотребности.ДатаПотребности КАК ДатаПотребности,
	|		ФормированиеПотребностейПотребности.Заказ КАК Заказ,
	|		ФормированиеПотребностейПотребности.Проект КАК Проект,
	|		ФормированиеПотребностейПотребности.ТоварТара КАК ТоварТара,
	|		ФормированиеПотребностейПотребности.Количество * ФормированиеПотребностейПотребности.Коэффициент / ФормированиеПотребностейПотребности.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК Количество
	|	ИЗ
	|		Документ.ФормированиеПотребностей.Потребности КАК ФормированиеПотребностейПотребности
	|	ГДЕ
	|		ФормированиеПотребностейПотребности.Ссылка = &Ссылка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		КалендарныеПотребностиВНоменклатуре.Номенклатура КАК Номенклатура,
	|		КалендарныеПотребностиВНоменклатуре.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		КалендарныеПотребностиВНоменклатуре.ДатаПотребности КАК ДатаПотребности,
	|		КалендарныеПотребностиВНоменклатуре.Заказ КАК Заказ,
	|		КалендарныеПотребностиВНоменклатуре.Проект КАК Проект,
	|		КалендарныеПотребностиВНоменклатуре.ТоварТара КАК ТоварТара,
	|		0 КАК Количество
	|	ИЗ
	|		РегистрСведений.КалендарныеПотребностиВНоменклатуре.СрезПоследних(&ДатаДокумента, Количество > 0 И Период < НАЧАЛОПЕРИОДА(&ДатаДокумента, ДЕНЬ)) КАК КалендарныеПотребностиВНоменклатуре) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.ДатаПотребности,
	|	ВложенныйЗапрос.ТоварТара,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры,
	|	ВложенныйЗапрос.Проект,
	|	ВложенныйЗапрос.Заказ");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДатаДокумента", Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
		
			НовоеДвижение = Движения.КалендарныеПотребностиВНоменклатуре.Добавить();
			ЗаполнитьЗначенияСвойств(НовоеДвижение, Выборка);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	мУдалятьДвижения = НЕ ЭтоНовый();

КонецПроцедуры // ПередЗаписью

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);

КонецПроцедуры // ОбработкаУдаленияПроведения

