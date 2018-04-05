
// Показывает стандартное предупреждение.
// 
// Параметры:
//  ПредставлениеКоманды - Строка, если указано то будет уточнена команда,
//                         для которой необходимо расширение.
//
Процедура ПредупредитьОНеобходимостиРасширенияРаботыСФайлами(ПредставлениеКоманды = "") Экспорт
	
	Если ЗначениеЗаполнено(ПредставлениеКоманды) Тогда
		
		Предупреждение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для выполнения команды ""%1"" необходимо
			           |установить расширение работы с файлами.'"),
			ПредставлениеКоманды));
	Иначе
		Предупреждение(НСтр("ru = 'Для выполнения команды необходимо
		                          |установить расширение работы с файлами.'"));
	КонецЕсли;
	
КонецПроцедуры

// Показывает стандартное предупреждение.
// 
// Параметры:
//  ПредставлениеКоманды - Строка, если указано то будет уточнена команда,
//                         для которой необходимо расширение.
//
Процедура ПредупредитьОНеобходимостиРасширенияРаботыСКриптографией(ПредставлениеКоманды = "") Экспорт
	
	Если ЗначениеЗаполнено(ПредставлениеКоманды) Тогда
		
		Предупреждение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для выполнения команды ""%1"" необходимо
			           |установить расширение работы с криптографией.'"),
			ПредставлениеКоманды));
	Иначе
		Предупреждение(НСтр("ru = 'Для выполнения команды необходимо
		                          |установить расширение работы с криптографией.'"));
	КонецЕсли;
	
КонецПроцедуры

// Возвращает путь к рабочему каталогу пользователя.
Функция РабочийКаталогПользователя() Экспорт
	
	Возврат ФайловыеФункцииСлужебныйКлиентПовтИсп.РабочийКаталогПользователя();
	
КонецФункции

// Сохраняет путь к рабочему каталогу пользователя в настройках.
//
// Параметры:
//  ИмяКаталога - Строка - имя каталога.
//
Процедура УстановитьРабочийКаталогПользователя(ИмяКаталога) Экспорт
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьИОбновитьПовторноИспользуемыеЗначения(
		"ЛокальныйКэшФайлов", "ПутьКЛокальномуКэшуФайлов", ИмяКаталога);
	
КонецПроцедуры

// Возвращает каталог "Мои Документы" + имя текущего пользователя или
// ранее использованную папку для выгрузки.
//
Функция КаталогВыгрузки() Экспорт
	
	Путь = "";
	
#Если Не ВебКлиент Тогда
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	
	Путь = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("ИмяПапкиВыгрузки", "ИмяПапкиВыгрузки");
	
	Если Путь = Неопределено Тогда
		Если НЕ ПараметрыКлиента.ЭтоБазоваяВерсияКонфигурации Тогда
			
			Оболочка = Новый COMОбъект("MSScriptControl.ScriptControl");
			Оболочка.Language = "vbscript";
			Оболочка.AddCode("
				|Function SpecialFoldersName(Name)
				|set Shell=CreateObject(""WScript.Shell"")
				|SpecialFoldersName=Shell.SpecialFolders(Name)
				|End Function");
			
			Путь = НормализоватьКаталог(Оболочка.Run("SpecialFoldersName", "MyDocuments"));
			
			ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
				"ИмяПапкиВыгрузки", "ИмяПапкиВыгрузки", Путь);
		КонецЕсли;
	КонецЕсли;
	
#КонецЕсли
	
	Возврат Путь;
	
КонецФункции

// Показывает пользователю диалог выбора файлов и возвращает
// массив - выбранные файлы для импорта.
//
Функция ПолучитьСписокИмпортируемыхФайлов() Экспорт
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла     = "";
	ДиалогОткрытияФайла.Фильтр             = НСтр("ru = 'Все файлы(*.*)|*.*'");
	ДиалогОткрытияФайла.МножественныйВыбор = Истина;
	ДиалогОткрытияФайла.Заголовок          = НСтр("ru = 'Выберите файлы'");
	
	МассивИменФайлов = Новый Массив;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
		
		Для Каждого ИмяФайла Из МассивФайлов Цикл
			МассивИменФайлов.Добавить(ИмяФайла);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат МассивИменФайлов;
	
КонецФункции

// Добавляет концевой слэш к имени каталога, если это надо,
// удаляет все запрещенные символы из имени каталога и заменяет "/" на "\".
//
Функция НормализоватьКаталог(ИмяКаталога) Экспорт
	
	Результат = СокрЛП(ИмяКаталога);
	
	// Запоминание имени диска в начале пути "Диск:" без двоеточия.
	СтрДиск = "";
	Если Сред(Результат, 2, 1) = ":" Тогда
		СтрДиск = Сред(Результат, 1, 2);
		Результат = Сред(Результат, 3);
	Иначе
		
		// Проверка, это не UNC-путь (Т.е. вначале нет "\\").
		Если Сред(Результат, 2, 2) = "\\" Тогда
			СтрДиск = Сред(Результат, 1, 2);
			Результат = Сред(Результат, 3);
		КонецЕсли;
	КонецЕсли;
	
	// Преобразование слэшей к Windows-формату.
	Результат = СтрЗаменить(Результат, "/", "\");
	
	// Добавление конечного слэша.
	Результат = СокрЛП(Результат);
	Если Прав(Результат,1) <> "\" Тогда
		Результат = Результат + "\";
	КонецЕсли;
	
	// Замена всех двойных слэшей на одинарные и получение полного пути.
	Результат = СтрДиск + СтрЗаменить(Результат, "\\", "\");
	
	Возврат Результат;
	
КонецФункции

// Проверяет имя файла на наличие некорректных символов.
//
// Параметры:
//  ИмяФайла - Строка- проверяемое имя файла.
//
//  УдалятьНекорректныеСимволы - Булево - Истина указывает удалять некорректные
//             символы из переданной строки.
//
Процедура КорректноеИмяФайла(ИмяФайла, УдалятьНекорректныеСимволы = Ложь) Экспорт
	
	// Перечень запрещенных символов взят отсюда: http://support.microsoft.com/kb/100108/ru
	// при этом были объединены запрещенные символы для файловых систем FAT и NTFS.
	
	СтрИсключения = ОбщегоНазначенияКлиентСервер.ПолучитьНедопустимыеСимволыВИмениФайла();
	
	ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'В имени файла не должно быть следующих символов: %1'"), СтрИсключения);
	
	Результат = Истина;
	
	МассивНайденныхНедопустимыхСимволов =
		ОбщегоНазначенияКлиентСервер.НайтиНедопустимыеСимволыВИмениФайла(ИмяФайла);
	
	Если МассивНайденныхНедопустимыхСимволов.Количество() <> 0 Тогда
		
		Результат = Ложь;
		
		Если УдалятьНекорректныеСимволы Тогда
			ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла, "");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Результат Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

// Рекурсивно обходит каталоги и подсчитывает количество файлов и их суммарный размер.
Процедура ОбходФайловРазмер(Путь, МассивФайлов, РазмерСуммарный, КоличествоСуммарное) Экспорт
	
	Для Каждого ВыбранныйФайл Из МассивФайлов Цикл
		
		Если ВыбранныйФайл.ЭтоКаталог() Тогда
			НовыйПуть = Строка(Путь);
			
			НовыйПуть = НовыйПуть + ОбщегоНазначенияКлиентСервер.РазделительПути();
			
			НовыйПуть = НовыйПуть + Строка(ВыбранныйФайл.Имя);
			МассивФайловВКаталоге = НайтиФайлы(НовыйПуть, "*.*");
			
			Если МассивФайловВКаталоге.Количество() <> 0 Тогда
				ОбходФайловРазмер(
					НовыйПуть, МассивФайловВКаталоге, РазмерСуммарный, КоличествоСуммарное);
			КонецЕсли;
		
			Продолжить;
		КонецЕсли;
		
		РазмерСуммарный = РазмерСуммарный + ВыбранныйФайл.Размер();
		КоличествоСуммарное = КоличествоСуммарное + 1;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает полный путь к файлу.
Функция ПолучитьПолныйПутьКФайлуВРабочемКаталоге(ДанныеФайла) Экспорт
	
	Возврат ДанныеФайла.ИмяФайлаСПутемВРабочемКаталоге;
	
КонецФункции

// Возвращает путь к каталогу вида
// "C:\Documents and Settings\ИМЯ ПОЛЬЗОВАТЕЛЯ\Application Data\1C\ФайлыА8\".
//
Функция ВыбратьПутьККаталогуДанныхПользователя() Экспорт
	
	ИмяКаталога = "";
	
#Если Не ВебКлиент Тогда
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	
	Если НЕ ПараметрыРаботыКлиента.ЭтоБазоваяВерсияКонфигурации Тогда
		
		Оболочка = Новый COMОбъект("WScript.Shell");
		Путь = Оболочка.ExpandEnvironmentStrings("%APPDATA%");
		Путь = Путь + "\1C\Файлы\";
		
		Путь = Путь
		     + ПараметрыРаботыКлиента.ИмяКонфигурации
		     + ОбщегоНазначенияКлиентСервер.РазделительПути();
		
		ИмяПользователя = ПользователиКлиентСервер.ТекущийПользователь();
		
		ИмяКаталога = Путь + ИмяПользователя;
		ИмяКаталога = СтрЗаменить(ИмяКаталога, "<", " ");
		ИмяКаталога = СтрЗаменить(ИмяКаталога, ">", " ");
		ИмяКаталога = СокрЛП(ИмяКаталога);
		
		ИмяКаталога = ИмяКаталога + ОбщегоНазначенияКлиентСервер.РазделительПути();
	КонецЕсли;
	
#Иначе // ВебКлиент
	
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	
	Если РасширениеПодключено Тогда
		
		Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.Каталог = "";
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите путь к рабочему каталогу'");
		
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			
			ИмяКаталога = ДиалогОткрытияФайла.Каталог;
			
			ИмяКаталога = ИмяКаталога + ОбщегоНазначенияКлиентСервер.РазделительПути();
		КонецЕсли;
		
	КонецЕсли;
	
#КонецЕсли
	
	Возврат ИмяКаталога;
	
КонецФункции

// Открывает Проводник Windows и выделяет указанный файл.
Функция ОткрытьПроводникСФайлом(Знач ПолноеИмяФайла) Экспорт
	
#Если НЕ ВебКлиент Тогда
	ФайлНаДиске = Новый Файл(ПолноеИмяФайла);
	
	Если ФайлНаДиске.Существует() Тогда
		
		Если Лев(ПолноеИмяФайла, 0) <> """" Тогда
			ПолноеИмяФайла = """" + ПолноеИмяФайла + """";
		КонецЕсли;
		
		ЗапуститьПриложение("explorer.exe /select, " + ПолноеИмяФайла);
		
		Возврат Истина;
		
	КонецЕсли;
#КонецЕсли
	
	Возврат Ложь;
	
КонецФункции

