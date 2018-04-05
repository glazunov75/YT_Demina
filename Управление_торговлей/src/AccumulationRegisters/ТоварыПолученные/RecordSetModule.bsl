Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

// Выполняет приход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьПриход() Экспорт

	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Приход);

КонецПроцедуры // ВыполнитьПриход()

// Выполняет расход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьРасход() Экспорт

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

// Процедура контролирует остаток по данному регистру по переданному документу
// и его табличной части. В случае недостатка товаров выставляется флаг отказа и 
// выдается сообщение.
//
// Параметры:
//  ДокументОбъект    - объект проводимого документа, 
//  ИмяТабличнойЧасти - строка, имя табличной части, которая проводится по регистру, 
//  СтруктураШапкиДокумента - структура, содержащая значения "через точку" ссылочных реквизитов по шапке документа,
//  Отказ             - флаг отказа в проведении,
//  Заголовок         - строка, заголовок сообщения об ошибке проведения.
//
Процедура КонтрольОстатков(ДокументОбъект, ИмяТабличнойЧасти, СтруктураШапкиДокумента, СтатусПолучения, Отказ, Заголовок) Экспорт
	
	Если ДокументОбъект[ИмяТабличнойЧасти].Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеДокумента = ДокументОбъект.Метаданные();
	ИмяДокумента        = МетаданныеДокумента.Имя;
	ИмяТаблицы          = ИмяДокумента + "." + СокрЛП(ИмяТабличнойЧасти);
	ЕстьСерия           = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("СерияНоменклатуры", МетаданныеДокумента, ИмяТабличнойЧасти);
	ЕстьХарактеристика  = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("ХарактеристикаНоменклатуры", МетаданныеДокумента, ИмяТабличнойЧасти);
	ЕстьКоэффициент     = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("Коэффициент", МетаданныеДокумента, ИмяТабличнойЧасти);

	// Текст вложенного запроса, ограничивающего номенклатуру при получении остатков
	ТекстЗапросаСписокНоменклатуры = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Номенклатура 
		|ИЗ
		|	Документ." + ИмяТаблицы + "
		|ГДЕ
		|	Ссылка = &ДокументСсылка";

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",     СтруктураШапкиДокумента.Ссылка);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", СтруктураШапкиДокумента.ДоговорКонтрагента); 
	Если ЗначениеЗаполнено(СтруктураШапкиДокумента.Сделка) Тогда
		Запрос.УстановитьПараметр("Сделка", СтруктураШапкиДокумента.Сделка);
	Иначе
		Запрос.УстановитьПараметр("Сделка", Неопределено);
	КонецЕсли;
	Запрос.УстановитьПараметр("СтатусПолучения",    СтатусПолучения);

	ТекстЗапроса = "
	|ВЫБРАТЬ // Запрос, контролирующий остатки на складах
	|	Док.Номенклатура.Представление                         КАК НоменклатураПредставление,
	|	Док.Номенклатура.ЕдиницаХраненияОстатков.Представление КАК ЕдиницаХраненияОстатковПредставление,
	|   %ПОЛЕ_Док_Характеристика%                              КАК ХарактеристикаНоменклатуры,
	|	ПРЕДСТАВЛЕНИЕ(%ПОЛЕ_Док_Характеристика%)               КАК ХарактеристикаНоменклатурыПредставление,
	|   %ПОЛЕ_Док_Серия%                                       КАК СерияНоменклатуры,
	|	ПРЕДСТАВЛЕНИЕ(%ПОЛЕ_Док_Серия%)                        КАК СерияНоменклатурыПредставление,
	|	%ПОЛЕ_Док_Количество%                                  КАК ДокументКоличество,
	|	ЕСТЬNULL(МАКСИМУМ(Остатки.КоличествоОстаток), 0)       КАК ОстатокКоличество
	|ИЗ 
	|	Документ." + ИмяТаблицы + " КАК Док
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ТоварыПолученные.Остатки(,
	|		Номенклатура В (%ВыборкаПоНоменклатуре%)
	|		И ДоговорКонтрагента = &ДоговорКонтрагента
	|		И Сделка             = &Сделка
	|		И СтатусПолучения    = &СтатусПолучения
	|	) КАК Остатки
	|ПО 
	|	Док.Номенклатура                = Остатки.Номенклатура
	|   // СОЕДИНЕНИЕ_Характеристика_Остатки
	|   // СОЕДИНЕНИЕ_Серия_Остатки
	|
	|ГДЕ
	|	Док.Ссылка  =  &ДокументСсылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Док.Номенклатура,
	|   %ПОЛЕ_Док_Характеристика%,
	|   %ПОЛЕ_Док_Серия%
	|
	|ИМЕЮЩИЕ
	|	ЕСТЬNULL(МАКСИМУМ(Остатки.КоличествоОстаток), 0) < %ПОЛЕ_Док_Количество%
	|
	|ДЛЯ ИЗМЕНЕНИЯ
	|	РегистрНакопления.ТоварыПолученные.Остатки // Блокирующие чтение таблицы остатков регистра для разрешения коллизий многопользовательской работы
	|";

	Если ЕстьХарактеристика Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПОЛЕ_Док_Характеристика%",            "Док.ХарактеристикаНоменклатуры");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// СОЕДИНЕНИЕ_Характеристика_Остатки", " И Док.ХарактеристикаНоменклатуры = Остатки.ХарактеристикаНоменклатуры");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПОЛЕ_Док_Характеристика%",            "Неопределено");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// СОЕДИНЕНИЕ_Характеристика_Остатки", "");
	КонецЕсли;
	Если ЕстьСерия Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПОЛЕ_Док_Серия%",            "Док.СерияНоменклатуры");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// СОЕДИНЕНИЕ_Серия_Остатки", " И Док.СерияНоменклатуры = Остатки.СерияНоменклатуры");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПОЛЕ_Док_Серия%",            "Неопределено");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// СОЕДИНЕНИЕ_Серия_Остатки", "");
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПОЛЕ_Док_Количество%", ?(ЕстьКоэффициент,
		"СУММА(Док.Количество * Док.Коэффициент / Док.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент)",
		"СУММА(Док.Количество)"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ВыборкаПоНоменклатуре%", ТекстЗапросаСписокНоменклатуры);
	
	Запрос.Текст = ТекстЗапроса;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		СтрокаСообщения = "Остатка " + 
			УправлениеЗапасами.ПредставлениеНоменклатуры(Выборка.НоменклатураПредставление, 
									  ?(ЕстьХарактеристика, Выборка.ХарактеристикаНоменклатурыПредставление, ""),
									  ?(ЕстьСерия, Выборка.СерияНоменклатурыПредставление, "")) +
			" полученного по договору """ + СокрЛП(СтруктураШапкиДокумента.ДоговорКонтрагента) + ?(НЕ ЗначениеЗаполнено(СтруктураШапкиДокумента.Сделка), "",
			" и по сделке " + СокрЛП(СтруктураШапкиДокумента.Сделка)) +
			""" недостаточно.";

		УправлениеЗапасами.ОшибкаНетОстатка(СтрокаСообщения, Выборка.ОстатокКоличество, Выборка.ДокументКоличество,
			Выборка.ЕдиницаХраненияОстатковПредставление, Отказ, Заголовок);

	КонецЦикла;

КонецПроцедуры // КонтрольОстатков()
