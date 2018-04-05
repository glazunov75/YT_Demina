////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ПередЗаписью"
//
// Параметры
//  Отказ     – <Булево>
//            – признак отказа от записи набора регистра сведений. Если в теле
//              процедуры-обработчика установить данному параметру значение 
//              Истина, запись выполнена не будет.
//
//  Замещение – <Булево>
//            – режим записи набора; Истина - запись осуществляется с заменой
//              существующих в базе данных записей набора.Ложь - запись
//              осуществляется с "дописыванием" текущего набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)

	Перем Ошибки;
	Перем Ошибка;
	Перем ЗаписьРегистра;
	Перем Регистр;

	Если Не ОбменДанными.Загрузка Тогда
		Ошибки  = "";

		Для Каждого ЗаписьРегистра Из ЭтотОбъект Цикл
			Ошибка = КорректнаяЗапись(ЗаписьРегистра.Номенклатура,
			                          ЗаписьРегистра.Код,
			                          ЗаписьРегистра.Качество,
			                          ЗаписьРегистра.СерияНоменклатуры,
			                          ЗаписьРегистра.ХарактеристикаНоменклатуры);
			Если Не ПустаяСтрока(Ошибка) Тогда
				Если Не ПустаяСтрока(Ошибки) Тогда
					Ошибки = Ошибки + "
					                  |";
				КонецЕсли;
				Ошибки = Ошибки + "Запись с кодом "
				                + Формат(ЗаписьРегистра.Код, "ЧЦ=5; ЧДЦ=0; ЧН=0")
				                + ":
				                  |"
				                + Ошибка;
			КонецЕсли;
		КонецЦикла;

		Если Не ПустаяСтрока(Ошибки) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("При попытке записи обнаружены следующие ошибки:
			                 |" + Ошибки);
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ПередЗаписью()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Функция осуществляет проверку корректности записи регистра сведений
//
// Параметры
//  Номенклатура    – <СправочникСсылка.Номенклатура>
//                  – значение ресурса "Номенклатура"
//
//  Код             – <Число>
//                  – значение измерения "Код"
//
//  Качество        – <СправочникСсылка.Качество>
//                  – значение ресурса "Качество"
//
//  Серия           – <СправочникСсылка.СерииНоменклатуры>
//                  – значение ресурса "СерияНоменклатуры"
//
//  Характеристика  – <СправочникСсылка.ХарактеристикиНоменклатуры>
//                  – значение ресурса "ХарактеристикаНоменклатуры"
//
// Возвращаемое значение:
//  <Строка>        – описание ошибок или пустая строка в случае успеха
//
Функция КорректнаяЗапись(Номенклатура, Код, Качество, Серия, Характеристика)

	Перем Ошибки;
	Перем Запрос;

	Если НЕ ЗначениеЗаполнено(Код) Тогда
		Ошибки = " - Значение кода не может быть нулевым.";
	Иначе
		Ошибки = "";
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		Ошибки = " - Не задана номенклатура.";
	Иначе
		Ошибки = "";
	КонецЕсли;

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	1
	|ИЗ
	|	РегистрСведений.КодыВесовогоТовара КАК КодыВесовогоТовара
	|ГДЕ
	|	КодыВесовогоТовара.Номенклатура                 = &Номенклатура
	|	И КодыВесовогоТовара.ХарактеристикаНоменклатуры = &Характеристика
	|	И КодыВесовогоТовара.Качество                   = &Качество
	|	И КодыВесовогоТовара.СерияНоменклатуры          = &Серия");

	Запрос.УстановитьПараметр("Номенклатура",   Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	Запрос.УстановитьПараметр("Качество",       Качество);
	Запрос.УстановитьПараметр("Серия",          Серия);

	Если Не Запрос.Выполнить().Пустой() Тогда
		Если Не ПустаяСтрока(Ошибки) Тогда
			Ошибки = Ошибки + "
			                  |";
		КонецЕсли;
		Ошибки = Ошибки + " - Код весового товара с таким набором параметров уже задан.";
	КонецЕсли;

	Возврат Ошибки;

КонецФункции // КорректнаяЗапись()
