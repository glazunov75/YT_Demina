////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция СоздатьОбъектыИБ(АдресВременногоХранилища, ОшибкаЗаписи)
	
	Перем ДеревоРазбора;
	
	СтруктураРазбора = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	Если СтруктураРазбора <> Неопределено И СтруктураРазбора.Свойство("ДеревоРазбора", ДеревоРазбора) Тогда
		// Заполним ссылки на объекты из дерева соответствий, если ссылок нет,
		// тогда будем создавать объекты
		ЭлектронныеДокументыВнутренний.ЗаполнитьСсылкиНаОбъектыВДереве(ДеревоРазбора, ОшибкаЗаписи);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция СопоставитьНоменклатуру(ДанныеФормы = Неопределено)
	
	ЗначениеВозврата = Неопределено;
	СтруктураЭД = Новый Структура;
	СтруктураЭД.Вставить("ВидЭД", ВидЭД);
	СтруктураЭД.Вставить("СпособОбменаЭД", ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.БыстрыйОбмен"));
	СтруктураЭД.Вставить("ПолноеИмяФайла", ИмяФайла);
	СтруктураЭД.Вставить("Контрагент", Контрагент);
	СтруктураЭД.Вставить("НаправлениеЭД", ПредопределенноеЗначение("Перечисление.НаправленияЭД.Входящий"));
	СтруктураЭД.Вставить("ВладелецФайла", ДокументИБ);
	
	СтруктураПараметров = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьПараметрыФормыСопоставленияНоменклатуры(СтруктураЭД);
	Если ЗначениеЗаполнено(СтруктураПараметров) Тогда
		ЗначениеВозврата = ОткрытьФормуМодально(СтруктураПараметров.ИмяФормы, СтруктураПараметров.ПараметрыОткрытияФормы);
	КонецЕсли;
	
	Возврат ЗначениеВозврата;
	
КонецФункции

&НаКлиенте
Процедура ИзменитьВидимостьДоступность()
	
	Если ЗагрузкаЭД Тогда
		Элементы.ДокументИБ.Доступность = (СпособЗагрузкиДокумента = 1);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьДоступностьПриСозданииНаСервере()
	
	Элементы.ГруппаСодержимоеДокумента.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	Если ЗагрузкаЭД Тогда
		ЭтаФорма.Заголовок = Нстр("ru = 'Загрузка документа из файла'");
		Элементы.ГруппаНастроек.Видимость = Истина;
		Элементы.ГруппаКнопок.Видимость = Истина;
		Элементы.ГруппаГиперссылка.Видимость = Ложь;
	Иначе
		Текст = Нстр("ru = 'Электронный документ'");
		ЭтаФорма.Заголовок = Текст;
		Элементы.ГруппаНастроек.Видимость = Ложь;
		Элементы.ГруппаКнопок.Видимость = Ложь;
		Элементы.ГруппаГиперссылка.Видимость = Истина;
	КонецЕсли;
	
	Если ВидЭД = Перечисления.ВидыЭД.КаталогТоваров Тогда
		Элементы.Загрузка.Видимость = Ложь;
		Элементы.СписокТиповДокументов.Заголовок = "Загрузить";
		СписокТиповДокументов = "Каталог товаров";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПросмотрЭДСервер(СтруктураЭД)
	
	Перем ПерезаполняемыйДокумент, ДеревоРазбора, СтрокаОбъекта;
	
	Если ЗагрузкаЭД Тогда
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(СтруктураЭД.АдресВХранилище);
		
		Если СтруктураЭД.ФайлАрхива Тогда
			ПапкаДляРаспаковки = ЭлектронныеДокументыСлужебный.РабочийКаталог("Ext", СтруктураЭД.УникальныйИдентификатор);
			ИмяФайлаАрхива = ЭлектронныеДокументыСлужебный.ТекущееИмяВременногоФайла("zip");
			ДвоичныеДанные.Записать(ИмяФайлаАрхива);
			
			УдалитьФайлы(ПапкаДляРаспаковки, "*");
			
			ЧтениеЗИП = Новый ЧтениеZIPФайла(ИмяФайлаАрхива);
			Попытка
				ЧтениеЗИП.ИзвлечьВсе(ПапкаДляРаспаковки);
			Исключение
				ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				Если НЕ ЭлектронныеДокументыСлужебный.ВозможноИзвлечьФайлы(ЧтениеЗИП, ПапкаДляРаспаковки) Тогда
					ТекстСообщения = ЭлектронныеДокументыПовтИсп.ПолучитьСообщениеОбОшибке("006");
				КонецЕсли;
				ЭлектронныеДокументыСлужебныйВызовСервера.ОбработатьИсключениеПоЭДНаСервере(НСтр("ru = 'Распаковка архива ЭД'"),
					ТекстОшибки, ТекстСообщения);
					
				УдалитьФайлы(ИмяФайлаАрхива);
				УдалитьФайлы(ПапкаДляРаспаковки);
				Возврат ;
			КонецПопытки;
			
			// Расшифровать файл с данными
			МассивФайлИнформации = НайтиФайлы(ПапкаДляРаспаковки, "meta*.xml", Истина);
			Если МассивФайлИнформации.Количество() > 0 Тогда
				ФайлИнформации = МассивФайлИнформации[0];
			Иначе
				УдалитьФайлы(ИмяФайлаАрхива);
				УдалитьФайлы(ПапкаДляРаспаковки);
				Возврат;
			КонецЕсли;
			
			МассивФайлКарточки = НайтиФайлы(ПапкаДляРаспаковки, "card*.xml", Истина);
			Если МассивФайлКарточки.Количество() > 0 Тогда
				ФайлКарточки = МассивФайлКарточки[0];
			Иначе
				УдалитьФайлы(ИмяФайлаАрхива);
				УдалитьФайлы(ПапкаДляРаспаковки);
				Возврат;
			КонецЕсли;
			
			СоответствиеФайлПараметры = ЭлектронныеДокументыВнутренний.ПолучитьСоответствиеФайлПараметры(ФайлИнформации, ФайлКарточки);
			Если СоответствиеФайлПараметры.Количество() = 0 Тогда
				УдалитьФайлы(ПапкаДляРаспаковки);
				УдалитьФайлы(ИмяФайлаАрхива);
				Возврат;
			КонецЕсли;
			
			Для Каждого ЭлементСоответствия Из СоответствиеФайлПараметры Цикл
				
				МассивФайловИсточник = НайтиФайлы(ПапкаДляРаспаковки, ЭлементСоответствия.Ключ, Истина);
				Если МассивФайловИсточник.Количество() > 0 Тогда
					ИмяФайла = ЭлектронныеДокументыСлужебный.ТекущееИмяВременногоФайла("xml");
					КопироватьФайл(МассивФайловИсточник[0].ПолноеИмя, ИмяФайла);
				Иначе
					УдалитьФайлы(ПапкаДляРаспаковки);
					УдалитьФайлы(ИмяФайлаАрхива);
					Возврат;
				КонецЕсли;
			КонецЦикла;
			
			УдалитьФайлы(ИмяФайлаАрхива);
			УдалитьФайлы(ПапкаДляРаспаковки);
		Иначе
			ИмяФайла = ЭлектронныеДокументыСлужебный.ТекущееИмяВременногоФайла("xml");
			ДвоичныеДанные.Записать(ИмяФайла);
		КонецЕсли;
			
		СтруктураЭД.Свойство("СсылкаНаДокумент", ПерезаполняемыйДокумент);
	Иначе
		ИмяФайла = СтруктураЭД.ПолноеИмяФайла;
	КонецЕсли;
	
	СтруктураРазбора = ЭлектронныеДокументыВнутренний.СформироватьДеревоРазбора(ИмяФайла, Перечисления.НаправленияЭД.Входящий);
	Если ТипЗнч(СтруктураРазбора) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	АдресСтруктурыРазбораЭД = ПоместитьВоВременноеХранилище(СтруктураРазбора, УникальныйИдентификатор);
	ДанныеЭД = ЭлектронныеДокументыВнутренний.ПечатнаяФормаЭД(СтруктураРазбора, СтруктураЭД.НаправлениеЭД,
		СтруктураЭД.УникальныйИдентификатор, , , ВидЭД);
	
	Если ДанныеЭД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЭД) = Тип("ТабличныйДокумент") Тогда
		Если ЗагрузкаЭД Тогда
			Если (НЕ ЗначениеЗаполнено(ДокументИБ) ИЛИ СпособЗагрузкиДокумента = 0) И СтруктураРазбора <> Неопределено
					И СтруктураРазбора.Свойство("ДеревоРазбора", ДеревоРазбора)
					И СтруктураРазбора.Свойство("СтрокаОбъекта", СтрокаОбъекта) Тогда
				ОшибкаЗаписи = Ложь;
				СтрокаДерева = НайтиСтрокуВДереве(ДеревоРазбора, СтрокаОбъекта, "Контрагент");
				Если СтрокаДерева <> Неопределено Тогда
					Контрагент = СтрокаДерева.СсылкаНаОбъект;
				КонецЕсли;
			КонецЕсли;
			СписокТипов = Новый СписокЗначений;
			ЭлектронныеДокументыПереопределяемый.СписокТиповДокументовПоВидуЭД(ВидЭД, СписокТипов);
			Для Каждого ТекЗначение Из СписокТипов Цикл
				ТекЭлемент = Элементы.СписокТиповДокументов.СписокВыбора.Добавить();
				ЗаполнитьЗначенияСвойств(ТекЭлемент, ТекЗначение);
				// Если реквизит ДокументИБ еще не заполнен и прочитано первое по списку значение, то заполним имеющимися данными:
				Если НЕ ЗначениеЗаполнено(ДокументИБ) И СписокТипов.Индекс(ТекЗначение) = 0 Тогда
					СписокТиповДокументов = ТекЗначение.Представление;
					ДокументИБ = ТекЗначение.Значение;
					ИмяОбъектаМетаданных = ТекЗначение.Значение.Метаданные().ПолноеИмя();
				КонецЕсли;
				// Если в структуре параметров есть ссылка на (перезаполняемый) документ ИБ и его тип совпал с типом одного из значений
				// списка типов, то заполним этими данными соответствующие реквизиты формы.
				// Данное условие необходимо для корректной обработки ситуации, когда в качестве перезаполняемого документа, выбран
				// документ с типом не совпадающим ни с одним из доступных в списке или не совпадает с типом первого элемента списка.
				Если ЗначениеЗаполнено(ПерезаполняемыйДокумент) И ТипЗнч(ПерезаполняемыйДокумент) = ТипЗнч(ТекЗначение.Значение) Тогда
					СписокТиповДокументов = ТекЗначение.Представление;
					ДокументИБ = ПерезаполняемыйДокумент;
					ИмяОбъектаМетаданных = ТекЗначение.Значение.Метаданные().ПолноеИмя();
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Контрагент) И ЗначениеЗаполнено(ПерезаполняемыйДокумент) Тогда
			Контрагент = ПерезаполняемыйДокумент.Контрагент;
		КонецЕсли;
		
		ТабличныйДокументФормы = ДанныеЭД;
		Элементы.ГруппаСодержимоеДокумента.ТекущаяСтраница = Элементы.СтраницаТабличныйДокумент;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НайтиСтрокуВДереве(ДеревоРазбора, СтрокаОбъекта, ИмяОбъектаПоиска)
	
	ВозвращаемоеЗначение = Неопределено;
	
	СтруктураПоиска = Новый Структура("Реквизит", ИмяОбъектаПоиска);
	МассивСтрок = СтрокаОбъекта.Строки.НайтиСтроки(СтруктураПоиска);
	Если МассивСтрок.Количество() > 0 Тогда
		ИндексСтрокиКонтрагента = МассивСтрок[0].ЗначениеРеквизита;
		СтруктураПоиска = Новый Структура("ИндексСтроки", ИндексСтрокиКонтрагента);
		МассивСтрок = ДеревоРазбора.Строки.НайтиСтроки(СтруктураПоиска, Истина);
		Если МассивСтрок.Количество() > 0 Тогда
			СтрокаДерева = МассивСтрок[0];
			ВозвращаемоеЗначение = СтрокаДерева;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаСервере
Функция СформироватьДокументИБ(ДанныеФормы, ТекстСообщения)
	
	Перем СтрокаОбъекта, ДеревоРазбора;
	ОшибкаЗаписи = Истина;
	Если ЗначениеЗаполнено(АдресСтруктурыРазбораЭД) И ЭтоАдресВременногоХранилища(АдресСтруктурыРазбораЭД) Тогда
		СтруктураРазбора = ПолучитьИзВременногоХранилища(АдресСтруктурыРазбораЭД);
	Иначе
		СтруктураРазбора = ЭлектронныеДокументыВнутренний.СформироватьДеревоРазбора(ИмяФайла,
																					Перечисления.НаправленияЭД.Входящий);
	КонецЕсли;
	Если СтруктураРазбора <> Неопределено И СтруктураРазбора.Свойство("ДеревоРазбора", ДеревоРазбора)
		И СтруктураРазбора.Свойство("СтрокаОбъекта", СтрокаОбъекта) Тогда
		// Если на форме указан контрагент, не совпадающий с контрагентом в дереве разбора (найденный по реквизитам из ЭД),
		// то заменим контрагента в дереве на контрагента с формы.
		СтрокаДерева = НайтиСтрокуВДереве(ДеревоРазбора, СтрокаОбъекта, "Контрагент");
		Если СтрокаДерева.СсылкаНаОбъект <> Контрагент Тогда
			СтрокаДерева.СсылкаНаОбъект = Контрагент;
		КонецЕсли;
		ДокументСсылка = ?(СпособЗагрузкиДокумента = 1, ДокументИБ, Неопределено);
		Попытка
			ДокументОбъект = ЭлектронныеДокументыПереопределяемый.СохранитьДанныеОбъектаВБД(СтрокаОбъекта,
																							ДеревоРазбора,
																							ДокументСсылка,
																							Ложь);
			Если ДанныеФормы <> Неопределено Тогда
				ЗначениеВДанныеФормы(ДокументОбъект, ДанныеФормы);
			Иначе
				ДанныеФормы = ДокументОбъект;
			КонецЕсли;
			ОшибкаЗаписи = Ложь;
		Исключение
			ТекстСообщения = ИнформацияОбОшибке();
		КонецПопытки;
	КонецЕсли;

	Возврат ОшибкаЗаписи;
	
КонецФункции

&НаСервереБезКонтекста
Функция МожноЗагрузитьЭДВида(Знач ВидЭД)
	
	МожноЗагрузить = Истина;
	МассивАктуальныхВидовЭД = ЭлектронныеДокументыПовтИсп.ПолучитьАктуальныеВидыЭД();
	Если МассивАктуальныхВидовЭД.Найти(ВидЭД) = Неопределено Тогда
		МожноЗагрузить = Ложь;
	КонецЕсли;
	
	Возврат МожноЗагрузить;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	
	Если ЗагрузкаЭД И ЗначениеЗаполнено(ИмяОбъектаМетаданных) Тогда
		ОчиститьСообщения();
		
		Отказ = Ложь;
		ТекстСообщения = "";
		Если НЕ МожноЗагрузитьЭДВида(ВидЭД) Тогда
			ТекстСообщения = НСтр("ru = 'Не поддерживается загрузка электронных документов вида ""%1"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", СписокТиповДокументов);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
			ТекстСообщения = НСтр("ru = 'Не указан контрагент.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
		КонецЕсли;
		Если СпособЗагрузкиДокумента = 1 И НЕ ЗначениеЗаполнено(ДокументИБ) Тогда
			ТекстСообщения = НСтр("ru = 'Не указан документ для перезаполнения.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
		КонецЕсли;
		
		СоздатьОбъектыИБ(АдресСтруктурыРазбораЭД, Отказ);
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		Попытка
			Если СпособЗагрузкиДокумента = 1 И ЗначениеЗаполнено(ДокументИБ) Тогда
				ФормаДокумента = ПолучитьФорму(ИмяОбъектаМетаданных + ".ФормаОбъекта", Новый Структура("Ключ", ДокументИБ));
			Иначе
				ФормаДокумента = ПолучитьФорму(ИмяОбъектаМетаданных + ".ФормаОбъекта");
			КонецЕсли;
		Исключение
			ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		КонецПопытки;
		Если НЕ Отказ Тогда
			Если ТипЗнч(ФормаДокумента) = Тип("УправляемаяФорма") Тогда
				ДанныеФормы = ФормаДокумента.Объект;
			Иначе
				ДанныеФормы = Неопределено;
			КонецЕсли;
			СопоставлятьНоменклатуруПередЗаполнениемДокумента = Ложь;
			ЭлектронныеДокументыКлиентПереопределяемый.СопоставлятьНоменклатуруПередЗаполнениемДокумента(СопоставлятьНоменклатуруПередЗаполнениемДокумента);
			
			Если СопоставлятьНоменклатуруПередЗаполнениемДокумента Тогда
				СопоставитьНоменклатуру();
			КонецЕсли;

			Отказ = СформироватьДокументИБ(ДанныеФормы, ТекстСообщения);

			Если Отказ Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Иначе
				МассивОповещения = Новый Массив;
				МассивОповещения.Добавить(ДокументИБ);
				Оповестить("ОбновитьДокументИБПослеЗаполнения", МассивОповещения);
				Если Не СопоставлятьНоменклатуруПередЗаполнениемДокумента Тогда
					ЗначениеВозврата = СопоставитьНоменклатуру(ДанныеФормы);
					Если ЗначениеЗаполнено(ЗначениеВозврата) Тогда
						ЭлектронныеДокументыСлужебныйВызовСервера.ЗаполнитьИсточник(ДанныеФормы, ЗначениеВозврата);
					КонецЕсли;
				КонецЕсли;
				Если ТипЗнч(ФормаДокумента) = Тип("УправляемаяФорма") Тогда
					КопироватьДанныеФормы(ДанныеФормы, ФормаДокумента.Объект);
				Иначе
					ФормаДокумента.ДокументОбъект = ДанныеФормы;
				КонецЕсли;
				ФормаДокумента.Открыть();
				ФормаДокумента.Модифицированность = Истина;
				ЭтаФорма.Закрыть();
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;
	
	Если ВидЭД = ПредопределенноеЗначение("Перечисление.ВидыЭД.КаталогТоваров") Тогда
		
		СоздатьОбъектыИБ(АдресСтруктурыРазбораЭД, Ложь);
		СопоставитьНоменклатуру();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

&НаКлиенте
Процедура СписокТиповДокументовНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекЭлемент = Неопределено;
	Если ЗначениеЗаполнено(СписокТиповДокументов) Тогда
		Для Каждого ЭлементСписка Из Элементы.СписокТиповДокументов.СписокВыбора Цикл
			Если СписокТиповДокументов = ЭлементСписка.Представление Тогда
				ТекЭлемент = ЭлементСписка;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	ВыбранныйЭлемент = ВыбратьИзСписка(Элементы.СписокТиповДокументов.СписокВыбора, Элемент, ТекЭлемент);
	Если ВыбранныйЭлемент <> Неопределено И ВыбранныйЭлемент <> ТекЭлемент Тогда
		СписокТиповДокументов = ВыбранныйЭлемент.Представление;
		Если НЕ ЗначениеЗаполнено(ДокументИБ) ИЛИ ТипЗнч(ДокументИБ) <> ТипЗнч(ВыбранныйЭлемент.Значение) Тогда
			ДокументИБ = ВыбранныйЭлемент.Значение;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпособЗагрузкиДокументаПриИзменении(Элемент)
	
	ИзменитьВидимостьДоступность();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЭД = "";
	НаправлениеЭД = "";
	Если Параметры.Свойство("СтруктураЭД", СтруктураЭД) И ТипЗнч(СтруктураЭД) = Тип("Структура")
		И СтруктураЭД.Свойство("НаправлениеЭД", НаправлениеЭД) Тогда
		ЗагрузкаЭД = (НаправлениеЭД = Перечисления.НаправленияЭД.Входящий);
		СтруктураЭД.Свойство("ВладелецЭД", ДокументИБ);
		Если ЗагрузкаЭД Тогда
			СсылкаНаЗаполняемыйДокумент = "";
			Если СтруктураЭД.Свойство("СсылкаНаДокумент", СсылкаНаЗаполняемыйДокумент)
				И ЗначениеЗаполнено(СсылкаНаЗаполняемыйДокумент) Тогда
				СпособЗагрузкиДокумента = 1;
			КонецЕсли;
		КонецЕсли;
		ВыполнитьПросмотрЭДСервер(СтруктураЭД);
	КонецЕсли;
	ИзменитьВидимостьДоступностьПриСозданииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИзменитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументИБНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ДокументИБ = Неопределено Тогда
		ТекЭлемент = Неопределено;
		Если ЗначениеЗаполнено(СписокТиповДокументов) Тогда
			Для Каждого ЭлементСписка Из Элементы.СписокТиповДокументов.СписокВыбора Цикл
				Если СписокТиповДокументов = ЭлементСписка.Представление Тогда
					ДокументИБ = ЭлементСписка.Значение;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
