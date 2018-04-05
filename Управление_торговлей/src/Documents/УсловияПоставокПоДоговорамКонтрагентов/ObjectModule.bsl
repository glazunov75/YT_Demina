Перем мУдалятьДвижения;

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

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура определяет чтобы в указанном пользователем периоде выбранная периодичность поместилась
//  бы хотя бы один раз.
//
// Параметры
//  Отказ - булево, отказ от проведения документа
//  Заголовок - строка, для информирования пользователя об ошибке
//
// Возвращаемое значение:
//   НЕТ
//
Процедура ПроверитьСоответствиеПериодичностиИПериода(Отказ, Заголовок)

	Если ЗначениеЗаполнено(Периодичность) И ДатаОкончания <> '00010101' Тогда
		
		РасчетнаяДатаКонца = ОбщегоНазначения.ПолучитьДатуНачалаПериодаПоДатеОкончанияКоличествуПериодов(ДатаНачала, Периодичность, -1);
		
		Если РасчетнаяДатаКонца > КонецДня(ДатаОкончания) Тогда
			Отказ = Истина;
			ОбщегоНазначения.СообщитьОбОшибке("Некорректная дата окончания, не будет закончен хотя бы один период с указанной периодичностью!", Отказ, Заголовок);
		КонецЕсли;
	
	КонецЕсли;

КонецПроцедуры

// Функция определяет сумму по ТЧ в валюте взаиморасчетов
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   Число
//
Функция РассчитатьСуммуТЧ() Экспорт

	СуммаПоТЧ = 0;
	
	ВалютаВзаиморасчетов = ОпределитьВалютуВзаиморасчетовДоговора();
	
	Если НЕ ЗначениеЗаполнено(ВалютаВзаиморасчетов) Тогда
		Возврат СуммаПоТЧ;
	КонецЕсли; 
	
	СтруктураВалютыВзаиморасчетов = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, Дата);
	КурсВзаиморасчетов      = СтруктураВалютыВзаиморасчетов.Курс;
	КратностьВзаиморасчетов = СтруктураВалютыВзаиморасчетов.Кратность;
	
	Для каждого СтрокаТаблицы Из НоменклатураДоговора Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ВалютаЦены) Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрокаТаблицы.ВалютаЦены = ВалютаВзаиморасчетов Тогда
			СуммаПоТЧ = СуммаПоТЧ + СтрокаТаблицы.Сумма;
		Иначе
			СтруктураКурсаВалютыНоменклатуры = МодульВалютногоУчета.ПолучитьКурсВалюты(СтрокаТаблицы.ВалютаЦены, Дата);
			КурсВалютыНоменклатуры      = СтруктураКурсаВалютыНоменклатуры.Курс;
			КратностьВалютыНоменклатуры = СтруктураКурсаВалютыНоменклатуры.Кратность;
			СуммаПоТЧ = СуммаПоТЧ + МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.Сумма, СтрокаТаблицы.ВалютаЦены, ВалютаВзаиморасчетов,
									КурсВалютыНоменклатуры, КурсВзаиморасчетов, КратностьВалютыНоменклатуры, КратностьВзаиморасчетов);
		КонецЕсли; 
		
	КонецЦикла;
	
	Возврат СуммаПоТЧ;
	
КонецФункции // РассчитатьСуммуТЧ()

// Процедура проверяет нет ли пересекающихся интервалами документов с текущим.
//
Процедура ПроверитьПересекающиесяДокументы(Отказ, Заголовок)

	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	УсловияПоставокПоДоговорамКонтрагентовОбщие.Регистратор               КАК Регистратор,
	|	УсловияПоставокПоДоговорамКонтрагентовОбщие.Регистратор.ДатаНачала    КАК ДатаНачала,
	|	УсловияПоставокПоДоговорамКонтрагентовОбщие.Регистратор.ДатаОкончания КАК ДатаОкончания
	|ИЗ
	|	РегистрСведений.УсловияПоставокПоДоговорамКонтрагентовОбщие КАК УсловияПоставокПоДоговорамКонтрагентовОбщие
	|ГДЕ
	|	УсловияПоставокПоДоговорамКонтрагентовОбщие.ДоговорКонтрагента = &ТекущийДоговорКонтрагента
	|
	|СГРУППИРОВАТЬ ПО
	|	УсловияПоставокПоДоговорамКонтрагентовОбщие.Регистратор,
	|	УсловияПоставокПоДоговорамКонтрагентовОбщие.Регистратор.ДатаНачала,
	|	УсловияПоставокПоДоговорамКонтрагентовОбщие.Регистратор.ДатаОкончания
	|";
	
	Запрос.УстановитьПараметр("ТекущийДоговорКонтрагента", ДоговорКонтрагента);
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	
	СтрокаДокументовПересечений = "";
	
	Для каждого СтрокаТаблицы Из ТаблицаЗапроса Цикл
	
		Если НЕ ЗначениеЗаполнено(ДатаОкончания) Тогда // Без даты окончания
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДатаОкончания) Тогда
				Если НЕ ПустаяСтрока(СтрокаДокументовПересечений) Тогда
					СтрокаДокументовПересечений = СтрокаДокументовПересечений + Символы.ПС;
				КонецЕсли; 
				СтрокаДокументовПересечений = СтрокаДокументовПересечений + Строка(СтрокаТаблицы.Регистратор) + " с " + Формат(СтрокаТаблицы.ДатаНачала, "ДФ=dd.MM.yyyy") + " по " + ?(НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДатаОкончания), "...", Формат(СтрокаТаблицы.ДатаОкончания, "ДФ=dd.MM.yyyy"));
			ИначеЕсли СтрокаТаблицы.ДатаОкончания > ДатаНачала Тогда
				Если НЕ ПустаяСтрока(СтрокаДокументовПересечений) Тогда
					СтрокаДокументовПересечений = СтрокаДокументовПересечений + Символы.ПС;
				КонецЕсли; 
				СтрокаДокументовПересечений = СтрокаДокументовПересечений + Строка(СтрокаТаблицы.Регистратор) + " с " + Формат(СтрокаТаблицы.ДатаНачала, "ДФ=dd.MM.yyyy") + " по " + ?(НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДатаОкончания), "...", Формат(СтрокаТаблицы.ДатаОкончания, "ДФ=dd.MM.yyyy"));
			КонецЕсли; 
		Иначе
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДатаОкончания) Тогда 
				Если ДатаОкончания > СтрокаТаблицы.ДатаНачала Тогда
					Если НЕ ПустаяСтрока(СтрокаДокументовПересечений) Тогда
						СтрокаДокументовПересечений = СтрокаДокументовПересечений + Символы.ПС;
					КонецЕсли; 
					СтрокаДокументовПересечений = СтрокаДокументовПересечений + Строка(СтрокаТаблицы.Регистратор) + " с " + Формат(СтрокаТаблицы.ДатаНачала, "ДФ=dd.MM.yyyy") + " по " + ?(НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДатаОкончания), "...", Формат(СтрокаТаблицы.ДатаОкончания, "ДФ=dd.MM.yyyy"));
				КонецЕсли;
			ИначеЕсли (ДатаНачала >= СтрокаТаблицы.ДатаНачала И ДатаОкончания <= СтрокаТаблицы.ДатаОкончания)
				  ИЛИ (ДатаНачала <= СтрокаТаблицы.ДатаНачала И ДатаОкончания >= СтрокаТаблицы.ДатаОкончания)
				  ИЛИ (ДатаНачала <= СтрокаТаблицы.ДатаНачала И ДатаОкончания >= СтрокаТаблицы.ДатаНачала)
				  ИЛИ (ДатаНачала <= СтрокаТаблицы.ДатаОкончания И ДатаОкончания >= СтрокаТаблицы.ДатаОкончания) Тогда
					Если НЕ ПустаяСтрока(СтрокаДокументовПересечений) Тогда
						СтрокаДокументовПересечений = СтрокаДокументовПересечений + Символы.ПС;
					КонецЕсли; 
					СтрокаДокументовПересечений = СтрокаДокументовПересечений + Строка(СтрокаТаблицы.Регистратор) + " с " + Формат(СтрокаТаблицы.ДатаНачала, "ДФ=dd.MM.yyyy") + " по " + ?(НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДатаОкончания), "...", Формат(СтрокаТаблицы.ДатаОкончания, "ДФ=dd.MM.yyyy"));
			КонецЕсли; 
		КонецЕсли; 
	
	КонецЦикла;
	
	Если НЕ ПустаяСтрока(СтрокаДокументовПересечений) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(("Найдены условия поставок, которые уже действуют в выбранном периоде:" + Символы.ПС + СтрокаДокументовПересечений), Отказ, Заголовок);
		Отказ = Истина;
	КонецЕсли; 

КонецПроцедуры

// Функция определяет валюту взаиморасчетов из договора
//
Функция ОпределитьВалютуВзаиморасчетовДоговора() Экспорт

	Если ДоговорКонтрагента.Пустая() Тогда
		Возврат Неопределено;
	Иначе
		Возврат ДоговорКонтрагента.ВалютаВзаиморасчетов;
	КонецЕсли; 

КонецФункции

// Формирует запрос по шапке документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке(Режим)

	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);

	Запрос.Текст = "
	|ВЫБРАТЬ 
	|	Док.Дата                                        КАК Дата,
	|	Док.Ссылка                                      КАК Ссылка,
	|	Док.Контрагент                                  КАК Контрагент,
	|	Док.ДоговорКонтрагента                          КАК ДоговорКонтрагента,
	|	Док.ДоговорКонтрагента.ВидДоговора              КАК ВидДоговора,
	|	Док.ДоговорКонтрагента.ВидУсловийДоговора       КАК ВидУсловийДоговора,
	|	Док.ДатаНачала                                  КАК ДатаНачала,
	|	Док.ДатаОкончания                               КАК ДатаОкончания,
	|	Док.Периодичность                               КАК Периодичность,
	|	Док.СуммаУсловийДоговора                        КАК СуммаУсловийДоговора
	|ИЗ 
	|	Документ.УсловияПоставокПоДоговорамКонтрагентов КАК Док
	|ГДЕ
	|	Док.Ссылка = &ДокументСсылка
	|";
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	// Договор
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДоговорКонтрагента) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не выбран договор контрагента в документе!", Отказ, Заголовок);
	Иначе
		Если ВыборкаПоШапкеДокумента.ВидУсловийДоговора <> Перечисления.ВидыУсловийДоговоровВзаиморасчетов.СДополнительнымиУсловиями Тогда
			ОбщегоНазначения.СообщитьОбОшибке("В договоре взаиморасчетов не указан признак ведения договора с дополнительными условиями поставок !", Отказ, Заголовок);
		КонецЕсли; 
		Если ВыборкаПоШапкеДокумента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.ПустаяСсылка()
		 ИЛИ ВыборкаПоШапкеДокумента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Прочее Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Вид договора взаиморасчетов может быть только ""С поставщиком"" или ""С покупателем"" !", Отказ, Заголовок);
		КонецЕсли; 
	КонецЕсли;
	
	// Контрагент
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Контрагент) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не выбран контрагент в документе!", Отказ, Заголовок);
	КонецЕсли;
	
	// Дата начала
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаНачала) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указана дата начала в документе!", Отказ, Заголовок);
	КонецЕсли;
	
	// Периодичность и дата окончания
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Периодичность) И НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаОкончания) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указана периодичность или дата окончания в документе!", Отказ, Заголовок);
	КонецЕсли;
	
	// Даты начала и окончания
	Если ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаОкончания) И ВыборкаПоШапкеДокумента.ДатаОкончания < ВыборкаПоШапкеДокумента.ДатаНачала Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Дата окончания не может быть меньше даты начала!", Отказ, Заголовок);
	КонецЕсли;
	
	// Периодичность
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.СуммаУсловийДоговора) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указана сумма условий по договору в документе!", Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "Товары" документа.
// Если какой-то из реквизтов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определенной строке выборка 
//  							  из результата запроса по товарам документа, 
//  Отказ 						- флаг отказа в проведении.
//
Процедура ПроверитьЗаполнениеСтрокиНоменклатуры(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									""" табл. части ""Товары"": ";
	// Номенклатура
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Номенклатура) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбрана номенклатура!", Отказ, Заголовок);
	КонецЕсли;

	Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Номенклатура) И ВыборкаПоСтрокамДокумента.Номенклатура.Набор Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "выбранная номенклатура не должна быть набором-пакетом!", Отказ, Заголовок);
	КонецЕсли;

	// Валюта
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ВалютаЦены) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбрана валюта цены!", Отказ, Заголовок);
	КонецЕсли;

	// ЕдиницаИзмерения
	Если НЕ ВыборкаПоСтрокамДокумента.Услуга И НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ЕдиницаИзмерения) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбрана единица!", Отказ, Заголовок);
	КонецЕсли;
	
	// Цена
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Цена) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбрана цена!", Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеСтрокиТоваров()

// Формирует запрос по товарам документа, при оперативном проведении добавляет данные регистров
//
// Параметры: 
//  Режим                   - режим проведения,
//  ВыборкаПоШапкеДокумента - выборка из результата запроса по шапке документа,
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоНоменклатуре(Режим, ВыборкаПоШапкеДокумента)

	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);

	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Док.Номенклатура КАК Номенклатура,
	|	Док.Номенклатура.Услуга КАК Услуга,
	|	Док.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	Док.Цена,
	|	Док.ВалютаЦены,
	|	Док.ЕдиницаИзмерения,
	|	Док.Количество,
	|	Док.Сумма,
	|	Док.Ссылка.ДатаОкончания,
	|	Док.Ссылка.ДатаНачала,
	|	Док.Ссылка.Периодичность,
	|	Док.Ссылка.ДоговорКонтрагента,
	|	Док.НомерСтроки, // Для контроля заполнения
	|	1 КАК КоличествоДублей
	|ИЗ
	|	Документ.УсловияПоставокПоДоговорамКонтрагентов.НоменклатураДоговора КАК Док
	|ГДЕ
	|	Док.Ссылка = &ДокументСсылка
	|
	|ИТОГИ КОЛИЧЕСТВО(КоличествоДублей) 
	|ПО Номенклатура, ХарактеристикаНоменклатуры";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоТоварам()

// По строке выборки результата запроса по документу, которая соответствует строке шапке документа,
// формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                - выборка из результата запроса по шапке документа,
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров 
//                                           сведений по которым надо проводить документ,
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьШапкуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений)

	// Если документ нужно проводить по регистру, то для него есть ключ в структуре
	Движение = Движения.УсловияПоставокПоДоговорамКонтрагентовОбщие.Добавить();

	// Свойства
	Движение.Период                = ВыборкаПоШапкеДокумента.ДатаНачала;

	// Измерения
	Движение.ДоговорКонтрагента = ВыборкаПоШапкеДокумента.ДоговорКонтрагента;

	// Ресурсы
	
	ВалютаУпрУчета = глЗначениеПеременной("ВалютаУправленческогоУчета");
	Если ВалютаУпрУчета = ДоговорКонтрагента.ВалютаВзаиморасчетов Тогда
		Движение.СуммаУпрУчета = ВыборкаПоШапкеДокумента.СуммаУсловийДоговора;
	Иначе
		СтруктураКурсаВзаиморасчетов = МодульВалютногоУчета.ПолучитьКурсВалюты(ДоговорКонтрагента.ВалютаВзаиморасчетов, Дата);
		СтруктураКурсаУпрУчета  = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаУпрУчета, Дата);
		Движение.СуммаУпрУчета = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(ВыборкаПоШапкеДокумента.СуммаУсловийДоговора, ДоговорКонтрагента.ВалютаВзаиморасчетов, ВалютаУпрУчета, СтруктураКурсаВзаиморасчетов.Курс, СтруктураКурсаУпрУчета.Курс, СтруктураКурсаВзаиморасчетов.Кратность, СтруктураКурсаУпрУчета.Кратность);
	КонецЕсли; 
	
	Движение.СуммаВзаиморасчетов   = ВыборкаПоШапкеДокумента.СуммаУсловийДоговора;
	Движение.Периодичность         = ВыборкаПоШапкеДокумента.Периодичность;

	// Реквизиты
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаОкончания) Тогда
		Движение.ДатаОкончания = ВыборкаПоШапкеДокумента.ДатаОкончания;
	Иначе
		Движение.ДатаОкончания = КонецДня(ВыборкаПоШапкеДокумента.ДатаОкончания);
	КонецЕсли; 
	
КонецПроцедуры

// По строке выборки результата запроса по документу, которая соответствует строке ТЧ документа,
// формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                - выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента              - спозиционированная на определенной строке выборка 
//                                           из результата запроса по товарам документа, 
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента)

	Движение = Движения.УсловияПоставокПоДоговорамКонтрагентовПоНоменклатуре.Добавить();

	// Свойства
	Движение.Период                     = НачалоДня(ВыборкаПоСтрокамДокумента.ДатаНачала);

	// Измерения
	Движение.ДоговорКонтрагента         = ВыборкаПоСтрокамДокумента.ДоговорКонтрагента;
	Движение.Номенклатура               = ВыборкаПоСтрокамДокумента.Номенклатура;
	Движение.ХарактеристикаНоменклатуры = ВыборкаПоСтрокамДокумента.ХарактеристикаНоменклатуры;

	// Ресурсы
	Движение.ЕдиницаИзмерения           = ВыборкаПоСтрокамДокумента.ЕдиницаИзмерения;
	Движение.ВалютаЦены                 = ВыборкаПоСтрокамДокумента.ВалютаЦены;
	Движение.Цена                       = ВыборкаПоСтрокамДокумента.Цена;
	Движение.ВалютаЦены                 = ВыборкаПоСтрокамДокумента.ВалютаЦены;
	Движение.Количество                 = ВыборкаПоСтрокамДокумента.Количество;

	Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаОкончания) Тогда
	
		Движение = Движения.УсловияПоставокПоДоговорамКонтрагентовПоНоменклатуре.Добавить();

		// Свойства
		Движение.Период             = КонецДня(ВыборкаПоСтрокамДокумента.ДатаОкончания);

		// Измерения
		Движение.ДоговорКонтрагента         = ВыборкаПоСтрокамДокумента.ДоговорКонтрагента;
		Движение.Номенклатура               = ВыборкаПоСтрокамДокумента.Номенклатура;
		Движение.ХарактеристикаНоменклатуры = ВыборкаПоСтрокамДокумента.ХарактеристикаНоменклатуры;

		// Ресурсы
		// все пусто, т.к. условия с этой даты не действуют

	КонецЕсли; 
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений

// Проверяет дубли номенклатуры (разные строки с одинаковой номенклатурой) в товарах документа.
//
// Параметры: 
//  ВыборкаПоСтрокамДокумента - спозиционированная на определенной строке выборка 
//                              из результата запроса по товарам документа, 
//  Отказ                     - флаг отказа в проведении.
//
Процедура ПроверитьДублиНоменклатуры(ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	Если ВыборкаПоСтрокамДокумента.КоличествоДублей > 1 Тогда
		ОбщегоНазначения.СообщитьОбОшибке("""" + СокрЛП(ВыборкаПоСтрокамДокумента.Номенклатура) + ", " + СокрЛП(ВыборкаПоСтрокамДокумента.ХарактеристикаНоменклатуры) + """
			               |: дублей строк номенклатуры в этом документе быть не должно!", Отказ, Заголовок);
	КонецЕсли; 

КонецПроцедуры // ПроверитьДублиНоменклатуры

// Процедура проверяет что бы сумма товаров в табличной части была не больше суммы всего по
// условиям поставок
Процедура ПроверитьСуммыТабличнойЧастиИШапки(Отказ, Заголовок)

	СуммаПоТЧ = РассчитатьСуммуТЧ();
	
	Если СуммаПоТЧ > СуммаУсловийДоговора Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьОбОшибке("Сумма по всем номенклатурным позициям табличной части, не может быть больше суммы условий по договору!", Отказ, Заголовок);
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Обработкик события "Проведение" объекта.
//
Процедура ОбработкаПроведения(Отказ, Режим)

	//структура, содержащая имена регистров сведений по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамСведений;
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Сформируем структуру реквизитов шапки документа.
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);

	// Добудем нужные реквизиты по шапке запросом
	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);

	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);
		
		Если НЕ Отказ Тогда
			ПроверитьПересекающиесяДокументы(Отказ, Заголовок);
		КонецЕсли; 
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		ДобавитьШапкуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений);
		
		// Сформируем структуру параметров проведения по шапке документа
		// чтобы не рассчитывать их для каждого движения
		СтруктураПараметров = Новый Структура(); //Зарезервировано для дальнейшего использования
		
		// Добудем нужные реквизиты по строкам табличной части запросом
		РезультатЗапросаПоНоменклатуре   = СформироватьЗапросПоНоменклатуре(Режим, ВыборкаПоШапкеДокумента);
		
		// В цикле по строкам табличной части будем добавлять информацию в движения документа
		ВыборкаПоСтрокамДокумента = РезультатЗапросаПоНоменклатуре.Выбрать();
		Пока ВыборкаПоСтрокамДокумента.Следующий() Цикл 

			// Если тип записи выборки - итог по группировке, то это итог для проверки дублей строк
			Если ВыборкаПоСтрокамДокумента.Уровень() = 1 Тогда
				// В документе не должно быть дублей строк с одинаковой номенклатурой
				ПроверитьДублиНоменклатуры(ВыборкаПоСтрокамДокумента, Отказ, Заголовок);
				Продолжить;
			КонецЕсли;
			
			Если ВыборкаПоСтрокамДокумента.ТипЗаписи() <> ТипЗаписиЗапроса.ДетальнаяЗапись Тогда
				Продолжить;
			КонецЕсли; 
			
			//Надо позвать проверку заполнения реквизитов ТЧ
			ПроверитьЗаполнениеСтрокиНоменклатуры(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок);

			// Движения стоит добавлять, если в проведении еще не отказано (отказ =ложь)
			Если Отказ Тогда
				Продолжить;
			КонецЕсли; 

			ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента);

		КонецЦикла;
		
	КонецЕсли;
	
	ПроверитьСуммыТабличнойЧастиИШапки(Отказ, Заголовок);
	
	ПроверитьСоответствиеПериодичностиИПериода(Отказ, Заголовок);

КонецПроцедуры // ОбработкаПроведения

// Обработкик события "ПередЗаписью" объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	мУдалятьДвижения = НЕ ЭтоНовый();

	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	// Проверка заполнения единицы измерения мест и количества мест
	ОбработкаТабличныхЧастей.ПриЗаписиПроверитьЕдиницуИзмеренияМест(НоменклатураДоговора);

КонецПроцедуры // ПередЗаписью



Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);

КонецПроцедуры

