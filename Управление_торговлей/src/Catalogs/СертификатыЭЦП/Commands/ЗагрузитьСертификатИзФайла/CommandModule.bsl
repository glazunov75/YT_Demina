
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ЭлектронныеДокументыСлужебныйВызовСервера.ВыполнятьКриптооперацииНаСервере() Тогда
		Если Не ЭлектронныеДокументыСлужебныйВызовСервера.ЕстьКриптосредстваНаСервере() Тогда
			Возврат;
		КонецЕсли;
	Иначе
		Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
			Если НЕ ЭлектронныеДокументыСлужебныйКлиент.УстановитьРасширениеРаботыСКриптографиейНаКлиенте() Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
		Попытка
			МенеджерКриптографии = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМенеджерКриптографии();
		Исключение
			ТекстСообщения = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьСообщениеОбОшибке("100");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	АдресВХранилище = Неопределено;
	Если НЕ ПоместитьФайл(АдресВХранилище, , , Истина, ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор) Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка средств криптографии на компьютере.
		
	СтруктураСертификата = ПодготовитьФайлСертификатаНаСервере(АдресВХранилище);
	Если СтруктураСертификата = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Организация = Неопределено;
	
	ЭлектронныеДокументыСлужебныйВызовСервера.ОпределитьОрганизацию(Организация);
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация = ОткрытьФормуМодально("Справочник.СертификатыЭЦП.Форма.ВыборОрганизации");
	КонецЕсли;
	
	Если ТипЗнч(Организация) = Тип("СправочникСсылка.Организации") И ЗначениеЗаполнено(Организация) Тогда
		СтруктураСертификата.Вставить("Организация", Организация);
	Иначе
		Возврат;
	КонецЕсли;

	ТекстСообщения = "";
	СсылкаНаОбъект = ЭлектронныеДокументыСлужебныйВызовСервера.ЗагрузитьСертификат(СтруктураСертификата, ТекстСообщения);
	Если НЕ ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Ключ", СсылкаНаОбъект);
	ОткрытьФорму("Справочник.СертификатыЭЦП.Форма.ФормаЭлемента", ПараметрыФормы);
	ОповеститьОбИзменении(СсылкаНаОбъект);
	Оповестить("ОбновитьСписокСертификатов");
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьФайлСертификатаНаСервере(Знач АдресВХранилище)
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеФайлаСертификата = ПолучитьИзВременногоХранилища(АдресВХранилище);
	
	Попытка
		НовыйСертификат = Новый СертификатКриптографии(ДанныеФайлаСертификата);
	Исключение
		ТекстСообщения = НСтр("ru = 'Файл сертификата должен быть в формате DER X.509, операция прервана.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Неопределено;
	КонецПопытки;
	
	СтруктураСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(НовыйСертификат);
	СтруктураСертификата.Вставить("ДвоичныеДанныеСертификата", ДанныеФайлаСертификата);
	
	Возврат СтруктураСертификата;
	
КонецФункции



