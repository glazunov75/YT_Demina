Процедура УдалитьЧекиККМПриЗакрытииСмены(МассивЧековККМ) Экспорт
	
	ВыполнитьПроверкуПравДоступа("ИнтерактивнаяПометкаУдаления", Метаданные.Документы.ЧекККМ);
	ПривилегированныйРежим = ПривилегированныйРежим();
	Если НЕ ПривилегированныйРежим Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	УдалитьОбъекты(МассивЧековККМ, Ложь);
	УстановитьПривилегированныйРежим(ПривилегированныйРежим);
	
КонецПроцедуры