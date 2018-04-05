#Если Клиент Тогда
	
Перем мВалютаРегламентированногоУчета;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура УстановитьНачальныеНастройки(ДополнительныеПараметры = Неопределено) Экспорт
	
	// Настройка общих параметров универсального отчета
	УправлениеОтчетами.ВосстановитьРеквизитыОтчета(ЭтотОбъект, ДополнительныеПараметры);
	
	УниверсальныйОтчет.мНазваниеОтчета = СокрЛП(ЭтотОбъект.Метаданные().Синоним);
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Ложь;
	УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Истина;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказыПоставщикамОстаткиИОбороты.ДоговорКонтрагента.Владелец КАК ДоговорКонтрагентаВладелец,
	|	ПРЕДСТАВЛЕНИЕ(ЗаказыПоставщикамОстаткиИОбороты.ДоговорКонтрагента.Владелец),
	|	ЗаказыПоставщикамОстаткиИОбороты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ПРЕДСТАВЛЕНИЕ(ЗаказыПоставщикамОстаткиИОбороты.ДоговорКонтрагента),
	|	ЗаказыПоставщикамОстаткиИОбороты.ЗаказПоставщику КАК ЗаказПоставщику,
	|	ПРЕДСТАВЛЕНИЕ(ЗаказыПоставщикамОстаткиИОбороты.ЗаказПоставщику) КАК ЗаказПоставщикуПредставление,
	|	ЗаказыПоставщикамОстаткиИОбороты.Номенклатура КАК Номенклатура,
	|	ПРЕДСТАВЛЕНИЕ(ЗаказыПоставщикамОстаткиИОбороты.Номенклатура),
	|	ЗаказыПоставщикамОстаткиИОбороты.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ПРЕДСТАВЛЕНИЕ(ЗаказыПоставщикамОстаткиИОбороты.ХарактеристикаНоменклатуры),
	|	ЗаказыПоставщикамОстаткиИОбороты.СтатусПартии КАК СтатусПартии,
	|	ПРЕДСТАВЛЕНИЕ(ЗаказыПоставщикамОстаткиИОбороты.СтатусПартии),
	|	ЗаказыПоставщикамОстаткиИОбороты.Цена КАК Цена,
	|	ПРЕДСТАВЛЕНИЕ(ЗаказыПоставщикамОстаткиИОбороты.Цена),
	|	ЗаказыПоставщикамОстаткиИОбороты.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ПРЕДСТАВЛЕНИЕ(ЗаказыПоставщикамОстаткиИОбороты.ЕдиницаИзмерения),
	|	ВЫБОР
	|		КОГДА СводЗаказыПоставщикамОстаткиИОбороты.КоличествоПриход = СводЗаказыПоставщикамОстаткиИОбороты.КоличествоКонечныйОстаток
	|			ТОГДА ""Не поступило""
	|		КОГДА ЕСТЬNULL(СводЗаказыПоставщикамОстаткиИОбороты.КоличествоКонечныйОстаток, 0) <= 0
	|			ТОГДА ""Поступило полностью""
	|		ИНАЧЕ ""Поступило частично""
	|	КОНЕЦ КАК СостояниеОтгрузки,
	|	ВЫБОР
	|		КОГДА РасчетыСКонтрагентами.СуммаВзаиморасчетовПриход = 0
	|				ИЛИ РасчетыСКонтрагентами.СуммаВзаиморасчетовПриход ЕСТЬ NULL 
	|			ТОГДА ""Не оплачено""
	|		КОГДА РасчетыСКонтрагентами.СуммаВзаиморасчетовПриход >= РасчетыСКонтрагентами.СуммаВзаиморасчетовРасход
	|			ТОГДА ""Оплачено полностью""
	|		ИНАЧЕ ""Оплачено частично""
	|	КОНЕЦ КАК СостояниеОплаты,
	|	РасчетыСКонтрагентами.СуммаУпрРасход КАК СуммаЗаказа,
	|	ЗаявкиНаРасходованиеСредств.СуммаУпрОстаток КАК СуммаЗапланировано,
	|	(-РасчетыСКонтрагентами.СуммаУпрКонечныйОстаток) КАК ОсталосьОплатить,
	|	ВзаиморасчетыСКонтрагентами.СуммаУпрПриход КАК Оплачено,
	|	ЗаказыПоставщикамОстаткиИОбороты.СуммаВзаиморасчетовКонечныйОстаток КАК ОсталосьЗакупитьСуммаВзаиморасчетов,
	|	ЗаказыПоставщикамОстаткиИОбороты.СуммаУпрКонечныйОстаток 			КАК ОсталосьЗакупитьСуммаУпр,
	// Количество в ед. хранения
	|	ЗаказыПоставщикамОстаткиИОбороты.КоличествоПриход КАК Запланировано,
	|	ЗаказыПоставщикамОстаткиИОбороты.КоличествоКонечныйОстаток КАК ОсталосьОтгрузить,
	|	РазмещениеЗаказовПокупателей.КоличествоОстаток КАК Заказано,

	// Количество в баз. единицах
	|	ЗаказыПоставщикамОстаткиИОбороты.КоличествоПриход * ЗаказыПоставщикамОстаткиИОбороты.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент                   КАК ЗапланированоБазовыхЕд,
	|	ЗаказыПоставщикамОстаткиИОбороты.КоличествоКонечныйОстаток * ЗаказыПоставщикамОстаткиИОбороты.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент          КАК ОсталосьОтгрузитьБазовыхЕд,
	|	РазмещениеЗаказовПокупателей.КоличествоОстаток * ЗаказыПоставщикамОстаткиИОбороты.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент                      КАК ЗаказаноБазовыхЕд,
	
	// Количество в ед. отчетов
	|	ЗаказыПоставщикамОстаткиИОбороты.КоличествоПриход
	|		* ЗаказыПоставщикамОстаткиИОбороты.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент
	|		/ ЗаказыПоставщикамОстаткиИОбороты.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК ЗапланированоЕдиницОтчетов,
	|	ЗаказыПоставщикамОстаткиИОбороты.КоличествоКонечныйОстаток
	|		* ЗаказыПоставщикамОстаткиИОбороты.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент
	|		/ ЗаказыПоставщикамОстаткиИОбороты.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК ОсталосьОтгрузитьЕдиницОтчетов,
	|	РазмещениеЗаказовПокупателей.КоличествоОстаток
	|		* РазмещениеЗаказовПокупателей.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент
	|		/ РазмещениеЗаказовПокупателей.Номенклатура.ЕдиницаДляОтчетов.Коэффициент     КАК ЗаказаноЕдиницОтчетов
	
	|	//ПОЛЯ_СВОЙСТВА
	|	//ПОЛЯ_КАТЕГОРИИ
	
	|{ВЫБРАТЬ
	|	ДоговорКонтрагентаВладелец.*,
	|	ДоговорКонтрагента.*,
	|	ЗаказПоставщику.*,
	|	Номенклатура.*,
	|	ХарактеристикаНоменклатуры.*,
	|	СтатусПартии,
	|	Цена,
	|	ЕдиницаИзмерения.*,
	|	СостояниеОтгрузки,
	|	СостояниеОплаты,
	|	СуммаЗаказа,
	|	СуммаЗапланировано,
	|	ОсталосьОплатить,
	|	Оплачено,
	|	Запланировано,
	|	ОсталосьОтгрузить,
	|	Заказано,
	|	ОсталосьЗакупитьСуммаВзаиморасчетов,
	|	ОсталосьЗакупитьСуммаУпр,
	
	|	ЗапланированоБазовыхЕд,
	|	ОсталосьОтгрузитьБазовыхЕд,
	|	ЗаказаноБазовыхЕд,
	
	|	ЗапланированоЕдиницОтчетов,
	|	ОсталосьОтгрузитьЕдиницОтчетов,
	|	ЗаказаноЕдиницОтчетов
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам.ОстаткиИОбороты(&ДатаНач, &ДатаКон, , , ЗаказПоставщику ССЫЛКА Документ.ЗаказПоставщику {ДоговорКонтрагента.Владелец.* КАК ДоговорКонтрагентаВладелец, ДоговорКонтрагента.* КАК ДоговорКонтрагента, ВЫРАЗИТЬ(ЗаказПоставщику КАК Документ.ЗаказПоставщику).* КАК ЗаказПоставщику, Номенклатура.* КАК Номенклатура, ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры}) КАК ЗаказыПоставщикамОстаткиИОбороты
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РазмещениеЗаказовПокупателей.Остатки(&ДатаКон, ЗаказПоставщику ССЫЛКА Документ.ЗаказПоставщику {ВЫРАЗИТЬ(ЗаказПоставщику КАК Документ.ЗаказПоставщику).* КАК ЗаказПоставщику, Номенклатура.* КАК Номенклатура, ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры}) КАК РазмещениеЗаказовПокупателей
	|		ПО ЗаказыПоставщикамОстаткиИОбороты.ЗаказПоставщику = РазмещениеЗаказовПокупателей.ЗаказПоставщику
	|			И ЗаказыПоставщикамОстаткиИОбороты.Номенклатура = РазмещениеЗаказовПокупателей.Номенклатура
	|			И ЗаказыПоставщикамОстаткиИОбороты.ХарактеристикаНоменклатуры = РазмещениеЗаказовПокупателей.ХарактеристикаНоменклатуры}
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКонтрагентами.ОстаткиИОбороты(&ДатаНач, &ДатаКон, , , Сделка ССЫЛКА Документ.ЗаказПоставщику {ДоговорКонтрагента.Владелец.* КАК ДоговорКонтрагентаВладелец, ДоговорКонтрагента.* КАК ДоговорКонтрагента, ВЫРАЗИТЬ(Сделка КАК Документ.ЗаказПоставщику).* КАК ЗаказПоставщику}) КАК РасчетыСКонтрагентами
	|		ПО ЗаказыПоставщикамОстаткиИОбороты.ЗаказПоставщику = РасчетыСКонтрагентами.Сделка
	|			И ЗаказыПоставщикамОстаткиИОбороты.ДоговорКонтрагента = РасчетыСКонтрагентами.ДоговорКонтрагента}
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВзаиморасчетыСКонтрагентами.Обороты(&ДатаНач, &ДатаКон, , Сделка ССЫЛКА Документ.ЗаказПоставщику {ДоговорКонтрагента.Владелец.* КАК ДоговорКонтрагентаВладелец, ДоговорКонтрагента.* КАК ДоговорКонтрагента, ВЫРАЗИТЬ(Сделка КАК Документ.ЗаказПоставщику).* КАК ЗаказПоставщику}) КАК ВзаиморасчетыСКонтрагентами
	|		ПО ЗаказыПоставщикамОстаткиИОбороты.ЗаказПоставщику = ВзаиморасчетыСКонтрагентами.Сделка
	|			И ЗаказыПоставщикамОстаткиИОбороты.ДоговорКонтрагента = ВзаиморасчетыСКонтрагентами.ДоговорКонтрагента}	
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаявкиНаРасходованиеСредств.Остатки(&ДатаКон, Сделка ССЫЛКА Документ.ЗаказПоставщику {ДоговорКонтрагента.Владелец.* КАК ДоговорКонтрагентаВладелец, ДоговорКонтрагента.* КАК ДоговорКонтрагента, ВЫРАЗИТЬ(Сделка КАК Документ.ЗаказПоставщику).* КАК ЗаказПоставщику}) КАК ЗаявкиНаРасходованиеСредств
	|		ПО ЗаказыПоставщикамОстаткиИОбороты.ЗаказПоставщику = ЗаявкиНаРасходованиеСредств.Сделка
	|			И ЗаказыПоставщикамОстаткиИОбороты.ДоговорКонтрагента = ЗаявкиНаРасходованиеСредств.ДоговорКонтрагента
	|			И ЗаявкиНаРасходованиеСредств.ЗаявкаНаРасходование.Состояние = &СостояниеПодготовлен}
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.ОстаткиИОбороты(&ДатаНач, &ДатаКон, , , ЗаказПоставщику ССЫЛКА Документ.ЗаказПоставщику {ДоговорКонтрагента.Владелец.* КАК ДоговорКонтрагентаВладелец, ДоговорКонтрагента.* КАК ДоговорКонтрагента, ВЫРАЗИТЬ(ЗаказПоставщику КАК Документ.ЗаказПоставщику).* КАК ЗаказПоставщику}) КАК СводЗаказыПоставщикамОстаткиИОбороты
	|		ПО ЗаказыПоставщикамОстаткиИОбороты.ЗаказПоставщику = СводЗаказыПоставщикамОстаткиИОбороты.ЗаказПоставщику}

	|	//СОЕДИНЕНИЯ
	|{ГДЕ
	|	ВЫРАЗИТЬ(ЗаказыПоставщикамОстаткиИОбороты.ЗаказПоставщику КАК Документ.ЗаказПоставщику).* КАК ЗаказПоставщику,
	|	ЗаказыПоставщикамОстаткиИОбороты.СтатусПартии.* КАК СтатусПартии,
	|	ЗаказыПоставщикамОстаткиИОбороты.Цена.* КАК Цена,
	|	ЗаказыПоставщикамОстаткиИОбороты.ЕдиницаИзмерения.* КАК ЕдиницаИзмерения,
	|	ВЫБОР
	|			КОГДА СводЗаказыПоставщикамОстаткиИОбороты.КоличествоПриход = СводЗаказыПоставщикамОстаткиИОбороты.КоличествоКонечныйОстаток
	|				ТОГДА ""Не поступило""
	|			КОГДА ЕСТЬNULL(СводЗаказыПоставщикамОстаткиИОбороты.КоличествоКонечныйОстаток, 0) <= 0
	|				ТОГДА ""Поступило полностью""
	|			ИНАЧЕ ""Поступило частично""
	|		КОНЕЦ КАК СостояниеОтгрузки,
	|	ВЫБОР
	|			КОГДА РасчетыСКонтрагентами.СуммаВзаиморасчетовПриход = 0
	|					ИЛИ РасчетыСКонтрагентами.СуммаВзаиморасчетовПриход ЕСТЬ NULL 
	|				ТОГДА ""Не оплачено""
	|			КОГДА РасчетыСКонтрагентами.СуммаВзаиморасчетовПриход >= РасчетыСКонтрагентами.СуммаВзаиморасчетовРасход
	|				ТОГДА ""Оплачено полностью""
	|			ИНАЧЕ ""Оплачено частично""
	|		КОНЕЦ КАК СостояниеОплаты,
	|	ЗаказыПоставщикамОстаткиИОбороты.КоличествоПриход КАК Запланировано,
	|	ЗаказыПоставщикамОстаткиИОбороты.КоличествоКонечныйОстаток КАК ОсталосьОтгрузить,
	|	РазмещениеЗаказовПокупателей.КоличествоОстаток КАК Заказано,
	|	ЗаказыПоставщикамОстаткиИОбороты.СуммаВзаиморасчетовКонечныйОстаток КАК ОсталосьЗакупитьСуммаВзаиморасчетов,
	|	ЗаказыПоставщикамОстаткиИОбороты.СуммаУпрКонечныйОстаток 			КАК ОсталосьЗакупитьСуммаУпр,
	
	// Количество в баз. единицах
	|	ЗаказыПоставщикамОстаткиИОбороты.КоличествоПриход * ЗаказыПоставщикамОстаткиИОбороты.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент                   КАК ЗапланированоБазовыхЕд,
	|	ЗаказыПоставщикамОстаткиИОбороты.КоличествоКонечныйОстаток * ЗаказыПоставщикамОстаткиИОбороты.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент          КАК ОсталосьОтгрузитьБазовыхЕд,
	|	РазмещениеЗаказовПокупателей.КоличествоОстаток * ЗаказыПоставщикамОстаткиИОбороты.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент                      КАК ЗаказаноБазовыхЕд,
	
	// Количество в ед. отчетов
	|	ЗаказыПоставщикамОстаткиИОбороты.КоличествоПриход
	|		* ЗаказыПоставщикамОстаткиИОбороты.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент
	|		/ ЗаказыПоставщикамОстаткиИОбороты.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК ЗапланированоЕдиницОтчетов,
	|	ЗаказыПоставщикамОстаткиИОбороты.КоличествоКонечныйОстаток
	|		* ЗаказыПоставщикамОстаткиИОбороты.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент
	|		/ ЗаказыПоставщикамОстаткиИОбороты.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК ОсталосьОтгрузитьЕдиницОтчетов,
	|	РазмещениеЗаказовПокупателей.КоличествоОстаток
	|		* РазмещениеЗаказовПокупателей.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент
	|		/ РазмещениеЗаказовПокупателей.Номенклатура.ЕдиницаДляОтчетов.Коэффициент     КАК ЗаказаноЕдиницОтчетов,
	
	|	РасчетыСКонтрагентами.СуммаУпрРасход КАК СуммаЗаказа,
	|	ЗаявкиНаРасходованиеСредств.СуммаУпрОстаток КАК СуммаЗапланировано,
	|	(-РасчетыСКонтрагентами.СуммаУпрКонечныйОстаток) КАК ОсталосьОплатить,
	|	ВзаиморасчетыСКонтрагентами.СуммаУпрПриход КАК Оплачено
	|	//УСЛОВИЯ_СВОЙСТВА
	|	//УСЛОВИЯ_КАТЕГОРИИ
	|}
	
	|{УПОРЯДОЧИТЬ ПО
	|	ДоговорКонтрагентаВладелец.*,
	|	ДоговорКонтрагента.*,
	|	ЗаказПоставщику.*,
	|	Номенклатура.*,
	|	ХарактеристикаНоменклатуры.*,
	|	СтатусПартии,
	|	Цена,
	|	ЕдиницаИзмерения.*,
	|	СостояниеОтгрузки,
	|	СостояниеОплаты,
	|	Запланировано,
	|	Заказано,
	|	СуммаЗаказа,
	|	СуммаЗапланировано,
	|	ОсталосьОплатить,
	|	ОсталосьОтгрузить,
	|	Оплачено,
	|	ОсталосьЗакупитьСуммаВзаиморасчетов,
	|	ОсталосьЗакупитьСуммаУпр,
	|	ЗапланированоБазовыхЕд,
	|	ОсталосьОтгрузитьБазовыхЕд,
	|	ЗаказаноБазовыхЕд,
	|	ЗапланированоЕдиницОтчетов,
	|	ОсталосьОтгрузитьЕдиницОтчетов,
	|	ЗаказаноЕдиницОтчетов
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}
	|
	|ИТОГИ
	|	Минимум(СостояниеОтгрузки),
	|	Минимум(СостояниеОплаты),
	|	ВЫБОР
	|		КОГДА Номенклатура ЕСТЬ НЕ NULL 
	|			ТОГДА 0
	|		КОГДА ЗаказПоставщику ЕСТЬ НЕ NULL 
	|			ТОГДА СУММА(СуммаЗаказа) / КОЛИЧЕСТВО(Номенклатура)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаЗаказа,
	|	ВЫБОР
	|		КОГДА Номенклатура ЕСТЬ НЕ NULL 
	|			ТОГДА 0
	|		КОГДА ЗаказПоставщику ЕСТЬ НЕ NULL 
	|			ТОГДА СУММА(СуммаЗапланировано) / КОЛИЧЕСТВО(Номенклатура)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаЗапланировано,	
	|	ВЫБОР
	|		КОГДА Номенклатура ЕСТЬ НЕ NULL 
	|			ТОГДА 0
	|		КОГДА ЗаказПоставщику ЕСТЬ НЕ NULL 
	|			ТОГДА СУММА(ОсталосьОплатить) / КОЛИЧЕСТВО(Номенклатура)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ОсталосьОплатить,
	|	ВЫБОР
	|		КОГДА Номенклатура ЕСТЬ НЕ NULL 
	|			ТОГДА 0
	|		КОГДА ЗаказПоставщику ЕСТЬ НЕ NULL 
	|			ТОГДА СУММА(Оплачено) / КОЛИЧЕСТВО(Номенклатура)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Оплачено,	
	|	СУММА(ОсталосьЗакупитьСуммаВзаиморасчетов),
	|	СУММА(ОсталосьЗакупитьСуммаУпр),
	
	|	СУММА(Запланировано),
	|	СУММА(ОсталосьОтгрузить),
	|	СУММА(Заказано),
	
	|	СУММА(ЗапланированоБазовыхЕд),
	|	СУММА(ОсталосьОтгрузитьБазовыхЕд),
	|	СУММА(ЗаказаноБазовыхЕд),
	
	|	СУММА(ЗапланированоЕдиницОтчетов),
	|	СУММА(ОсталосьОтгрузитьЕдиницОтчетов),
	|	СУММА(ЗаказаноЕдиницОтчетов)
	|	//ИТОГИ_СВОЙСТВА
	|	//ИТОГИ_КАТЕГОРИИ
	|
	|ПО
	|	ОБЩИЕ,
	|	ДоговорКонтрагентаВладелец,
	|	ДоговорКонтрагента,
	|	ЗаказПоставщику,
	|	Номенклатура,
	|	ХарактеристикаНоменклатуры,
	|	Цена,
	|	ЕдиницаИзмерения,
	|	СтатусПартии
	|{ИТОГИ ПО
	|	СостояниеОтгрузки,
	|	СостояниеОплаты,
	|	ДоговорКонтрагентаВладелец.*,
	|	ДоговорКонтрагента.*,
	|	ЗаказПоставщику.*,
	|	Номенклатура.*,
	|	ХарактеристикаНоменклатуры.*,
	|	Цена.*,
	|	ЕдиницаИзмерения.*,
	|	СтатусПартии
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}";

	
	// В универсальном отчете включен флаг использования свойств и категорий.
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Добавление свойств и категорий поля запроса в таблицу полей.
		// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
		
		// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>, <Представление>, <Назначение>);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля( "ЗаказыПоставщикамОстаткиИОбороты.ДоговорКонтрагента.Владелец", "ДоговорКонтрагентаВладелец", "Контрагент",                  ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля( "ЗаказыПоставщикамОстаткиИОбороты.ДоговорКонтрагента",          "ДоговорКонтрагента",         "Договор контрагента",         ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ДоговорыКонтрагентов);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля( "ЗаказыПоставщикамОстаткиИОбороты.Номенклатура",                "Номенклатура",               "Номенклатура",                ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля( "ЗаказыПоставщикамОстаткиИОбороты.ХарактеристикаНоменклатуры",  "ХарактеристикаНоменклатуры", "Характеристика номенклатуры", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ХарактеристикиНоменклатуры);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля( "ЗаказыПоставщикамОстаткиИОбороты.ЗаказПоставщику",             "ЗаказПоставщику",            "Заказ поставщику",            ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Документы);
		
		// Добавление свойств и категорий в исходный текст запроса.
		УниверсальныйОтчет.ДобавитьВТекстЗапросаСвойстваИКатегории(ТекстЗапроса);
		
	КонецЕсли;
		
	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	Пока УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Количество() > 0 Цикл
		
		УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Удалить(УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки[0]);
		
	КонецЦикла;
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДоговорКонтрагентаВладелец", "Контрагент");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДоговорКонтрагента", "Договор");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ЗаказПоставщику", "Заказ");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Номенклатура", "Номенклатура");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ХарактеристикаНоменклатуры", "Характеристика номенклатуры");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Цена", "Цена");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ЕдиницаИзмерения", "Единица измерения");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтатусПартии", "Статус партии");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СостояниеОтгрузки", "Состояние поступления");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СостояниеОплаты", "Состояние оплаты");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаЗаказа", "Сумма заказа");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаЗапланировано", "Сумма запланировано оплатить");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ОсталосьОплатить", "Осталось оплатить");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Оплачено", "Оплачено");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ОсталосьЗакупитьСуммаВзаиморасчетов", "Осталось закупить (сумма в валюте взаиморасчетов)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ОсталосьЗакупитьСуммаУпр", "Осталось закупить (сумма в валюте упр. учета)");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Запланировано",      "Запланировано отгрузить");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ОсталосьОтгрузить",  "Осталось закупить");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Заказано",           "Размещено в заказе");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ЗапланированоБазовыхЕд",      "Запланировано отгрузить (в базовых ед.)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ОсталосьОтгрузитьБазовыхЕд",  "Осталось закупить (в базовых ед.)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ЗаказаноБазовыхЕд",           "Размещено в заказе (в базовых ед.)");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ЗапланированоЕдиницОтчетов",      "Запланировано отгрузить (в ед. отчетов)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ОсталосьОтгрузитьЕдиницОтчетов",  "Осталось закупить (в ед. отчетов)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ЗаказаноЕдиницОтчетов",           "Размещено в заказе (в ед. отчетов)");
	
	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
	
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаЗаказа",        "Сумма заказа",   				Истина, "ЧЦ=15; ЧДЦ=2", "Оплата", "Оплата");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаЗапланировано", "Сумма запланировано оплатить",	Истина, "ЧЦ=15; ЧДЦ=2", "Оплата", "Оплата");
	УниверсальныйОтчет.ДобавитьПоказатель("ОсталосьОплатить",   "Осталось оплатить", 			Истина, "ЧЦ=15; ЧДЦ=2", "Оплата", "Оплата");
	УниверсальныйОтчет.ДобавитьПоказатель("Оплачено",   		"Оплачено",			 			Истина, "ЧЦ=15; ЧДЦ=2", "Оплата", "Оплата");
	УниверсальныйОтчет.ДобавитьПоказатель("ОсталосьЗакупитьСуммаУпр",			 "Осталось закупить "+Символы.ПС+ "(в валюте упр. учета)",	   Ложь, "ЧЦ=15; ЧДЦ=2");
	УниверсальныйОтчет.ДобавитьПоказатель("ОсталосьЗакупитьСуммаВзаиморасчетов", "Осталось закупить "+Символы.ПС+ "(в валюте взаиморасчетов)",Ложь, "ЧЦ=15; ЧДЦ=2");
	
	УниверсальныйОтчет.ДобавитьПоказатель("Запланировано",      "Запланировано",      Истина, "ЧЦ=15; ЧДЦ=3", "Отгрузка", "Закупка (в ед. хранения)");
	УниверсальныйОтчет.ДобавитьПоказатель("ОсталосьОтгрузить",  "Осталось закупить",  Истина, "ЧЦ=15; ЧДЦ=3", "Отгрузка", "Закупка (в ед. хранения)");
	УниверсальныйОтчет.ДобавитьПоказатель("Заказано",           "Размещено в заказе", Истина, "ЧЦ=15; ЧДЦ=3", "Отгрузка", "Закупка (в ед. хранения)");
	
	УниверсальныйОтчет.ДобавитьПоказатель("ЗапланированоБазовыхЕд",      "Запланировано",      Ложь, "ЧЦ=15; ЧДЦ=3", "ОтгрузкаБазовыхЕд", "Закупка (в базовых ед.)");
	УниверсальныйОтчет.ДобавитьПоказатель("ОсталосьОтгрузитьБазовыхЕд",  "Осталось закупить",  Ложь, "ЧЦ=15; ЧДЦ=3", "ОтгрузкаБазовыхЕд", "Закупка (в базовых ед.)");
	УниверсальныйОтчет.ДобавитьПоказатель("ЗаказаноБазовыхЕд",           "Размещено в заказе", Ложь, "ЧЦ=15; ЧДЦ=3", "ОтгрузкаБазовыхЕд", "Закупка (в базовых ед.)");
	
	УниверсальныйОтчет.ДобавитьПоказатель("ЗапланированоЕдиницОтчетов",      "Запланировано",       Ложь, "ЧЦ=15; ЧДЦ=3", "ОтгрузкаЕдиницОтчетов", "Закупка (в ед. отчетов)");
	УниверсальныйОтчет.ДобавитьПоказатель("ОсталосьОтгрузитьЕдиницОтчетов",  "Осталось закупить",   Ложь, "ЧЦ=15; ЧДЦ=3", "ОтгрузкаЕдиницОтчетов", "Закупка (в ед. отчетов)");
	УниверсальныйОтчет.ДобавитьПоказатель("ЗаказаноЕдиницОтчетов",           "Размещено в заказе",  Ложь, "ЧЦ=15; ЧДЦ=3", "ОтгрузкаЕдиницОтчетов", "Закупка (в ед. отчетов)");
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ДоговорКонтрагентаВладелец");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ДоговорКонтрагента");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ЗаказПоставщику");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Номенклатура");
	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	
	УниверсальныйОтчет.ДобавитьОтбор("ДоговорКонтрагентаВладелец");
	УниверсальныйОтчет.ДобавитьОтбор("ЗаказПоставщику");
	УниверсальныйОтчет.ДобавитьОтбор("Номенклатура");
	
	УниверсальныйОтчет.ПостроительОтчета.ДоступныеПоля.СостояниеОтгрузки.Отбор = Ложь;
	УниверсальныйОтчет.ПостроительОтчета.ДоступныеПоля.СостояниеОплаты.Отбор = Ложь;
	
	// Добавление предопределенных полей порядка отчета.
	// Необходимо вызывать для каждого добавляемого поля порядка.
	// УниверсальныйОтчет.ДобавитьПорядок(<ПутьКДанным>);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДаннымРодитель>);
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	
	УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения("СостояниеОтгрузки", "ЗаказПоставщику");
	УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения("СостояниеОплаты", "ЗаказПоставщику");
	
	// Установка представлений полей
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>, <Размещение>, <Положение>);
	
КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	УниверсальныйОтчет.ПостроительОтчета.ДоступныеПоля.СостояниеОтгрузки.Отбор = Истина;
	УниверсальныйОтчет.ПостроительОтчета.ДоступныеПоля.СостояниеОплаты.Отбор = Истина;
	
	ОтборСостояниеОтгрузкиПоЗаказуСписок = Новый СписокЗначений;
	
	Если НеОтгружено = Истина Тогда
		
		ОтборСостояниеОтгрузкиПоЗаказуСписок.Добавить("Не поступило");
		
	КонецЕсли;
	
	Если ОтгруженоЧастично = Истина Тогда
		
		ОтборСостояниеОтгрузкиПоЗаказуСписок.Добавить("Поступило частично");
		
	КонецЕсли;
	
	Если ОтгруженоПолностью = Истина Тогда
		
		ОтборСостояниеОтгрузкиПоЗаказуСписок.Добавить("Поступило полностью");
		
	КонецЕсли;
	
	ОтборСостояниеОплатыПоЗаказуСписок = Новый СписокЗначений;
		
	Если НеОплачено = Истина Тогда
		
		ОтборСостояниеОплатыПоЗаказуСписок.Добавить("Не оплачено");
		
	КонецЕсли;
	
	Если ОплаченоЧастично = Истина Тогда
		
		ОтборСостояниеОплатыПоЗаказуСписок.Добавить("Оплачено частично");
		
	КонецЕсли;
	
	Если ОплаченоПолностью = Истина Тогда
		
		ОтборСостояниеОплатыПоЗаказуСписок.Добавить("Оплачено полностью");
		
	КонецЕсли;
		
	УниверсальныйОтчет.ДобавитьОтбор("СостояниеОтгрузки", СостояниеОтгрузкиПоЗаказу, ВидСравнения.ВСписке, ОтборСостояниеОтгрузкиПоЗаказуСписок);
	УниверсальныйОтчет.ДобавитьОтбор("СостояниеОплаты", СостояниеОплатыПоЗаказу, ВидСравнения.ВСписке, ОтборСостояниеОплатыПоЗаказуСписок);
	
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("СостояниеПодготовлен",Перечисления.СостоянияОбъектов.Утвержден);
	
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент);
	
	УниверсальныйОтчет.ПостроительОтчета.Отбор.Удалить(УниверсальныйОтчет.ПостроительОтчета.Отбор.Индекс(УниверсальныйОтчет.ПостроительОтчета.Отбор["СостояниеОтгрузки"]));
	УниверсальныйОтчет.ПостроительОтчета.Отбор.Удалить(УниверсальныйОтчет.ПостроительОтчета.Отбор.Индекс(УниверсальныйОтчет.ПостроительОтчета.Отбор["СостояниеОплаты"]));
	
	УниверсальныйОтчет.ПостроительОтчета.ДоступныеПоля.СостояниеОтгрузки.Отбор = Ложь;
	УниверсальныйОтчет.ПостроительОтчета.ДоступныеПоля.СостояниеОплаты.Отбор = Ложь;

КонецПроцедуры // СформироватьОтчет()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно передать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	ДополнительныеПараметры = УправлениеОтчетами.СохранитьРеквизитыОтчета(ЭтотОбъект);
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект, ДополнительныеПараметры);
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру для сохранения настроек отчета
//
Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	УниверсальныйОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками);
	УправлениеОтчетами.СохранитьРеквизитыОтчета(ЭтотОбъект, СтруктураСНастройками);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки отчета из структуры сохраненных настроек
//
Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт
	
	УправлениеОтчетами.ВосстановитьРеквизитыОтчета(ЭтотОбъект, СтруктураСНастройками);
	Возврат УниверсальныйОтчет.ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, ЭтотОбъект);
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

// Содержит значение используемого режима ввода периода.
// Тип: Число.
// Возможные значения: // (-1) - не выбирать период, 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
УниверсальныйОтчет.мРежимВводаПериода = 0;

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

#КонецЕсли