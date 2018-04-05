#Если Клиент Тогда

// СписокЗначений - список имен и представлений объектов анализа
Перем мСписокОбъектов Экспорт;

// Структура - соответствие имен полей и их представления для построителя отчетов
Перем мСтруктураСоответствияИмен Экспорт;

// Число - количество строк табличного документа, соответствующее заголовку отчета
Перем мКоличествоВыведенныхСтрокЗаголовка Экспорт;

// Число - индекс группировки, в которой содержится объект анализа
Перем мИндексГруппировкиОбъекта;

// Настройка периода
Перем НП Экспорт;

// Таблица с данными для диаграммы
Перем ТаблицаДиаграммы Экспорт;

// Структура, ключи которой - имена отборов Построителя, значения - параметры Построителя
Перем мСтруктураДляОтбораПоКатегориям Экспорт;

// Процедура определяет и устанавливает значение для реквизита ОтборЗначениеКласс в зависимости от вида сравнения
// 
// Параметры
//  НЕТ
// 
// Возвращаемое значение
//  НЕТ
// 
Процедура ОпределитьТипЗначенияОтбораКласса() Экспорт

	Если ОтборВидСравненияКласс = ВидСравнения.Равно ИЛИ ОтборВидСравненияКласс = ВидСравнения.НеРавно Тогда
		Если ОтборЗначениеКласс = Неопределено Тогда
			ОтборЗначениеКласс = Перечисления.ABCКлассификация.ПустаяСсылка();
		ИначеЕсли ТипЗнч(ОтборЗначениеКласс) = Тип("СписокЗначений") Тогда
			Если ОтборЗначениеКласс.Количество() > 0 Тогда
				ОтборЗначениеКласс = ОтборЗначениеКласс[0].Значение;
			Иначе
				ОтборЗначениеКласс = Перечисления.ABCКлассификация.ПустаяСсылка();
			КонецЕсли; 
		КонецЕсли; 
	Иначе
		Если ОтборЗначениеКласс = Неопределено Тогда
			ОтборЗначениеКласс = Новый СписокЗначений;
		ИначеЕсли ТипЗнч(ОтборЗначениеКласс) = Тип("ПеречислениеСсылка.ABCКлассификация") Тогда
			НовыйСписок = Новый СписокЗначений;
			Если НЕ ОтборЗначениеКласс.Пустая() Тогда
				НовыйСписок.Добавить(ОтборЗначениеКласс);
			КонецЕсли; 
			ОтборЗначениеКласс = НовыйСписок;
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

// Процедура меняет видимость заголовка поля табличного документа
// 
// Параметры
//  Таб - табличный документ
//
// Возвращаемые значения
//  НЕТ
Процедура ИзменитьВидимостьЗаголовка(Таб) Экспорт

	ОбластьВидимости = Таб.Область(1,,мКоличествоВыведенныхСтрокЗаголовка,);
	ОбластьВидимости.Видимость = ПоказыватьЗаголовок;

КонецПроцедуры

// Функция формирует строку представления периода отчета
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   Строка
//
Функция СформироватьСтрокуПериода() Экспорт

	ОписаниеПериода = "";
	
	// Вывод заголовка, описателя периода и фильтров и заголовка
	Если ДатаНачала = '00010101000000' И ДатаОкончания = '00010101000000' Тогда

		ОписаниеПериода     = "Период не установлен";

	Иначе

		Если ДатаНачала = '00010101000000' ИЛИ ДатаОкончания = '00010101000000' Тогда

			ОписаниеПериода = "Период: " + Формат(ДатаНачала, "ДФ = ""дд.ММ.гггг""; ДП = ""...""") 
							+ " - "      + Формат(ДатаОкончания, "ДФ = ""дд.ММ.гггг""; ДП = ""...""");

		Иначе

			Если ДатаНачала <= ДатаОкончания Тогда
				ОписаниеПериода = "Период: " + ПредставлениеПериода(НачалоДня(ДатаНачала), КонецДня(ДатаОкончания), "ФП = Истина");
			Иначе
				ОписаниеПериода = "Неправильно задан период!"
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Возврат ОписаниеПериода;
	
КонецФункции

// Функция определяет параметр ABC_Класса по самому классу
//
// Параметры
//  ABC_КлассСсылка - ПеречислениеСсылка, для которой необходимо
//  определить значение параметра
//
// Возвращаемое значение:
//   Число - значение параметра для класса
//
Функция ПолучитьЗначениеПараметраABC_Класса(ABC_КлассСсылка)

	Если ABC_КлассСсылка = Перечисления.ABCКлассификация.AКласс Тогда
		Возврат ПроцентAКласса;
	ИначеЕсли ABC_КлассСсылка = Перечисления.ABCКлассификация.BКласс Тогда
		Возврат ПроцентBКласса;
	ИначеЕсли ABC_КлассСсылка = Перечисления.ABCКлассификация.CКласс Тогда
		Возврат ПроцентCКласса;
	Иначе
		Возврат 0;
	КонецЕсли; 
	
КонецФункции // ПолучитьЗначениеПараметраABC_КлассКлиента()

// Процедура заполняет данными таблицу значений, распределяет объекты отчета по АВС-классам
// 
// Параметры
//  Выборка                - ВыборкаИзРезультатаЗапроса, по группировке объекта отчета
//  ТаблицаКлассовОбъектов - таблица значений, таблица с распределенными объектами отчета по классам
//
// Возвращаемые значения
//  НЕТ
//
Процедура ЗаполнитьТаблицуКлассовОбъектов(Выборка, ТаблицаКлассовОбъектов)

	ВыборкаОбъектов = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, ОбъектАнализа);
	Пока ВыборкаОбъектов.СледующийПоЗначениюПоля(ОбъектАнализа) Цикл
		НоваяСтрока = ТаблицаКлассовОбъектов.Добавить();
		НоваяСтрока.Объект = ВыборкаОбъектов[ОбъектАнализа];
		Для каждого Показатель Из Показатели Цикл
			Если Показатель.Использование ИЛИ Показатель.Имя = ПараметрАнализа Тогда
				НоваяСтрока[Показатель.Имя] = ВыборкаОбъектов[Показатель.Имя];
			КонецЕсли; 
		КонецЦикла; 
	КонецЦикла; 
	
	ТаблицаКлассовОбъектов.Сортировать(ПараметрАнализа + " ВОЗР");

	ВсегоСумма = ТаблицаКлассовОбъектов.Итог(ПараметрАнализа);

	СуммаВысокая = Окр((ВсегоСумма*ПолучитьЗначениеПараметраABC_Класса(Перечисления.ABCКлассификация.AКласс)/100),2);
	СуммаСредняя = Окр((ВсегоСумма*ПолучитьЗначениеПараметраABC_Класса(Перечисления.ABCКлассификация.BКласс)/100),2);
	СуммаНизкая = ВсегоСумма - СуммаВысокая - СуммаСредняя;

	СуммаНакопления = 0;
	Для каждого Строки Из ТаблицаКлассовОбъектов Цикл
		
		СуммаНакопления = СуммаНакопления + Строки[ПараметрАнализа];
		
		Если СуммаНакопления <= СуммаНизкая Тогда
			ABCКлассификация = Перечисления.ABCКлассификация.CКласс;
		ИначеЕсли СуммаНакопления <= (СуммаНизкая + СуммаСредняя) Тогда
			ABCКлассификация = Перечисления.ABCКлассификация.BКласс;
		Иначе
			ABCКлассификация = Перечисления.ABCКлассификация.AКласс;
		КонецЕсли;
		
		Строки.Класс = ABCКлассификация;
		
	КонецЦикла;
	
	ТаблицаКлассовОбъектов.Сортировать(ПараметрАнализа + " УБЫВ, Класс");

КонецПроцедуры

// Функция определяет, соответствие выводимых значений в табличный документ
//  отбору по АВС-классиифкации
//
// Параметры
//  Класс - ПеречислениеСсылка.ABCКлассификация, для которой определяет принадлежность к отбору
//
// Возвращаемое значение:
//   Булево, удовлетворяет или нет условиям отбора
//
Функция ПроверитьКлассВОтборе(Класс)

	УдовлетворяетОтбору = Истина;
	
	Если ОтборФлагКласс Тогда
		Если ОтборВидСравненияКласс = ВидСравнения.Равно Тогда
			Если ОтборЗначениеКласс <> Класс Тогда
				УдовлетворяетОтбору = Ложь;
			КонецЕсли; 
		ИначеЕсли ОтборВидСравненияКласс = ВидСравнения.НеРавно Тогда
			Если ОтборЗначениеКласс = Класс Тогда
				УдовлетворяетОтбору = Ложь;
			КонецЕсли; 
		ИначеЕсли ОтборВидСравненияКласс = ВидСравнения.ВСписке Тогда
			Если ОтборЗначениеКласс.НайтиПоЗначению(Класс) = Неопределено Тогда
				УдовлетворяетОтбору = Ложь;
			КонецЕсли; 
		ИначеЕсли ОтборВидСравненияКласс = ВидСравнения.НеВСписке Тогда
			Если ОтборЗначениеКласс.НайтиПоЗначению(Класс) <> Неопределено Тогда
				УдовлетворяетОтбору = Ложь;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
	Возврат УдовлетворяетОтбору;

КонецФункции // ПроверитьКлассВОтборе()


// Процедура передает построителю отчета запрос
//
// Параметры
//  НЕТ
//
// Возвращаемое значение
//  НЕТ
//
Процедура ЗаполнитьНачальныеНастройки() Экспорт

	//Если ОбъектАнализа <> "Номенклатура" И ОбъектАнализа <> "Контрагент" И ОбъектАнализа = "МенеджерПокупателя" Тогда
	//	Возврат;
	//КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ //РАЗЛИЧНЫЕ
	|	Продажи." + ОбъектАнализа + " КАК " + ОбъектАнализа + ",
	|	СУММА(Продажи.СтоимостьОборот) КАК СуммаВыручки,
	|	СУММА(Продажи.СтоимостьОборот - Продажи.НДСОборот) КАК СуммаВыручкиБезНДС,
	|	СУММА(ВЫБОР КОГДА (ПродажиСебестоимость.СтоимостьОборот ЕСТЬ NULL ИЛИ ПродажиСебестоимость.КоличествоОборот ЕСТЬ NULL ИЛИ ПродажиСебестоимость.КоличествоОборот = 0) ТОГДА
	|		Продажи.СтоимостьОборот
	|	ИНАЧЕ
	|		Продажи.СтоимостьОборот - (ПродажиСебестоимость.СтоимостьОборот / ПродажиСебестоимость.КоличествоОборот) * Продажи.КоличествоОборот
	|	КОНЕЦ)                          КАК СуммаВаловойПрибыли,
	|	СУММА(Продажи.КоличествоОборот) КАК КоличествоПроданныхТоваров
	|
	|	{ВЫБРАТЬ
	|		Продажи.Номенклатура.*,
	|		Продажи.Регистратор.*,
	|		Продажи." + ОбъектАнализа + ".*
	|	//СВОЙСТВА
	|	}
	|
	|ИЗ
	|
	|	(
	|	ВЫБРАТЬ
	|		Продажи.Номенклатура                                                КАК Номенклатура,
	|		Продажи.ХарактеристикаНоменклатуры                                  КАК ХарактеристикаНоменклатуры,
	|		Продажи.ДоговорКонтрагента.Владелец                                 КАК Контрагент,
	|		Продажи.ДокументПродажи.Ответственный                               КАК МенеджерПокупателя,
	|		Продажи.СтоимостьОборот                                             КАК СтоимостьОборот,
	|		Продажи.НДСОборот                                                   КАК НДСОборот,
	|		Продажи.КоличествоОборот                                            КАК КоличествоОборот,
	|		Продажи.Регистратор                                                 КАК Регистратор
	|
	|	ИЗ
	|
	|		РегистрНакопления.Продажи.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор , (Номенклатура <> &ПустаяНоменклатура"+?(ОбъектАнализа = "Номенклатура",""," И ДоговорКонтрагента <> &ПустойДоговор")+")) КАК Продажи
	|
	|	) КАК Продажи
	|//СОЕДИНЕНИЯ
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|
	|	(
	|	ВЫБРАТЬ
	|		ПродажиСебестоимость.Номенклатура               КАК Номенклатура,
	|		ПродажиСебестоимость.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		СУММА(ПродажиСебестоимость.СтоимостьОборот)     КАК СтоимостьОборот,
	|		СУММА(ПродажиСебестоимость.КоличествоОборот)    КАК КоличествоОборот,
	|		ВЫБОР	КОГДА ПродажиСебестоимость.Регистратор ССЫЛКА Документ.РасходныйОрдерНаТовары 
	|			ТОГДА ПродажиСебестоимость.Регистратор.ДокументПередачи
	|			ИНАЧЕ ПродажиСебестоимость.Регистратор
	|		КОНЕЦ 										   КАК Регистратор
	|
	|	ИЗ
	|		РегистрНакопления.ПродажиСебестоимость.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор , Номенклатура <> &ПустаяНоменклатура) КАК ПродажиСебестоимость
	|
	|	СГРУППИРОВАТЬ ПО
	|		ПродажиСебестоимость.Номенклатура,
	|		ПродажиСебестоимость.ХарактеристикаНоменклатуры,
	|		ВЫБОР	КОГДА ПродажиСебестоимость.Регистратор ССЫЛКА Документ.РасходныйОрдерНаТовары 
	|			ТОГДА ПродажиСебестоимость.Регистратор.ДокументПередачи
	|			ИНАЧЕ ПродажиСебестоимость.Регистратор
	|		КОНЕЦ
	|
	|	) КАК ПродажиСебестоимость
	|
	|	ПО
	|		ПродажиСебестоимость.Номенклатура = Продажи.Номенклатура
	|		И
	|		ПродажиСебестоимость.ХарактеристикаНоменклатуры = Продажи.ХарактеристикаНоменклатуры
	|		И
	|		(ВЫБОР
	|		КОГДА  ПродажиСебестоимость.Регистратор ССЫЛКА Документ.РасходныйОрдерНаТовары 
	|				ТОГДА ПродажиСебестоимость.Регистратор.ДокументПередачи = Продажи.Регистратор
	|			ИНАЧЕ ПродажиСебестоимость.Регистратор = Продажи.Регистратор
	|		КОНЕЦ)
	|
	|{ГДЕ
	|	Продажи.Номенклатура.* КАК Номенклатура,
	|	Продажи.Контрагент.* КАК Контрагент,
	|	Продажи.МенеджерПокупателя.* КАК МенеджерПокупателя
	|	//СВОЙСТВА
	|	//КАТЕГОРИИ
	|	}
	|
	|СГРУППИРОВАТЬ ПО
	|	Продажи." + ОбъектАнализа + "
	|
	|{УПОРЯДОЧИТЬ ПО
	|	Продажи.Номенклатура.* КАК Номенклатура,
	|	Продажи.Контрагент.* КАК Контрагент,
	|	Продажи.МенеджерПокупателя.* КАК МенеджерПокупателя
	|	//СВОЙСТВА
	|	}
	|
	|{ИТОГИ ПО
	|	Продажи.Номенклатура.* КАК Номенклатура,
	|	Продажи.Контрагент.* КАК Контрагент,
	|	Продажи.МенеджерПокупателя.* КАК МенеджерПокупателя,
	|	Продажи.Регистратор.* КАК ДокументПродажи
	|	//СВОЙСТВА
	|	}
	|
	|";
	
	мСтруктураСоответствияИмен.Очистить();
	мСтруктураСоответствияИмен = Новый Структура("Номенклатура, Контрагент, МенеджерПокупателя, ДокументПродажи", "Номенклатура", "Контрагент", "Менеджер покупателя", "Расходный документ");
	
	ПостроительОтчета.Параметры.Вставить("ПустаяНоменклатура", Справочники.Номенклатура.ПустаяСсылка());
	ПостроительОтчета.Параметры.Вставить("ПустойДоговор", Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
	
	мСоответствиеНазначений = Новый Соответствие;

	мСоответствиеНазначений = Новый Соответствие;

	Если ИспользоватьСвойстваИКатегории Тогда
		
		ТаблицаПолей = Новый ТаблицаЗначений;
		ТаблицаПолей.Колонки.Добавить("ПутьКДанным");  // описание поля запроса поля, для которого добавляются свойства и категории. Используется в условии соединения с регистром сведений, хранящим значения свойств или категорий
		ТаблицаПолей.Колонки.Добавить("Представление");// представление поля, для которого добавляются свойства и категории. 
		ТаблицаПолей.Колонки.Добавить("Назначение");   // назначение свойств/категорий объектов для данного поля
		ТаблицаПолей.Колонки.Добавить("ТипЗначения");  // тип значения поля, для которого добавляются свойства и категории. Используется, если не установлено назначение
		ТаблицаПолей.Колонки.Добавить("НетКатегорий"); // признак НЕиспользования категорий для объекта

		НоваяСтрока = ТаблицаПолей.Добавить();
		НоваяСтрока.ПутьКДанным = "Продажи.Контрагент";
		НоваяСтрока.Представление = "Контрагент";
		НоваяСтрока.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты;

		НоваяСтрока = ТаблицаПолей.Добавить();
		НоваяСтрока.ПутьКДанным = "Продажи.Номенклатура";
		НоваяСтрока.Представление = "Номенклатура";
		НоваяСтрока.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура;

		ТекстПоляКатегорий = "";
		ТекстПоляСвойств = "";

		// Добавим строки запроса, необходимые для использования свойств и категорий
		УправлениеОтчетами.ДобавитьВТекстСвойстваИКатегории(ТаблицаПолей, ТекстЗапроса, мСтруктураСоответствияИмен, мСоответствиеНазначений, ПостроительОтчета.Параметры, , ТекстПоляКатегорий, ТекстПоляСвойств, , , , , , мСтруктураДляОтбораПоКатегориям);

	КонецЕсли;

	ПостроительОтчета.Текст = ТекстЗапроса;
	
	Если ИспользоватьСвойстваИКатегории Тогда
		УправлениеОтчетами.УстановитьТипыЗначенийСвойствИКатегорийДляОтбора(ПостроительОтчета, ТекстПоляКатегорий, ТекстПоляСвойств, мСоответствиеНазначений, мСтруктураСоответствияИмен);
	КонецЕсли;
	
	ПостроительОтчета.РазмещениеИзмеренийВСтроках = ТипРазмещенияИзмерений.Вместе;
	
	УправлениеОтчетами.ЗаполнитьПредставленияПолей(мСтруктураСоответствияИмен, ПостроительОтчета);
	
КонецПроцедуры


// Процедура заполняет табличный документ данными
//
// Параметры
//  Таб - поле табличного документа
//
// Возвращаемое значение
//  НЕТ
//
Процедура СформироватьОтчет(Таб) Экспорт

	мИндексГруппировкиОбъекта = 0;
	
	Таб.Очистить();
	
	ПостроительОтчета.Параметры.Вставить("ДатаНачала", НачалоДня(ДатаНачала));
	ПостроительОтчета.Параметры.Вставить("ДатаОкончания", ?(ДатаОкончания = '00010101000000', ДатаОкончания, КонецДня(ДатаОкончания)));
	
	Если НЕ УправлениеОтчетами.ЗадатьПараметрыОтбораПоКатегориям(ПостроительОтчета, мСтруктураДляОтбораПоКатегориям) Тогда
		Предупреждение("По одной категории нельзя устанавливать несколько отборов");
		Возврат;
	КонецЕсли;

	УправлениеОтчетами.ПроверитьПорядокПостроителяОтчета(ПостроительОтчета);
	
	ПостроительОтчета.Выполнить();

	Макет = ПолучитьМакет("Макет");
	
	Таб.Очистить();

	Секция = Макет.ПолучитьОбласть("ШапкаВерх|КолонкаОсновная");
	Таб.Вывести(Секция);
	
	КоличествоПоказателей = 0;
	Для каждого Показатель Из Показатели Цикл
		Если Показатель.Использование Тогда
			КоличествоПоказателей = КоличествоПоказателей + 1;
		КонецЕсли; 
	КонецЦикла; 
	
	ПоследнийСтолбецОтчета = КоличествоПоказателей + 2;

	Секция = Макет.ПолучитьОбласть("ШапкаИнтервал|КолонкаОсновная");
	Секция.Параметры.СтрокаИнтервал = СформироватьСтрокуПериода();
	Таб.Вывести(Секция);
	Таб.Область(1, 2, 4, ПоследнийСтолбецОтчета).ПоВыделеннымКолонкам = Истина;
	мКоличествоВыведенныхСтрокЗаголовка = 4;
	
	ПоследняяСтрока = 4;
	СтрокаГруппировок = УправлениеОтчетами.СформироватьСтрокуИзмерений(ПостроительОтчета.ИзмеренияСтроки);
	Если НЕ ПустаяСтрока(СтрокаГруппировок) Тогда
		ПоследняяСтрока = ПоследняяСтрока + 1;
		СтрокаГруппировок = "Группировки строк: " + СтрокаГруппировок;
		Секция = Макет.ПолучитьОбласть("ШапкаГруппировки|КолонкаОсновная");
		Секция.Параметры.СтрокаГруппировок = СтрокаГруппировок;
		Таб.Вывести(Секция);
		Таб.Область(ПоследняяСтрока, 2, ПоследняяСтрока, ПоследнийСтолбецОтчета).ПоВыделеннымКолонкам = Истина;
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
	КонецЕсли; 

	СтрокаОтборов = "";
	Если ОтборФлагКласс Тогда
		Если ОтборВидСравненияКласс = ВидСравнения.Равно Тогда
			СтрокаОтборов = СтрокаОтборов + "АВС-класс = "+ СокрЛП(ОтборЗначениеКласс);
		ИначеЕсли ОтборВидСравненияКласс = ВидСравнения.НеРавно Тогда
			СтрокаОтборов = СтрокаОтборов + "АВС-класс <> "+ СокрЛП(ОтборЗначениеКласс);
		ИначеЕсли ОтборВидСравненияКласс = ВидСравнения.ВСписке Тогда
			СтрокаСписка = "";
			Для каждого ЭлементСписка Из ОтборЗначениеКласс Цикл
				Если НЕ ПустаяСтрока(СтрокаСписка) Тогда
					СтрокаСписка = СтрокаСписка + "; ";
				КонецЕсли; 
				СтрокаСписка = СтрокаСписка + СокрЛП(ЭлементСписка.Значение);
			КонецЦикла; 
			СтрокаОтборов = СтрокаОтборов + "АВС-класс в списке "+ СтрокаСписка;
		ИначеЕсли ОтборВидСравненияКласс = ВидСравнения.НеВСписке Тогда
			СтрокаСписка = "";
			Для каждого ЭлементСписка Из ОтборЗначениеКласс Цикл
				Если НЕ ПустаяСтрока(СтрокаСписка) Тогда
					СтрокаСписка = СтрокаСписка + "; ";
				КонецЕсли; 
				СтрокаСписка = СтрокаСписка + СокрЛП(ЭлементСписка.Значение);
			КонецЦикла; 
			СтрокаОтборов = СтрокаОтборов + "АВС-класс не в списке "+ СтрокаСписка;
		КонецЕсли;
	КонецЕсли; 
	
	СтрокаОтборов = СтрокаОтборов + ?(Не ПустаяСтрока(СтрокаОтборов), ", ", "") + УправлениеОтчетами.СформироватьСтрокуОтборов(ПостроительОтчета.Отбор);
	Если НЕ ПустаяСтрока(СтрокаОтборов) Тогда
		ПоследняяСтрока = ПоследняяСтрока + 1;
		СтрокаОтборов = "Отбор: " + СтрокаОтборов;
		Секция = Макет.ПолучитьОбласть("ШапкаОтбор|КолонкаОсновная");
		Секция.Параметры.СтрокаОтборов = СтрокаОтборов;
		Таб.Вывести(Секция);
		Таб.Область(ПоследняяСтрока, 2, ПоследняяСтрока, ПоследнийСтолбецОтчета).ПоВыделеннымКолонкам = Истина;
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
	КонецЕсли; 
	
	СтрокаПорядка = УправлениеОтчетами.СформироватьСтрокуПорядка(ПостроительОтчета.Порядок);
	Если НЕ ПустаяСтрока(СтрокаПорядка) Тогда
		ПоследняяСтрока = ПоследняяСтрока + 1;
		СтрокаПорядка = "Сортировка: " + СтрокаПорядка;
		Секция = Макет.ПолучитьОбласть("ШапкаПорядок|КолонкаОсновная");
		Секция.Параметры.СтрокаПорядка = СтрокаПорядка;
		Таб.Вывести(Секция);
		Таб.Область(ПоследняяСтрока, 2, ПоследняяСтрока, ПоследнийСтолбецОтчета).ПоВыделеннымКолонкам = Истина;
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
	КонецЕсли;
	
	Секция = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаОсновная");
	Таб.Вывести(Секция);
	
	Для каждого Показатель Из Показатели Цикл
		Если Показатель.Использование Тогда
			Секция = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаПоказатель");
			Секция.Параметры.ИмяПоказателя = Показатель.Представление;
			Таб.Присоединить(Секция);
		КонецЕсли; 
	КонецЦикла; 
	
	Если ПостроительОтчета.ИзмеренияСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СуммаПроцентов = ПроцентAКласса + ПроцентBКласса + ПроцентCКласса;
	Если СуммаПроцентов <> 100 Тогда
		Предупреждение("Сумма процентов критериев распределения по АВС-классам должна быть равна 100%");
		Возврат;
	КонецЕсли; 
	
	ГруппировкаОбъекта = ПостроительОтчета.ИзмеренияСтроки.Найти(ОбъектАнализа);
	Если ГруппировкаОбъекта = Неопределено Тогда
		ФормаОтчета = ЭтотОбъект.ПолучитьФорму("Форма");
		ПредставлениеОбъектаАнализа = ФормаОтчета.ЭлементыФормы.ОбъектАнализа.СписокВыбора.НайтиПоЗначению(ОбъектАнализа).Представление;
		Предупреждение("Группировка по объекту анализа """ + ПредставлениеОбъектаАнализа + """, должна присутствовать обязательно!");
		Возврат;
	Иначе
		мИндексГруппировкиОбъекта = ПостроительОтчета.ИзмеренияСтроки.Индекс(ГруппировкаОбъекта);
	КонецЕсли;
	
	РезультатЗапроса = ПостроительОтчета.Результат;
	
	ТаблицаКлассовОбъектов = Новый ТаблицаЗначений;
	ТаблицаКлассовОбъектов.Колонки.Добавить("Объект");
	ТаблицаКлассовОбъектов.Колонки.Добавить("Класс", Новый ОписаниеТипов("ПеречислениеСсылка.ABCКлассификация"));
	Для каждого Показатель Из Показатели Цикл
		ТаблицаКлассовОбъектов.Колонки.Добавить(Показатель.Имя, ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(15,2));
	КонецЦикла;
	
	Таб.НачатьАвтогруппировкуСтрок();
	
	// Заполним данные для возможной диаграммы, дерево значений
	ТаблицаДиаграммы = Новый ТаблицаЗначений;
	Если ОбъектАнализа = "Контрагент" Тогда
		ТаблицаДиаграммы.Колонки.Добавить("Объект", Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	ИначеЕсли ОбъектАнализа = "Номенклатура" Тогда
		ТаблицаДиаграммы.Колонки.Добавить("Объект", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Иначе
		ТаблицаДиаграммы.Колонки.Добавить("Объект", Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	КонецЕсли; 
	ТаблицаДиаграммы.Колонки.Добавить("Класс", Новый ОписаниеТипов("ПеречислениеСсылка.ABCКлассификация"));
	Для каждого Показатель Из Показатели Цикл
		Если Показатель.Использование Тогда
			ТаблицаДиаграммы.Колонки.Добавить(Показатель.Имя, Новый ОписаниеТипов("Число"));
		КонецЕсли; 
	КонецЦикла; 
	
	ВывестиСтроки(Таб, Макет, РезультатЗапроса, 0, ТаблицаКлассовОбъектов, ТаблицаДиаграммы);
	
	Таб.ЗакончитьАвтогруппировкуСтрок();
	
	Таб.ФиксацияСверху = мКоличествоВыведенныхСтрокЗаголовка + 2;
	Таб.ФиксацияСлева = 2;

	ИзменитьВидимостьЗаголовка(Таб);
	
	Таб.ТолькоПросмотр = Истина;
	Таб.Показать();
	
КонецПроцедуры

// Процедура подготавливает данные для вывода строк в ПолеТабличногоДокумента
// 
// Параметры
//  Таб                                 - ПолеТабличногоДокумента, в котором показывать данные отчета
//  Макет                               - макет отчета
//  ТекущаяВыборка                      - выборка запроса, из которой выводить строки
//  ИндексТекущейГруппировки            - число, индекс выводимой группировки
//  ТаблицаКлассовОбъектов              - ТаблицаЗначений, в которую записываются данные о распределенных объектах по классам
//  СтруктураЗначенийВерхнихГруппировок - Структура, в которой передаются параметры верхних, уже выведенных в табличный документ,
//                                        группировок, для ссуммирования показателей при установленном отборе по АВС-классам
// 
// Возвращаемое значение
//  НЕТ
// 
Процедура ВывестиСтроки(Таб, Макет, ТекущаяВыборка, ИндексТекущейГруппировки, ТаблицаКлассовОбъектов, ТаблицаДиаграммы, СтруктураЗначенийВерхнихГруппировок = Неопределено)

	Если ИндексТекущейГруппировки > ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Тогда
		Возврат;
	КонецЕсли;
	
	НаименованиеГруппировки = ПостроительОтчета.ИзмеренияСтроки[ИндексТекущейГруппировки].Имя;
	
	// Если добавить в группировки строк одинаковые значения, то в именах групировок
	// добавляется цифра 1,2,3..., а поля таблицы запроса естественно не добавляются с такими именами
	// поэтому из имени группировки удилим последние цифры в имени
	
	а = СтрДлина(НаименованиеГруппировки);
	Пока а > 0 Цикл
		Если КодСимвола(Сред(НаименованиеГруппировки, а, 1)) >= 49 И КодСимвола(Сред(НаименованиеГруппировки, а, 1)) <= 57 Тогда
			а = а - 1;
			Продолжить;
		КонецЕсли;
		Прервать;
	КонецЦикла;
	
	НаименованиеГруппировки = Лев(НаименованиеГруппировки, а);

	Выборка = ТекущаяВыборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, НаименованиеГруппировки);

	Если НаименованиеГруппировки = ОбъектАнализа Тогда
		
		ТаблицаКлассовОбъектов.Очистить();
		ЗаполнитьТаблицуКлассовОбъектов(ТекущаяВыборка, ТаблицаКлассовОбъектов);
		
		ПрошлыйКласс = Неопределено;
		Для каждого СтрокаТаблицыКлассов Из ТаблицаКлассовОбъектов Цикл
			
			Если НЕ ПроверитьКлассВОтборе(СтрокаТаблицыКлассов.Класс) Тогда
				Продолжить;
			КонецЕсли; 
			
			Если СтрокаТаблицыКлассов.Класс <> ПрошлыйКласс Тогда
				
				ПрошлыйКласс = СтрокаТаблицыКлассов.Класс;
				
				СтруктураЗначений = Новый Структура;
				СтрокиКласса = ТаблицаКлассовОбъектов.НайтиСтроки(Новый Структура("Класс", СтрокаТаблицыКлассов.Класс));
				Для каждого СтрокаКласса Из СтрокиКласса Цикл
					Для каждого Показатель Из Показатели Цикл
						Если Показатель.Использование Тогда
							Если СтруктураЗначений.Свойство(Показатель.Имя) Тогда
								СтруктураЗначений[Показатель.Имя] = СтруктураЗначений[Показатель.Имя] + СтрокаКласса[Показатель.Имя];
							Иначе
								СтруктураЗначений.Вставить(Показатель.Имя, СтрокаКласса[Показатель.Имя]);
							КонецЕсли; 
						КонецЕсли; 
					КонецЦикла; 
				КонецЦикла; 
				
				Если ТипЗнч(СтруктураЗначенийВерхнихГруппировок) = Тип("Структура") Тогда
					Для каждого ЭлементСтруктуры Из СтруктураЗначенийВерхнихГруппировок Цикл
						Если СтруктураЗначений.Свойство(ЭлементСтруктуры.Ключ) Тогда
							Если ТипЗнч(СтруктураЗначенийВерхнихГруппировок[ЭлементСтруктуры.Ключ]) = Тип("Число") Тогда
								СтруктураЗначенийВерхнихГруппировок[ЭлементСтруктуры.Ключ] = СтруктураЗначенийВерхнихГруппировок[ЭлементСтруктуры.Ключ] + СтруктураЗначений[ЭлементСтруктуры.Ключ];
							Иначе
								СтруктураЗначенийВерхнихГруппировок[ЭлементСтруктуры.Ключ] = СтруктураЗначений[ЭлементСтруктуры.Ключ];
							КонецЕсли; 
						КонецЕсли; 
					КонецЦикла; 
				КонецЕсли; 
				
				ВывестиСтрокуГруппировки(СтрокаТаблицыКлассов, "Класс", Макет, ИндексТекущейГруппировки, Таб, Неопределено, СтруктураЗначений);
				
			КонецЕсли;
			
			Выборка.Сбросить();
			Если НЕ Выборка.НайтиСледующий(Новый Структура(НаименованиеГруппировки, СтрокаТаблицыКлассов.Объект)) Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаДиаграммы = ТаблицаДиаграммы.Добавить();
			СтрокаДиаграммы.Объект = Выборка[НаименованиеГруппировки];
			СтрокаДиаграммы.Класс  = ПрошлыйКласс;
			
			ВывестиСтрокуГруппировки(Выборка, НаименованиеГруппировки, Макет, ИндексТекущейГруппировки, Таб, СтрокаДиаграммы);
			ВывестиСтроки(Таб, Макет, Выборка, ИндексТекущейГруппировки+1, ТаблицаКлассовОбъектов, ТаблицаДиаграммы);
			
		КонецЦикла; 
		
	Иначе
		
		СтруктураНокопленияЗначений = Новый Структура;
		Для каждого Показатель Из Показатели Цикл
			Если Показатель.Использование Тогда
				СтруктураНокопленияЗначений.Вставить(Показатель.Имя, 0);
			КонецЕсли; 
		КонецЦикла; 
		
		Пока Выборка.Следующий() Цикл

			СтруктураЗначенийВерхнихГруппировок = Неопределено;
			ВывестиСтрокуГруппировки(Выборка, НаименованиеГруппировки, Макет, ИндексТекущейГруппировки, Таб, Неопределено, СтруктураЗначенийВерхнихГруппировок);
			
			СтараяСтруктураЗначенийВерхнихГруппировок = Новый Структура;
			Если ТипЗнч(СтруктураЗначенийВерхнихГруппировок) = Тип("Структура") Тогда
				Для каждого ЭлементСтруктуры Из СтруктураЗначенийВерхнихГруппировок Цикл
					СтараяСтруктураЗначенийВерхнихГруппировок.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
				КонецЦикла; 
			КонецЕсли; 
			
			ВывестиСтроки(Таб, Макет, Выборка, ИндексТекущейГруппировки+1, ТаблицаКлассовОбъектов, ТаблицаДиаграммы, СтруктураЗначенийВерхнихГруппировок);
			
			Если ТипЗнч(СтараяСтруктураЗначенийВерхнихГруппировок) = Тип("Структура") Тогда
				Для каждого ЭлементСтруктуры Из СтруктураЗначенийВерхнихГруппировок Цикл
					Если СтараяСтруктураЗначенийВерхнихГруппировок.Свойство(ЭлементСтруктуры.Ключ) Тогда
						СтараяСтруктураЗначенийВерхнихГруппировок[ЭлементСтруктуры.Ключ].Текст = Формат((Число(СтараяСтруктураЗначенийВерхнихГруппировок[ЭлементСтруктуры.Ключ].Текст) + ЭлементСтруктуры.Значение), "ЧЦ=20; ЧДЦ=2; ЧРД=,");
						СтруктураНокопленияЗначений[ЭлементСтруктуры.Ключ] = СтруктураНокопленияЗначений[ЭлементСтруктуры.Ключ] + ЭлементСтруктуры.Значение;
					КонецЕсли; 
				КонецЦикла; 
			КонецЕсли;
			
		КонецЦикла; 
		
		СтруктураЗначенийВерхнихГруппировок = СтруктураНокопленияЗначений;
		
	КонецЕсли; 

КонецПроцедуры

// Процедура выводит строки в ПолеТабличногоДокумента
// 
// Параметры
//  Выборка                  - Выборка запроса, из которой выводить строки
//  НаименованиеГруппировки  - Строка, имя текущей группировки
//  Макет                    - макет отчета
//  ИндексТекущейГруппировки - число, индекс выводимой группировки
//  Таб                      - ПолеТабличногоДокумента, в котором показывать данные отчета
//  СтруктураЗначений        - Структура, в которую записыватся данные о выведенных строках в табличный документ
// 
// Возвращаемое значение
//  НЕТ
// 
Процедура ВывестиСтрокуГруппировки(Выборка, НаименованиеГруппировки, Макет, ИндексТекущейГруппировки, Таб, СтрокаДиаграммы = Неопределено, СтруктураЗначений = Неопределено)

	СтрокаВывода = СокрЛП(Выборка[НаименованиеГруппировки]);
	Если ПустаяСтрока(СтрокаВывода) Тогда
		СтрокаВывода = "<...>";
	КонецЕсли;
	
	Если ИндексТекущейГруппировки >= мИндексГруппировкиОбъекта Тогда
		Если НаименованиеГруппировки = "Класс" Тогда
			РеальныйИндексТекущейГруппировки = ИндексТекущейГруппировки;
		Иначе
			РеальныйИндексТекущейГруппировки = ИндексТекущейГруппировки + 1;
		КонецЕсли; 
	Иначе
		РеальныйИндексТекущейГруппировки = ИндексТекущейГруппировки;
	КонецЕсли; 

	ТекущийЦвет = Новый Цвет;
	Если РаскрашиватьГруппировки Тогда
		Если РеальныйИндексТекущейГруппировки <> ПостроительОтчета.ИзмеренияСтроки.Количество() Тогда
			ИндексЦвета = РеальныйИндексТекущейГруппировки;
			Если ИндексЦвета >= 10 Тогда
				ИндексЦвета = (РеальныйИндексТекущейГруппировки/10 - Цел(РеальныйИндексТекущейГруппировки/10))*10;
			КонецЕсли; 
			ТекущийЦвет = Макет.Области["Цвет"+СокрЛП(ИндексЦвета)].ЦветФона;
		Иначе
			ТекущийЦвет = Новый Цвет;
		КонецЕсли; 
	КонецЕсли;
	
	Секция = Макет.ПолучитьОбласть("СтрокаГруппировки|КолонкаОсновная");
	Секция.Параметры.ЗначениеГруппировки = СтрокаВывода;
	Секция.Области.ЗначениеГруппировки.ЦветФона = ТекущийЦвет;
	ОбластьВыводаЯчеек = Таб.Вывести(Секция, РеальныйИндексТекущейГруппировки);
	ОбластьВыводаЯчеек.Отступ = РеальныйИндексТекущейГруппировки;
	ОбластьВыводаЯчеек.Расшифровка = Выборка[НаименованиеГруппировки];
	Если НаименованиеГруппировки = "Класс" Тогда
		ОбластьВыводаЯчеек.Шрифт = Новый Шрифт(,,Истина);
	КонецЕсли;
	
	СтруктураВозвратаЗначений = Новый Структура;
	Для каждого Показатель Из Показатели Цикл
		Если Показатель.Использование Тогда
			Секция = Макет.ПолучитьОбласть("СтрокаГруппировки|КолонкаПоказатель");
			Если ТипЗнч(СтруктураЗначений) = Тип("Структура") Тогда
				Секция.Параметры.ЗначениеПоказателя = Формат(СтруктураЗначений[Показатель.Имя], "ЧЦ=20; ЧДЦ=2; ЧРД=,");
				Если СтрокаДиаграммы <> Неопределено Тогда
					СтрокаДиаграммы[Показатель.Имя] = СтруктураЗначений[Показатель.Имя];
				КонецЕсли; 
			Иначе
				Секция.Параметры.ЗначениеПоказателя = Формат(Выборка[Показатель.Имя], "ЧЦ=20; ЧДЦ=2; ЧРД=,");
				Если СтрокаДиаграммы <> Неопределено Тогда
					СтрокаДиаграммы[Показатель.Имя] = Выборка[Показатель.Имя];
				КонецЕсли; 
			КонецЕсли;
			Секция.ТекущаяОбласть.ЦветФона = ТекущийЦвет;
			ОбластьЯчеекТаблицы = Таб.Присоединить(Секция, РеальныйИндексТекущейГруппировки);
			Если ИндексТекущейГруппировки < мИндексГруппировкиОбъекта Тогда
				ОбластьЯчеекТаблицы.Текст = "0";
				СтруктураВозвратаЗначений.Вставить(Показатель.Имя, ОбластьЯчеекТаблицы);
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	
	СтруктураЗначений = СтруктураВозвратаЗначений;

КонецПроцедуры

// Сформируем список объектов анализа отчета
мСписокОбъектов = Новый СписокЗначений;
мСписокОбъектов.Добавить("Контрагент", "Контрагент");
мСписокОбъектов.Добавить("Номенклатура", "Номенклатура");
мСписокОбъектов.Добавить("МенеджерПокупателя", "Менеджер покупателя");

мСтруктураСоответствияИмен = Новый Структура;

// Заполним таблицу возможных для отображения показателей отчета
НовыйПоказатель = Показатели.Добавить();
НовыйПоказатель.Имя = "СуммаВыручки";
НовыйПоказатель.Представление = "Сумма выручки в валюте упр.учета (" + глЗначениеПеременной("ВалютаУправленческогоУчета") + ")";

НовыйПоказатель = Показатели.Добавить();
НовыйПоказатель.Имя = "СуммаВыручкиБезНДС";
НовыйПоказатель.Представление = "Сумма выручки без НДС в валюте упр.учета (" + глЗначениеПеременной("ВалютаУправленческогоУчета") + ")";

НовыйПоказатель = Показатели.Добавить();
НовыйПоказатель.Имя = "СуммаВаловойПрибыли";
НовыйПоказатель.Представление = "Сумма валовой прибыли в валюте упр.учета (" + глЗначениеПеременной("ВалютаУправленческогоУчета") + ")";

НовыйПоказатель = Показатели.Добавить();
НовыйПоказатель.Имя = "КоличествоПроданныхТоваров";
НовыйПоказатель.Представление = "Количество проданных товаров";

мКоличествоВыведенныхСтрокЗаголовка = 0;
мИндексГруппировкиОбъекта = 0;

НП = Новый НастройкаПериода;
#КонецЕсли
