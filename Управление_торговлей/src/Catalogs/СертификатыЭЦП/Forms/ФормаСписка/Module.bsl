
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользуетсяОбменСоСбербанком = Ложь;
	ЭлектронныеДокументыПереопределяемый.ПроверитьИспользованиеПодсистемыСбербанк(ИспользуетсяОбменСоСбербанком);
	
	Если Не ИспользуетсяОбменСоСбербанком ИЛИ НЕ Константы.ИспользоватьОбменЭДСБанками.Получить() Тогда
		Элементы.ЗагрузитьСертификатСТокена.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры
