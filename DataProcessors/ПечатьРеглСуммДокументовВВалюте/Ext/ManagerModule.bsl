﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция РазложитьМассивПоТипамОбъектов(МассивОбъектов)
	СтруктураТипов 	= Новый Структура;
	
	Для Каждого Объект Из МассивОбъектов Цикл
		
		МетаданныеДокумента = Метаданные.НайтиПоТипу(ТипЗнч(Объект));
		Если МетаданныеДокумента <> Неопределено Тогда
	
			ИмяДокумента = МетаданныеДокумента.Имя;
			Если НЕ СтруктураТипов.Свойство(ИмяДокумента) Тогда
				МассивДокументов 	= Новый Массив;
				СтруктураТипов.Вставить(ИмяДокумента, МассивДокументов);
			КонецЕсли;
			СтруктураТипов[ИмяДокумента].Добавить(Объект);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтруктураТипов;
	
КонецФункции

// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ПЕЧАТНЫХ ФОРМ

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РеглСуммыДокументаВВалюте") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"РеглСуммыДокументаВВалюте",
			НСтр("ru = 'Справка-расчет ""Регл. суммы документа в валюте""'"),
			СформироватьПечатнуюФормуСправкиРеглСуммыДокументаВВалюте(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));	
	КонецЕсли;
	
КонецПроцедуры

// Функция осуществляет печать справки - расчета.
//
Функция СформироватьПечатнуюФормуСправкиРеглСуммыДокументаВВалюте(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ПолеСверху = 0;
	ТабличныйДокумент.ПолеСлева = 5;
	ТабличныйДокумент.ПолеСнизу = 0;
	ТабличныйДокумент.ПолеСправа = 5;
	ТабличныйДокумент.РазмерКолонтитулаСверху = 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу = 0;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РеглСуммыДокументаВВалюте";
	
	СисИнфо = Новый СистемнаяИнформация;
	Если ПустаяСтрока(СисИнфо.ИнформацияПрограммыПросмотра) Тогда 
		ТабличныйДокумент.ПолеСлева          = 5;
		ТабличныйДокумент.ПолеСправа         = 5;
	Иначе
		ТабличныйДокумент.ПолеСлева          = 10;
		ТабличныйДокумент.ПолеСправа         = 10;
	КонецЕсли;
	
	КоличествоДокументов = 0;
	НомераТаблиц = Новый Структура;
	ВалютаРегламентированногоУчета 	= Константы.ВалютаРегламентированногоУчета.Получить();
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьРеглСуммДокументовВВалюте.ПФ_MXL_РеглСуммыДокументаВВалюте");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ВалютаРегламентированногоУчета);

	СтруктураТипов = РазложитьМассивПоТипамОбъектов(МассивОбъектов);

	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомераТаблиц.Очистить();
		
		ИмяДокумента = СтруктураОбъектов.Ключ;
		
		Запрос.Текст = Документы[ИмяДокумента].ПодготовитьТекстЗапросаДляПечатиСправкиРасчетаРеглСуммыДокументовВВалюте(НомераТаблиц);
		
		Запрос.УстановитьПараметр("МассивОбъектов", СтруктураОбъектов.Значение);
		
		РезультатЗапроса        = Запрос.ВыполнитьПакет();
		
		ВыборкаДокументов       = РезультатЗапроса[НомераТаблиц.ТаблицаРеквизитов].Выбрать();
		
		ВыборкаСуммПоДокументам = РезультатЗапроса[НомераТаблиц.ТаблицаСумм].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		ЕстьПредоплаты = НомераТаблиц.Свойство("ТаблицаПредоплат");
		
		Если ЕстьПредоплаты Тогда
			ВыборкаПредоплат = РезультатЗапроса[НомераТаблиц.ТаблицаПредоплат].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		КонецЕсли;
		
		Пока ВыборкаДокументов.Следующий() Цикл
			
			СсылкаНаВыводимыйДокумент = ВыборкаДокументов.Ссылка;
		
			ТекстСообщения = "";
			Если НЕ ВыборкаДокументов.Проведен Тогда
				ТекстСообщения = НСтр("ru = '%1: справка-расчет формируется только по проведенным документам.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка(СсылкаНаВыводимыйДокумент));
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ТекстСообщения) Тогда
				Если ВыборкаДокументов.ВалютаДокумента = ВалютаРегламентированногоУчета Тогда
					ТекстСообщения = НСтр("ru = '%1: справка-расчет формируется только по документам в иностранной валюте.'");
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка(СсылкаНаВыводимыйДокумент));
				КонецЕсли;
			КонецЕсли;
			
			Если НЕ ВыборкаСуммПоДокументам.НайтиСледующий(СсылкаНаВыводимыйДокумент, "Ссылка") Тогда
				ТекстСообщения = НСтр("ru = '%1: нет ни одной заполненной табличной части, по которой происходит печать справки-расчета.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка(СсылкаНаВыводимыйДокумент));
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ТекстСообщения) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, СсылкаНаВыводимыйДокумент);
				Продолжить;
			КонецЕсли;
			
			КоличествоДокументов = КоличествоДокументов + 1;
			Если КоличествоДокументов > 1 Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			Если ЕстьПредоплаты Тогда
				ЕстьПредоплаты = ВыборкаПредоплат.НайтиСледующий(СсылкаНаВыводимыйДокумент, "Ссылка");
			КонецЕсли;	
			
			ЗаполнитьТабличныйДокументСправки(ТабличныйДокумент, ВыборкаДокументов, ВыборкаСуммПоДокументам, ЕстьПредоплаты, ВыборкаПредоплат, ВалютаРегламентированногоУчета, Макет);
					
		КонецЦикла;
		
	КонецЦикла;

	Возврат ТабличныйДокумент;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ЗАПОЛНЕНИЯ ТАБЛИЧНОГО ДОКУМЕНТОВ ПЕЧАТНОЙ ФОРМЫ

Процедура ЗаполнитьТабличныйДокументСправки(ТабличныйДокумент, ВыборкаДокументов, ВыборкаСуммПоДокументам, ЕстьПредоплаты, ВыборкаПредоплат, ВалютаРегламентированногоУчета, Макет)
	
	СуммаВключаетНДС = ВыборкаДокументов.СуммаВключаетНДС;
	УчитыватьНДС     = ВыборкаДокументов.УчитыватьНДС;
	НДСсверху        = УчитыватьНДС И НЕ СуммаВключаетНДС;
	
	СуммаУвеличенияВсегоНаДанныеИзШапкиВал    = ВыборкаДокументов.ВсегоВал + ?(СуммаВключаетНДС, 0, ВыборкаДокументов.НДСВал);
	СуммаУвеличенияВсегоНДСНаДанныеИзШапкиВал = ВыборкаДокументов.НДСВал;
	
	СуммаДокументаВал = ВыборкаСуммПоДокументам.ВсегоВал + СуммаУвеличенияВсегоНаДанныеИзШапкиВал + ?(СуммаВключаетНДС, 0, ВыборкаСуммПоДокументам.НДСВал);
	НДСВал            = ВыборкаСуммПоДокументам.НДСВал   + ВыборкаДокументов.НДСВал;
	
	СуммаДокументаРегл	= ВыборкаСуммПоДокументам.ВсегоРегл;
	
	СуммаПредоплатыВал  = ?(ЕстьПредоплаты, ВыборкаПредоплат.СуммаПредоплатыВал, 0);
	СуммаПредоплатыРегл = ?(ЕстьПредоплаты, ВыборкаПредоплат.СуммаПредоплатыРегл, 0);
	
	СуммаДокументаВалДляРасчета  = СуммаДокументаВал;
	СуммаДокументаРеглДляРасчета = СуммаДокументаРегл;
	
	ТипСсылки = ТипЗнч(ВыборкаДокументов.Ссылка);
	
	КурсПредоплаты = ?(СуммаПредоплатыВал <> 0, Окр(СуммаПредоплатыРегл / СуммаПредоплатыВал, 4), 0);
	
	СуммаНеоплаченоВал = СуммаДокументаВалДляРасчета - СуммаПредоплатыВал;
	
	КурсДокумента = ВыборкаДокументов.КурсВзаиморасчетов
		/ ?(ВыборкаДокументов.КратностьВзаиморасчетов <> 0, ВыборкаДокументов.КратностьВзаиморасчетов, 1);
	КурсВзаиморасчетов      = ВыборкаДокументов.КурсВзаиморасчетов;
	КратностьВзаиморасчетов = ВыборкаДокументов.КратностьВзаиморасчетов;
	
	// Определим эквивалент в валюте регл. для неоплаченной суммы
	
	Если СуммаНеоплаченоВал <> 0 Тогда
		// Документ выписан в валюте, остаток определяем в валюте регл. по курсу расчетов
		СуммаНеоплаченоРегл = ОбщегоНазначенияБККлиентСервер.ПересчитатьИзВалютыВВалюту(СуммаНеоплаченоВал,
			ВыборкаДокументов.ВалютаДокумента, ВалютаРегламентированногоУчета,
			КурсВзаиморасчетов, 1,
			КратностьВзаиморасчетов, 1);
	Иначе
		СуммаНеоплаченоРегл = 0;
	КонецЕсли;
	
	ПогрешностьОкругленияСвязаннаяСРасчетомПоРазнымКурсам = 1;
	
	Если СуммаДокументаРеглДляРасчета - (СуммаПредоплатыРегл + СуммаНеоплаченоРегл) > ПогрешностьОкругленияСвязаннаяСРасчетомПоРазнымКурсам 
		ИЛИ СуммаДокументаРеглДляРасчета - (СуммаПредоплатыРегл + СуммаНеоплаченоРегл) < ПогрешностьОкругленияСвязаннаяСРасчетомПоРазнымКурсам *(-1) Тогда
		//ТекстСообщения = НСтр("ru = '%1: обнаружено расхождение сведений о теньговой сумме документа по проводкам (%2) и по данным сумм документа (%3).'");

		//ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ВыборкаДокументов.Ссылка, 
		//	СуммаПредоплатыРегл + СуммаНеоплаченоРегл, СуммаДокументаРеглДляРасчета);
		//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ВыборкаДокументов.Ссылка);
	Иначе
		СуммаНеоплаченоРегл = СуммаДокументаРеглДляРасчета - СуммаПредоплатыРегл;
	КонецЕсли;
	
	СуммаДокументаРеглДляРасчета = СуммаПредоплатыРегл + СуммаНеоплаченоРегл;

	СуммаДокументаВал 	= СуммаДокументаВалДляРасчета;
	
	СуммаДокументаРегл  = СуммаДокументаРеглДляРасчета;
	
	РасчетныйКурсВал  = ?(СуммаДокументаВал <> 0, Окр(СуммаДокументаРегл / СуммаДокументаВал, 4), 0);
	
    // Вывод данных в табличный документ

	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	
	СтруктурнаяЕдиницаОрганизация = ОбщегоНазначенияБК.ПолучитьСтруктурнуюЕдиницу(ВыборкаДокументов.Организация, ВыборкаДокументов.СтруктурноеПодразделение);
	СведенияОбОрганизации = ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(СтруктурнаяЕдиницаОрганизация, ВыборкаДокументов.Дата);
	ОрганизацияПредставление = ОбщегоНазначенияБКВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,", , ВыборкаДокументов.Дата, "ru");
	
	ОбластьШапка.Параметры.ОрганизацияПредставление = ОрганизацияПредставление;
	
	КонтрагентПредставление = "";
	Если ТипЗнч(ВыборкаДокументов.Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
		СведенияОКонтрагенте = ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(ВыборкаДокументов.Контрагент, ВыборкаДокументов.Дата);
		КонтрагентПредставление = ОбщегоНазначенияБКВызовСервера.ОписаниеОрганизации(СведенияОКонтрагенте, "ПолноеНаименование,", , ВыборкаДокументов.Дата, "ru");
	ИначеЕсли ТипЗнч(ВыборкаДокументов.Контрагент) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		ДанныеФизЛица = ПроцедурыУправленияПерсоналомВызовСервера.ДанныеФизЛица(
			ВыборкаДокументов.Организация, ВыборкаДокументов.Контрагент, ВыборкаДокументов.Дата);
		Если ПустаяСтрока(ДанныеФизЛица.Представление) Тогда
			КонтрагентПредставление = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВыборкаДокументов.Контрагент, "Наименование");
		Иначе
			КонтрагентПредставление = ДанныеФизЛица.Представление;
		КонецЕсли;
	КонецЕсли;
	ОбластьШапка.Параметры.КонтрагентПредставление	= КонтрагентПредставление;
	ОбластьШапка.Параметры.Контрагент				= ВыборкаДокументов.Контрагент;
	
	ДокументПредставление 		= "";
	Если ЗначениеЗаполнено(ВыборкаДокументов.НомерВходящегоДокумента) Тогда
		ДокументПредставление   = "вх. № " + СокрЛП(ВыборкаДокументов.НомерВходящегоДокумента)
			+ ?(ЗначениеЗаполнено(ВыборкаДокументов.ДатаВходящегоДокумента), " от " + Формат(ВыборкаДокументов.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy"), "");
	КонецЕсли;
	
	ОбластьШапка.Параметры.Документ					= ВыборкаДокументов.Ссылка;
	ОбластьШапка.Параметры.ДокументПредставление	= Строка(ВыборкаДокументов.Ссылка) 
		+ ?(ЗначениеЗаполнено(ДокументПредставление), Символы.ПС + ДокументПредставление, "");

	ОбластьШапка.Параметры.ВалютаПредставление		= Строка(ВыборкаДокументов.ВалютаДокумента);
	
	ТабличныйДокумент.Вывести(ОбластьШапка);
	
	// Раздел "Показатели"
	
	ОбластьПоказатели = Макет.ПолучитьОбласть("Показатели");
	
	Если ТипСсылки = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
		
		ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_1 = НСтр("ru = 'Сумма документа в валюте'");
		ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_2 = НСтр("ru = 'Зачтено задолженности по документу отгрузки в валюте'");
		ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_3 = НСтр("ru = 'Зачтено задолженности по документу отгрузки, тг.'");
		ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_4 = НСтр("ru = 'Средний курс валюты по зачтенной задолженности - справочно  (1.3) / (1.2)'");
		ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_5 = НСтр("ru = 'Ранее оплачено по документу отгрузки в валюте  (1.1) - (1.2)'");
		ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_7 = НСтр("ru = 'Ранее оплачено по документу отгрузки, тг. (1.5) * (1.6)'");
		ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_8 = НСтр("ru = 'Сумма документа, тг. (1.3) + (1.7)'");
		
	Иначе
		
		ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_1 = НСтр("ru = 'Сумма документа в валюте'");
		ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_2 = НСтр("ru = 'Зачтено предоплаты в валюте'");
		ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_3 = НСтр("ru = 'Зачтено предоплаты, тг.'");
		ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_4 = НСтр("ru = 'Средний курс валюты по зачтенной предоплате - справочно  (1.3) / (1.2)'");
		ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_5 = НСтр("ru = 'Не оплачено по документу в валюте  (1.1) - (1.2)'");
		ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_7 = НСтр("ru = 'Не оплачено по документу, тг. (1.5) * (1.6)'");
		ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_8 = НСтр("ru = 'Сумма документа, тг. (1.3) + (1.7)'");
			
	КонецЕсли;
	
	ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_6 = НСтр("ru = 'Курс валюты на дату документа'");
	ОбластьПоказатели.Параметры.ЗаголовокДляСтроки1_9 = НСтр("ru = 'Расчетный курс валюты - справочно (1.8) / (1.1)'");
	
	ОбластьПоказатели.Параметры.СуммаДокументаВал		= СуммаДокументаВал;
	ОбластьПоказатели.Параметры.СуммаПредоплатыВал		= СуммаПредоплатыВал;
	ОбластьПоказатели.Параметры.СуммаПредоплатыРегл		= СуммаПредоплатыРегл;
	ОбластьПоказатели.Параметры.КурсПредоплаты			= КурсПредоплаты;
	ОбластьПоказатели.Параметры.СуммаНеоплаченоВал		= СуммаНеоплаченоВал;
	ОбластьПоказатели.Параметры.КурсДокумента			= КурсДокумента;
	ОбластьПоказатели.Параметры.СуммаНеоплаченоРегл		= СуммаНеоплаченоРегл;
	ОбластьПоказатели.Параметры.СуммаДокументаРегл		= СуммаДокументаРегл;
	ОбластьПоказатели.Параметры.РасчетныйКурсВал		= РасчетныйКурсВал;
	
	ТабличныйДокумент.Вывести(ОбластьПоказатели);
	
	// Раздел "Расшифровка предоплаты"
	
	ОбластьШапкаПредоплата = Макет.ПолучитьОбласть("ШапкаПредоплата");
	
	Если ТипСсылки = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
		ОбластьШапкаПредоплата.Параметры.ЗаголовокТаблицыЗачтеннойПредоплатыЗадолженности = НСтр("ru = '2. Расшифровка зачтенной задолженности'");
	Иначе
		ОбластьШапкаПредоплата.Параметры.ЗаголовокТаблицыЗачтеннойПредоплатыЗадолженности = НСтр("ru = '2. Расшифровка зачтенной предоплаты'");
	КонецЕсли;	
	
	ТабличныйДокумент.Вывести(ОбластьШапкаПредоплата);
	
	Если ЕстьПредоплаты Тогда
	
		ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаПредоплата");
		
		ВыборкаПредоплатПоДокументамАвансов = ВыборкаПредоплат.Выбрать();
		
		Пока ВыборкаПредоплатПоДокументамАвансов.Следующий() Цикл
			
			ЗаполнитьЗначенияСвойств(ОбластьСтрока.Параметры, ВыборкаПредоплатПоДокументамАвансов);
			
			Если ЗначениеЗаполнено(ВыборкаПредоплатПоДокументамАвансов.НомерВходящегоДокумента) Тогда
				
				ДокументПредоплатыПредставление = ВыборкаПредоплатПоДокументамАвансов.ДокументПредоплатыПредставление + " (вх. № " + ВыборкаПредоплатПоДокументамАвансов.НомерВходящегоДокумента 
				+ ?(ЗначениеЗаполнено(ВыборкаПредоплатПоДокументамАвансов.ДатаВходящегоДокумента), " от " + Формат(ВыборкаПредоплатПоДокументамАвансов.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy"), "") + ")";
				
				ОбластьСтрока.Параметры.ДокументПредоплатыПредставление = ДокументПредоплатыПредставление;
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьСтрока);
			
		КонецЦикла;
		
	КонецЕсли;	
	
   	ОбластьПодвалПредоплата = Макет.ПолучитьОбласть("ПодвалПредоплата");
	ОбластьПодвалПредоплата.Параметры.СуммаПредоплатыВал = СуммаПредоплатыВал;
	ОбластьПодвалПредоплата.Параметры.СуммаПредоплатыРегл = СуммаПредоплатыРегл;
	ТабличныйДокумент.Вывести(ОбластьПодвалПредоплата);
	
	// Раздел "Расшифровка по строкам документа"
	ОбластьШапкаРаздел3 = Макет.ПолучитьОбласть("ШапкаРаздел3");
	ТабличныйДокумент.Вывести(ОбластьШапкаРаздел3);

	ОбластьШапкаСтрокиДокумента = Макет.ПолучитьОбласть("ШапкаСтрокиДокумента");
	
	ОбластьШапкаСтрокиДокумента.Параметры.ФормулаБазаНДС 	= "(3.4) * (1.6)";
	
	ТабличныйДокумент.Вывести(ОбластьШапкаСтрокиДокумента);
	
	ВыборкаСумм = ВыборкаСуммПоДокументам.Выбрать();

	НомерПП 	= 0;
	ВсегоВал 	= 0;
	НДСВал 		= 0;
	ВсегоРегл	= 0;
	НалоговаяБазаНДСРегл = 0;
	НДСРегл		= 0;
	
	ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаДокумента");
	
	Пока ВыборкаСумм.Следующий() Цикл
		
		НомерПП 	= НомерПП + 1;
		
		ОбластьСтрока.Параметры.Заполнить(ВыборкаСумм);
		ОбластьСтрока.Параметры.НомерПП = НомерПП;
		ОбластьСтрока.Параметры.ВсегоВал       = ВыборкаСумм.ВсегоВал + СуммаУвеличенияВсегоНаДанныеИзШапкиВал + ?(СуммаВключаетНДС, 0, ВыборкаСумм.НДСВал + СуммаУвеличенияВсегоНДСНаДанныеИзШапкиВал);
		ОбластьСтрока.Параметры.НДСВал         = ВыборкаСумм.НДСВал + СуммаУвеличенияВсегоНДСНаДанныеИзШапкиВал;
		ОбластьСтрока.Параметры.СуммаБезНДСВал = (ВыборкаСумм.ВсегоВал + СуммаУвеличенияВсегоНаДанныеИзШапкиВал) - ?(СуммаВключаетНДС, (ВыборкаСумм.НДСВал + СуммаУвеличенияВсегоНДСНаДанныеИзШапкиВал), 0);
		
		СтрокаСуммаНДСРегл = УчетНДСиАкцизаКлиентСервер.РассчитатьСуммуНДС(
			ВыборкаСумм.НалоговаяБазаНДСРегл,
			УчитыватьНДС, 
			Ложь, //СуммаВключаетНДС,
			УчетНДСиАкцизаВызовСервераПовтИсп.ПолучитьСтавкуНДС(ВыборкаСумм.СтавкаНДС));
			
		ОбластьСтрока.Параметры.НДСРегл = СтрокаСуммаНДСРегл;
		ОбластьСтрока.Параметры.СуммаБезНДСРегл = ВыборкаСумм.ВсегоРегл - ?(НДСсверху, 0, СтрокаСуммаНДСРегл);
		ОбластьСтрока.Параметры.ВсегоРегл = ВыборкаСумм.ВсегоРегл + ?(НДСсверху, СтрокаСуммаНДСРегл, 0);
		
		Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ОбластьСтрока) Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			ТабличныйДокумент.Вывести(ОбластьШапкаСтрокиДокумента);
		КонецЕсли;
		ТабличныйДокумент.Вывести(ОбластьСтрока);
		
		ВсегоВал 	= ВсегоВал 	+ ВыборкаСумм.ВсегоВал + СуммаУвеличенияВсегоНаДанныеИзШапкиВал + ?(СуммаВключаетНДС, 0, ВыборкаСумм.НДСВал + СуммаУвеличенияВсегоНДСНаДанныеИзШапкиВал);
		НДСВал		= НДСВал	+ ВыборкаСумм.НДСВал + СуммаУвеличенияВсегоНДСНаДанныеИзШапкиВал;
		ВсегоРегл	= ВсегоРегл	+ (ВыборкаСумм.ВсегоРегл + ?(НДСсверху, СтрокаСуммаНДСРегл, 0));
		НДСРегл		= НДСРегл	+ СтрокаСуммаНДСРегл;
		НалоговаяБазаНДСРегл	= НалоговаяБазаНДСРегл + ВыборкаСумм.НалоговаяБазаНДСРегл;
		
	КонецЦикла;
	
	ОбластьПодвалСтрокиДокумента = Макет.ПолучитьОбласть("ПодвалСтрокиДокумента");
	ОбластьПодвалСтрокиДокумента.Параметры.СуммаБезНДСВал 	= ВсегоВал - НДСВал;
	ОбластьПодвалСтрокиДокумента.Параметры.НДСВал			= НДСВал;
	ОбластьПодвалСтрокиДокумента.Параметры.ВсегоВал			= ВсегоВал;
	ОбластьПодвалСтрокиДокумента.Параметры.ВсегоРегл			= ВсегоРегл;
	ОбластьПодвалСтрокиДокумента.Параметры.НалоговаяБазаНДСРегл = НалоговаяБазаНДСРегл;
	ОбластьПодвалСтрокиДокумента.Параметры.НДСРегл 			= НДСРегл;
	ОбластьПодвалСтрокиДокумента.Параметры.СуммаБезНДСРегл	= ВсегоРегл - НДСРегл;
	
	ТабличныйДокумент.Вывести(ОбластьПодвалСтрокиДокумента);
	
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	Руководители = ОбщегоНазначенияБКВызовСервера.ОтветственныеЛицаОрганизаций(СтруктурнаяЕдиницаОрганизация, ВыборкаДокументов.Дата);
	
	ОбластьПодвал.Параметры.ДолжностьОтветственного          = Руководители.ГлавныйБухгалтерДолжность;
	ОбластьПодвал.Параметры.РасшифровкаПодписиОтветственного = Руководители.ГлавныйБухгалтер;
	
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
КонецПроцедуры

#КонецЕсли