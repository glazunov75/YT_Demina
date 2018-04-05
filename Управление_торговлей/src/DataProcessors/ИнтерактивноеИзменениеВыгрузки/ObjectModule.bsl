#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
//

//  Возвращает технический отчет в виде табличного документа.
//  Опирается на значения реквизитов "УзелИнформационнойБазы", "ДополнительнаяРегистрация"
//
//  Параметры:
//      СписокИменМетаданных: массив (или перечислимое с полем "ПолноеИмяМетаданных") полных имен 
//                            метаданных для ограничения запроса
//
Функция СформироватьТабличныйДокумент(СписокИменМетаданных=Неопределено) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеКомпоновки = ИнициализироватьКомпоновщик(СписокИменМетаданных);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(ДанныеКомпоновки.СхемаКомпоновки, ДанныеКомпоновки.КомпоновщикНастроек.ПолучитьНастройки(), , , Тип("ГенераторМакетаКомпоновкиДанных"));
	Процессор = Новый ПроцессорКомпоновкиДанных;
	Процессор.Инициализировать(Макет, Новый Структура(
		"ТаблицаМетаданныхСоставаУзла", ДанныеКомпоновки.ТаблицаМетаданныхСоставаУзла
	),,Истина);
	Вывод = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	Вывод.УстановитьДокумент(Новый ТабличныйДокумент);
	
	Возврат Вывод.Вывести(Процессор);
КонецФункции

//  Запускает фоновое задание для дополнительной регистрации
//  Возвращает идентификатор фонового задания (или Неопределено для файловой базы)
//
//  Параметры:
//      АдресОбъекта: адрес временного хранилища с параметрами дополнительной регистрации
//
Функция ФоноваяРегистрацияДополнительныхИзменений() Экспорт
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ЗарегистрироватьДополнительныеИзменения();
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(ЭтотОбъектВСтруктуруДляФонового());
	
	Возврат ОбменДаннымиСервер.ЗапуститьФоновоеЗадание(
		"ОбменДаннымиСервер.ИнтерактивноеИзменениеВыгрузки_ЗарегистрироватьДополнительныеИзменения",
		ПараметрыЗадания, НСтр("ru='Регистрация дополнительных данных для отправки при синхронизации'")
	);
	
КонецФункции

//  Запускает фоновое задание для формирования отчета.
//  Возвращает идентификатор фонового задания (или Неопределено для файловой базы)
//  Опирается на значения реквизитов "УзелИнформационнойБазы", "ДополнительнаяРегистрация"
//
//  Параметры:
//      АдресРезультата:     адрес во временном хранилище, куда будет помещен результат
//      ПолноеИмяМетаданных: параметр отчета
//      Представление:       параметр отчета
//
Функция ФоновоеФормированиеТабличногоДокументаПользователя(АдресРезультата, ПолноеИмяМетаданных="", Представление="") Экспорт
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресРезультата = ПоместитьВоВременноеХранилище(
			СформироватьТабличныйДокументПользователя(ПолноеИмяМетаданных, Представление)
		);
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(ЭтотОбъектВСтруктуруДляФонового());
	ПараметрыЗадания.Добавить(АдресРезультата);
	ПараметрыЗадания.Добавить(ПолноеИмяМетаданных);
	ПараметрыЗадания.Добавить(Представление);
	
	Возврат ОбменДаннымиСервер.ЗапуститьФоновоеЗадание(
		"ОбменДаннымиСервер.ИнтерактивноеИзменениеВыгрузки_СформироватьТабличныйДокументПользователя",
		ПараметрыЗадания, НСтр("ru='Формирование отчета по составу данных для отправки при синхронизации'")
	);
КонецФункции

//  Запускает фоновое задание для формирования дерева значений с данными.
//  Возвращает идентификатор фонового задания (или Неопределено для файловой базы)
//  Опирается на значения реквизитов "УзелИнформационнойБазы", "ДополнительнаяРегистрация"
//
//  Параметры:
//      АдресРезультата:      адрес во временном хранилище, куда будет помещен результат
//      СписокИменМетаданных: параметр отчета
//
Функция ФоновоеФормированиеДереваЗначений(АдресРезультата, СписокИменМетаданных=Неопределено) Экспорт
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресРезультата = ПоместитьВоВременноеХранилище( СформироватьДеревоЗначений(СписокИменМетаданных) );
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(ЭтотОбъектВСтруктуруДляФонового());
	ПараметрыЗадания.Добавить(АдресРезультата);
	ПараметрыЗадания.Добавить(СписокИменМетаданных);
	
	Возврат ОбменДаннымиСервер.ЗапуститьФоновоеЗадание(
		"ОбменДаннымиСервер.ИнтерактивноеИзменениеВыгрузки_СформироватьДеревоЗначений",
		ПараметрыЗадания, НСтр("ru='Расчет количества объектов для отправки при синхронизации'")
	);
	
КонецФункции

//  Возвращает пользовательский отчет в виде табличного документа.
//  Опирается на значения реквизитов "УзелИнформационнойБазы", "ДополнительнаяРегистрация"
//
Функция СформироватьТабличныйДокументПользователя(ПолноеИмяМетаданных="", Представление="") Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеКомпоновки = ИнициализироватьКомпоновщик();
	
	Если ПустаяСтрока(ПолноеИмяМетаданных) Тогда
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
		ИмяВарианта = "ПользовательскиеДанные"; 
	Иначе
		ДанныеРасшифровки = Неопределено;
		ИмяВарианта = "РасшифровкаПоВидуОбъекта"; 
	КонецЕсли;
	
	// сохраняем отборы
	НастройкиОтборов = ДанныеКомпоновки.КомпоновщикНастроек.ПолучитьНастройки();
	
	// Нужный вариант
	ДанныеКомпоновки.КомпоновщикНастроек.ЗагрузитьНастройки(
		ДанныеКомпоновки.СхемаКомпоновки.ВариантыНастроек[ИмяВарианта].Настройки
	);
	
	// восстанавливаем отборы
	ДобавитьЗначенияОтбораКомпоновки(
		ДанныеКомпоновки.КомпоновщикНастроек.Настройки.Отбор.Элементы, 
		НастройкиОтборов.Отбор.Элементы
	);
	
	Параметры = ДанныеКомпоновки.СхемаКомпоновки.Параметры;
	Параметры.Найти("ДатаФормирования").Значение = ТекущаяДатаСеанса();
	
	Параметры.Найти("ТекстОбщихПараметровСинхронизации").Значение = ОбменДаннымиСервер.ОписаниеОграниченийПередачиДанных(УзелИнформационнойБазы);
	Параметры.Найти("ТекстДополнительныхПараметров").Значение     = ТекстДополнительныхПараметров();
	
	Если Не ПустаяСтрока(ПолноеИмяМетаданных) Тогда
		Параметры.Найти("ПредставлениеСписка").Значение = Представление;
		
		ЭлементыОтбора = ДанныеКомпоновки.КомпоновщикНастроек.Настройки.Отбор.Элементы;
		
		Элемент = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Элемент.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ПолноеИмяМетаданных");
		Элемент.Представление  = Представление;
		Элемент.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		Элемент.ПравоеЗначение = ПолноеИмяМетаданных;
		Элемент.Использование  = Истина;
	КонецЕсли;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(ДанныеКомпоновки.СхемаКомпоновки, ДанныеКомпоновки.КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки, , Тип("ГенераторМакетаКомпоновкиДанных"));
	Процессор = Новый ПроцессорКомпоновкиДанных;
	Процессор.Инициализировать(Макет, Новый Структура(
		"ТаблицаМетаданныхСоставаУзла", ДанныеКомпоновки.ТаблицаМетаданныхСоставаУзла
	), ДанныеРасшифровки, Истина);
	
	Вывод = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	Вывод.УстановитьДокумент(Новый ТабличныйДокумент);
	
	Возврат Новый Структура("ТабличныйДокумент, Расшифровка, СхемаКомпоновки",
		Вывод.Вывести(Процессор), ДанныеРасшифровки, ДанныеКомпоновки.СхемаКомпоновки
	);
КонецФункции

//  Возвращает данные в виде двухуровневого дерева, первый уровень-вид метаданных, второй-объекты
//  Опирается на значения реквизитов "УзелИнформационнойБазы", "ДополнительнаяРегистрация"
//
//  Параметры:
//      СписокИменМетаданных: массив (или перечислимое с полем "ПолноеИмяМетаданных") полных имен 
//                            метаданных для ограничения запроса
//
Функция СформироватьДеревоЗначений(СписокИменМетаданных=Неопределено) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеКомпоновки = ИнициализироватьКомпоновщик(СписокИменМетаданных);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(ДанныеКомпоновки.СхемаКомпоновки, ДанныеКомпоновки.КомпоновщикНастроек.ПолучитьНастройки(), , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	Процессор = Новый ПроцессорКомпоновкиДанных;
	Процессор.Инициализировать(Макет, Новый Структура(
		"ТаблицаМетаданныхСоставаУзла", ДанныеКомпоновки.ТаблицаМетаданныхСоставаУзла
	),,Истина);
	Вывод = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Вывод.УстановитьОбъект(Новый ДеревоЗначений);
	ДеревоРезультата = Вывод.Вывести(Процессор);
	
	Возврат ДеревоРезультата;
КонецФункции

//  Инициализирует весь объект
//
//  Параметры:
//      АдресОбъекта: адрес объекта-источника во временном хранилище
//
Функция ИнициализироватьЭтотОбъект(АдресОбъекта="") Экспорт
	Если Не ПустаяСтрока(АдресОбъекта) Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПолучитьИзВременногоХранилища(АдресОбъекта));
	КонецЕсли;
	Возврат ЭтотОбъект;
КонецФункции

//  Возвращает компоновщик для общих отборов узла "УзелИнформационнойБазы"
//  Опирается на значения реквизитов "УзелИнформационнойБазы", "ДополнительнаяРегистрация"
//
//  Параметры:
//      АдресСохраненияСхемы: адрес временного хранилища для сохранения схемы компоновки
//                            (обход особенности платформы)  
//
Функция КомпоновщикНастроекОбщегоОтбора(АдресСохраненияСхемы=Неопределено) Экспорт
	
	СохраненныйВариант = ВариантВыгрузки;
	
	ВариантВыгрузки = 1;
	Результат = ИнициализироватьКомпоновщик(Неопределено, Истина, АдресСохраненияСхемы);
	
	ВариантВыгрузки = СохраненныйВариант;
	
	Возврат Результат.КомпоновщикНастроек
КонецФункции

//  Возвращает компоновщик для отборов одного вида метаданных узла "УзелИнформационнойБазы"
//
//  Параметры:
//      ПолноеИмяМетаданных:  имя таблицы для построения компоновщика. Возможно там будут 
//                            идентификаторы для "всех документов" или "всех справочников"
//                            или ссылка на группу.
//      Представление:        представление объекта в отборе
//      Отбор:                отбор компоновки для заполнения
//      АдресСохраненияСхемы: адрес временного хранилища для сохранения схемы компоновки
//                            (обход особенности платформы)  
//
Функция КомпоновщикНастроекПоИмениТаблицы(ПолноеИмяМетаданных, Представление=Неопределено, Отбор=Неопределено, АдресСохраненияСхемы=Неопределено) Экспорт
	
	СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
	
	Источник = СхемаКомпоновки.ИсточникиДанных.Добавить();
	Источник.Имя = "Источник";
	Источник.ТипИсточникаДанных = "local";
	
	ДобавляемыеТаблицы = СоставУкрупненнойГруппыМетаданных(ПолноеИмяМетаданных);
	
	Для Каждого ИмяТаблицы Из ДобавляемыеТаблицы Цикл
		ДобавитьНаборВСхемуКомпоновки(СхемаКомпоновки, ИмяТаблицы, Представление);
	КонецЦикла;
	
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(
		ПоместитьВоВременноеХранилище(СхемаКомпоновки, АдресСохраненияСхемы)
	));
	
	Если Отбор<>Неопределено Тогда
		ДобавитьЗначенияОтбораКомпоновки(Компоновщик.Настройки.Отбор.Элементы, Отбор.Элементы);
		Компоновщик.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	КонецЕсли;
	
	Возврат Компоновщик;
КонецФункции

//  Возвращает префикс для получения имен форм текущего объекта
//
Функция БазовоеИмяДляФормы() Экспорт
	Возврат Метаданные().ПолноеИмя() + "."
КонецФункции

//  Возвращает описание периода и отбора строкой
//
//  Параметры:
//      Период:                период для описания отбора
//      Отбор:                 отбор компоновки данных для описания
//      ОписаниеПустогоОтбора: значение, возвращаемое в случае пустого отбора
//
Функция ПредставлениеОтбора(Период, Отбор, Знач ОписаниеПустогоОтбора=Неопределено) Экспорт
	
	НашОтбор = ?(ТипЗнч(Отбор)=Тип("КомпоновщикНастроекКомпоновкиДанных"), Отбор.Настройки.Отбор, Отбор);
	
	ПериодСтрокой = ?(ЗначениеЗаполнено(Период), Строка(Период), "");
	ОтборСтрокой  = Строка(НашОтбор);
	
	Если ПустаяСтрока(ОтборСтрокой) Тогда
		Если ОписаниеПустогоОтбора=Неопределено Тогда
			ОтборСтрокой = НСтр("ru='Все объекты'");
		Иначе
			ОтборСтрокой = ОписаниеПустогоОтбора;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ПериодСтрокой) Тогда
		ОтборСтрокой =  ПериодСтрокой + ", " + ОтборСтрокой;
	КонецЕсли;
	
	Возврат ОтборСтрокой;
КонецФункции

//  Возвращает описание периода и отбора по реквизитам "ПериодОтбораВсехДокументов" и "КомпоновщикОтбораВсехДокументов"
//
//  Параметры:
//      ОписаниеПустогоОтбора: значение, возвращаемое в случае пустого отбора
//
Функция ПредставлениеОтбораВсехДокументов(Знач ОписаниеПустогоОтбора=Неопределено) Экспорт
	
	Если ОписаниеПустогоОтбора=Неопределено Тогда
		ОписаниеПустогоОтбора = НСтр("ru='Все документы'");
	КонецЕсли;
	
	Возврат ПредставлениеОтбора("", КомпоновщикОтбораВсехДокументов, ОписаниеПустогоОтбора);
КонецФункции

//  Возвращает описание детального отбора по реквизиту "ДополнительнаяРегистрация"
//
//  Параметры:
//      ОписаниеПустогоОтбора: значение, возвращаемое в случае пустого отбора
//
Функция ПредставлениеДетальногоОтбора(Знач ОписаниеПустогоОтбора=Неопределено) Экспорт
	
	Текст = "";
	Для Каждого Строка Из ДополнительнаяРегистрация Цикл
		Текст = Текст + Символы.ПС + Строка.Представление + ": " + ПредставлениеОтбора(Строка.Период, Строка.Отбор);
	КонецЦикла;
	
	Если Не ПустаяСтрока(Текст) Тогда
		Возврат СокрЛП(Текст);
		
	ИначеЕсли ОписаниеПустогоОтбора=Неопределено Тогда
		Возврат НСтр("ru='Дополнительные данные не выбраны'");
		
	КонецЕсли;
	
	Возврат ОписаниеПустогоОтбора;
КонецФункции

// Идентификатор служебной группы объектов метаданных "Все документы"
//
Функция ИдентификаторВсехДокументов() Экспорт
	// Не должно пересекаться с полным именем метаданных
	Возврат "ВсеДокументы";
КонецФункции

//
// Идентификатор служебной группы объектов метаданных "Все справочники"
//
Функция ИдентификаторВсехСправочников() Экспорт
	// Не должно пересекаться с полным именем метаданных
	Возврат "ВсеСправочники";
КонецФункции

//
//  Добавляет отбор в конец отбора с возможной коррекцией полей
//
//  Параметры:
//      ЭлементыПриемника: КоллекцияЭлементовОтбораКомпоновкиДанных - приемник
//      ЭлементыИсточника: КоллекцияЭлементовОтбораКомпоновкиДанных - источник
//      СоответствиеПолей: Коллекция объектов КлючИЗначение, у которых
//                         Ключ - исходный путь к данным поля, Значение - путь 
//                         для результата. Например для замены полей типа
//                         "Ссылка.Наименование" -> "ОбъектРегистрации.Наименование"
//                         надо передать Новый Структура("Ссылка", "ОбъектРегистрации")
//
Процедура ДобавитьЗначенияОтбораКомпоновки(ЭлементыПриемника, ЭлементыИсточника, СоответствиеПолей=Неопределено) Экспорт
	
	Для Каждого Элемент Из ЭлементыИсточника Цикл
		
		Тип=ТипЗнч(Элемент);
		ЭлементОтбора = ЭлементыПриемника.Добавить(Тип);
		ЗаполнитьЗначенияСвойств(ЭлементОтбора, Элемент);
		Если Тип=Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			ДобавитьЗначенияОтбораКомпоновки(ЭлементОтбора.Элементы, Элемент.Элементы, СоответствиеПолей);
			
		ИначеЕсли СоответствиеПолей<>Неопределено Тогда
			ИсходноеПолеСтрокой = Элемент.ЛевоеЗначение;
			ИсходноеПолеНРег    = НРег(ИсходноеПолеСтрокой);
			Для Каждого КлючЗначение Из СоответствиеПолей Цикл
				КонтрольНовое     = НРег(КлючЗначение.Ключ);
				ДлинаКонтроля     = 1 + СтрДлина(КонтрольНовое);
				КонтрольИсходного = НРег(Лев(ИсходноеПолеСтрокой, ДлинаКонтроля));
				Если КонтрольИсходного=КонтрольНовое Тогда
					ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(КлючЗначение.Значение);
					Прервать;
				ИначеЕсли КонтрольИсходного=КонтрольНовое+"." Тогда
					ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(КлючЗначение.Значение + Сред(ИсходноеПолеСтрокой, ДлинаКонтроля));
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

//  Возвращает элемент списка значений по представлению
//
//  Параметры:
//      СписокЗначений: список для поиска
//      Представление:  параметр для поиска
//
Функция НайтиПоПредставлениюЭлементСписка(СписокЗначений, Представление) Экспорт
	Для Каждого ЭлементСписка Из СписокЗначений Цикл
		Если ЭлементСписка.Представление=Представление Тогда
			Возврат ЭлементСписка;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

//  Производит дополнительную регистрацию по текущим данными объекта
//
Процедура ЗарегистрироватьДополнительныеИзменения() Экспорт
	
	Если ВариантВыгрузки=0 Тогда
		// без изменений
		Возврат;
	КонецЕсли;
	
	ДеревоИзменений = СформироватьДеревоЗначений();
	
	УстановитьПривилегированныйРежим(Истина);
	Для Каждого СтрокаГруппы Из ДеревоИзменений.Строки Цикл
		Для Каждого Строка Из СтрокаГруппы.Строки Цикл
			Если Строка.КоличествоДляВыгрузки>0 Тогда
				ПланыОбмена.ЗарегистрироватьИзменения(УзелИнформационнойБазы, Строка.ОбъектРегистрации);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

//  Возвращает список значений из представлений возможных настроек
//
//  Параметры:
//      УзелОбмена: ссылка на узел обмена для возвращаемых настроек. Если не указано, то используется 
//                  текущее значение реквизита "УзелИнформационнойБазы"
//
Функция ПрочитатьПредставленияСпискаНастроек(УзелОбмена=Неопределено) Экспорт
	
	ПараметрыНастроек = СтруктураПараметровНастроек(УзелОбмена);
	
	УстановитьПривилегированныйРежим(Истина);    
	СписокВариантов = ХранилищеОбщихНастроек.Загрузить(
	ПараметрыНастроек.КлючОбъекта, ПараметрыНастроек.КлючНастроек,
	ПараметрыНастроек, ПараметрыНастроек.Пользователь
	);
	
	СписокПредставлений = Новый СписокЗначений;
	Если СписокВариантов<>Неопределено Тогда
		Для Каждого Элемент Из СписокВариантов Цикл
			СписокПредставлений.Добавить(Элемент.Представление, Элемент.Представление);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СписокПредставлений;
КонецФункции

//  Восстанавливает значения реквизитов текущего объекта из указанного элемента списка
//
//  Параметры:
//      АдресВариантовНастроек: адрес во временном хранилище списка значений настроек
//      Представление:          представление восстанавливаемых настроек
//
Процедура ВосстановитьТекущееИзНастроек(Представление) Экспорт
	
	СписокВариантов = ПрочитатьСписокНастроек();
	Вариант = НайтиПоПредставлениюЭлементСписка(СписокВариантов, Представление);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Вариант.Значение);
	
	КомпоновщикОтбораВсехДокументов.ЗагрузитьНастройки(Вариант.Значение._НастройкиКомпоновщикаОтбораВсехДокументов);
КонецПроцедуры

//  Сохраняет значения реквизитов текущего объекта в настройки с указанным представлением
//
//  Параметры:
//      АдресВариантовНастроек: адрес во временном хранилище списка значений настроек
//      Представление:          представление сохраняемых настроек
//
Процедура СохранитьТекущееВНастройки(Представление) Экспорт
	СписокВариантов = ПрочитатьСписокНастроек();
	
	ЭлементСписка = НайтиПоПредставлениюЭлементСписка(СписокВариантов, Представление);
	Если ЭлементСписка=Неопределено Тогда
		ЭлементСписка = СписокВариантов.Добавить(,Представление);
		СписокВариантов.СортироватьПоПредставлению();
	КонецЕсли;
	ЭлементСписка.Значение = Новый Структура("УзелИнформационнойБазы, ВариантВыгрузки, ПериодОтбораВсехДокументов, ДополнительнаяРегистрация");
	ЗаполнитьЗначенияСвойств(ЭлементСписка.Значение, ЭтотОбъект);
	
	ЭлементСписка.Значение.Вставить("_НастройкиКомпоновщикаОтбораВсехДокументов", 
		// Без фиксированных настроек!
		КомпоновщикОтбораВсехДокументов.Настройки
	);
	
	ПараметрыНастроек = СтруктураПараметровНастроек();
	
	УстановитьПривилегированныйРежим(Истина);
	ХранилищеОбщихНастроек.Сохранить(
		ПараметрыНастроек.КлючОбъекта, ПараметрыНастроек.КлючНастроек, 
		СписокВариантов, 
		ПараметрыНастроек, ПараметрыНастроек.Пользователь
	);
КонецПроцедуры

//  Удаляет вариант настроек из списка
//
//  Параметры:
//      АдресВариантовНастроек: адрес во временном хранилище списка значений настроек
//      Представление:          представление удаляемых  настроек
//
Процедура УдалитьВариантНастроек(Представление) Экспорт
	СписокВариантов = ПрочитатьСписокНастроек();
	ЭлементСписка = НайтиПоПредставлениюЭлементСписка(СписокВариантов, Представление);
	
	Если ЭлементСписка<>Неопределено Тогда
		СписокВариантов.Удалить(ЭлементСписка);
		СписокВариантов.СортироватьПоПредставлению();
		СохранитьСписокНастроек(СписокВариантов);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает массив имен таблиц метаданных по составному типу параметра "ПолноеИмяМетаданных"
// Опирается на текущее значение реквизита "УзелИнформационнойБазы"
//
// Параметры:
//      ПолноеИмяМетаданных - имя таблицы (например "Справочник.Валюты") или имя предопределенной группы
//                            (например "ВсеДокументы") или дерево значений, описывающее группу
//
Функция СоставУкрупненнойГруппыМетаданных(ПолноеИмяМетаданных) Экспорт
	
	Если ТипЗнч(ПолноеИмяМетаданных)<>Тип("Строка") Тогда
		// Дерево значений с группой отбора. Корень - описание, в строках - имена метаданных
		ТаблицыСостава = Новый Массив;
		Для Каждого СтрокаГруппы Из ПолноеИмяМетаданных.Строки Цикл
			Для Каждого СтрокаСоставаГруппы Из СтрокаГруппы.Строки Цикл
				ТаблицыСостава.Добавить(СтрокаСоставаГруппы.ПолноеИмяМетаданных);
			КонецЦикла;
		КонецЦикла;
		
	ИначеЕсли ПолноеИмяМетаданных=ИдентификаторВсехДокументов() Тогда
		// Все документы узла
		ВсеДанные = ОбменДаннымиСервер.СсылочныеТаблицыСоставаУзла(УзелИнформационнойБазы, Истина, Ложь);
		ТаблицыСостава = ВсеДанные.ВыгрузитьКолонку("ПолноеИмяМетаданных");
		
	ИначеЕсли ПолноеИмяМетаданных=ИдентификаторВсехСправочников() Тогда
		// Все справочники узла
		ВсеДанные = ОбменДаннымиСервер.СсылочныеТаблицыСоставаУзла(УзелИнформационнойБазы, Ложь, Истина);
		ТаблицыСостава = ВсеДанные.ВыгрузитьКолонку("ПолноеИмяМетаданных");
		
	Иначе
		// Одиночная таблица метаданных
		ТаблицыСостава = Новый Массив;
		ТаблицыСостава.Добавить(ПолноеИмяМетаданных);
		
	КонецЕсли;
	
	Возврат ТаблицыСостава;
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

//  Конструктор таблиц значений. Генерирует таблицу с колонками произвольного типа.
//
//  Параметры:
//      СписокКолонок:  список имен колонок таблицы через запятую.
//      СписокИндексов: список индексов таблицы через запятую.
//
Функция ТаблицаЗначений(СписокКолонок, СписокИндексов="")
	ТаблицаРезультата = Новый ТаблицаЗначений;
	
	Для Каждого КлючЗначение Из (Новый Структура(СписокКолонок)) Цикл
		ТаблицаРезультата.Колонки.Добавить(КлючЗначение.Ключ);
	КонецЦикла;
	Для Каждого КлючЗначение Из (Новый Структура(СписокИндексов)) Цикл
		ТаблицаРезультата.Индексы.Добавить(КлючЗначение.Ключ);
	КонецЦикла;
	
	Возврат ТаблицаРезультата;
КонецФункции

//  Добавляет одиночный элемент отбора в список.
//
//  Параметры:
//      ЭлементыОтбора:  ссылка на проверяемый объект.
//      ПутьПоляКДанным: путь к данным для добавляемого элемента
//      ВидСравнения:    вид сравнения для добавляемого элемента
//      Значение:        значение сравнения для добавляемого элемента
//      Представление:   необязательное представление поля
//      
Процедура ДобавитьЭлементОтбора(ЭлементыОтбора, ПутьПоляКДанным, ВидСравнения, Значение, Представление=Неопределено)
	
	Элемент = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Элемент.Использование  = Истина;
	Элемент.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПутьПоляКДанным);
	Элемент.ВидСравнения   = ВидСравнения;
	Элемент.ПравоеЗначение = Значение;
	
	Если Представление<>Неопределено Тогда
		Элемент.Представление = Представление;
	КонецЕсли;
КонецПроцедуры

//  Добавляет в схему компоновки набор данных с одним полем "Ссылка" по имени таблицы
//
//  Параметры:
//      СхемаКомпоновкиДанных: схема, в которую происходит добавление
//      ИмяТаблицы:            имя таблицы данных
//      Представление:         представление для поля "ссылка"
//
Процедура ДобавитьНаборВСхемуКомпоновки(СхемаКомпоновкиДанных, ИмяТаблицы, Представление=Неопределено)
	
	Набор = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	Набор.Запрос = "
		|ВЫБРАТЬ 
		|   Ссылка
		|ИЗ 
		|   " + ИмяТаблицы + "
		|";
	Набор.АвтоЗаполнениеДоступныхПолей = Истина;
	Набор.ИсточникДанных = СхемаКомпоновкиДанных.ИсточникиДанных[0].Имя;
	Набор.Имя = "Набор" + Формат(СхемаКомпоновкиДанных.НаборыДанных.Количество()-1, "ЧН=; ЧГ=");
	
	Поле = Набор.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	Поле.Поле = "Ссылка";
	Поле.Заголовок = ?(Представление=Неопределено, ОбменДаннымиСервер.ПредставлениеОбъекта(ИмяТаблицы), Представление);
	
КонецПроцедуры

//  Добавляет в структуру компоновки структуру из коллекции
//
//  Параметры:
//      ЭлементыПриемника: КоллекцияЭлементовСтруктурыНастроекКомпоновкиДанных - приемник
//      ЭлементыИсточника: КоллекцияЭлементовСтруктурыНастроекКомпоновкиДанных - источник
//
Процедура ДобавитьЗначенияСтруктурыКомпоновки(ЭлементыПриемника, ЭлементыИсточника)
	Для Каждого Элемент Из ЭлементыИсточника Цикл
		Тип=ТипЗнч(Элемент);
		ЭлементОтбора = ЭлементыПриемника.Добавить(Тип);
		ЗаполнитьЗначенияСвойств(ЭлементОтбора, Элемент);
		Если Тип=Тип("ГруппировкаКомпоновкиДанных") Тогда
			ДобавитьЗначенияСтруктурыКомпоновки(ЭлементОтбора.Элементы, Элемент.Элементы);
		КонецЕсли;
	КонецЦикла
КонецПроцедуры

//  Устанавливает наборы данных в схему и инициализирует компоновщик
//  Опирается на значения реквизитов:
//    "УзелИнформационнойБазы", "ДополнительнаяРегистрация", 
//    "ВариантВыгрузки", "ПериодОтбораВсехДокументов", "КомпоновщикОтбораВсехДокументов"
//
//  Вовзращает структуру с полями "ТаблицаМетаданныхСоставаУзла, СхемаКомпоновки, КомпоновщикНастроек"
//
//  Параметры:
//      СписокИменМетаданных:             массив (или перечислимое с полем "ПолноеИмяМетаданных") имен 
//                                        метаданных (деревья значений группы ограничений, служебных идентификаторов 
//                                        "все документов" или "все НСИ"), для которых будет построена  схема. 
//                                        Если не указано, то для всего состава узла.
//      ОграничиватьИспользованиеОтбором: флаг того, что компоновка будет инициализирована только
//                                        для отбора элементов выгрузки
//      АдресСохраненияСхемы:             адрес временного хранилища для сохранения схемы компоновки
//                                        (обход особенности платформы)  
//
Функция ИнициализироватьКомпоновщик(СписокИменМетаданных=Неопределено, ОграничиватьИспользованиеОтбором=Ложь, АдресСохраненияСхемы=Неопределено)
	
	ТаблицаМетаданныхСоставаУзла = ОбменДаннымиСервер.СсылочныеТаблицыСоставаУзла(УзелИнформационнойБазы);
	СхемаКомпоновки = ПолучитьМакет("СхемаКомпоновкиДанных");
	
	// Наборы для общего количества
	ЭлементыНаборыКоличества = СхемаКомпоновки.НаборыДанных.ОбщееКоличествоЭлементов.Элементы;
	
	// Наборы для каждого нужного вида метаданных
	ЭлементыНабораИзменения = СхемаКомпоновки.НаборыДанных.РегистрацияИзменений.Элементы;
	Пока ЭлементыНабораИзменения.Количество()>1 Цикл
		// [0] - Описание полей
		ЭлементыНабораИзменения.Удалить(ЭлементыНабораИзменения[1]);
	КонецЦикла;
	ИсточникДанных = СхемаКомпоновки.ИсточникиДанных[0].Имя;
	
	// Фильтр того, чего от нас хотят
	ФильтрИменМетаданных = Новый Соответствие;
	Если СписокИменМетаданных<>Неопределено Тогда
		Если ТипЗнч(СписокИменМетаданных)=Тип("Массив") Тогда
			Для Каждого МетаИмя Из СписокИменМетаданных Цикл
				ФильтрИменМетаданных.Вставить(МетаИмя, Истина);
			КонецЦикла;
		Иначе
			Для Каждого Элемент Из СписокИменМетаданных Цикл
				ФильтрИменМетаданных.Вставить(Элемент.ПолноеИмяМетаданных, Истина);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	// Автоматические изменения и количества всегда
	Для Каждого Строка Из ТаблицаМетаданныхСоставаУзла Цикл
		ПолноеИмяМетаданных = Строка.ПолноеИмяМетаданных;
		Если СписокИменМетаданных<>Неопределено И ФильтрИменМетаданных[ПолноеИмяМетаданных]<>Истина Тогда
			Продолжить;
		КонецЕсли;
		
		Набор = ЭлементыНабораИзменения.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
		
		// В отбор попадет только если не строим отбор
		Набор.АвтоЗаполнениеДоступныхПолей = Не ОграничиватьИспользованиеОтбором;
		
		Набор.ИсточникДанных = ИсточникДанных;
		Набор.Имя = "Автоматически" + Формат(ЭлементыНабораИзменения.Количество()-1, "ЧН=; ЧГ=");
		Набор.Запрос = "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
			|	Ссылка                           КАК ОбъектРегистрации,
			|	ТИП(" + ПолноеИмяМетаданных + ") КАК ОбъектРегистрацииТип,
			|	&ПричинаРегистрацииАвтоматически КАК ПричинаРегистрации
			|ИЗ
			|	" + ПолноеИмяМетаданных + ".Изменения
			|ГДЕ
			|	Узел=&УзелИнформационнойБазы
			|";
		
		Набор = ЭлементыНаборыКоличества.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
		Набор.АвтоЗаполнениеДоступныхПолей = Истина;
		Набор.ИсточникДанных = ИсточникДанных;
		Набор.Имя = "Количества" + Формат(ЭлементыНаборыКоличества.Количество()-1, "ЧН=; ЧГ=");
		Набор.Запрос = "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ТИП(" + ПолноеИмяМетаданных + ") КАК Тип,
			|	КОЛИЧЕСТВО(Ссылка)               КАК ОбщееКоличество
			|ИЗ
			|	" + ПолноеИмяМетаданных + "
			|";
	КонецЦикла;
	
	// Варианты дополнительных изменений
	Если ВариантВыгрузки=1 Тогда
		// Общий отбор по шапке
		ТаблицаДополнительныхИзменений = ТаблицаЗначений("ПолноеИмяМетаданных, Отбор, Период, ВыборПериода");
		Строка = ТаблицаДополнительныхИзменений.Добавить();
		Строка.ПолноеИмяМетаданных = ИдентификаторВсехДокументов();
		Строка.ВыборПериода        = Истина;
		Строка.Период              = ПериодОтбораВсехДокументов;
		Строка.Отбор               = КомпоновщикОтбораВсехДокументов.Настройки.Отбор;
		
	ИначеЕсли ВариантВыгрузки=2 Тогда
		// Детальный отбор
		ТаблицаДополнительныхИзменений = ДополнительнаяРегистрация;
		
	Иначе
		// Без дополнительных изменений вообще
		ТаблицаДополнительныхИзменений = Новый ТаблицаЗначений;
		
	КонецЕсли;        
	
	// Дополнительные изменения
	Для Каждого Строка Из ТаблицаДополнительныхИзменений Цикл
		ПолноеИмяМетаданных = Строка.ПолноеИмяМетаданных;
		Если СписокИменМетаданных<>Неопределено И ФильтрИменМетаданных[ПолноеИмяМетаданных]<>Истина Тогда
			Продолжить;
		КонецЕсли;
		
		ДобавляемыеТаблицы = СоставУкрупненнойГруппыМетаданных(ПолноеИмяМетаданных);
		Для Каждого ИмяДобавляемойТаблицы Из ДобавляемыеТаблицы Цикл
			Если СписокИменМетаданных<>Неопределено И ФильтрИменМетаданных[ИмяДобавляемойТаблицы]<>Истина Тогда
				Продолжить;
			КонецЕсли;
			
			Набор = ЭлементыНабораИзменения.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
			Набор.АвтоЗаполнениеДоступныхПолей = Истина;
			Набор.ИсточникДанных = ИсточникДанных;
			Набор.Имя = "Дополнительно" + Формат(ЭлементыНабораИзменения.Количество()-1, "ЧН=; ЧГ=");
			Набор.Запрос = "
				|ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	Ссылка                             КАК ОбъектРегистрации,
				|	ТИП(" + ИмяДобавляемойТаблицы + ") КАК ОбъектРегистрацииТип,
				|	&ПричинаРегистрацииДополнительно   КАК ПричинаРегистрации
				|ИЗ
				|	" + ИмяДобавляемойТаблицы + "
				|";
		КонецЦикла;
	КонецЦикла;
	
	// Общие параметры
	Параметры = СхемаКомпоновки.Параметры;
	Параметры.Найти("УзелИнформационнойБазы").Значение = УзелИнформационнойБазы;
	
	ПараметрАвтоматически = Параметры.Найти("ПричинаРегистрацииАвтоматически");
	ПараметрАвтоматически.Значение = "По общим правилам";
	
	ПараметрДополнительно = Параметры.Найти("ПричинаРегистрацииДополнительно");
	ПараметрДополнительно.Значение = "Дополнительно";
	
	ПараметрПоСсылке = Параметры.Найти("ПричинаРегистрацииПоСсылке");
	ПараметрПоСсылке.Значение = "По ссылке";
	
	Если ОграничиватьИспользованиеОтбором Тогда
		Поля = СхемаКомпоновки.НаборыДанных.РегистрацияИзменений.Поля;
		Ограничение = Поля.Найти("ОбъектРегистрацииТип").ОграничениеИспользования;
		Ограничение.Условие = Истина;
		Ограничение = Поля.Найти("ПричинаРегистрации").ОграничениеИспользования;
		Ограничение.Условие = Истина;
		
		Поля = СхемаКомпоновки.НаборыДанных.ТаблицаМетаданныхСоставаУзла.Поля;
		Ограничение = Поля.Найти("ПредставлениеСписка").ОграничениеИспользования;
		Ограничение.Условие = Истина;
		Ограничение = Поля.Найти("Представление").ОграничениеИспользования;
		Ограничение.Условие = Истина;
		Ограничение = Поля.Найти("ПолноеИмяМетаданных").ОграничениеИспользования;
		Ограничение.Условие = Истина;
		Ограничение = Поля.Найти("Периодический").ОграничениеИспользования;
		Ограничение.Условие = Истина;
	КонецЕсли;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(
		ПоместитьВоВременноеХранилище(СхемаКомпоновки, АдресСохраненияСхемы)
	));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновки.НастройкиПоУмолчанию);
	
	Если ТаблицаДополнительныхИзменений.Количество()>0 Тогда 
		
		Если ОграничиватьИспользованиеОтбором Тогда
			КореньНастроек = КомпоновщикНастроек.ФиксированныеНастройки;
		Иначе
			КореньНастроек = КомпоновщикНастроек.Настройки;
		КонецЕсли;
		
		// Добавляем настройки для отбора дополнительных данных
		ГруппаОтбора = КореньНастроек.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.Использование = Истина;
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		ЭлементыОтбора = ГруппаОтбора.Элементы;
		
		// Авторегистрацию подтягиваем всегда
		ДобавитьЭлементОтбора(ГруппаОтбора.Элементы, "ПричинаРегистрации", ВидСравненияКомпоновкиДанных.Равно, ПараметрАвтоматически.Значение);
		ДобавитьЭлементОтбора(ГруппаОтбора.Элементы, "ПричинаРегистрации", ВидСравненияКомпоновкиДанных.Равно, ПараметрПоСсылке.Значение);
		
		Для Каждого Строка Из ТаблицаДополнительныхИзменений Цикл
			ПолноеИмяМетаданных = Строка.ПолноеИмяМетаданных;
			Если СписокИменМетаданных<>Неопределено И ФильтрИменМетаданных[ПолноеИмяМетаданных]<>Истина Тогда
				Продолжить;
			КонецЕсли;
			
			ДобавляемыеТаблицы = СоставУкрупненнойГруппыМетаданных(ПолноеИмяМетаданных);
			Для Каждого ИмяДобавляемойТаблицы Из ДобавляемыеТаблицы Цикл
				Если СписокИменМетаданных<>Неопределено И ФильтрИменМетаданных[ИмяДобавляемойТаблицы]<>Истина Тогда
					Продолжить;
				КонецЕсли;
				
				ГруппаОтбора = ЭлементыОтбора.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
				ГруппаОтбора.Использование = Истина;
				
				ДобавитьЭлементОтбора(ГруппаОтбора.Элементы, "ПолноеИмяМетаданных", ВидСравненияКомпоновкиДанных.Равно, ИмяДобавляемойТаблицы);
				ДобавитьЭлементОтбора(ГруппаОтбора.Элементы, "ПричинаРегистрации",  ВидСравненияКомпоновкиДанных.Равно, ПараметрДополнительно.Значение);
				
				Если Строка.ВыборПериода Тогда
					ДатаНачала    = Строка.Период.ДатаНачала;
					ДатаОкончания = Строка.Период.ДатаОкончания;
					Если ДатаНачала<>'00010101' Тогда
						ДобавитьЭлементОтбора(ГруппаОтбора.Элементы, "ОбъектРегистрации.Дата", ВидСравненияКомпоновкиДанных.БольшеИлиРавно, ДатаНачала);
					КонецЕсли;
					Если ДатаОкончания<>'00010101' Тогда
						ДобавитьЭлементОтбора(ГруппаОтбора.Элементы, "ОбъектРегистрации.Дата", ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, ДатаОкончания);
					КонецЕсли;
				КонецЕсли;
				
				// Добавляем элементы отбора с коррекцией полей "Ссылка" -> "ОбъектРегистрации"
				ДобавитьЗначенияОтбораКомпоновки(ГруппаОтбора.Элементы, Строка.Отбор.Элементы,
					Новый Структура("Ссылка", "ОбъектРегистрации")
				);
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Новый Структура("ТаблицаМетаданныхСоставаУзла, СхемаКомпоновки, КомпоновщикНастроек", 
		ТаблицаМетаданныхСоставаУзла, СхемаКомпоновки, КомпоновщикНастроек
	);
КонецФункции

//  Возвращает параметры-ключи для сохранения настроек в разрезе плана обмена для всех пользователей
//
//  Параметры:
//      УзелОбмена: ссылка на узел обмена для возвращаемых настроек. Если не указано, то используется 
//                  текущее значение реквизита "УзелИнформационнойБазы"
//
Функция СтруктураПараметровНастроек(УзелОбмена=Неопределено)
	Узел = ?(УзелОбмена=Неопределено,  УзелИнформационнойБазы, УзелОбмена);
	
	Мета = Узел.Метаданные();
	
	Представление = Мета.РасширенноеПредставлениеОбъекта;
	Если ПустаяСтрока(Представление) Тогда
		Представление = Мета.ПредставлениеОбъекта;
	КонецЕсли;
	Если ПустаяСтрока(Представление) Тогда
		Представление = Строка(Мета);
	КонецЕсли;
	
	ПараметрыНастроек = Новый ОписаниеНастроек();
	ПараметрыНастроек.Представление = Представление;
	ПараметрыНастроек.КлючОбъекта   = "ВариантыНастроекИнтерактивнойВыгрузки";
	ПараметрыНастроек.КлючНастроек  = Мета.Имя;
	ПараметрыНастроек.Пользователь  = "*";
	
	Возврат ПараметрыНастроек;
КонецФункции

// Возвращает список значений настроек для текущего значения "УзелИнформационнойБазы"
//
Функция ПрочитатьСписокНастроек()
	ПараметрыНастроек = СтруктураПараметровНастроек();
	
	УстановитьПривилегированныйРежим(Истина);
	СписокВариантов = ХранилищеОбщихНастроек.Загрузить(
		ПараметрыНастроек.КлючОбъекта, ПараметрыНастроек.КлючНастроек, 
		ПараметрыНастроек, ПараметрыНастроек.Пользователь
	);
	
	Возврат ?(СписокВариантов=Неопределено, Новый СписокЗначений, СписокВариантов);
КонецФункции

// Сохраняет список значений настроек для текущего значения "УзелИнформационнойБазы"
//
//  Параметры:
//      СписокВариантов: сохраняемый список вариантов
//
Процедура СохранитьСписокНастроек(СписокВариантов)
	ПараметрыНастроек = СтруктураПараметровНастроек();
	
	УстановитьПривилегированныйРежим(Истина);
	Если СписокВариантов.Количество()=0 Тогда
		ХранилищеОбщихНастроек.Удалить(
			ПараметрыНастроек.КлючОбъекта, ПараметрыНастроек.КлючНастроек, ПараметрыНастроек.Пользователь
		);
	Иначе
		ХранилищеОбщихНастроек.Сохранить(
			ПараметрыНастроек.КлючОбъекта, ПараметрыНастроек.КлючНастроек, 
			СписокВариантов, 
			ПараметрыНастроек, ПараметрыНастроек.Пользователь
		);
	КонецЕсли;        
КонецПроцедуры

// Возвращает описание варианта всех дополнительных параметров
//
Функция ТекстДополнительныхПараметров()
	
	Если ВариантВыгрузки=0 Тогда
		// Все автоматические данные
		Возврат НСтр("ru='Без дополнительных данных.'");
		
	ИначеЕсли ВариантВыгрузки=1 Тогда
		ОписаниеПустогоОтбора = НСтр("ru='Все документы'");
		Возврат ПредставлениеОтбора(ПериодОтбораВсехДокументов, КомпоновщикОтбораВсехДокументов, ОписаниеПустогоОтбора);
		
	ИначеЕсли ВариантВыгрузки=2 Тогда         
		Возврат ПредставлениеДетальногоОтбора();
		
	КонецЕсли;
	
	Возврат "";
Конецфункции

// Возвращает структуру с реквизитами объекта
//
Функция ЭтотОбъектВСтруктуруДляФонового()
	СтруктураРезультата = Новый Структура;
	Для Каждого Мета Из Метаданные().Реквизиты Цикл
		ИмяРеквизита = Мета.Имя;
		СтруктураРезультата.Вставить(ИмяРеквизита, ЭтотОбъект[ИмяРеквизита]);
	КонецЦикла;
	
	// Отдельно настройки КомпоновщикОтбораВсехДокументов - там только отбор
	СтруктураРезультата.Вставить("НастройкиКомпоновщикаОтбораВсехДокументов", КомпоновщикОтбораВсехДокументов.Настройки);
	
	Возврат СтруктураРезультата;
КонецФункции

#КонецЕсли