
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбъектЭлемента = РеквизитФормыВЗначение("Объект");
	
	ЗаполнитьВидыЭДДоступнымиЗначениями();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда // новый
		Объект.СтатусСоглашения = Перечисления.СтатусыСоглашенийЭД.НеСогласовано;
		Объект.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезВебРесурсБанка;
		Объект.РесурсВходящихДокументов = "";
	Иначе
		ДокументОбъект = РеквизитФормыВЗначение("Объект");
		Попытка
			ДвоичныеДанныеСертификата  = ДокументОбъект.СертификатКонтрагентаДляШифрования.Получить();
			Если ДвоичныеДанныеСертификата <> Неопределено Тогда
				СертификатКриптографии = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
				ПредставлениеСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ПолучитьПредставлениеПользователя(
																						СертификатКриптографии.Субъект);
				СертификатБанка = ПредставлениеСертификата;
			КонецЕсли;
		Исключение
			ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке())
							+ НСтр("ru = ' (подробности см. в Журнале регистрации).'");
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЭлектронныеДокументы.ОбработатьИсключениеПоЭДНаСервере(
										НСтр("ru = 'открытие формы соглашения'"),
										ТекстОшибки,
										ТекстСообщения);
		КонецПопытки;

	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Объект.Контрагент = ЭлектронныеДокументыПовтИсп.ПолучитьПустуюСсылку("Банки");
	КонецЕсли;
	
	Элементы.СтраницыВидыБанковскихСистем.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	ЭлектронныеДокументыПереопределяемый.ПроверитьИспользованиеПодсистемыСбербанк(ИспользуетсяПодсистемаСбербанк);
	
	Если НЕ ИспользуетсяПодсистемаСбербанк Тогда
		Элементы.ВидБанковскойСистемы.Видимость = Ложь;
	КонецЕсли;
	
	ПереключитьСтраницы();

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОчиститьСообщения();
	
	Если Объект.СтатусСоглашения = ПредопределенноеЗначение("Перечисление.СтатусыСоглашенийЭД.Действует") Тогда
		ТекстОшибкиАктуальности = "";
		ПроверитьАктуальностьДанныхСоглашения(ТекстОшибкиАктуальности);
		Если НЕ ПустаяСтрока(ТекстОшибкиАктуальности) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибкиАктуальности, ,,,Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Объект.СпособОбменаЭД = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезВебРесурсБанка");
			
	Если ЗначениеЗаполнено(Объект.АдресСервера) И НЕ ПравильныйФорматАдреса()
		И Объект.СтатусСоглашения = ПредопределенноеЗначение("Перечисление.СтатусыСоглашенийЭД.Действует") Тогда
		
		ТекстСообщения = НСтр("ru = 'Адрес сервера банка должен начинаться с """"https://"""" или """"http://""""'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"АдресСервера","Объект",Отказ);
		
	КонецЕсли;
	
	УдалитьПустыеСтрокиТаблиц();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПереключитьСтраницы();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ЗаполнитьТаблицуЭтапов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидБанковскойСистемыПриИзменении(Элемент)
	
	ПереключитьСтраницы();
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатБанкаПриИзменении(Элемент)
	
	Если ПустаяСтрока(Элемент.ТекстРедактирования) Тогда
		ПоместитьВХранилищеСертификат();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатБанкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если СоглашениеЗаписано() Тогда
		Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
			Возврат;
		КонецЕсли;
		
		Режим = РежимДиалогаВыбораФайла.Открытие;
		Диалог = Новый ДиалогВыбораФайла(Режим);
		Диалог.Фильтр = "Файлы сертификатов(*.cer)|*.cer";
		Диалог.Заголовок = НСтр("ru = 'Выберите файл сертификата банка'");
		МассивПомещенных = Новый Массив;
		Если ПоместитьФайлы( ,МассивПомещенных, Диалог) Тогда
			ПоместитьСертификатВСоглашение(МассивПомещенных);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СертификатБанкаОчистка(Элемент, СтандартнаяОбработка)
	
	ПоместитьВХранилищеСертификат();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЧНОЙ ЧАСТИ ИСХОДЯЩИЕ ДОКУМЕНТЫ

&НаКлиенте
Процедура ИсходящиеДокументыПриАктивизацииСтроки(Элемент)
	
	ЗаполнитьТаблицуЭтапов();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЧНОЙ ЧАСТИ ВХОДЯЩИЕ ДОКУМЕНТЫ

&НаКлиенте
Процедура ВходящиеДокументыПриАктивизацииСтроки(Элемент)
	
	ЗаполнитьТаблицуЭтапов();

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Прочее

&НаКлиенте
Процедура ЗаполнитьТаблицуЭтапов()
	
	СтруктураПараметров = СтруктураПараметровВидаЭД();
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаВходящиеДокументы Тогда
		ЗаполнитьСтруктуруПараметров(СтруктураПараметров, Элементы.ВходящиеДокументы.ТекущиеДанные);
		УстановитьЗначенияЭтаповОбменаПоНастройкам(Ложь, СтруктураПараметров);
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаИсходящиеДокументы Тогда
		ЗаполнитьСтруктуруПараметров(СтруктураПараметров, Элементы.ИсходящиеДокументы.ТекущиеДанные);
		УстановитьЗначенияЭтаповОбменаПоНастройкам(СтруктураПараметров);
	КонецЕсли	

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыЭДДоступнымиЗначениями()
	
	АктуальныеВидыЭД = ЭлектронныеДокументыПовтИсп.ПолучитьАктуальныеВидыЭД();
	
	Для Каждого ЗначениеПеречисления Из АктуальныеВидыЭД Цикл
		Если ЗначениеПеречисления = Перечисления.ВидыЭД.ПлатежноеПоручение 
			ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ЗапросВыписки Тогда
				МассивСтрок = Объект.ИсходящиеДокументы.НайтиСтроки(Новый Структура("ИсходящийДокумент", ЗначениеПеречисления));
				Если МассивСтрок.Количество() = 0 Тогда 
					НоваяСтрока = Объект.ИсходящиеДокументы.Добавить();
					НоваяСтрока.ИсходящийДокумент = ЗначениеПеречисления;
					НоваяСтрока.Формировать       = Истина;
					НоваяСтрока.ИспользоватьЭЦП   = Истина;
				КонецЕсли;
		ИначеЕсли ЗначениеПеречисления = Перечисления.ВидыЭД.ВыпискаБанка Тогда
				МассивСтрок = Объект.ВходящиеДокументы.НайтиСтроки(Новый Структура("ВходящийДокумент", ЗначениеПеречисления));
				Если МассивСтрок.Количество() = 0 Тогда 
					НоваяСтрока = Объект.ВходящиеДокументы.Добавить();
					НоваяСтрока.ВходящийДокумент = ЗначениеПеречисления;
					НоваяСтрока.Формировать       = Истина;
					НоваяСтрока.ИспользоватьЭЦП   = Истина;
				КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияЭтаповОбменаПоНастройкам(НастройкиИсходящие = Ложь, НастройкиВходящие = Ложь)
	
	Если НастройкиИсходящие <> Ложь Тогда
		МассивСтатусов = ЭлектронныеДокументыСлужебный.ВернутьМассивСтатусовЭД(НастройкиИсходящие);
		ТаблицаЗаполнения = ТаблицаЭтаповИсходящие;
	КонецЕсли;
	
	Если НастройкиВходящие <> Ложь Тогда
		МассивСтатусов = ЭлектронныеДокументыСлужебный.ВернутьМассивСтатусовЭД(НастройкиВходящие);
		ТаблицаЗаполнения = ТаблицаЭтаповВходящие;
	КонецЕсли;
	
	Если ТаблицаЗаполнения <> Неопределено Тогда
		ТаблицаЗаполнения.Очистить();
		
		Для Каждого Элемент Из МассивСтатусов Цикл
			ТаблицаЗаполнения.Добавить(Элемент);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СтруктураПараметровВидаЭД()
	СтруктураВозврата = Новый Структура("Направление, ВидЭД, СпособОбмена, ИспользоватьПодпись, ИспользуетсяНесколькоПодписей, ПрограммаБанка");
	Возврат СтруктураВозврата;
КонецФункции

&НаКлиенте
Процедура ЗаполнитьСтруктуруПараметров(СтруктураПараметров,ДанныеФормыКоллекция)
	
	Если ДанныеФормыКоллекция = Неопределено ИЛИ НЕ ДанныеФормыКоллекция.Формировать Тогда
		СтруктураПараметров = Неопределено; 
	Иначе
		СтруктураПараметров.ИспользоватьПодпись           = ДанныеФормыКоллекция.ИспользоватьЭЦП;
		СтруктураПараметров.СпособОбмена                  = Объект.СпособОбменаЭД;
		
		СтруктураПараметров.ИспользуетсяНесколькоПодписей = ИспользуетсяНесколькоПодписей();
		
		Если ДанныеФормыКоллекция.Свойство("ИсходящийДокумент") Тогда
			СтруктураПараметров.Направление = ПредопределенноеЗначение("Перечисление.НаправленияЭД.Исходящий");
			СтруктураПараметров.ВидЭД = ДанныеФормыКоллекция.ИсходящийДокумент;
		Иначе
			СтруктураПараметров.Направление = ПредопределенноеЗначение("Перечисление.НаправленияЭД.Входящий");
			СтруктураПараметров.ВидЭД = ДанныеФормыКоллекция.ВходящийДокумент;
		КонецЕсли;
		
		СтруктураПараметров.ПрограммаБанка = Объект.ПрограммаБанка;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИспользуетсяНесколькоПодписей()
	
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.СертификатыПодписейОрганизации.Количество() > 1;
	
КонецФункции

&НаСервере
Процедура ПроверитьАктуальностьДанныхСоглашения(ТекстОшибкиАктуальности)
	
	ЗапросПоСоглашениям = Новый Запрос;
	ЗапросПоСоглашениям.УстановитьПараметр("СтатусСоглашения",  Перечисления.СтатусыСоглашенийЭД.Действует);
	ЗапросПоСоглашениям.УстановитьПараметр("ТекущееСоглашение", Объект.Ссылка);
	ЗапросПоСоглашениям.УстановитьПараметр("Организация",       Объект.Организация);
	ЗапросПоСоглашениям.УстановитьПараметр("Контрагент",        Объект.Контрагент);
	ЗапросПоСоглашениям.Текст = "ВЫБРАТЬ
	                            |	СоглашенияОбИспользованииЭДИсходящиеДокументы.ИсходящийДокумент КАК ТипДокумента,
	                            |	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка КАК Соглашение
	                            |ИЗ
	                            |	Справочник.СоглашенияОбИспользованииЭД.ИсходящиеДокументы КАК СоглашенияОбИспользованииЭДИсходящиеДокументы
	                            |ГДЕ
	                            |	СоглашенияОбИспользованииЭДИсходящиеДокументы.Формировать = ИСТИНА
	                            |	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.СтатусСоглашения = &СтатусСоглашения
	                            |	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.ПометкаУдаления = ЛОЖЬ
	                            |	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка <> &ТекущееСоглашение
	                            |	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.Организация = &Организация
	                            |	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.Контрагент = &Контрагент
	                            |	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезВебРесурсБанка)";
	Результат = ЗапросПоСоглашениям.Выполнить().Выгрузить();
	
	ПроверитьУникальностьДокументов(Объект.ИсходящиеДокументы, Результат, ТекстОшибкиАктуальности);
		
КонецПроцедуры

&НаСервере
Процедура ПроверитьУникальностьДокументов(ТабличнаяЧастьДокументов, РезультатПроверки, ТекстОшибки)
			
	Для Каждого ТекущийДокументСоглашения Из ТабличнаяЧастьДокументов Цикл
		Если ТекущийДокументСоглашения.Формировать Тогда
			Для Каждого ДокументВДругихСоглашениях Из РезультатПроверки Цикл
				Если ТекущийДокументСоглашения.ИсходящийДокумент = ДокументВДругихСоглашениях.ТипДокумента Тогда
					ТекстОшибки = НСтр("ru = 'По виду электронных документов %1 %2 
					|уже существует действующее соглашение между участниками %3 - %4:
					|%5.
					|'");
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						ТекстОшибки, 
						ДокументВДругихСоглашениях.ТипДокумента, 
						"Исходящий", 
						Объект.Организация, 
						Объект.Контрагент, 
						ДокументВДругихСоглашениях.Соглашение
						);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПравильныйФорматАдреса()
	
	Если НРег(Лев(Объект.АдресСервера, 7)) = "http://"
			ИЛИ НРег(Лев(Объект.АдресСервера, 8)) = "https://" Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ПереключитьСтраницы()
	
	Если Не ИспользуетсяПодсистемаСбербанк Тогда
		Элементы.СтраницаСертификатыСбербанк.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	ЭтоПрограммаСбербанка = (Объект.ПрограммаБанка = Перечисления.ПрограммыБанка.СбербанкОнлайн);
	
	Если ЭтоПрограммаСбербанка Тогда
		Элементы.СтраницыВидыБанковскихСистем.ТекущаяСтраница = Элементы.СтраницаСбербанк;
		Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСертификатыТиповые Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСертификатыСбербанк;
		КонецЕсли;
	Иначе
		Элементы.СтраницыВидыБанковскихСистем.ТекущаяСтраница = Элементы.СтраницаТиповой;
		Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСертификатыСбербанк Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСертификатыТиповые;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.СтраницаСертификатыСбербанк.Видимость = ЭтоПрограммаСбербанка;
	Элементы.СтраницаСертификатыТиповые.Видимость  = НЕ ЭтоПрограммаСбербанка;
	Элементы.ФормаТестСвязи.Видимость              = ЭтоПрограммаСбербанка;
	Элементы.ФормаЖурналАудита.Видимость           = ЭтоПрограммаСбербанка;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьПустыеСтрокиТаблиц()
	
	СписокСтрокКУдалению = Новый СписокЗначений;
	Для каждого СтрокаСертификата ИЗ Объект.СертификатыПодписейОрганизации Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаСертификата.Сертификат) Тогда
			СписокСтрокКУдалению.Добавить(СтрокаСертификата.НомерСтроки);
		КонецЕсли;
	КонецЦикла;

	СписокСтрокКУдалению.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
	
	Для Каждого Запись ИЗ СписокСтрокКУдалению Цикл
		Объект.СертификатыПодписейОрганизации.Удалить(Запись.Значение-1);
	КонецЦикла

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.ПрограммаБанка = Перечисления.ПрограммыБанка.СбербанкОнлайн
			И Объект.СтатусСоглашения = Перечисления.СтатусыСоглашенийЭД.Действует Тогда
		ПроверяемыеРеквизиты.Добавить("СертификатБанка");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьВХранилищеСертификат(ДвоичныеДанные = Неопределено, ПредставлениеСертификата=Неопределено)
	
	ХранилищеЗначения  = Новый ХранилищеЗначения(ДвоичныеДанные);
	СправочникОбъект = РеквизитФормыВЗначение("Объект");
	СправочникОбъект.СертификатКонтрагентаДляШифрования = ХранилищеЗначения;
	СправочникОбъект.Записать();
	ЗначениеВРеквизитФормы(СправочникОбъект, "Объект");
	ЭтаФорма.Прочитать();
	
	Если ДвоичныеДанные <> Неопределено Тогда
		Попытка
			СертификатКриптографии = Новый СертификатКриптографии(ДвоичныеДанные);
		Исключение
			ВремФайл = ПолучитьИмяВременногоФайла();
			Попытка
				ДвоичныеДанные.Записать(ВремФайл);
				ТекстовыйДокумент = Новый ТекстовыйДокумент;
				ТекстовыйДокумент.Прочитать(ВремФайл);
				СтрокаBase64 = ТекстовыйДокумент.ПолучитьТекст();
				СтрокаBase64 = СтрЗаменить(СтрокаBase64, "-----BEGIN CERTIFICATE-----" + Символы.ПС,""); 
				СтрокаBase64 = СтрЗаменить(СтрокаBase64, Символы.ПС + "-----END CERTIFICATE-----","");
				ДвоичныеДанныеСертификата = Base64Значение(СтрокаBase64);
				ХранилищеЗначения  = Новый ХранилищеЗначения(ДвоичныеДанныеСертификата);
				СправочникОбъект = РеквизитФормыВЗначение("Объект");
				СправочникОбъект.СертификатКонтрагентаДляШифрования = ХранилищеЗначения;
				СправочникОбъект.Записать();
				ЗначениеВРеквизитФормы(СправочникОбъект, "Объект");
				ЭтаФорма.Прочитать();
				СертификатКриптографии = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
			Исключение
				СправочникОбъект = РеквизитФормыВЗначение("Объект");
				СправочникОбъект.СертификатКонтрагентаДляШифрования = Неопределено;
				СправочникОбъект.Записать();
				ЗначениеВРеквизитФормы(СправочникОбъект, "Объект");
				ЭтаФорма.Прочитать();
				УдалитьФайлы(ВремФайл);
				ТекстСообщения = НСтр("ru = 'Не удалось прочитать файл сертификата, операция прервана.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				ПредставлениеСертификата = "";
				Возврат;
			КонецПопытки;
			УдалитьФайлы(ВремФайл);
			
		КонецПопытки;
		ПредставлениеСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ПолучитьПредставлениеПользователя(
																				СертификатКриптографии.Субъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СоглашениеЗаписано()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ Объект.ЭтоТиповое Тогда
		ТекстВопроса = НСтр("ru = 'Внешние сертификаты можно выбирать только в записанном соглашении.
							|Записать соглашение?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	Иначе
		Ответ = КодВозвратаДиалога.Да;
	КонецЕсли;
	
	Возврат Ответ = КодВозвратаДиалога.Да И ОбъектЗаполнен();
	
КонецФункции

&НаСервере
Процедура ПоместитьСертификатВСоглашение(МассивАдресовФайла)

	АдресВременногоХранилища = МассивАдресовФайла[0].Хранение;
	ДанныеФайла = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	ПредставлениеСертификата = Неопределено;
	ПоместитьВХранилищеСертификат(ДанныеФайла, ПредставлениеСертификата);
	СертификатБанка = ПредставлениеСертификата;
	
КонецПроцедуры

&НаСервере
Функция ОбъектЗаполнен()
	
	Возврат РеквизитФормыВЗначение("Объект").ПроверитьЗаполнение();
	
КонецФункции

&НаКлиенте
Процедура ТестСвязи(Команда)

	#Если ВебКлиент ИЛИ ТонкийКлиент Тогда
		ТекстСообщения = Нстр("ru = 'Тест возможен только в толстом клиенте'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	#КонецЕсли
	
	ЭлектронныеДокументыСлужебныйКлиент.ПроверитьНаличиеСвязиСБанком(Объект.Ссылка);

КонецПроцедуры

&НаКлиенте
Процедура ЖурналАудита(Команда)

	ОткрытьФорму("РегистрСведений.ЖурналАудитаСбербанк.ФормаСписка", Новый Структура("СоглашениеЭД", Объект.Ссылка));
	
КонецПроцедуры


