Перем мУдалятьДвижения;

Перем мВалютаРегламентированногоУчета Экспорт;

// Хранит структуру, содержащую параметры для определения договора, доступного в данном документе:
//    список допустимых видов договоров;
//    список допустимых способов ведения взаиморасчетов.
Перем мСтруктураПараметровДляПолученияДоговора Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

// Функция формирует табличный документ с печатной формой накладной,
// разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьПечатьПереоценкиТоваровПринятых()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	ДоговорКонтрагента,
	|	Контрагент,
	|	Контрагент КАК Поставщик,
	|	Организация,
	|	Организация КАК Покупатель,
	|	ВалютаДокумента,
	|	Товары.(
	|		НомерСтроки,
	|		Номенклатура,
	|		Номенклатура.НаименованиеПолное КАК Товар,
	|		КоличествоМест,
	|		Количество,
	|		ЕдиницаИзмерения.Представление     КАК ЕдиницаИзмерения,
	|		ЕдиницаИзмеренияМест.Представление КАК ЕдиницаИзмеренияМест,
	|		Цена,
	|		Сумма,
	|		ЦенаСтарая,
	|		СуммаСтарая,
	|		ХарактеристикаНоменклатуры КАК Характеристика,
	|		СерияНоменклатуры КАК Серия
	|	)
	|ИЗ
	|	Документ.ПереоценкаТоваровПринятыхНаКомиссию КАК ПереоценкаТоваровПринятыхНаКомиссию
	|
	|ГДЕ
	|	ПереоценкаТоваровПринятыхНаКомиссию.Ссылка = &ТекущийДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки
	|";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();
	ВыборкаСтрокТовары = Шапка.Товары.Выбрать();

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПереоценкаТоваровПринятыхНаКомиссию_Накладная";

	Макет = ПолучитьМакет("Накладная");

	// Выводим шапку накладной

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, "Переоценка товаров принятых на комиссию");
	ТабДокумент.Вывести(ОбластьМакета);

	ПредставлениеОрганизации = ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата), "ПолноеНаименование,");
	ПредставлениеКонтрагента = ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Контрагент, Шапка.Дата), "ПолноеНаименование,");

	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	ОбластьМакета.Параметры.ПредставлениеПоставщика = ПредставлениеКонтрагента;
	ОбластьМакета.Параметры.Поставщик = Шапка.Поставщик;
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
	ОбластьМакета.Параметры.ПредставлениеПолучателя = ПредставлениеОрганизации;
	ОбластьМакета.Параметры.Получатель = Шапка.Организация;
	ТабДокумент.Вывести(ОбластьМакета);

	ФлагПечатиМест = (Товары.Итог("КоличествоМест") > 0);

	// Вывести табличную часть
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы" + ?(ФлагПечатиМест, "Мест", ""));
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Строка" + ?(ФлагПечатиМест, "Мест", ""));

	Пока ВыборкаСтрокТовары.Следующий() Цикл

		Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
			Сообщить("В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.", СтатусСообщения.Важное);
			Продолжить;
		КонецЕсли;

		ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
		ОбластьМакета.Параметры.Товар = ВыборкаСтрокТовары.Товар + ФормированиеПечатныхФорм.ПредставлениеСерий(ВыборкаСтрокТовары);
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;

	// Вывести Итого
	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
	ОбластьМакета.Параметры.ВсегоПоСтарым = ОбщегоНазначения.ФорматСумм(Товары.Итог("СуммаСтарая"));
	ОбластьМакета.Параметры.ВсегоПоНовым  = ОбщегоНазначения.ФорматСумм(Товары.Итог("Сумма"));
	ТабДокумент.Вывести(ОбластьМакета);

	// Вывести подписи
	ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ТабДокумент.Вывести(ОбластьМакета);

	Возврат ТабДокумент;

КонецФункции // ПечатьПечатьПереоценкиТоваровПринятых()

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

	Если ИмяМакета = "Накладная" Тогда
		// Получить экземпляр документа на печать
		ТабДокумент = ПечатьПечатьПереоценкиТоваровПринятых();
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()));

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("Накладная", "Переоценка товаров принятых на комиссию");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

// Процедура выполняет заполнение табличной части принятыми на реализацию,
// но еще нереализованными товарами. Если передан документ основание то
//  заполнение производится по документу основанию, иначе по всем.
//
// Параметры:
//  ДокументОснование - ссылка на документ основание.
//
Процедура ЗаполнитьТоварыУпр(ДокументОснование = Неопределено) Экспорт

	Запрос = Новый Запрос;

	Если РегистрыСведений.УчетнаяПолитика.ПолучитьПоследнее(Дата).ВестиПартионныйУчетПоСкладам Тогда
		ВремСклад = Склад;
	Иначе
		ВремСклад = Справочники.Склады.ПустаяСсылка();
	КонецЕсли;

	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		ИмяДокумента = "ПоступлениеТоваровУслуг";
	ИначеЕсли ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПоступлениеТоваровУслугВНТТ") Тогда
		ИмяДокумента = "ПоступлениеТоваровУслугВНТТ";
	КонецЕсли;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("Склад", ВремСклад);
	Запрос.УстановитьПараметр("ДоговорКонтрагента",  ДоговорКонтрагента);
	Запрос.УстановитьПараметр("СтатусПартии",       Перечисления.СтатусыПартийТоваров.НаКомиссию);
	Запрос.УстановитьПараметр("ДокументОснование",  ДокументОснование);
	
	Если НЕ ЗначениеЗаполнено(Сделка) Тогда
		Запрос.УстановитьПараметр("Сделка",             Неопределено);
	Иначе
		Запрос.УстановитьПараметр("Сделка",             Сделка);
	КонецЕсли;

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Остатки.Номенклатура,
	|	Остатки.ХарактеристикаНоменклатуры,
	|	Остатки.СерияНоменклатуры,
	|	Остатки.ДокументОприходования,
	|	МАКСИМУМ(ВЫБОР КОГДА Остатки.СтоимостьОстаток ЕСТЬ NULL ТОГДА
	|		0
	|	ИНАЧЕ
	|		Остатки.СтоимостьОстаток
	|	КОНЕЦ)                                       КАК СтоимостьОстаток,
	|	МАКСИМУМ(ВЫБОР КОГДА Остатки.КоличествоОстаток ЕСТЬ NULL ТОГДА
	|		0
	|	ИНАЧЕ
	|		Остатки.КоличествоОстаток
	|	КОНЕЦ)                                       КАК КоличествоОстаток,
	|	МАКСИМУМ(ВЫБОР КОГДА Полученные.СуммаВзаиморасчетовОстаток ЕСТЬ NULL ТОГДА
	|		0
	|	ИНАЧЕ
	|		Полученные.СуммаВзаиморасчетовОстаток
	|	КОНЕЦ)                                       КАК СуммаВзаиморасчетовОстаток,
	|	МАКСИМУМ(ВЫБОР КОГДА Полученные.КоличествоОстаток ЕСТЬ NULL ТОГДА
	|		0
	|	ИНАЧЕ
	|		Полученные.КоличествоОстаток
	|	КОНЕЦ)                                       КАК КоличествоПолученных,
	|	Остатки.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаХраненияОстатков
	|ИЗ
	|	РегистрНакопления.ПартииТоваровНаСкладах.Остатки(, 
	|			Склад          = &Склад 
	|			И СтатусПартии = &СтатусПартии
	|" + ?(ЗначениеЗаполнено(ДокументОснование), "
	|			И Номенклатура В (ВЫБРАТЬ РАЗЛИЧНЫЕ Документ." + ИмяДокумента + ".Товары.Номенклатура
	|			                ИЗ Документ." + ИмяДокумента + ".Товары 
	|			                ГДЕ Документ." + ИмяДокумента + ".Товары.Ссылка = &ДокументОснование)
	|			И ДокументОприходования = &ДокументОснование
	|", "       И ДокументОприходования.ДоговорКонтрагента = &ДоговорКонтрагента") + "
	|			                                        ) КАК Остатки
	| "+ ?(НЕ ЗначениеЗаполнено(ДокументОснование), "" ,"	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ." + ИмяДокумента + ".Товары КАК ПоступлениеТоваровУслугТовары
	|	ПО Остатки.Номенклатура = ПоступлениеТоваровУслугТовары.Номенклатура И ПоступлениеТоваровУслугТовары.Ссылка = Остатки.ДокументОприходования" ) + "
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ТоварыПолученные.Остатки(, 
	|			ДоговорКонтрагента = &ДоговорКонтрагента 
	|			И Сделка           = &Сделка
	|" + ?(ЗначениеЗаполнено(ДокументОснование), "
	|			И Номенклатура В (ВЫБРАТЬ РАЗЛИЧНЫЕ Документ." + ИмяДокумента + ".Товары.Номенклатура
	|			                ИЗ Документ." + ИмяДокумента + ".Товары 
	|			                ГДЕ Документ." + ИмяДокумента + ".Товары.Ссылка = &ДокументОснование)", "") + ") КАК Полученные
	|	ПО Остатки.Номенклатура = Полученные.Номенклатура
	|	   И Остатки.ХарактеристикаНоменклатуры = Полученные.ХарактеристикаНоменклатуры
	|	   И Остатки.СерияНоменклатуры = Полученные.СерияНоменклатуры
	|ГДЕ
	|	Остатки.КоличествоОстаток > 0
	|	//И Полученные.КоличествоОстаток > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	Остатки.Номенклатура,
	|	Остатки.ХарактеристикаНоменклатуры,
	|	Остатки.СерияНоменклатуры,
	|	Остатки.ДокументОприходования
	|";

	РезультатЗапроса = Запрос.Выполнить();

	ВалютаУправленческогоУчета          = глЗначениеПеременной("ВалютаУправленческогоУчета");
	СтруктураКурсаУправленческогоУчета  = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаУправленческогоУчета, Дата);
	КурсВалютаУправленческогоУчета      = СтруктураКурсаУправленческогоУчета.Курс;
	КратностьВалютаУправленческогоУчета = СтруктураКурсаУправленческогоУчета.Кратность;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл

		СтрокаТабличнойЧасти = Товары.Добавить();

		СтрокаТабличнойЧасти.Номенклатура               = Выборка.Номенклатура;
		СтрокаТабличнойЧасти.ХарактеристикаНоменклатуры = Выборка.ХарактеристикаНоменклатуры;
		СтрокаТабличнойЧасти.СерияНоменклатуры          = Выборка.СерияНоменклатуры;
		СтрокаТабличнойЧасти.ЕдиницаИзмерения           = Выборка.ЕдиницаХраненияОстатков;
		СтрокаТабличнойЧасти.Коэффициент                = Выборка.ЕдиницаХраненияОстатков.Коэффициент;
		СтрокаТабличнойЧасти.Количество                 = Выборка.КоличествоОстаток;

		Если Выборка.КоличествоПолученных = 0 Тогда
			СтрокаТабличнойЧасти.СуммаСтарая = 0;
		Иначе
			СтрокаТабличнойЧасти.СуммаСтарая = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(
			                                   Выборка.СуммаВзаиморасчетовОстаток * Выборка.КоличествоОстаток / Выборка.КоличествоПолученных,
			                                   ДоговорКонтрагента.ВалютаВзаиморасчетов,
			                                   ВалютаДокумента,
			                                   КурсВзаиморасчетов,
			                                   ЗаполнениеДокументов.КурсДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета),
			                                   КратностьВзаиморасчетов,
			                                   ЗаполнениеДокументов.КратностьДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета));
		КонецЕсли;

		СтрокаТабличнойЧасти.ЦенаСтарая = СтрокаТабличнойЧасти.СуммаСтарая / СтрокаТабличнойЧасти.Количество;
		СтрокаТабличнойЧасти.Сумма      = СтрокаТабличнойЧасти.СуммаСтарая;
		СтрокаТабличнойЧасти.Цена       = СтрокаТабличнойЧасти.ЦенаСтарая;
	КонецЦикла;

КонецПроцедуры // ЗаполнитьТоварыУпр()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Процедура ПодготовитьТаблицуТоваровУпр(ТаблицаТоваров, СтруктураШапкиДокумента)

	// Надо добавить колонки "СуммаУпр"
	ТаблицаТоваров.Колонки.Добавить("СуммаУпр", ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(15,2));

	// Надо заполнить новые колонки.
	Для каждого СтрокаТаблицы Из ТаблицаТоваров Цикл

		Сумма = СтрокаТаблицы.Сумма;

		СтрокаТаблицы.СуммаУпр = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.Сумма, ВалютаДокумента, 
													СтруктураШапкиДокумента.ВалютаУправленческогоУчета,
													СтруктураШапкиДокумента.КурсДокумента, СтруктураШапкиДокумента.КурсВалютыУправленческогоУчета,
													СтруктураШапкиДокумента.КратностьДокумента, СтруктураШапкиДокумента.КратностьВалютыУправленческогоУчета);

	КонецЦикла;

КонецПроцедуры // ПодготовитьТаблицуТоваровУпр()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Товары",
//  СтруктураШапкиДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблица значений.
//
Функция ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента)

	ТаблицаТоваров = РезультатЗапросаПоТоварам.Выгрузить();
	
	Если СтруктураШапкиДокумента.ВалютаВзаиморасчетов <> ВалютаДокумента Тогда
		Для каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
			СтрокаТаблицы.СуммаВзаиморасчетов = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.СуммаВзаиморасчетов, ВалютаДокумента, СтруктураШапкиДокумента.ВалютаВзаиморасчетов,
											СтруктураШапкиДокумента.КурсДокумента, КурсВзаиморасчетов, СтруктураШапкиДокумента.КратностьДокумента, КратностьВзаиморасчетов);
		КонецЦикла;
	КонецЕсли;								
	
	// Вызываем отдельные процедуры подготовки для регл. и упр. учета
	ПодготовитьТаблицуТоваровУпр(ТаблицаТоваров, СтруктураШапкиДокумента);

	Возврат ТаблицаТоваров;

КонецФункции // ПодготовитьТаблицуТоваров()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки( СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = 
		Новый Структура("Организация, ВалютаДокумента, Контрагент, ДоговорКонтрагента, КурсВзаиморасчетов, КратностьВзаиморасчетов");

	// Сделка должна быть заполнена, если учет взаиморасчетов ведется по заказам.
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда

		Если ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам Тогда
			СтруктураОбязательныхПолей.Вставить("Сделка", 
				"По выбранному договору установлен способ ведения взаиморасчетов ""по заказам (счетам)""! 
				|Заполните поле ""Заказ поставщику:""!");
		ИначеЕсли ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам тогда
			СтруктураОбязательныхПолей.Вставить("Сделка", 
				"По выбранному договору установлен способ ведения взаиморасчетов ""по заказам (счетам)""! 
				|Заполните поле ""Счет поставщика:""!");
		КонецЕсли;

	КонецЕсли;

	// Вызовем общую процедуру для проверки проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

	//Организация в документе должна совпадать с организацией, указанной в договоре взаиморасчетов.
	УправлениеВзаиморасчетами.ПроверитьСоответствиеОрганизацииДоговоруВзаиморасчетов(Организация, ДоговорКонтрагента, СтруктураШапкиДокумента.ДоговорОрганизация, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Номенклатура, Количество, Сумма");

	// Вызовем общую процедуру для проверки проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураОбязательныхПолей, Отказ, Заголовок);

	// Здесь услуг быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетУслуг(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

	// Здесь наборов-пакетов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетНаборов(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);
	
	// Здесь наборов0комплектов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетКомплектов(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаПоТоварам          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  ТаблицаПоТаре             - таблица значений, содержащая данные для проведения и проверки ТЧ "Возвратная тара",
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)

	ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	ДвиженияПоРегиструСписанныеТовары(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);


	УчетнаяПолитика = РегистрыСведений.УчетнаяПолитика.ПолучитьПоследнее(Дата);
	
	Если ОтражатьВУправленческомУчете Тогда
		ЗаписьРегистрации = ПринадлежностьПоследовательностям.ПартионныйУчет.Добавить();
		ЗаписьРегистрации.Период = Дата;
	КонецЕсли;

	Если УчетнаяПолитика.СписыватьПартииПриПроведенииДокументов Тогда
		
		УправлениеЗапасамиПартионныйУчет.ДвижениеПартийТоваров(Ссылка, Движения.СписанныеТовары.Выгрузить());

	Иначе
		
		// В неоперативном режиме границы последовательностей сдвигаются назад, если они позже документа.
		Если РежимПроведения = РежимПроведенияДокумента.Неоперативный Тогда
			УправлениеЗапасамиПартионныйУчет.СдвигГраницыПоследовательностиПартионногоУчетаНазад(Дата, Ссылка, Организация);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)

	Если ОтражатьВУправленческомУчете Тогда

		// ТОВАРЫ ПО РЕГИСТРУ ТоварыПолученные.
		НаборДвижений = Движения.ТоварыПолученные;

		// Проверка остатков при оперативном проведении.
		Если РежимПроведения = РежимПроведенияДокумента.Оперативный Тогда
			НаборДвижений.КонтрольОстатков(ЭтотОбъект, "Товары", СтруктураШапкиДокумента, Перечисления.СтатусыПолученияПередачиТоваров.НаКомиссию, Отказ, Заголовок);
		КонецЕсли;
		
		Если НЕ Отказ Тогда
		
			СтруктТаблицДокумента = Новый Структура;
			СтруктТаблицДокумента.Вставить("ТаблицаПоТоварам", ТаблицаПоТоварам);
								
			ТаблицыДанныхДокумента = ОбщегоНазначения.ЗагрузитьТаблицыДокументаВСтруктуру(НаборДвижений, СтруктТаблицДокумента);
									
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "ДоговорКонтрагента", ДоговорКонтрагента);
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "Контрагент",         Контрагент);
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "Организация",        Организация);

			Если ЗначениеЗаполнено(СтруктураШапкиДокумента.Сделка) Тогда
				ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "Сделка", СтруктураШапкиДокумента.Сделка);
			КонецЕсли;

			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "СтатусПолучения",    Перечисления.СтатусыПолученияПередачиТоваров.НаКомиссию);
								
			ОбщегоНазначения.ЗаписатьТаблицыДокументаВРегистр(НаборДвижений, ВидДвиженияНакопления.Расход, ТаблицыДанныхДокумента, Дата);
			
			// Теперь в качестве суммы взаиморасчетов должна выступать колонка "Сумма"
			ТаблицаПоТоварам.Колонки.Удалить(ТаблицаПоТоварам.Колонки.Найти("СуммаВзаиморасчетов"));
			ТаблицаПоТоварам.Колонки.Сумма.Имя = "СуммаВзаиморасчетов";
				
			СтруктТаблицДокумента = Новый Структура;
			СтруктТаблицДокумента.Вставить("ТаблицаПоТоварам", ТаблицаПоТоварам);
								
			ТаблицыДанныхДокумента = ОбщегоНазначения.ЗагрузитьТаблицыДокументаВСтруктуру(НаборДвижений, СтруктТаблицДокумента);
									
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "ДоговорКонтрагента", ДоговорКонтрагента);
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "Контрагент",         Контрагент);
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "Организация",        Организация);

			Если ЗначениеЗаполнено(СтруктураШапкиДокумента.Сделка) Тогда
				ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "Сделка", СтруктураШапкиДокумента.Сделка);
			КонецЕсли;

			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "СтатусПолучения",    Перечисления.СтатусыПолученияПередачиТоваров.НаКомиссию);
								
			ОбщегоНазначения.ЗаписатьТаблицыДокументаВРегистр(НаборДвижений, ВидДвиженияНакопления.Приход, ТаблицыДанныхДокумента, Дата);
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегистрамУпр()

Процедура ДвиженияПоРегиструСписанныеТовары(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)

	// ТОВАРЫ ПО РЕГИСТРУ СписанныеТовары.

	НаборДвижений = Движения.СписанныеТовары;

	// Получим таблицу значений, совпадающую со структурой набора записей регистра.
	ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();

	// Поступление с новой стоимостью (колонка "СтоимостьПоступление")
	ТаблицаПоТоварам.Колонки.СуммаУпр.Имя = "СтоимостьПоступление";

	// Заполним таблицу движений.
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварам, ТаблицаДвижений);

	// Недостающие поля.
	Инд = 0;
	Для каждого Строка Из ТаблицаДвижений Цикл
		Инд = Инд+1;
		Строка.НомерСтрокиДокумента = Инд;
	КонецЦикла;

	ТаблицаДвижений.ЗаполнитьЗначения(Склад,"Склад");

	ТаблицаДвижений.ЗаполнитьЗначения(Дата,"Период");
	ТаблицаДвижений.ЗаполнитьЗначения(Ссылка,"Регистратор");
	ТаблицаДвижений.ЗаполнитьЗначения(Истина,"Активность");
	ТаблицаДвижений.ЗаполнитьЗначения(Справочники.Качество.Новый, "Качество");

	ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.КодыОперацийПартииТоваров.ПереоценкаПринятыхНаКомиссию,"КодОперацииПартииТоваров");
	ТаблицаДвижений.ЗаполнитьЗначения(Организация,    "Организация");
	
	ЗаполнитьКолонкиРегистраСписанныеТоварыПоТоварамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок, ТаблицаДвижений);

	НаборДвижений.мПериод            = Дата;
	НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;

	Если Не Отказ Тогда
		Движения.СписанныеТовары.ВыполнитьДвижения();
	КонецЕсли;

	Если Движения.СписанныеТовары.Модифицированность() Тогда
		Движения.СписанныеТовары.Записать(Истина);
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегиструСписанныеТовары()

Процедура ЗаполнитьКолонкиРегистраСписанныеТоварыПоТоварамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок, ТаблицаДвижений)
	
	ТаблицаДвижений.ЗаполнитьЗначения(ОтражатьВУправленческомУчете,"ОтражатьВУправленческомУчете");
	ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СтатусыПартийТоваров.НаКомиссию,"ДопустимыйСтатус3");
	ТаблицаДвижений.ЗаполнитьЗначения(Подразделение,"Подразделение");
	
КонецПроцедуры

Процедура ДополнитьДеревоПолейЗапросаПоШапкеУпр(ДеревоПолейЗапросаПоШапке)
	
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Константы"             , "ВалютаУправленческогоУчета"        , "ВалютаУправленческогоУчета");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Константы"             , "КурсВалютыУправленческогоУчета"    , "КурсВалютыУправленческогоУчета");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") 
	 Или ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслугВНТТ")Тогда

		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);

		Сделка = Основание.Сделка;

		Если Не ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом Тогда
			Возврат;
		КонецЕсли;

		Если Основание.Проведен Тогда
			ЗаполнитьТоварыУпр(Основание);
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ОбработкаЗаполнения()

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	мУдалятьДвижения = НЕ ЭтоНовый();

	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	// Проверка заполнения единицы измерения мест и количества мест
	ОбработкаТабличныхЧастей.ПриЗаписиПроверитьЕдиницуИзмеренияМест(Товары);

	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = Товары.Итог("Сумма");

КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке      = ОбщегоНазначения.СформироватьДеревоПолейЗапросаПоШапке();
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВедениеВзаиморасчетов"             , "ВедениеВзаиморасчетов");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВалютаВзаиморасчетов"              , "ВалютаВзаиморасчетов");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "Организация"                       , "ДоговорОрганизация");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Склад"                 , "ВидСклада"                         , "ВидСклада");
	ДополнитьДеревоПолейЗапросаПоШапкеУпр(ДеревоПолейЗапросаПоШапке);

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	// Получим необходимые данные для проведения и проверки заполнения данных по табличной части "Товары".
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("Номенклатура"              , "Номенклатура");
	СтруктураПолей.Вставить("Услуга"                    , "Номенклатура.Услуга");
	СтруктураПолей.Вставить("Набор"                     , "Номенклатура.Набор");
	СтруктураПолей.Вставить("Комплект"                  , "Номенклатура.Комплект");
	СтруктураПолей.Вставить("Количество"                , "Количество * Коэффициент /Номенклатура.ЕдиницаХраненияОстатков.Коэффициент");
	СтруктураПолей.Вставить("Сумма"                     , "Сумма");
	СтруктураПолей.Вставить("СуммаВзаиморасчетов"       , "СуммаСтарая");
	СтруктураПолей.Вставить("ХарактеристикаНоменклатуры", "ХарактеристикаНоменклатуры");
	СтруктураПолей.Вставить("СерияНоменклатуры"         , "СерияНоменклатуры");

	РезультатЗапросаПоТоварам = ОбщегоНазначения.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураПолей);

	// Подготовим таблицу товаров для проведения.
	ТаблицаПоТоварам = ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента);

	// Проверить заполнение ТЧ "Товары".
	ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок);

	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);

КонецПроцедуры

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

мСтруктураПараметровДляПолученияДоговора = Новый Структура();
мСписокДопустимыхВидовДоговоров = Новый СписокЗначений();
мСписокДопустимыхВидовДоговоров.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СКомитентом);
мСтруктураПараметровДляПолученияДоговора.Вставить("СписокДопустимыхВидовДоговоров", мСписокДопустимыхВидовДоговоров);

