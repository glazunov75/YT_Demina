Перем МнджрВрТблСоставГруппы;


Процедура ПередЗаписью(Отказ)
	
	#Если Клиент Тогда
		Если Не ЭтоНовый() Тогда	
			Запрос = Новый Запрос;
			МнджрВрТблСоставГруппы = Новый МенеджерВременныхТаблиц;
			Запрос.МенеджерВременныхТаблиц = МнджрВрТблСоставГруппы;
			Запрос.Текст = "
			|ВЫБРАТЬ
			|	ГруппыПользователейПользователиГруппы.Пользователь КАК Пользователь
			|ПОМЕСТИТЬ ВрмТаблКонтрольСоставаГруппы
			|ИЗ
			|	Справочник.ГруппыПользователей.ПользователиГруппы КАК ГруппыПользователейПользователиГруппы
			|ГДЕ
			|	ГруппыПользователейПользователиГруппы.Ссылка = &Ссылка";		
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Запрос.Выполнить();	
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	#Если Клиент Тогда
		Если МнджрВрТблСоставГруппы <> Неопределено Тогда
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = МнджрВрТблСоставГруппы;
			Запрос.Текст = "
			|ВЫБРАТЬ
			|	ВрмТаблКонтрольСоставаГруппы.Пользователь.Код КАК Код,
			|	ВрмТаблКонтрольСоставаГруппы.Пользователь КАК Пользователь
			|ИЗ
			|	ВрмТаблКонтрольСоставаГруппы
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыПользователей.ПользователиГруппы КАК ПользователиГруппы
			|		ПО (ПользователиГруппы.Ссылка = &Ссылка)
			|			И (ПользователиГруппы.Пользователь = ВрмТаблКонтрольСоставаГруппы.Пользователь)
			|ГДЕ
			|	ПользователиГруппы.Ссылка ЕСТЬ NULL 
	        |
			|ОБЪЕДИНИТЬ
	        |
			|ВЫБРАТЬ 
			|	ПользователиГруппы.Пользователь.Код,
			|	ПользователиГруппы.Пользователь
			|ИЗ
			|	Справочник.ГруппыПользователей.ПользователиГруппы КАК ПользователиГруппы
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВрмТаблКонтрольСоставаГруппы
			|		ПО ПользователиГруппы.Пользователь = ВрмТаблКонтрольСоставаГруппы.Пользователь
			|ГДЕ
			|	ПользователиГруппы.Ссылка = &Ссылка
			|	И ВрмТаблКонтрольСоставаГруппы.Пользователь ЕСТЬ NULL";
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			
			Выборка = Запрос.Выполнить().Выбрать();			
			ТаблицаПользователей = Новый ТаблицаЗначений;
			ТаблицаПользователей.Колонки.Добавить("Код", );
			ТаблицаПользователей.Колонки.Добавить("Активен", Новый ОписаниеТипов("Булево"));
			ТаблицаПользователей.Индексы.Добавить("Код");
			Пока Выборка.Следующий() Цикл
				Если Выборка.Пользователь = глЗначениеПеременной("глТекущийПользователь") Тогда
					глЗначениеПеременнойУстановить("ЗначенияНастроекПользователей", Новый Соответствие, Истина);
					глЗначениеПеременнойУстановить("ЗначенияДополнительныхПравПользователя", Новый Соответствие, Истина);
					Продолжить
				КонецЕсли;
				СтрокаПользователя = ТаблицаПользователей.Добавить();
				СтрокаПользователя.Код = СокрЛП(Выборка.Код);
			КонецЦикла;
			
			МассивСоединений = ПолучитьСоединенияИнформационнойБазы();
			НомерТекущегоСоединения = НомерСоединенияИнформационнойБазы();
			МассивАктивныхПользователей = Новый Массив;
			
			Для каждого Соединение ИЗ МассивСоединений Цикл					
				Если Соединение.ИмяПриложения <> "Designer" 
					И Соединение.НомерСоединения <> НомерТекущегоСоединения Тогда
					СтрокаПользователя = ТаблицаПользователей.Найти(Соединение.Пользователь.Имя, "Код");
					Если СтрокаПользователя <> Неопределено Тогда
						СтрокаПользователя.Активен = Истина;
					КонецЕсли;
				КонецЕсли;		
			КонецЦикла;			
			
			МассивАктивныхПользователей = ТаблицаПользователей.НайтиСтроки(Новый Структура("Активен", Истина));
			СписокПользователей = "";
			Для Каждого СтрокаПользователя ИЗ МассивАктивныхПользователей Цикл
				СписокПользователей = СписокПользователей + ?(СписокПользователей = "", "(", "; ") + СтрокаПользователя.Код;
			КонецЦикла;			
			Если НЕ ПустаяСтрока(СписокПользователей) Тогда												
				Сообщить("Для пользователей " + СписокПользователей + "), ");
				Сообщить("новые значения настроек, зависящие от вхождения в группы пользователей (значения доп. прав, дата запрета изменения данных и т.п.),");
				Сообщить("вступят в силу только после того, как они перезапустят сеанс работы с программой.");
			КонецЕсли;		
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры
