
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДанныеСертификата = ЭлектронныеДокументыСлужебныйКлиент.ПолучитьДанныеСертификатаНаТокене();
	
	Если ДанныеСертификата = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Попытка 
		НовыйСертификат = Новый СертификатКриптографии(ДанныеСертификата.ДвоичныеДанныеСертификата);
	Исключение
		Предупреждение(НСтр("ru = 'Не удалось прочитать файл сертификата, операция прервана.'"));
		Возврат;
	КонецПопытки;
	
	СтруктураСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(НовыйСертификат);
	
	СтруктураСертификата.Вставить("ДвоичныеДанныеСертификата", ДанныеСертификата.ДвоичныеДанныеСертификата);
	
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

	СтруктураСертификата.Вставить("Идентификатор", ДанныеСертификата.ИдентификаторСертификата);
	
	ОписаниеОшибки = "";
	СсылкаНаОбъект = ЭлектронныеДокументыСлужебныйВызовСервера.ЗагрузитьСертификат(СтруктураСертификата, ОписаниеОшибки);
	Если НЕ ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		Предупреждение(ОписаниеОшибки);
		Возврат;
	КонецЕсли;

	ПараметрыФормы = Новый Структура("Ключ", СсылкаНаОбъект);
	ОткрытьФорму("Справочник.СертификатыЭЦП.Форма.ФормаЭлемента", ПараметрыФормы);
	ОповеститьОбИзменении(СсылкаНаОбъект);
	Оповестить("ОбновитьСписокСертификатов");
	
КонецПроцедуры
