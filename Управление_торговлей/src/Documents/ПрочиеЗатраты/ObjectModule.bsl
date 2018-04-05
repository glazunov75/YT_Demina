Перем мУдалятьДвижения;

// Строки, хранят реквизиты имеющие смысл только для бух. учета и упр. соответственно
// в случае если документ не отражается в каком-то виде учета, делаются невидимыми
Перем мСтрокаРеквизитыБухУчета Экспорт; // (Регл)
Перем мСтрокаРеквизитыУпрУчета Экспорт; // (Упр)
Перем мСтрокаРеквизитыНалУчета Экспорт; // (Регл)

Перем мВалютаРегламентированногоУчета Экспорт;
Перем мВалютаУправленческогоУчета Экспорт;

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

// Процедура проверяет правильность заполнения реквизитов документа
//
Процедура ПроверкаРеквизитов(Отказ, Заголовок) Экспорт

	РеквизитыШапки = "Подразделение";

	РеквизитыТЧ = "СтатьяЗатрат, Сумма";

	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, Новый Структура(РеквизитыШапки), Отказ, Заголовок);
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Затраты", Новый Структура(РеквизитыТЧ), Отказ, Заголовок);

КонецПроцедуры // ПроверкаРеквизитов()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура формирования движений регистров
//
Процедура ФормированиеДвижений(СтруктураШапкиДокумента)

	ФормированиеДвиженийУпр(СтруктураШапкиДокумента);

КонецПроцедуры // ФормированиеДвижений()

// Процедура формирования движений упр. регистров
//
Процедура ФормированиеДвиженийУпр(СтруктураШапкиДокумента)

	СтруктДопПараметры = Новый Структура;
	СтруктДопПараметры.Вставить("ИмяРеквЗаказ",           "Заказ");
	СтруктДопПараметры.Вставить("Подразделение",   СтруктураШапкиДокумента.Подразделение);
	СтруктДопПараметры.Вставить("ЕстьНДС",         Ложь);

	УправлениеЗатратами.ДвиженияПоПрочимЗатратамУпр( ЭтотОбъект, Затраты, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета, СтруктДопПараметры);

КонецПроцедуры // ФормированиеДвиженийУпр()

// Дополняет полями, нужными для упр. учета.
//
Процедура ДополнитьДеревоПолейЗапросаПоШапкеУпр(ДеревоПолейЗапросаПоШапке)

	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Константы", "ВалютаУправленческогоУчета"    , "ВалютаУправленческогоУчета");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Константы", "КурсВалютыУправленческогоУчета", "КурсВалютыУправленческогоУчета");
	
КонецПроцедуры // ДополнитьДеревоПолейЗапросаПоШапкеУпр()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаПроведения"
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// Дополним полями, нужными для регл. и упр. учета
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначения.СформироватьДеревоПолейЗапросаПоШапке();
	ДополнитьДеревоПолейЗапросаПоШапкеУпр(ДеревоПолейЗапросаПоШапке);

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);
	СтруктураШапкиДокумента.Вставить("ОтражатьВУправленческомУчете", Истина);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);
	
	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	ОбщегоНазначения.ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	ПроверкаРеквизитов(Отказ, Заголовок);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Формирование движений регистров, бухгалтерских и налоговых проводок.
	ФормированиеДвижений(СтруктураШапкиДокумента);
	
КонецПроцедуры	// ОбработкаПроведения()


// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	мУдалятьДвижения = НЕ ЭтоНовый();

КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);

КонецПроцедуры

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");
мВалютаУправленческогоУчета     = глЗначениеПеременной("ВалютаУправленческогоУчета");
