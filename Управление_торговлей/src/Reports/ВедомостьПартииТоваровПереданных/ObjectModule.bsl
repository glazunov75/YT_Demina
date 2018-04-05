#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура УстановитьНачальныеНастройкиУпр(ДополнительныеПараметры = Неопределено)
	
	// Дополнительные параметры, переданные из отчета, вызвавшего расшифровку.
	// Информация, передаваемая в переменной ДополнительныеПараметры, может быть использована
	// для реализации специфичных для данного отчета параметрических настроек.
	
	// Описание исходного текста запроса.
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИсточникДанных.Номенклатура КАК Номенклатура,
	|	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.Номенклатура),
	|	ИсточникДанных.СтатусПередачи КАК СтатусПередачи,
	|	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.СтатусПередачи),
	|	ИсточникДанных.ДоговорКонтрагента.Владелец КАК ДоговорКонтрагентаВладелец,
	|	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.ДоговорКонтрагента.Владелец),
	|	ИсточникДанных.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.ДоговорКонтрагента),
	|	ИсточникДанных.ДокументПередачи КАК ДокументПередачи,
	|	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.ДокументПередачи),
	|	ИсточникДанных.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.ХарактеристикаНоменклатуры),
	|	ИсточникДанных.ДокументОприходования КАК ДокументОприходования,
	|	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.ДокументОприходования),
	|	ИсточникДанных.СтатусПартии КАК СтатусПартии,
	|	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.СтатусПартии),
	|	ИсточникДанных.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	|	ИсточникДанных.КоличествоНачальныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК КоличествоНачальныйОстатокВЕдиницахДляОтчетов,
	|	ИсточникДанных.КоличествоНачальныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КоличествоНачальныйОстатокВБазовыхЕдиницах,
	|	ИсточникДанных.КоличествоПриход КАК КоличествоПриход,
	|	ИсточникДанных.КоличествоПриход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК КоличествоПриходВЕдиницахДляОтчетов,
	|	ИсточникДанных.КоличествоПриход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КоличествоПриходВБазовыхЕдиницах,
	|	ИсточникДанных.КоличествоРасход КАК КоличествоРасход,
	|	ИсточникДанных.КоличествоРасход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК КоличествоРасходВЕдиницахДляОтчетов,
	|	ИсточникДанных.КоличествоРасход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КоличествоРасходВБазовыхЕдиницах,
	|	ИсточникДанных.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
	|	ИсточникДанных.КоличествоКонечныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК КоличествоКонечныйОстатокВЕдиницахДляОтчетов,
	|	ИсточникДанных.КоличествоКонечныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КоличествоКонечныйОстатокВБазовыхЕдиницах,
	|	ИсточникДанных.СтоимостьНачальныйОстаток КАК СтоимостьНачальныйОстаток,
	|	ИсточникДанных.СтоимостьПриход КАК СтоимостьПриход,
	|	ИсточникДанных.СтоимостьРасход КАК СтоимостьРасход,
	|	ИсточникДанных.СтоимостьКонечныйОстаток КАК СтоимостьКонечныйОстаток,
	|	ИсточникДанных.Регистратор КАК Регистратор,
	|	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.Регистратор),
	|	ИсточникДанных.Период КАК Период,
	|	НачалоПериода(ИсточникДанных.Период, День) КАК ПериодДень,
	|	НачалоПериода(ИсточникДанных.Период, Неделя) КАК ПериодНеделя,
	|	НачалоПериода(ИсточникДанных.Период, Декада) КАК ПериодДекада,
	|	НачалоПериода(ИсточникДанных.Период, Месяц) КАК ПериодМесяц,
	|	НачалоПериода(ИсточникДанных.Период, Квартал) КАК ПериодКвартал,
	|	НачалоПериода(ИсточникДанных.Период, Полугодие) КАК ПериодПолугодие,
	|	НачалоПериода(ИсточникДанных.Период, Год) КАК ПериодГод
	|	//ПОЛЯ_СВОЙСТВА
	|	//ПОЛЯ_КАТЕГОРИИ
	|{ВЫБРАТЬ
	|	Номенклатура.*,
	|	СтатусПередачи.*,
	|	ДоговорКонтрагентаВладелец.*,
	|	ДоговорКонтрагента.*,
	|	ДокументПередачи.*,
	|	ХарактеристикаНоменклатуры.*,
	|	ДокументОприходования.*,
	|	СтатусПартии.*,
	|	КоличествоНачальныйОстаток,
	|	КоличествоНачальныйОстатокВЕдиницахДляОтчетов,
	|	КоличествоНачальныйОстатокВБазовыхЕдиницах,
	|	КоличествоПриход,
	|	КоличествоПриходВЕдиницахДляОтчетов,
	|	КоличествоПриходВБазовыхЕдиницах,
	|	КоличествоРасход,
	|	КоличествоРасходВЕдиницахДляОтчетов,
	|	КоличествоРасходВБазовыхЕдиницах,
	|	КоличествоКонечныйОстаток,
	|	КоличествоКонечныйОстатокВЕдиницахДляОтчетов,
	|	КоличествоКонечныйОстатокВБазовыхЕдиницах,
	|	СтоимостьНачальныйОстаток,
	|	СтоимостьПриход,
	|	СтоимостьРасход,
	|	СтоимостьКонечныйОстаток,
	|	Регистратор.*,
	|	Период,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}
	|ИЗ РегистрНакопления.ПартииТоваровПереданные.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор {&Периодичность},, {
	|	Номенклатура.* КАК Номенклатура,
	|	СтатусПередачи.* КАК СтатусПередачи,
	|	ДоговорКонтрагента.Владелец.* КАК ДоговорКонтрагентаВладелец,
	|	ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	|	ДокументПередачи.* КАК ДокументПередачи,
	|	ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	|	ДокументОприходования.* КАК ДокументОприходования,
	|	СтатусПартии.* КАК СтатусПартии}) КАК ИсточникДанных
	|//СОЕДИНЕНИЯ
	|{ГДЕ
	|	ИсточникДанных.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	|	ИсточникДанных.КоличествоНачальныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК КоличествоНачальныйОстатокВЕдиницахДляОтчетов,
	|	ИсточникДанных.КоличествоНачальныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КоличествоНачальныйОстатокВБазовыхЕдиницах,
	|	ИсточникДанных.КоличествоПриход КАК КоличествоПриход,
	|	ИсточникДанных.КоличествоПриход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК КоличествоПриходВЕдиницахДляОтчетов,
	|	ИсточникДанных.КоличествоПриход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КоличествоПриходВБазовыхЕдиницах,
	|	ИсточникДанных.КоличествоРасход КАК КоличествоРасход,
	|	ИсточникДанных.КоличествоРасход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК КоличествоРасходВЕдиницахДляОтчетов,
	|	ИсточникДанных.КоличествоРасход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КоличествоРасходВБазовыхЕдиницах,
	|	ИсточникДанных.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
	|	ИсточникДанных.КоличествоКонечныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК КоличествоКонечныйОстатокВЕдиницахДляОтчетов,
	|	ИсточникДанных.КоличествоКонечныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КоличествоКонечныйОстатокВБазовыхЕдиницах,
	|	ИсточникДанных.СтоимостьНачальныйОстаток КАК СтоимостьНачальныйОстаток,
	|	ИсточникДанных.СтоимостьПриход КАК СтоимостьПриход,
	|	ИсточникДанных.СтоимостьРасход КАК СтоимостьРасход,
	|	ИсточникДанных.СтоимостьКонечныйОстаток КАК СтоимостьКонечныйОстаток,
	|	ИсточникДанных.Регистратор.* КАК Регистратор,
	|	ИсточникДанных.Период КАК Период,
	|	НачалоПериода(ИсточникДанных.Период, День) КАК ПериодДень,
	|	НачалоПериода(ИсточникДанных.Период, Неделя) КАК ПериодНеделя,
	|	НачалоПериода(ИсточникДанных.Период, Декада) КАК ПериодДекада,
	|	НачалоПериода(ИсточникДанных.Период, Месяц) КАК ПериодМесяц,
	|	НачалоПериода(ИсточникДанных.Период, Квартал) КАК ПериодКвартал,
	|	НачалоПериода(ИсточникДанных.Период, Полугодие) КАК ПериодПолугодие,
	|	НачалоПериода(ИсточникДанных.Период, Год) КАК ПериодГод
	|	//УСЛОВИЯ_СВОЙСТВА
	|	//УСЛОВИЯ_КАТЕГОРИИ
	|}
	|{УПОРЯДОЧИТЬ ПО
	|	Номенклатура.*,
	|	СтатусПередачи.*,
	|	ДоговорКонтрагентаВладелец.*,
	|	ДоговорКонтрагента.*,
	|	ДокументПередачи.*,
	|	ХарактеристикаНоменклатуры.*,
	|	ДокументОприходования.*,
	|	СтатусПартии.*,
	|	КоличествоНачальныйОстаток,
	|	КоличествоНачальныйОстатокВЕдиницахДляОтчетов,
	|	КоличествоНачальныйОстатокВБазовыхЕдиницах,
	|	КоличествоПриход,
	|	КоличествоПриходВЕдиницахДляОтчетов,
	|	КоличествоПриходВБазовыхЕдиницах,
	|	КоличествоРасход,
	|	КоличествоРасходВЕдиницахДляОтчетов,
	|	КоличествоРасходВБазовыхЕдиницах,
	|	КоличествоКонечныйОстаток,
	|	КоличествоКонечныйОстатокВЕдиницахДляОтчетов,
	|	КоличествоКонечныйОстатокВБазовыхЕдиницах,
	|	СтоимостьНачальныйОстаток,
	|	СтоимостьПриход,
	|	СтоимостьРасход,
	|	СтоимостьКонечныйОстаток,
	|	Регистратор.*,
	|	Период,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}
	|ИТОГИ
	|	СУММА(КоличествоНачальныйОстаток),
	|	СУММА(КоличествоНачальныйОстатокВЕдиницахДляОтчетов),
	|	СУММА(КоличествоНачальныйОстатокВБазовыхЕдиницах),
	|	СУММА(КоличествоПриход),
	|	СУММА(КоличествоПриходВЕдиницахДляОтчетов),
	|	СУММА(КоличествоПриходВБазовыхЕдиницах),
	|	СУММА(КоличествоРасход),
	|	СУММА(КоличествоРасходВЕдиницахДляОтчетов),
	|	СУММА(КоличествоРасходВБазовыхЕдиницах),
	|	СУММА(КоличествоКонечныйОстаток),
	|	СУММА(КоличествоКонечныйОстатокВЕдиницахДляОтчетов),
	|	СУММА(КоличествоКонечныйОстатокВБазовыхЕдиницах),
	|	СУММА(СтоимостьНачальныйОстаток),
	|	СУММА(СтоимостьПриход),
	|	СУММА(СтоимостьРасход),
	|	СУММА(СтоимостьКонечныйОстаток)
	|	//ИТОГИ_СВОЙСТВА
	|	//ИТОГИ_КАТЕГОРИИ
	|ПО
	|	ОБЩИЕ
	|{ИТОГИ ПО
	|	Номенклатура.*,
	|	СтатусПередачи.*,
	|	ДоговорКонтрагентаВладелец.*,
	|	ДоговорКонтрагента.*,
	|	ДокументПередачи.*,
	|	ХарактеристикаНоменклатуры.*,
	|	ДокументОприходования.*,
	|	СтатусПартии.*,
	|	Регистратор.*,
	|	Период,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}";
	
	// В универсальном отчете включен флаг использования свойств и категорий.
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Добавление свойств и категорий поля запроса в таблицу полей.
		// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
		
		// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>, <Представление>, <Назначение>);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ИсточникДанных.Номенклатура", "Номенклатура", "Номенклатура", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ИсточникДанных.ХарактеристикаНоменклатуры", "ХарактеристикаНоменклатуры", "Характеристика номенклатуры", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ХарактеристикиНоменклатуры);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ИсточникДанных.ДоговорКонтрагента.Владелец", "ДоговорКонтрагентаВладелец", "Контрагент", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ИсточникДанных.ДоговорКонтрагента", "ДоговорКонтрагента", "Договор контрагента", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ДоговорыКонтрагентов);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ИсточникДанных.ДокументПередачи", "ДокументПередачи", "Документ передачи", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Документы);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ИсточникДанных.ДокументОприходования", "ДокументОприходования", "Документ оприходования", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Документы);
		
		// Добавление свойств и категорий в исходный текст запроса.
		УниверсальныйОтчет.ДобавитьВТекстЗапросаСвойстваИКатегории(ТекстЗапроса);
		
	КонецЕсли;
		
	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДокументОприходования", "Документ оприходования");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ХарактеристикаНоменклатуры", "Характеристика номенклатуры");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СерияНоменклатуры", "Серия номенклатуры");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтатусПартии", "Статус партии");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтатусПередачи", "Статус передачи");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДоговорКонтрагентаВладелец", "Контрагент");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДоговорКонтрагента", "Договор контрагента");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДокументПередачи", "Документ передачи");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоНачальныйОстаток", "Количество начальный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоНачальныйОстатокВЕдиницахДляОтчетов", "Количество начальный остаток (в ед. отчетов)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоНачальныйОстатокВБазовыхЕдиницах", "Количество начальный остаток (в базовых ед.)");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтоимостьНачальныйОстаток", "Стоимость начальный остаток");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоПриход", "Количество приход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоПриходВЕдиницахДляОтчетов", "Количество приход (в ед. отчетов)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоПриходВБазовыхЕдиницах", "Количество приход (в базовых ед.)");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтоимостьПриход", "Стоимость приход");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоРасход", "Количество расход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоРасходВЕдиницахДляОтчетов", "Количество расход (в ед. отчетов)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоРасходВБазовыхЕдиницах", "Количество расход (в базовых ед.)");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтоимостьРасход", "Стоимость расход");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоКонечныйОстаток", "Количество конечный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоКонечныйОстатокВЕдиницахДляОтчетов", "Количество конечный остаток (в ед. отчетов)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоКонечныйОстатокВБазовыхЕдиницах", "Количество конечный остаток (в базовых ед.)");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтоимостьКонечныйОстаток", "Стоимость конечный остаток");
	
	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоНачальныйОстаток", "Количество", Истина, "ЧЦ=15; ЧДЦ=3", "НачальныйОстаток", "Начальный остаток");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоНачальныйОстатокВЕдиницахДляОтчетов", "Количество (в ед. отчетов)", Ложь, "ЧЦ=15; ЧДЦ=3", "НачальныйОстаток", "Начальный остаток");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоНачальныйОстатокВБазовыхЕдиницах", "Количество (в базовых ед.)", Ложь, "ЧЦ=15; ЧДЦ=3", "НачальныйОстаток", "Начальный остаток");
	УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьНачальныйОстаток", "Стоимость", Истина, "ЧЦ=15; ЧДЦ=2", "НачальныйОстаток", "Начальный остаток");
	
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоПриход", "Количество", Истина, "ЧЦ=15; ЧДЦ=3", "Приход", "Приход");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоПриходВЕдиницахДляОтчетов", "Количество (в ед. отчетов)", Ложь, "ЧЦ=15; ЧДЦ=3", "Приход", "Приход");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоПриходВБазовыхЕдиницах", "Количество (в базовых ед.)", Ложь, "ЧЦ=15; ЧДЦ=3", "Приход", "Приход");
	УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьПриход", "Стоимость", Истина, "ЧЦ=15; ЧДЦ=2", "Приход", "Приход");
	
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоРасход", "Количество", Истина, "ЧЦ=15; ЧДЦ=3", "Расход", "Расход");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоРасходВЕдиницахДляОтчетов", "Количество (в ед. отчетов)", Ложь, "ЧЦ=15; ЧДЦ=3", "Расход", "Расход");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоРасходВБазовыхЕдиницах", "Количество (в базовых ед.)", Ложь, "ЧЦ=15; ЧДЦ=3", "Расход", "Расход");
	УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьРасход", "Стоимость", Истина, "ЧЦ=15; ЧДЦ=2", "Расход", "Расход");
	
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоКонечныйОстаток", "Количество", Истина, "ЧЦ=15; ЧДЦ=3", "КонечныйОстаток", "Конечный остаток");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоКонечныйОстатокВЕдиницахДляОтчетов", "Количество (в ед. отчетов)", Ложь, "ЧЦ=15; ЧДЦ=3", "КонечныйОстаток", "Конечный остаток");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоКонечныйОстатокВБазовыхЕдиницах", "Количество (в базовых ед.)", Ложь, "ЧЦ=15; ЧДЦ=3", "КонечныйОстаток", "Конечный остаток");
	УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьКонечныйОстаток", "Стоимость", Истина, "ЧЦ=15; ЧДЦ=2", "КонечныйОстаток", "Конечный остаток");
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ДокументОприходования");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Номенклатура");
	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	
	УниверсальныйОтчет.ДобавитьОтбор("Номенклатура");
	УниверсальныйОтчет.ДобавитьОтбор("ДокументОприходования");
		
	// Добавление предопределенных полей порядка отчета.
	// Необходимо вызывать для каждого добавляемого поля порядка.
	// УниверсальныйОтчет.ДобавитьПорядок(<ПутьКДанным>);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДанным>);
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	
	// Установка представлений полей
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>);
	
КонецПроцедуры // УстановитьНачальныеНастройкиУпр()

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура УстановитьНачальныеНастройки(ДополнительныеПараметры = Неопределено) Экспорт
	
	// Настройка общих параметров универсального отчета
	УправлениеОтчетами.ВосстановитьРеквизитыОтчета(ЭтотОбъект, ДополнительныеПараметры);
	
	// Содержит название отчета, которое будет выводиться в шапке.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.мНазваниеОтчета = "Название отчета";
	УниверсальныйОтчет.мНазваниеОтчета = СокрЛП(ЭтотОбъект.Метаданные().Синоним);
	
	// Содержит признак необходимости отображения надписи и поля выбора раздела учета в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	
	// Содержит имя регистра, по метаданным которого будет выполняться заполнение настроек отчета.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.ИмяРегистра = "ТоварыНаСкладах";
	
	// Содержит значение используемого режима ввода периода.
	// Тип: Число.
	// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
	// Значение по умолчанию: 0
	// Пример:
	// УниверсальныйОтчет.мРежимВводаПериода = 0;
	
	// Содержит признак необходимости вывода отрицательных значений показателей красным цветом.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ОтрицательноеКрасным = Истина;
	УниверсальныйОтчет.ОтрицательноеКрасным = Истина;
	
	// Содержит признак необходимости вывода в отчет общих итогов.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ВыводитьОбщиеИтоги = Ложь;
	
	// Содержит признак необходимости вывода детальных записей в отчет.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Истина;
	
	// Содержит признак необходимости отображения флага использования свойств и категорий в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Ложь;
	
	// Содержит признак использования свойств и категорий при заполнении настроек отчета.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ИспользоватьСвойстваИКатегории = Истина;
	//УниверсальныйОтчет.ИспользоватьСвойстваИКатегории = Истина;
	
	// Содержит признак использования простой формы настроек отчета без группировок колонок.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.мРежимФормыНастройкиБезГруппировокКолонок = Истина;
	УниверсальныйОтчет.мРежимФормыНастройкиБезГруппировокКолонок = Истина;

	УстановитьНачальныеНастройкиУпр(ДополнительныеПараметры);
	
КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	// Перед формирование отчета можно установить необходимые параметры универсального отчета.
	
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент);

КонецПроцедуры // СформироватьОтчет()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно передать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	ДополнительныеПараметры = УправлениеОтчетами.СохранитьРеквизитыОтчета(ЭтотОбъект);
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект, ДополнительныеПараметры);
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру для сохранения настроек отчета
//
Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	УниверсальныйОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками);
	УправлениеОтчетами.СохранитьРеквизитыОтчета(ЭтотОбъект, СтруктураСНастройками);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки отчета из структуры сохраненных настроек
//
Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт
	
	УправлениеОтчетами.ВосстановитьРеквизитыОтчета(ЭтотОбъект, СтруктураСНастройками);
	Возврат УниверсальныйОтчет.ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, ЭтотОбъект);
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

// Содержит значение используемого режима ввода периода.
// Тип: Число.
// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
// УниверсальныйОтчет.мРежимВводаПериода = 1;

#КонецЕсли
