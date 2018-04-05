#Если Клиент Тогда
Процедура ЗаполнитьНачальныеНастройки() Экспорт

	ОбщийОтчет.мТаблицаПоказатели.Очистить();
	
	ПостроительОтчета = ОбщийОтчет.ПостроительОтчета;
	
	СтруктураПредставлениеПолей = Новый Структура;
	МассивОтбора = Новый Массив;
	ОбщийОтчет.ИмяРегистра = "Продажи";
	УправлениеОтчетами.ЗаполнитьНачальныеНастройкиПоМакету(ПолучитьМакет("ПараметрыОтчетовПродажиКомпании"), СтруктураПредставлениеПолей, МассивОтбора, ОбщийОтчет, "Диаграмма");
	УправлениеОтчетами.ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	УправлениеОтчетами.ОчиститьДополнительныеПоляПостроителя(ПостроительОтчета);
	УправлениеОтчетами.ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	ОбщийОтчет.мВыбиратьИмяРегистра = Ложь;

КонецПРоцедуры

Процедура СформироватьОтчет(Диаграмма) Экспорт
	ОбщийОтчет.СформироватьОтчет(Диаграмма);
КонецПроцедуры

// Настраивает отчет для параметрического вызова
//
// Параметры
//  СтруктураПараметров  – Структура, Соответсвие – содержит список параметров:
//	ДатаНач,
//	ДатаКон,
//	ИмяРегистра,
Процедура Настроить(СтруктураПараметров) Экспорт
	
	ОбщийОтчет.Настроить(СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

// Читает свойство Построитель отчета
//
// Параметры
//	Нет
//
Функция ПолучитьПостроительОтчета() Экспорт

	Возврат ОбщийОтчет.ПолучитьПостроительОтчета();

КонецФункции // ПолучитьПостроительОтчета()

// Возвращает основную форму отчета
//
// Параметры
//  Нет.
//
// Возвращаемое значение:
//   основная форма отчета
//
Функция ПолучитьОсновнуюФорму() Экспорт

	ОснФорма = ПолучитьФорму();
	ОснФорма.ОбщийОтчет = ОбщийОтчет;
	ОснФорма.ЭтотОтчет = ЭтотОбъект;
	Возврат ОснФорма;

КонецФункции // ПолучитьОсновнуюФорму()
#КонецЕсли
