#Если Клиент Тогда
	
Перем мНазваниеОтчета Экспорт;

// Коды операций продаж
Перем мКодыОперацийПродажи;

// Все возможные показатели
Перем мТаблицаПоказатели Экспорт;

// Соответствия, содержащая назначения свойств и категорий именам
Перем мСоответствиеНазначений Экспорт;
Перем мСтруктураДляОтбораПоКатегориям Экспорт;

// Структура, содержащая представления полей
Перем СтруктураПредставлениеПолей;

Перем МассивИзмерения;
Перем МассивОтбора;

// СписокЗначений - список имен и представлений объектов анализа
Перем мСписокСтатусовТоваров Экспорт;


//////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура ПрибавитьПериод(ТочкаОтсчета)

	Если Периодичность = Перечисления.Периодичность.Год Тогда
		ТочкаОтсчета = ДобавитьМесяц(ТочкаОтсчета, 12);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Полугодие Тогда
		ТочкаОтсчета = ДобавитьМесяц(ТочкаОтсчета, 6);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		ТочкаОтсчета = ДобавитьМесяц(ТочкаОтсчета, 3);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Месяц Тогда
		ТочкаОтсчета = ДобавитьМесяц(ТочкаОтсчета, 1);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Декада Тогда
		ТочкаОтсчета = ТочкаОтсчета + 60*60*24*10;
	ИначеЕсли Периодичность = Перечисления.Периодичность.Неделя Тогда
		ТочкаОтсчета = ТочкаОтсчета + 60*60*24*7;
	ИначеЕсли Периодичность = Перечисления.Периодичность.День Тогда
		ТочкаОтсчета = ТочкаОтсчета + 60*60*24;
	КонецЕсли;

КонецПроцедуры

// Выводит показатели в строку отчета
Процедура ВывестиПоказатели(РезультатЗапроса, КоличествоПоказателей, ДокументРезультат, МакетПоказатель, ПоследняяГруппировка)
	Перем Расход, Остаток, КОборачиваемости, СрокХранения;

	Если (ПоследняяГруппировка) Тогда
		Если Периодичность <> Перечисления.Периодичность.ПустаяСсылка() Тогда

			Расход = РезультатЗапроса.Расход;
			Остаток = 0;
			КоличествоКонтрольныхТочек = 0;

			ТочкаОтсчета = ДатаНачала;
			КонечныйОстаток = 0;

			ПервыйЭлементВыборки = Истина;
			Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Период","Все");
			Пока Выборка.Следующий() Цикл
				Если Не ЗначениеЗаполнено(Выборка.Период) Тогда
					Продолжить;
				КонецЕсли;
				
				Если КоличествоКонтрольныхТочек = 0 Тогда
					Остаток = Остаток + Выборка.НачальныйОстаток;
					КоличествоКонтрольныхТочек = КоличествоКонтрольныхТочек + 1;					
				КонецЕсли;

				Пока ТочкаОтсчета < Выборка.Период Цикл
					Остаток = Остаток + КонечныйОстаток;
					КоличествоКонтрольныхТочек = КоличествоКонтрольныхТочек + 1;
					ПрибавитьПериод(ТочкаОтсчета);
				КонецЦикла;

				КонечныйОстаток = Выборка.КонечныйОстаток;

				Остаток = Остаток + КонечныйОстаток;
				КоличествоКонтрольныхТочек = КоличествоКонтрольныхТочек + 1;
				ПрибавитьПериод(ТочкаОтсчета);
			КонецЦикла;

			Если ТочкаОтсчета < ДатаКонца Тогда
				Пока ТочкаОтсчета <= ДатаКонца Цикл
					Остаток = Остаток + КонечныйОстаток;
					КоличествоКонтрольныхТочек = КоличествоКонтрольныхТочек + 1;
					ПрибавитьПериод(ТочкаОтсчета);
				КонецЦикла;
			КонецЕсли;
				
			Остаток = Остаток / КоличествоКонтрольныхТочек;

		Иначе

			Расход  = РезультатЗапроса.Расход;
			Остаток = (РезультатЗапроса.НачальныйОстаток + РезультатЗапроса.КонечныйОстаток) / 2;

		КонецЕсли;

		КОборачиваемости = ?(Остаток = 0, 0, Расход / Остаток);
		Если Не ЗначениеЗаполнено(ДатаНачала) илИ Не ЗначениеЗаполнено(ДатаКонца) Тогда
			СрокХранения = 0;
		Иначе
			КоличествоСекундПериода = ДатаКонца-ДатаНачала;
			СрокХранения = ?(КОборачиваемости = 0, 0, (КоличествоСекундПериода/(60*60*24)+1)/КОборачиваемости);
		КонецЕсли;

		Для Каждого Показатель Из Показатели Цикл
			Если Показатель.Использование Тогда
				Если Показатель.Имя = "Расход" Тогда
					МакетПоказатель.Параметры.Расход = Расход;
				ИначеЕсли Показатель.Имя = "Остаток" Тогда
					МакетПоказатель.Параметры.Остаток = Остаток;
				ИначеЕсли Показатель.Имя = "КОборачиваемости" Тогда
					МакетПоказатель.Параметры.КОборачиваемости = КОборачиваемости;
				ИначеЕсли Показатель.Имя = "СрокХранения" Тогда
					МакетПоказатель.Параметры.СрокХранения = СрокХранения;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;

		ДокументРезультат.Присоединить(МакетПоказатель);

	Иначе
		Для а = 0 По КоличествоПоказателей-1 Цикл
			МакетПоказатель.Параметры[а] = 0;
		КонецЦикла;
		ДокументРезультат.Присоединить(МакетПоказатель);
	КонецЕсли;

КонецПроцедуры

// Выводит строку отчета
Процедура ВывестиСтроку(РезультатЗапроса, Знач Индекс, КоличествоКолонок, КоличествоПоказателей, ДокументРезультат)

	Если Индекс = ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Тогда
		ПоследняяГруппировка = Истина;
	Иначе
		ПоследняяГруппировка = ЛОЖЬ;
	КонецЕсли;

	ИзмерениеСтроки = ПостроительОтчета.ИзмеренияСтроки[Индекс];
	Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, ИзмерениеСтроки.Имя);
	Пока Выборка.Следующий() Цикл

		// Вывод значения измерения
		МакетСтроки = ?(Выборка.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоИерархии,
		                ПостроительОтчета.ИзмеренияСтроки[Индекс].МакетИерархии,
		                ПостроительОтчета.ИзмеренияСтроки[Индекс].Макет);

		// Значения измерений и т.д.
		МакетСтроки.Параметры.Заполнить(Выборка);

		МакетИзмерение = МакетСтроки.ПолучитьОбласть(1,1,МакетСтроки.ВысотаТаблицы,1+КоличествоКолонок);

		ДокументРезультат.Вывести(МакетИзмерение, Выборка.Уровень());

		// Макет показателей
		МакетПоказатель = МакетСтроки.ПолучитьОбласть(1,1+КоличествоКолонок+1,
		                                              МакетСтроки.ВысотаТаблицы,1+КоличествоКолонок+КоличествоПоказателей);

		// Выводим показатели в соответствии с их порядком в шапке
		ВывестиПоказатели(Выборка, КоличествоПоказателей, ДокументРезультат, МакетПоказатель, ПоследняяГруппировка);

		Если НЕ ПоследняяГруппировка Тогда
			ВывестиСтроку(Выборка, Индекс+1, КоличествоКолонок, КоличествоПоказателей, ДокументРезультат);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////

Процедура ЗаполнитьПоказатели(ИмяПоля, ПредставлениеПоля, ВклПоУмолчанию, ФорматнаяСтрока)

	СтруктураПредставлениеПолей.Вставить(ИмяПоля, ПредставлениеПоля);

	// Показатели заносятся в специальную таблицу и добавляются в список
	СтрПоказатели = мТаблицаПоказатели.Добавить();
	СтрПоказатели.ИмяПоля           = ИмяПоля;
	СтрПоказатели.ПредставлениеПоля = ПредставлениеПоля;
	СтрПоказатели.ВклПоУмолчанию    = ВклПоУмолчанию;
	СтрПоказатели.ФорматнаяСтрока   = ФорматнаяСтрока;

	Показатель = Показатели.Добавить();
	Показатель.Имя           = ИмяПоля;
	Показатель.Представление = ПредставлениеПоля;
	Показатель.Использование = ВклПоУмолчанию;

КонецПроцедуры

Процедура ЗаполнитьПредставление(ИмяПоля, ПредставлениеПоля, ВклВИтоги, ВклВОтбор)

	Если ВклВИтоги Тогда
		МассивИзмерения.Добавить(ИмяПоля);
	КонецЕсли;

	СтруктураПредставлениеПолей.Вставить(ИмяПоля, ПредставлениеПоля);

	Если ВклВОтбор Тогда
		МассивОтбора.Добавить(ИмяПоля);
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьТекстЗапросаПостроителяОтчета() Экспорт

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ //РАЗЛИЧНЫЕ
	|	ВложенныйЗапрос.СтатусТоваров,
	|	ВложенныйЗапрос.Склад,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры,
	|	ВложенныйЗапрос.Период,
	|	ВложенныйЗапрос.НачальныйОстаток КАК НачальныйОстаток,
	|	ВложенныйЗапрос.КонечныйОстаток КАК КонечныйОстаток,
	|	ВложенныйЗапрос.Расход КАК Расход
	|	//СВОЙСТВА
	|{ВЫБРАТЬ
	|	Склад.*,
	|	Номенклатура.*,
	|	ХарактеристикаНоменклатуры.*
	|	//СВОЙСТВА
	|}
	|ИЗ
	|	(ВЫБРАТЬ
	|		""Товары на складах"" КАК СтатусТоваров,
	|		ПартииТоваровНаСкладахОстаткиИОбороты.Склад КАК Склад,
	|		ПартииТоваровНаСкладахОстаткиИОбороты.Номенклатура КАК Номенклатура,
	|		ПартииТоваровНаСкладахОстаткиИОбороты.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		ПартииТоваровНаСкладахОстаткиИОбороты.Период КАК Период,
	|		ПартииТоваровНаСкладахОстаткиИОбороты.КоличествоНачальныйОстаток КАК НачальныйОстаток,
	|		ПартииТоваровНаСкладахОстаткиИОбороты.КоличествоКонечныйОстаток КАК КонечныйОстаток,
	|		0 КАК Расход
	|	ИЗ
	|		РегистрНакопления.ПартииТоваровНаСкладах.ОстаткиИОбороты(&ДатаНачала, &ДатаКонца, Месяц, , {(Склад).* КАК Склад, (Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры}) КАК ПартииТоваровНаСкладахОстаткиИОбороты
	|	ГДЕ
	|		(&ВсеТовары = ИСТИНА
	|				ИЛИ &ТоварыНаСкладах = ИСТИНА)
	|	{ГДЕ
	|		ПартииТоваровНаСкладахОстаткиИОбороты.Склад.* КАК Склад,
	|		ПартииТоваровНаСкладахОстаткиИОбороты.Номенклатура.* КАК Номенклатура,
	|		ПартииТоваровНаСкладахОстаткиИОбороты.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры}
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		""Товары на складах"",
	|		ПартииТоваровНаСкладах.Склад,
	|		ПартииТоваровНаСкладах.Номенклатура,
	|		ПартииТоваровНаСкладах.ХарактеристикаНоменклатуры,
	|		NULL,
	|		0,
	|		0,
	|		ПартииТоваровНаСкладах.Количество
	|	ИЗ
	|		РегистрНакопления.ПартииТоваровНаСкладах КАК ПартииТоваровНаСкладах
	|	ГДЕ
	|		(&ВсеТовары = ИСТИНА
	|				ИЛИ &ТоварыНаСкладах = ИСТИНА)
	|		И ПартииТоваровНаСкладах.КодОперации В(&КодОперации)
	|		И ПартииТоваровНаСкладах.Период >= &ДатаНачала
	|		И ПартииТоваровНаСкладах.Период <= &ДатаКонца
	|	{ГДЕ
	|		ПартииТоваровНаСкладах.Склад.* КАК Склад,
	|		ПартииТоваровНаСкладах.Номенклатура.* КАК Номенклатура,
	|		ПартииТоваровНаСкладах.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры}
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		""Товары у комиссионеров"",
	|		ПартииТоваровПереданныеОстаткиИОбороты.ДоговорКонтрагента.Владелец,
	|		ПартииТоваровПереданныеОстаткиИОбороты.Номенклатура,
	|		ПартииТоваровПереданныеОстаткиИОбороты.ХарактеристикаНоменклатуры,
	|		ПартииТоваровПереданныеОстаткиИОбороты.Период,
	|		ПартииТоваровПереданныеОстаткиИОбороты.КоличествоНачальныйОстаток,
	|		ПартииТоваровПереданныеОстаткиИОбороты.КоличествоКонечныйОстаток,
	|		0
	|	ИЗ
	|		РегистрНакопления.ПартииТоваровПереданные.ОстаткиИОбороты(&ДатаНачала, &ДатаКонца, Месяц, , {(ДоговорКонтрагента.Владелец).* КАК Склад, (Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры}) КАК ПартииТоваровПереданныеОстаткиИОбороты
	|	ГДЕ
	|		(&ВсеТовары = ИСТИНА
	|				ИЛИ &ТоварыУКомиссионеров = ИСТИНА)
	|	{ГДЕ
	|		ПартииТоваровПереданныеОстаткиИОбороты.ДоговорКонтрагента.Владелец.* КАК Комиссионер,
	|		ПартииТоваровПереданныеОстаткиИОбороты.Номенклатура.* КАК Номенклатура,
	|		ПартииТоваровПереданныеОстаткиИОбороты.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры}
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		""Товары у комиссионеров"",
	|		ПартииТоваровПереданные.ДоговорКонтрагента.Владелец,
	|		ПартииТоваровПереданные.Номенклатура,
	|		ПартииТоваровПереданные.ХарактеристикаНоменклатуры,
	|		NULL,
	|		0,
	|		0,
	|		ПартииТоваровПереданные.Количество
	|	ИЗ
	|		РегистрНакопления.ПартииТоваровПереданные КАК ПартииТоваровПереданные
	|	ГДЕ
	|		(&ВсеТовары = ИСТИНА
	|				ИЛИ &ТоварыУКомиссионеров = ИСТИНА)
	|		И ПартииТоваровПереданные.КодОперации = &КодОперацииРеализацияКомиссия
	|		И ПартииТоваровПереданные.Период >= &ДатаНачала
	|		И ПартииТоваровПереданные.Период <= &ДатаКонца
	|	{ГДЕ
	|		ПартииТоваровПереданные.ДоговорКонтрагента.Владелец.* КАК Комиссионер,
	|		ПартииТоваровПереданные.Номенклатура.* КАК Номенклатура,
	|		ПартииТоваровПереданные.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры}) КАК ВложенныйЗапрос
	|	//СОЕДИНЕНИЯ
	|{ГДЕ
	|	ВложенныйЗапрос.Склад.* КАК Склад,
	|	ВложенныйЗапрос.Номенклатура.* КАК Номенклатура,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры
	|	//СВОЙСТВА
	|	//КАТЕГОРИИ
	|}
	|{УПОРЯДОЧИТЬ ПО
	|	Склад.*,
	|	Номенклатура.*,
	|	ХарактеристикаНоменклатуры.*
	|	//ОБЩИЕСВОЙСТВА
	|}
	|ИТОГИ
	|	СУММА(НачальныйОстаток),
	|	СУММА(КонечныйОстаток),
	|	СУММА(Расход)
	|ПО
	|	ОБЩИЕ
	|
	|{ИТОГИ ПО
	|	СтатусТоваров,
	|	Склад.*,
	|	Номенклатура.*,
	|	ХарактеристикаНоменклатуры.*
	|	//ОБЩИЕСВОЙСТВА
	|}";

	Если ИспользоватьСвойстваИКатегории Тогда
		
		ТаблицаПолей = Новый ТаблицаЗначений;
		ТаблицаПолей.Колонки.Добавить("ПутьКДанным");
		ТаблицаПолей.Колонки.Добавить("Представление");
		ТаблицаПолей.Колонки.Добавить("Назначение");
		ТаблицаПолей.Колонки.Добавить("НетКатегорий");

		НазначениеСклады = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Склады;
		НазначениеНоменклатура = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура;
		НазначениеКонтрагенты = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты;
		
		СтрокаТаблицыПолей = ТаблицаПолей.Добавить();
		СтрокаТаблицыПолей.ПутьКДанным = "Номенклатура";
		СтрокаТаблицыПолей.Представление = "Номенклатура";
		СтрокаТаблицыПолей.Назначение = НазначениеНоменклатура;
		
		СтрокаТаблицыПолей = ТаблицаПолей.Добавить();
		СтрокаТаблицыПолей.ПутьКДанным = "Склад";
		СтрокаТаблицыПолей.Представление = "Склад";
		СтрокаТаблицыПолей.Назначение = НазначениеСклады;
		
		СтрокаТаблицыПолей = ТаблицаПолей.Добавить();
		СтрокаТаблицыПолей.ПутьКДанным = "Склад";
		СтрокаТаблицыПолей.Представление = "Склад";
		СтрокаТаблицыПолей.Назначение = НазначениеКонтрагенты;
		
		ТекстСвойств = "";
		ТекстКатегорий = "";
		
		УправлениеОтчетами.ДобавитьВТекстСвойстваИКатегории(ТаблицаПолей, ТекстЗапроса, СтруктураПредставлениеПолей, мСоответствиеНазначений, 
	                                          ПостроительОтчета.Параметры, , ТекстКатегорий, 
	                                          ТекстСвойств,,,,,, мСтруктураДляОтбораПоКатегориям);
		
		// Добавим строки запроса для использования ранее добавленных полей свойств в упорядочивании и группировках
		УправлениеОтчетами.ДобавитьВТекстСвойстваОбщие(ТекстЗапроса, ТекстСвойств, "//ОБЩИЕСВОЙСТВА");
		
	КонецЕсли;
	
	ПостроительОтчета.Текст = ТекстЗапроса;

	Если ИспользоватьСвойстваИКатегории Тогда
		УправлениеОтчетами.УстановитьТипыЗначенийСвойствИКатегорийДляОтбора(ПостроительОтчета, ТекстКатегорий, ТекстСвойств, мСоответствиеНазначений, СтруктураПредставлениеПолей);
	КонецЕсли;	
	
КонецПроцедуры

// Выполняет настройку отчета по умолчанию.
// 
Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	Если Не ЗначениеЗаполнено(СтатусТоваров) Тогда
		СтатусТоваров = "ВсеТовары";
	КонецЕсли;

	мТаблицаПоказатели.Очистить();
	Показатели.Очистить();

	СтруктураПредставлениеПолей = Новый Структура;
	мСоответствиеНазначений     = Новый Соответствие;
	МассивИзмерения             = Новый Массив;
	МассивОтбора                = Новый Массив;

	// Очистим отбор
	ОтборКоличество = ПостроительОтчета.Отбор.Количество();
	Для а = 1 По ОтборКоличество Цикл
		ПостроительОтчета.Отбор.Удалить(ОтборКоличество - а);
	КонецЦикла;

	ЗаполнитьПоказатели("Остаток",          "Средний остаток за период",
	                    ИСТИНА,   "ЧЦ = 15; ЧДЦ = 3");
	ЗаполнитьПоказатели("Расход",           "Расход за период",
	                    ИСТИНА,   "ЧЦ = 15; ЧДЦ = 3");
	ЗаполнитьПоказатели("КОборачиваемости", "Коэффициент оборачиваемости",
	                    ИСТИНА,   "ЧЦ = 15; ЧДЦ = 5");
	ЗаполнитьПоказатели("СрокХранения",     "Средний срок хранения в днях",
	                    ИСТИНА,   "ЧЦ = 15; ЧДЦ = 2");

	ЗаполнитьПредставление("СтатусТоваров",              "Статус товаров",              ИСТИНА, ЛОЖЬ  );
	Если СтатусТоваров = "ТоварыНаСкладах" Тогда
		ЗаполнитьПредставление("Склад",                      "Склад",                       ИСТИНА, ИСТИНА);
	ИначеЕсли СтатусТоваров = "ТоварыУКомиссионеров" Тогда 
		ЗаполнитьПредставление("Комиссионер",                "Комиссионер",                 ЛОЖЬ,   ИСТИНА);
	Иначе
		ЗаполнитьПредставление("Склад",                      "Склад",                       ИСТИНА, ИСТИНА);
		ЗаполнитьПредставление("Комиссионер",                "Комиссионер",                 ЛОЖЬ,   ИСТИНА);
	КонецЕсли;
	ЗаполнитьПредставление("Номенклатура",               "Номенклатура",                ИСТИНА, ИСТИНА);
	ЗаполнитьПредставление("ХарактеристикаНоменклатуры", "Характеристика номенклатуры", ЛОЖЬ,   ЛОЖЬ  );

	УстановитьТекстЗапросаПостроителяОтчета();
	
	Для Каждого Измерение Из МассивИзмерения Цикл
		ПостроительОтчета.ИзмеренияСтроки.Добавить(Измерение, Измерение, ТипИзмеренияПостроителяОтчета.Иерархия);
	КонецЦикла;

	Для Сч = 0 По ПостроительОтчета.ДоступныеПоля.Количество()-1 Цикл
		Поле = ПостроительОтчета.ДоступныеПоля[Сч];
		СтруктураПредставлениеПолей.Свойство(Поле.Имя, Поле.Представление);
	КонецЦикла;

	Для Сч = 0 По ПостроительОтчета.ВыбранныеПоля.Количество()-1 Цикл
		Поле = ПостроительОтчета.ВыбранныеПоля[Сч];
		СтруктураПредставлениеПолей.Свойство(Поле.Имя, Поле.Представление);
	КонецЦикла;

	Для Сч = 0 По ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Цикл
		Поле = ПостроительОтчета.ИзмеренияСтроки[Сч];
		СтруктураПредставлениеПолей.Свойство(Поле.Имя, Поле.Представление);
	КонецЦикла;

	// Удалим добавляемые автоматически поля измерений
	Сч=0;
	Пока Сч < ПостроительОтчета.ВыбранныеПоля.Количество() Цикл

		Если (ПостроительОтчета.ИзмеренияСтроки.Найти(ПостроительОтчета.ВыбранныеПоля[Сч].Имя)<>Неопределено)
		 ИЛИ (ПостроительОтчета.ИзмеренияКолонки.Найти(ПостроительОтчета.ВыбранныеПоля[Сч].Имя)<>Неопределено) Тогда
			ПостроительОтчета.ВыбранныеПоля.Удалить(ПостроительОтчета.ВыбранныеПоля[Сч]);
		Иначе
			Сч=Сч+1;
		КонецЕсли;

	КонецЦикла;

	Для Каждого Элемент Из МассивОтбора Цикл
		ПостроительОтчета.Отбор.Добавить(Элемент);
	КонецЦикла; 

КонецПроцедуры // ЗаполнитьНачальныеНастройки()

// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//  ДокументРезультат - табличный документ, формируемый отчетом,
//  ПоказыватьЗаголовок - флаг того, показывать заголовок или скрывать его
//  ВысотаЗаголовка - возращаемое значение - высота заголовка
//  ТолькоЗаголовок - флаг того, сформировать только заголовок или весь отчет
//
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок = Ложь) Экспорт

	Если НЕ УправлениеОтчетами.ЗадатьПараметрыОтбораПоКатегориям(ПостроительОтчета, мСтруктураДляОтбораПоКатегориям) Тогда
		//повторные отборы по категориям
		Предупреждение("По одной категории нельзя устанавливать два отбора");
		ЕстьОшибки = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ ТолькоЗаголовок И ПостроительОтчета.ИзмеренияСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Макет = ПолучитьМакет("Макет");
	ДокументРезультат.Очистить();

	СписокИзмерений = "";
	Для Сч=0 По ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Цикл
		СписокИзмерений = СписокИзмерений + ", " + ПостроительОтчета.ИзмеренияСтроки[Сч].Представление + " " + ПостроительОтчета.ИзмеренияСтроки[Сч].ТипИзмерения;
	КонецЦикла; 

	СписокПоказателей = "";
	Для Сч=0 По Показатели.Количество()-1 Цикл
		Если Показатели[Сч].Использование Тогда
			СписокПоказателей = СписокПоказателей +", "+ Показатели[Сч].Представление;
		КонецЕсли; 
	КонецЦикла; 

	СписокОтбор = "";
	Для Сч=0 По ПостроительОтчета.Отбор.Количество()-1 Цикл
		Если ПостроительОтчета.Отбор[Сч].Использование Тогда
			СписокОтбор = СписокОтбор + ", " + ПостроительОтчета.Отбор[Сч].Представление + " " + ПостроительОтчета.Отбор[Сч].ВидСравнения + " " + ПостроительОтчета.Отбор[Сч].Значение;
		КонецЕсли;
	КонецЦикла; 

	Секция = Макет.ПолучитьОбласть("Заголовок|ПолеОтступ");
	ДокументРезультат.Вывести(Секция);
	Секция = Макет.ПолучитьОбласть("Заголовок|Поле");
	Секция.Параметры.ЗаголовокОтчета = мНазваниеОтчета;
	Секция.Параметры.Период          = "Данные за период: " + Формат(ДатаНачала, "ДФ = ""дд.ММ.гггг""; ДП = ""...""")
	                                 + " - " + Формат(ДатаКонца, "ДФ = ""дд.ММ.гггг""; ДП = ""...""");
	Секция.Параметры.Измерения       = "Итоги по: "       + Сред(СписокИзмерений, 2);
	Секция.Параметры.Показатели      = "Показатели: "     + Сред(СписокПоказателей, 2);
	Секция.Параметры.Отбор           = "Отбор:"           + Сред(СписокОтбор,2);
	ДокументРезультат.Присоединить(Секция);

	ВысотаЗаголовка = ДокументРезультат.ВысотаТаблицы;

	// Управление заголовком
	Если ЗначениеЗаполнено(ВысотаЗаголовка) Тогда
		ДокументРезультат.Область(1,,ВысотаЗаголовка).Видимость = ПоказыватьЗаголовок;
	КонецЕсли;

	Если ТолькоЗаголовок Тогда
		ДокументРезультат.Показать();
		Возврат;
	КонецЕсли;

	Секция = Макет.ПолучитьОбласть("ШапкаТаблицы|ПолеОтступ");
	ДокументРезультат.Вывести(Секция);
	Секция = Макет.ПолучитьОбласть("ШапкаТаблицы|Поле");
	Секция.Параметры.Заголовок = ПостроительОтчета.ИзмеренияСтроки[ПостроительОтчета.ИзмеренияСтроки.Количество()-1].Представление;
	ДокументРезультат.Присоединить(Секция);
	Секция = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаДанные");

	КоличествоПоказателей = 0;
	Для Каждого Показатель Из Показатели Цикл
		Если Показатель.Использование = Истина Тогда
			ЭлементТаблицы   = мТаблицаПоказатели.Найти(Показатель.Имя);
			Секция.Параметры.Параметр = ?(ЭлементТаблицы<>Неопределено,ЭлементТаблицы.ПредставлениеПоля,Показатель.Представление);
			ДокументРезультат.Присоединить(Секция);

			КоличествоПоказателей = КоличествоПоказателей + 1;
		КонецЕсли;
	КонецЦикла;

	// Формирование макета заголовка отчета
	ДокументРезультат.Область(1+1,1+1,ДокументРезультат.ВысотаТаблицы,1+1+КоличествоПоказателей).ПоВыделеннымКолонкам = Истина;

	// Фиксация шапки
	ВысотаФиксации = ДокументРезультат.ВысотаТаблицы;
	ДокументРезультат.ФиксацияСверху = ВысотаФиксации;

	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
		ДатаНачала = ДатаКонца;
	КонецЕсли;

	Если Периодичность = Перечисления.Периодичность.Год Тогда
		ДатаНачала = НачалоГода(ДатаНачала);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		ДатаНачала = НачалоКвартала(ДатаНачала);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Месяц Тогда
		ДатаНачала = НачалоМесяца(ДатаНачала);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Неделя Тогда
		ДатаНачала = НачалоНедели(ДатаНачала);
	ИначеЕсли Периодичность = Перечисления.Периодичность.День Тогда
		ДатаНачала = НачалоДня(ДатаНачала);
	КонецЕсли;

	// Передадим параметры и откорректируем текст запроса
	ПостроительОтчета.Параметры.Вставить("ДатаНачала"  , ДатаНачала);
	ПостроительОтчета.Параметры.Вставить("ДатаКонца"   , КонецДня(ДатаКонца));
	ПостроительОтчета.Параметры.Вставить("КодОперации" , мКодыОперацийПродажи);
	ПостроительОтчета.Параметры.Вставить("КодОперацииРеализацияКомиссия" , Перечисления.КодыОперацийПартииТоваров.РеализацияКомиссия);

	УправлениеОтчетами.ПроверитьПорядокПостроителяОтчета(ПостроительОтчета);

	Запрос = ПостроительОтчета.ПолучитьЗапрос();

	Если СтатусТоваров = "ВсеТовары" Тогда
		КоличествоЗапросов = 2;
	Иначе
		КоличествоЗапросов = 1;
	КонецЕсли;
	
	Для к = 1 по КоличествоЗапросов Цикл
		ПоложениеВТексте = Найти(Запрос.Текст, "Месяц");
		Если (ПоложениеВТексте = 0) ИЛИ (Периодичность = Перечисления.Периодичность.ПустаяСсылка()) Тогда
			Периодичность = Перечисления.Периодичность.ПустаяСсылка();
		Иначе
			Запрос.Текст = Сред(Запрос.Текст, 1, ПоложениеВТексте - 1)
			+ Строка(Периодичность)
			+ Сред(Запрос.Текст, ПоложениеВТексте + 5);
		КонецЕсли;
	КонецЦикла;			 

	Если (Периодичность <> Перечисления.Периодичность.ПустаяСсылка()) Тогда
		Запрос.Текст = Запрос.Текст + ","
		             + Символы.ПС + Символы.Таб + "Период";
	КонецЕсли;

	Запрос.УстановитьПараметр("ВсеТовары", СтатусТоваров = "ВсеТовары");
	Запрос.УстановитьПараметр("ТоварыНаСкладах", СтатусТоваров = "ТоварыНаСкладах");
	Запрос.УстановитьПараметр("ТоварыУКомиссионеров", СтатусТоваров = "ТоварыУКомиссионеров");
	
	РезультатЗапроса = Запрос.Выполнить();

	// Получим цвета измерений
	МассивЦветаИзмерений = Новый Массив;
	Если РаскрашиватьИзмерения Тогда

		ТабДокЦветаИзмерений = Макет.ПолучитьОбласть("ЦветаИзмерений");
		Для Сч = 1 По ТабДокЦветаИзмерений.ВысотаТаблицы Цикл
			МассивЦветаИзмерений.Добавить(ТабДокЦветаИзмерений.Область(Сч,2).ЦветФона);
		КонецЦикла;

		Если НЕ ВыводитьДетальныеЗаписи Тогда
			МассивЦветаИзмерений.Добавить(Новый Цвет());
		КонецЕсли; 

	КонецЕсли;

	// Назначение, корректировка макетов измерений
	Сдвиг = Макс(МассивЦветаИзмерений.Количество()-ПостроительОтчета.ИзмеренияСтроки.Количество(),0);

	//ПостроительОтчета.ЗаполнениеРасшифровки = ВидЗаполненияРасшифровкиПостроителяОтчета.Расшифровка;

	// Нарисует макеты для строк
	ОбластьСтрока         = Макет.Область("Строка");
	ОбластьСтрокаИерархии = Макет.Область("СтрокаИерархии");

	КоличествоКолонок     = 1;
	Для Сч = 0 По ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Цикл

		Измерение = ПостроительОтчета.ИзмеренияСтроки[Сч];

		Если МассивЦветаИзмерений.Количество()>0 Тогда
			ЦветИзмерения = МассивЦветаИзмерений[Сдвиг+((Сч) - (МассивЦветаИзмерений.Количество()-Сдвиг)*Цел((Сч)/(МассивЦветаИзмерений.Количество()-Сдвиг)))];
		Иначе
			ЦветИзмерения = Новый Цвет();
		КонецЕсли;

		ФорматПоля = "";

		Шаблон = "["+Измерение.Имя+"]";

		Для Инд = 0 По ПостроительОтчета.ВыбранныеПоля.Количество()-1 Цикл

			Если ПостроительОтчета.ВыбранныеПоля[Инд].ПутьКДанным <> Измерение.ПутьКДанным
			   И Найти(ПостроительОтчета.ВыбранныеПоля[Инд].ПутьКДанным, Измерение.ПутьКДанным) >0 Тогда
				Шаблон = Шаблон + ", [" + ПостроительОтчета.ВыбранныеПоля[Инд].Имя+"]";
			КонецЕсли;

		КонецЦикла;

		Макет.Область(ОбластьСтрока.Верх,1+1,ОбластьСтрока.Верх,1+КоличествоКолонок+КоличествоПоказателей).Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Параметр;
		Макет.Область(ОбластьСтрока.Верх,1+1,ОбластьСтрока.Верх,1+КоличествоКолонок+КоличествоПоказателей).ЦветФона   = ЦветИзмерения;
		Макет.Область(ОбластьСтрока.Верх,1+1).Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Шаблон;
		Макет.Область(ОбластьСтрока.Верх,1+1).Отступ     = Сч;
		Макет.Область(ОбластьСтрока.Верх,1+1).Текст      = Шаблон;
		Макет.Область(ОбластьСтрока.Верх,1+1).ПараметрРасшифровки = Измерение.Имя;

		Макет.Область(ОбластьСтрокаИерархии.Верх,1+1,ОбластьСтрокаИерархии.Верх,1+КоличествоКолонок+КоличествоПоказателей).Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Параметр;
		Макет.Область(ОбластьСтрокаИерархии.Верх,1+1,ОбластьСтрокаИерархии.Верх,1+КоличествоКолонок+КоличествоПоказателей).ЦветФона   = ЦветИзмерения;
		Макет.Область(ОбластьСтрокаИерархии.Верх,1+1).Отступ   = Сч;
		Макет.Область(ОбластьСтрокаИерархии.Верх,1+1).Параметр = Измерение.Имя;

		Если КоличествоКолонок > 1 Тогда
			Макет.Область(ОбластьСтрока.Верх        , 1+1, ОбластьСтрока.Верх        , 1+КоличествоКолонок).Объединить();
			Макет.Область(ОбластьСтрокаИерархии.Верх, 1+1, ОбластьСтрокаИерархии.Верх, 1+КоличествоКолонок).Объединить();
		КонецЕсли;

		Кол = 0;
		Для Каждого Показатель Из Показатели Цикл

			Если Показатель.Использование = Истина Тогда

				ИмяПоказателя    = Показатель.Имя;
				ФорматПоказателя = мТаблицаПоказатели.Найти(Показатель.Имя).ФорматнаяСтрока;

				Макет.Область(ОбластьСтрока.Верх,1+КоличествоКолонок+1+Кол).Параметр = ИмяПоказателя;
				Макет.Область(ОбластьСтрока.Верх,1+КоличествоКолонок+1+Кол).Формат   = ФорматПоказателя;

				Макет.Область(ОбластьСтрокаИерархии.Верх,1+КоличествоКолонок+1+Кол).Параметр = ИмяПоказателя;
				Макет.Область(ОбластьСтрокаИерархии.Верх,1+КоличествоКолонок+1+Кол).Формат   = ФорматПоказателя;

				Кол= Кол + 1;

			КонецЕсли;

		КонецЦикла;

		НетЛинии        = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, 0);
		ТонкаяОдинарная = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);

		Макет.Область(ОбластьСтрока.Верх, 1 + КоличествоКолонок + 1, ОбластьСтрока.Верх, 1 + КоличествоКолонок + КоличествоПоказателей).ГраницаСверху = ТонкаяОдинарная;
		Макет.Область(ОбластьСтрока.Верх, 1 + КоличествоКолонок + 1, ОбластьСтрока.Верх, 1 + КоличествоКолонок + КоличествоПоказателей).ГраницаСнизу  = ТонкаяОдинарная;
		Если Сч <> ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Тогда
			Макет.Область(ОбластьСтрока.Верх, 1 + КоличествоКолонок + 1, ОбластьСтрока.Верх, 1 + КоличествоКолонок + КоличествоПоказателей).ГраницаСлева  = НетЛинии;
			Макет.Область(ОбластьСтрока.Верх, 1 + КоличествоКолонок + 1, ОбластьСтрока.Верх, 1 + КоличествоКолонок + КоличествоПоказателей).ГраницаСправа = НетЛинии;
		Иначе
			Макет.Область(ОбластьСтрока.Верх, 1 + КоличествоКолонок + 1, ОбластьСтрока.Верх, 1 + КоличествоКолонок + КоличествоПоказателей).ГраницаСлева  = ТонкаяОдинарная;
			Макет.Область(ОбластьСтрока.Верх, 1 + КоличествоКолонок + 1, ОбластьСтрока.Верх, 1 + КоличествоКолонок + КоличествоПоказателей).ГраницаСправа = ТонкаяОдинарная;
		КонецЕсли;

		Макет.Область(ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + 1, ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + КоличествоПоказателей).ГраницаСверху = ТонкаяОдинарная;
		Макет.Область(ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + 1, ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + КоличествоПоказателей).ГраницаСнизу  = ТонкаяОдинарная;
		Если Сч <> ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Тогда
			Макет.Область(ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + 1, ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + КоличествоПоказателей).ГраницаСлева  = НетЛинии;
			Макет.Область(ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + 1, ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + КоличествоПоказателей).ГраницаСправа = НетЛинии;
		Иначе
			Макет.Область(ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + 1, ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + КоличествоПоказателей).ГраницаСлева  = ТонкаяОдинарная;
			Макет.Область(ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + 1, ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + КоличествоПоказателей).ГраницаСправа = ТонкаяОдинарная;
		КонецЕсли;

		Макет.Область(ОбластьСтрока.Верх        , 1 + КоличествоКолонок + 1, ОбластьСтрока.Верх        , 1 + КоличествоКолонок + КоличествоПоказателей).Шрифт = Макет.Область(ОбластьСтрока.Верх        , 1 + КоличествоКолонок + 1).Шрифт;
		Макет.Область(ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + 1, ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + КоличествоПоказателей).Шрифт = Макет.Область(ОбластьСтрокаИерархии.Верх, 1 + КоличествоКолонок + 1).Шрифт;

		Измерение.Макет         = Макет.ПолучитьОбласть(ОбластьСтрока.Верх        , , ОбластьСтрока.Верх        );
		Измерение.МакетИерархии = Макет.ПолучитьОбласть(ОбластьСтрокаИерархии.Верх, , ОбластьСтрокаИерархии.Верх);

	КонецЦикла;

	ДокументРезультат.НачатьАвтогруппировкуСтрок();
	ВывестиСтроку(РезультатЗапроса, 0, КоличествоКолонок, КоличествоПоказателей, ДокументРезультат);
	ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();

	// Первую колонку и строку не печатаем
	ДокументРезультат.ОбластьПечати = ДокументРезультат.Область(2,2,ДокументРезультат.ВысотаТаблицы,ДокументРезультат.ШиринаТаблицы);

	ЛинияСлеваВШапкеТтаблицы = Новый Линия(ДокументРезультат.Область(ВысотаЗаголовка+2, 2).ГраницаСлева.ТипЛинии, ДокументРезультат.Область(ВысотаЗаголовка+2, 2).ГраницаСлева.Толщина);

	// Справа граница той же линией, что и слева в шапке таблицы
	ШиринаТаблицы = 1+КоличествоКолонок+КоличествоПоказателей;
	ДокументРезультат.Область(ВысотаЗаголовка+2, ШиринаТаблицы, ДокументРезультат.ВысотаТаблицы, ШиринаТаблицы).ГраницаСправа = ЛинияСлеваВШапкеТтаблицы;

	// Справа после колонки измерений
	ДокументРезультат.Область(ВысотаЗаголовка+2, 2+КоличествоКолонок-1, ДокументРезультат.ВысотаТаблицы, 2+КоличествоКолонок-1).ГраницаСправа = ЛинияСлеваВШапкеТтаблицы;

	// Слева граница той же линией, что и слева в шапке таблицы
	ДокументРезультат.Область(ВысотаЗаголовка+2, 2, ДокументРезультат.ВысотаТаблицы, 2).ГраницаСлева = ЛинияСлеваВШапкеТтаблицы;

	// Снизу граница той же линией, что и слева в шапке таблицы
	ДокументРезультат.Область(ДокументРезультат.ВысотаТаблицы, 2, ДокументРезультат.ВысотаТаблицы, ШиринаТаблицы).ГраницаСнизу = ЛинияСлеваВШапкеТтаблицы;

	// Снизу шапки той же линией, что и слева в шапке таблицы
	ДокументРезультат.Область(ВысотаФиксации, 2, ВысотаФиксации, ШиринаТаблицы).ГраницаСнизу = ЛинияСлеваВШапкеТтаблицы;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

ОписаниеТиповСтрока = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(100);

МассивБулево = Новый Массив;
МассивБулево.Добавить(Тип("Булево"));
ОписаниеТиповБулево = Новый ОписаниеТипов(МассивБулево);

// Инициализация таблиц всех возможных показателей, группировок,  фильтров
мТаблицаПоказатели = Новый ТаблицаЗначений;
мТаблицаПоказатели.Колонки.Добавить("ИмяПоля",           ОписаниеТиповСтрока);
мТаблицаПоказатели.Колонки.Добавить("ПредставлениеПоля", ОписаниеТиповСтрока);
мТаблицаПоказатели.Колонки.Добавить("ОписаниеПоля",      ОписаниеТиповСтрока);
мТаблицаПоказатели.Колонки.Добавить("ВклПоУмолчанию",    ОписаниеТиповБулево);
мТаблицаПоказатели.Колонки.Добавить("Пометка",           ОписаниеТиповБулево);
мТаблицаПоказатели.Колонки.Добавить("ФорматнаяСтрока",   ОписаниеТиповСтрока);

МассивКатегории = Новый Массив;
МассивКатегории.Добавить(Тип("СправочникСсылка.КатегорииОбъектов"));
ОписаниеТиповКатегории = Новый ОписаниеТипов(МассивКатегории);

мКодыОперацийПродажи = Новый СписокЗначений;
мКодыОперацийПродажи.Добавить(Перечисления.КодыОперацийПартииТоваров.Реализация);
мКодыОперацийПродажи.Добавить(Перечисления.КодыОперацийПартииТоваров.РеализацияРозница);

// Сформируем список объектов анализа отчета
мСписокСтатусовТоваров = Новый СписокЗначений;
мСписокСтатусовТоваров.Добавить("ВсеТовары", "Все товары");
мСписокСтатусовТоваров.Добавить("ТоварыНаСкладах", "Товары на складах");
мСписокСтатусовТоваров.Добавить("ТоварыУКомиссионеров", "Товары у комиссионеров");

мНазваниеОтчета = "Анализ оборачиваемости товаров";

#КонецЕсли