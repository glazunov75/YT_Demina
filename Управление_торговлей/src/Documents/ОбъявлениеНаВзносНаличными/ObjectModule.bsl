Перем мУдалятьДвижения;

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьТаблицуПечатныхФорм()

// Формирует движения по регистрам
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//  Режим 					  - режим проведения документа
//
Процедура ДвиженияПоРегистрам(РежимПроведения, Отказ, Заголовок, СтруктураКурсыВалют)
	
	СуммаУпр  =МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СуммаДокумента, СтруктураКурсыВалют.ВалютаДокумента,
					СтруктураКурсыВалют.ВалютаУпрУчета, 
					СтруктураКурсыВалют.ВалютаДокументаКурс,
					СтруктураКурсыВалют.ВалютаУпрУчетаКурс, 
					СтруктураКурсыВалют.ВалютаДокументаКратность,
					СтруктураКурсыВалют.ВалютаУпрУчетаКратность);
	
	Если Оплачено Тогда
		
		// По регистру "Денежные средства"
		НаборДвижений = Движения.ДенежныеСредства;	
		ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();

		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.Организация                  	= Организация;
		СтрокаДвижений.БанковскийСчетКасса           	= СчетОрганизации;
		СтрокаДвижений.ВидДенежныхСредств 				= Перечисления.ВидыДенежныхСредств.Безналичные;
		СтрокаДвижений.Сумма                			= СуммаДокумента;
		СтрокаДвижений.СуммаУпр    						= СуммаУпр;
		
		
		НаборДвижений.мПериод            = КонецДня(ДатаОплаты);
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
		Движения.ДенежныеСредства.ВыполнитьПриход();
		
		// По регистру "Денежные средства к получению"
		НаборДвижений = Движения.ДенежныеСредстваКПолучению;
		ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();

		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.Организация                  	= Организация;
		СтрокаДвижений.БанковскийСчетКасса           	= СчетОрганизации;
		СтрокаДвижений.ВидДенежныхСредств 				= Перечисления.ВидыДенежныхСредств.Безналичные;
		СтрокаДвижений.Сумма                			= СуммаДокумента;
		СтрокаДвижений.СуммаУпр    						= СуммаУпр;
		
		СтрокаДвижений.СтатьяДвиженияДенежныхСредств	= СтатьяДвиженияДенежныхСредств;
		СтрокаДвижений.ДокументПолучения                = Ссылка;
		
		НаборДвижений.мПериод            = КонецДня(ДатаОплаты);
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
	
		Движения.ДенежныеСредстваКПолучению.ВыполнитьРасход();
		
		// По регистру "Движения денежных средств"
		НаборДвижений = Движения.ДвиженияДенежныхСредств;
		
		// Получим таблицу значений, совпадающую со структурой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
		
		СтрокаДДС = ТаблицаДвижений.Добавить();
		СтрокаДДС.ВидДенежныхСредств            = Перечисления.ВидыДенежныхСредств.Безналичные;
		СтрокаДДС.ПриходРасход                  = Перечисления.ВидыДвиженийПриходРасход.Приход;
		СтрокаДДС.Организация                   = Организация;
		СтрокаДДС.БанковскийСчетКасса           = СчетОрганизации;
		СтрокаДДС.ДокументДвижения              = Ссылка;
		СтрокаДДС.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
		
		СтрокаДДС.Сумма    = СуммаДокумента;
		СтрокаДДС.СуммаУпр = СуммаУпр;
				
		НаборДвижений.мПериод            = КонецДня(ДатаОплаты);
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
		
		Движения.ДвиженияДенежныхСредств.ВыполнитьДвижения();
			
	КонецЕсли;	
	
	// По регистру "Денежные средства к списанию"
	НаборДвижений = Движения.ДенежныеСредстваКСписанию;
	ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
	
	СтрокаДвижений = ТаблицаДвижений.Добавить();
	СтрокаДвижений.Организация                  	= Организация;
	СтрокаДвижений.БанковскийСчетКасса           	= Касса;
	СтрокаДвижений.ВидДенежныхСредств 				= Перечисления.ВидыДенежныхСредств.Наличные;
	СтрокаДвижений.Сумма                			= СуммаДокумента;
	СтрокаДвижений.ДокументСписания                 = Ссылка;
	СтрокаДвижений.СтатьяДвиженияДенежныхСредств	= СтатьяДвиженияДенежныхСредств;
	
	НаборДвижений.мПериод            = Дата;
	НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
	
	Движения.ДенежныеСредстваКСписанию.ВыполнитьПриход();
	
	// По регистру "Денежные средства к получению"
	НаборДвижений = Движения.ДенежныеСредстваКПолучению;
	ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
	
	СтрокаДвижений = ТаблицаДвижений.Добавить();
	СтрокаДвижений.Организация                  	= Организация;
	СтрокаДвижений.БанковскийСчетКасса           	= СчетОрганизации;
	СтрокаДвижений.ВидДенежныхСредств 				= Перечисления.ВидыДенежныхСредств.Безналичные;
	СтрокаДвижений.Сумма                			= СуммаДокумента;
	СтрокаДвижений.СуммаУпр    						= СуммаУпр;
	
	СтрокаДвижений.ДокументПолучения	            = Ссылка;
	СтрокаДвижений.СтатьяДвиженияДенежныхСредств	= СтатьяДвиженияДенежныхСредств;
	
	НаборДвижений.мПериод            = Дата;
	НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
	
	Движения.ДенежныеСредстваКПолучению.ВыполнитьПриход();
		
КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ОбработкаПроведения(Отказ, Режим)

	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);

	СтруктураОбязательныхПолейШапка=Новый Структура("Организация,СчетОрганизации,Касса,СуммаДокумента");
	
	Если Оплачено Тогда
		СтруктураОбязательныхПолейШапка.Вставить("ДатаОплаты","Не указана дата зачисления средств на р/с");
	КонецЕсли;
				
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейШапка, Отказ, Заголовок);
		
	СтруктураГруппаВалют = Новый Структура;
	СтруктураГруппаВалют.Вставить("ВалютаУпрУчета",глЗначениеПеременной("ВалютаУправленческогоУчета").Код);
	СтруктураГруппаВалют.Вставить("ВалютаДокумента",ВалютаДокумента.Код);
				
	// Движения по документу
	Если Не Отказ Тогда
		
		СтруктураКурсыВалют=УправлениеДенежнымиСредствами.ПолучитьКурсыДляГруппыВалют(СтруктураГруппаВалют,?(Оплачено,ДатаОплаты,Дата));
		ДвиженияПоРегистрам(Режим, Отказ, Заголовок,СтруктураКурсыВалют);
		
	КонецЕсли; 
		
КонецПроцедуры

Процедура ОбработкаЗаполнения(Основание)

	Если Основание = Неопределено ИЛИ НЕ Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Основание)) Тогда
		возврат;
	КонецЕсли;

	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
	СуммаДокумента=Основание.СуммаДокумента;
	
КонецПроцедуры

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	мУдалятьДвижения = НЕ ЭтоНовый();

КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);

КонецПроцедуры

