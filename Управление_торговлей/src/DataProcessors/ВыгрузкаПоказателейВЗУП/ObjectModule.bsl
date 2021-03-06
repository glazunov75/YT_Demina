////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мНаименованиеВалютыУпрУчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 

мНаименованиеВалютыУпрУчета = глЗначениеПеременной("ВалютаУправленческогоУчета").Наименование;

СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "СуммаВыручки"; //СуммаВыручки
СтрокаПоказателя.ПредставлениеПоказателя = "Сумма выручки в " + мНаименованиеВалютыУпрУчета;
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "СуммаПрибыли"; //СуммаПрибыли
СтрокаПоказателя.ПредставлениеПоказателя = "Сумма себестоимости проданной продукции в " + мНаименованиеВалютыУпрУчета;
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "СуммаРучныхСкидок"; //КоэффициентУдержанияПокупателей
СтрокаПоказателя.ПредставлениеПоказателя = "Сумма предоставленных ручных скидок в " + мНаименованиеВалютыУпрУчета;
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "ЧислоСделок"; //КоличествоСобытий
СтрокаПоказателя.ПредставлениеПоказателя = "Число сделок";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "ЧислоПервыхСделок"; //СуммаЗакрытияЗаказов
СтрокаПоказателя.ПредставлениеПоказателя = "Число первичных сделок";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "СреднееЧислоСделок"; //ВыполнениеЗаказов
СтрокаПоказателя.ПредставлениеПоказателя = "Среднее число сделок с клиентом";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "СреднееЗначениеВыручки"; //СуммаВыручкиБезНДС
СтрокаПоказателя.ПредставлениеПоказателя = "Средняя сумма выручки от сделки в " + мНаименованиеВалютыУпрУчета;
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "ПроцентКИКонтрагентов"; //ПроцентКИКонтрагентов
СтрокаПоказателя.ПредставлениеПоказателя = "Заполненность конт. данных покупателей (%)";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "ПроцентКИКонтЛицКонтр"; //КИКонтЛицКонтр
СтрокаПоказателя.ПредставлениеПоказателя = "Заполненность конт. данных контактных лиц покупателей (%)";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "ПроцентКИКонтактныхЛиц"; //КИКонтактныхЛиц
СтрокаПоказателя.ПредставлениеПоказателя = "Заполненность личных конт. данных контактных лиц (%)";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "ЧислоЗаказов"; //ПолнотаБазыДанныхКонтактнойИнформации
СтрокаПоказателя.ПредставлениеПоказателя = "Число выставленных заказов";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "ЧислоОплаченныхЗаказов"; //СтадииПокупателей
СтрокаПоказателя.ПредставлениеПоказателя = "Число оплаченных заказов";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "ЧислоНеоплаченныхЗаказов"; //КоличествоДокументовПродажи
СтрокаПоказателя.ПредставлениеПоказателя = "Число неоплаченных заказов";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "ЧислоЧастичноОплаченных";
СтрокаПоказателя.ПредставлениеПоказателя = "Число частично оплаченных заказов";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "СуммаДолга";
СтрокаПоказателя.ПредставлениеПоказателя = "Сумма дебиторской задолженности в " + мНаименованиеВалютыУпрУчета;
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "ЧислоДолжников";
СтрокаПоказателя.ПредставлениеПоказателя = "Число должников";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "СрокЗадолженности";
СтрокаПоказателя.ПредставлениеПоказателя = "Средний срок существования задолженности в днях";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "СуммаПросроченногоДолга";
СтрокаПоказателя.ПредставлениеПоказателя = "Сумма просроченной дебиторской задолженности в " + мНаименованиеВалютыУпрУчета;
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "ЧислоПросрочившихДолжников";
СтрокаПоказателя.ПредставлениеПоказателя = "Число должников, с просроченной задолженностью";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "ЧислоДнейПросрочки";
СтрокаПоказателя.ПредставлениеПоказателя = "Среднее число дней просрочки";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "ЧислоСобытий";
СтрокаПоказателя.ПредставлениеПоказателя = "Число завершенных событий";
СтрокаПоказателя = ПоказателиОтчета.Добавить();
СтрокаПоказателя.ИмяПоказателя = "ДлительностьСобытий";
СтрокаПоказателя.ПредставлениеПоказателя = "Длительность завершенных событий (мин.)";

#Если Клиент Тогда
	ПоляНастройкиОтбора = ОтборМенеджер.ПолучитьДоступныеПоля();
	ПолеНастройки = ПоляНастройкиОтбора.Добавить("Менеджер", "Менеджер", Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	ПолеНастройки.Отбор = Истина;
	ОтборМенеджер.УстановитьДоступныеПоля(ПоляНастройкиОтбора);
	ОтборМенеджер.Добавить("Менеджер");
#КонецЕсли


