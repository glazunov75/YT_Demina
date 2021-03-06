////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обработчик обновления БЭД 1.0.5.0
// Заполнение версии регламента в соглашениях.
//
Процедура ОбновитьВерсиюРегламентаЭДО() Экспорт
	
	НаборЗаписей = РегистрыСведений.УчастникиОбменовЭДЧерезОператоровЭДО.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	
	Для каждого Запись Из НаборЗаписей Цикл
		Если НЕ ЗначениеЗаполнено(Запись.ВерсияРегламентаЭДО) Тогда
			Запись.ВерсияРегламентаЭДО = Перечисления.ВерсииРегламентаОбмена1С.Версия10;
		КонецЕсли;
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры