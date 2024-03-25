﻿////////////////////////////////////////////////////////////////////////////////
// РегламентированнаяОтчетностьПереопределяемый: <краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура добавляет в форму назначаемую команду.
//
// Параметры:
//   Форма - форма, в которую добавляется команда.
//   ГруппаФормы - группа формы, в которой будет располагаться команда.
//
Процедура ДобавитьНазначаемуюКоманду(Форма, ГруппаФормы) Экспорт

	//ИмяКоманды = "ОткрытьЭкспрессПроверкуВеденияУчета";
	//
	//Команда = Форма.Команды.Добавить(ИмяКоманды);
	//Команда.Заголовок = НСтр("ru = 'Экспресс-проверка ведения учета'");
	//Команда.Действие = "Подключаемый_ВыполнитьНазначаемуюКоманду";
	//
	//Кнопка = Форма.Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), ГруппаФормы);
	//Кнопка.ИмяКоманды = ИмяКоманды;
	//Кнопка.Вид = ВидКнопкиФормы.Гиперссылка;
	//
	//ГруппаФормы.Видимость = Истина;
	
КонецПроцедуры

// Функция возвращает заголовок формы "УправлениеОтчетностью" обработки "ОбщиеОбъектыРегламентированнойОтчетности".
// Если функция возвращает пустую строку, то используется заголовок формы, указанный по умолчанию.
//
// Пример:
//  Возврат "";
//
Функция ЗаголовокФормыУправлениеОтчетностью() Экспорт
	
	Возврат "";
	
КонецФункции

// Процедура изменят заголовки кнопок.
//
Процедура НастроитьКнопкиКалендаряБухгалтера(КнопкаСправочникОтчетов = Неопределено, КнопкаКалендарь = Неопределено) Экспорт
	
	Если КнопкаКалендарь <> Неопределено Тогда
		КнопкаКалендарь.Заголовок = НСтр("ru = 'Календарь бухгалтера'");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция возвращает идентификатор конфигурации.
// Длина идентификатора не должна превышать 8 символов.
//
// Пример:
//  Возврат "БПКОРП";
//
Функция ИДКонфигурации(СтандартнаяОбработка = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	МетаданныеИмя = Метаданные.Имя;
		
	Если МетаданныеИмя = "БухгалтерияДляКазахстана" ИЛИ МетаданныеИмя = "БухгалтерияДляКазахстанаБазовая" ИЛИ МетаданныеИмя = "БухгалтерияДляКазахстанаУчебная" Тогда
		Возврат "БК";
	ИначеЕсли МетаданныеИмя = "ЗарплатаИУправлениеПерсоналомДляКазахстана" Тогда
		Возврат "ЗУПК";
	ИначеЕсли МетаданныеИмя = "УправлениеТорговлейДляКазахстана" ИЛИ МетаданныеИмя = "УправлениеТорговлейДляКазахстанаБазовая" Тогда
		Возврат "УТК";
	ИначеЕсли МетаданныеИмя = "УправлениеТорговымПредприятиемДляКазахстана" Тогда
		Возврат "УТПК";
	ИначеЕсли МетаданныеИмя = "УправлениеПроизводственнымПредприятиемДляКазахстана" Тогда
		Возврат "УППК";
	Иначе
		Возврат МетаданныеИмя;
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьОрганизациюПоУмолчанию() Экспорт
	
	Возврат Справочники.Организации.ОрганизацияПоУмолчанию();
	
КонецФункции

Функция ПолучитьПризнакУчетаПоВсемОрганизациям() Экспорт
	
	Возврат ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(Неопределено, "УчетПоВсемОрганизациям");
	
КонецФункции

Функция ПоддержкаРаботыСоСтруктурнымиПодразделениями() Экспорт
	Возврат ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
КонецФункции

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПОЛУЧЕНИЯ СВЕДЕНИЙ ОБ ОРГАНИЗАЦИИ
//

// Функция возвращает сведения об организации.
//
// Параметры:
//  Организация       - ссылка на элемент справочника "Организации";
//  ДатаЗначения      - дата, на которую нужно получить сведения;
//  
// Возвращаемое значение:
//  Структура с ключами из списка показателей и возвращаемыми значениями.
//
//
Функция ПолучитьСведенияОНалогоплательщике(Знач Налогоплательщик, знач ДатаЗначения, знач НалоговыйКомитет = Неопределено, ВыводитьФИОПолностью = Ложь) Экспорт
	
	Если (Налогоплательщик  = Неопределено) Или (Налогоплательщик = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа("СправочникСсылка.Организации")) Тогда
		Возврат 0;
	КонецЕсли;
	
	
	// Теперь получаем данные из глобальной общей функции
	СведенияОбОрганизации = ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(Налогоплательщик, ДатаЗначения);
	

	// Добавим сведения о кодах налоговых органов	
	Если НалоговыйКомитет <> Неопределено Тогда
		НКСведения = ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(НалоговыйКомитет, ДатаЗначения);	
		СведенияОбОрганизации.Вставить("КодНалоговогоОргана", СокрЛП(Лев(НКСведения.КодОрганаГосударственныхДоходов, 4)));	
	КонецЕсли;
	
	СведенияОбОрганизации.Вставить("КБе", СокрЛП(Налогоплательщик.КБе));	
	СведенияОбОрганизации.Вставить("ОсновнойВидДеятельности", СокрЛП(Налогоплательщик.ОсновнойВидДеятельности.ПолноеНаименование));	
	СведенияОбОрганизации.Вставить("КодОКЭД", СокрЛП(Налогоплательщик.ОсновнойВидДеятельности.КодОКЭД));	
	
	ОтветственныеЛица = ОбщегоНазначенияБКВызовСервера.ОтветственныеЛицаОрганизаций(Налогоплательщик, ДатаЗначения,,, ВыводитьФИОПолностью);
	
	СведенияОбОрганизации.Вставить("Руководитель", СокрЛП(ОтветственныеЛица.Руководитель));	
	СведенияОбОрганизации.Вставить("ГлавныйБухгалтер", СокрЛП(ОтветственныеЛица.ГлавныйБухгалтер));	
	
	Возврат СведенияОбОрганизации;
	
КонецФункции // ПолучитьСведенияОНалогоплательщике

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ МЕХАНИЗМА АВТОМАТИЧЕСКОГО ЗАПОЛНЕНИЯ
//

// Функция возвращает структуру показателей.
// Ключ структуры – идентификатор показателя.
// Значение структуры – массив из двух элементов:
// 	- признак автозаполнения показателя;
//	- признак расшифровки показателя.
//
// Параметры:
// 	ИДОтчета         - идентификатор отчета;
//	ИДРедакцииОтчета - идентификатор редакции формы отчета;
//  ПараметрыОтчета  - структура параметров отчета.
//
// Пример:
//	ПоказателиОтчета = Новый Структура;
//	Если ИДОтчета = "РегламентированныйОтчетРСВ1" Тогда
//		Если ИДРедакцииОтчета = "ФормаОтчета2011Кв1" Тогда
//			РегламентированнаяОтчетность.ВставитьПоказательВСтруктуру(ПоказателиОтчета, "П000100010003", Истина, Истина);
//		КонецЕсли;
//	КонецЕсли;
//	Возврат ПоказателиОтчета;
//
Функция ПолучитьСведенияОПоказателяхОтчета(ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета = Неопределено) Экспорт
	
	ПоказателиОтчета = Новый Структура;
	
	//Если ИДОтчета = "РегламентированныйОтчетБухОтчетность" Тогда
	//	
	//	Если ИДРедакцииОтчета = "ФормаОтчета2011Кв1" Тогда
	//		
	//		ЗаполнениеБухгалтерскойОтчетностиВызовСервера.ПолучитьСведенияОПоказателяхОтчетаБухОтчетностьФормаОтчета2011Кв1(ПоказателиОтчета);
	//		
	//	ИначеЕсли ИДРедакцииОтчета = "ФормаОтчета2011Кв4" Тогда
	//		
	//		ЗаполнениеБухгалтерскойОтчетностиВызовСервера.ПолучитьСведенияОПоказателяхОтчетаБухОтчетностьФормаОтчета2011Кв4(ПоказателиОтчета, ПараметрыОтчета);
	//		
	//	КонецЕсли;
	//		
	//Иначе
	//	
	//	ЗарплатаКадры.ЗаполнитьПоказателиРегламентированногоОтчета(ПоказателиОтчета, ИДОтчета, ИДРедакцииОтчета);
	//	
	//КонецЕсли;
	
	Возврат ПоказателиОтчета;
	
КонецФункции

// Процедура заполняет переданную в виде контейнера структуру данных отчета.
//
// Пример:
//	Если ИДОтчета = "РегламентированныйОтчетРСВ1" Тогда
//		Если ИДРедакцииОтчета = "ФормаОтчета2011Кв1" Тогда	
//			Контейнер.Раздел30.П000300030103 = 100;
//			Контейнер.Раздел41.Добавить();
//		КонецЕсли;
//	КонецЕсли;
//
//Процедура ЗаполнитьОтчет(Знач ПараметрыОтчета, Параметр1 = Неопределено, Параметр2 = Неопределено, Контейнер = Неопределено) Экспорт
//Процедура ЗаполнитьОтчет(ИДОтчета, ИДРедакцииОтчета, Знач ПараметрыОтчета, Контейнер) Экспорт
Процедура ЗаполнитьОтчет(ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета, Контейнер) Экспорт
	
	//Если ИДОтчета = "РегламентированныйОтчет220Форма" Тогда
	//	
	//	Если ИДРедакцииОтчета = "Форма2202014Кв4" Тогда
			
			//Форма = ПараметрыОтчета.Форма;
			//КодФормы = ПараметрыОтчета.КодФормы;
			//Перезаполнить = ПараметрыОтчета.Перезаполнить;
			//
			//Если КодФормы = "Форма220" Тогда 		
			//	Форма.Форма220ЗаполнитьАвтоНаСервере(Перезаполнить);		 
			//ИначеЕсли КодФормы = "Форма220_01" Тогда 		
			//	Форма.Форма220_01ЗаполнитьАвтоНаСервере(Перезаполнить);
			//ИначеЕсли КодФормы = "Форма220_04" Тогда  
			//	Форма.Форма220_04ЗаполнитьАвтоНаСервере(Перезаполнить);
			//КонецЕсли;
			//
			//Форма.Модифицированность = Ложь;

	//	КонецЕсли;		
	//
	//КонецЕсли;
	
	Попытка
		Если ПараметрыОтчета.Свойство("ИмяВнешнегоОтчета") Тогда
			ОтчетОбъект = ВнешниеОтчеты.Создать(ПараметрыОтчета.ИмяВнешнегоОтчета);
		Иначе
			ОтчетОбъект = Отчеты[ИДОтчета].Создать();
		КонецЕсли;
	Исключение
		ОтчетОбъект = Неопределено;
	КонецПопытки;
	
	Если ОтчетОбъект <> Неопределено Тогда
		ОтчетОбъект.ЗаполнитьАвто(ИДРедакцииОтчета, ПараметрыОтчета);
	Иначе
		
	КонецЕсли;
	
	
	//Если ИДОтчета = "РегламентированныйОтчетБухОтчетность" Тогда
	//	
	//	Если ИДРедакцииОтчета = "ФормаОтчета2011Кв1" Тогда
	//		
	//		ЗаполнениеБухгалтерскойОтчетностиВызовСервера.ЗаполнитьОтчетБухОтчетностьФормаОтчета2011Кв1(ПараметрыОтчета, Контейнер);
	//		
	//	ИначеЕсли ИДРедакцииОтчета = "ФормаОтчета2011Кв4" Тогда
	//		
	//		ЗаполнениеБухгалтерскойОтчетностиВызовСервера.ЗаполнитьОтчетБухОтчетностьФормаОтчета2011Кв4(ПараметрыОтчета, Контейнер);
	//		
	//	КонецЕсли;		
	//
	//		
	//Иначе
	//	
	//	ЗарплатаКадры.ЗаполнитьРегламентированныйОтчет(ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета, Контейнер);
	//	
	//КонецЕсли;
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ КАЛЕНДАРЯ БУХГАЛТЕРА

Функция ПараметрыОткрытияФормыДляУплатыНалога(ДанныеРасшифровки) Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация", ДанныеРасшифровки.Организация);
	ДанныеЗаполнения.Вставить("ВидНалога", Справочники.НалогиСборыОтчисления.ПустаяСсылка());
	
	Если ДанныеРасшифровки.НазваниеОтчетаИлиНалога = "Перечисление обязательных пенсионных взносов" Тогда
		ДанныеЗаполнения.Вставить("ВидОперации", Перечисления.ВидыОперацийППИсходящее.ПеречислениеПенсионныхВзносов);
		ДанныеЗаполнения.Вставить("ВидНалога",   Справочники.НалогиСборыОтчисления.ОбязательныеПенсионныеВзносы);
	ИначеЕсли ДанныеРасшифровки.НазваниеОтчетаИлиНалога = "Перечисление обязательных профессиональных пенсионных взносов" Тогда
		ДанныеЗаполнения.Вставить("ВидОперации", Перечисления.ВидыОперацийППИсходящее.ПеречислениеПенсионныхВзносов);
		ДанныеЗаполнения.Вставить("ВидНалога",   Справочники.НалогиСборыОтчисления.ОбязательныеПрофессиональныеПенсионныеВзносы);
	ИначеЕсли ДанныеРасшифровки.НазваниеОтчетаИлиНалога = "Перечисление обязательных пенсионных взносов работодателя" Тогда
		ДанныеЗаполнения.Вставить("ВидОперации", Перечисления.ВидыОперацийППИсходящее.ПеречислениеПенсионныхВзносов);
		ДанныеЗаполнения.Вставить("ВидНалога",   Справочники.НалогиСборыОтчисления.ОбязательныеПрофессиональныеПенсионныеВзносы);
	ИначеЕсли ДанныеРасшифровки.НазваниеОтчетаИлиНалога = "Перечисление социальных отчислений" Тогда	
		ДанныеЗаполнения.Вставить("ВидОперации", Перечисления.ВидыОперацийППИсходящее.ПеречислениеСоциальныхОтчислений);
		ДанныеЗаполнения.Вставить("ВидНалога",   Справочники.НалогиСборыОтчисления.ОбязательныеСоциальныеОтчисления);
	Иначе         	    
		ДанныеЗаполнения.Вставить("ВидОперации", Перечисления.ВидыОперацийППИсходящее.ПеречислениеНалога);
		Если ДанныеРасшифровки.НазваниеОтчетаИлиНалога = "Платежи по акцизу" Тогда
			ДанныеЗаполнения.Вставить("ВидНалога", Справочники.НалогиСборыОтчисления.Акциз);
		ИначеЕсли ДанныеРасшифровки.НазваниеОтчетаИлиНалога = "Платежи по НДС" Тогда
			ДанныеЗаполнения.Вставить("ВидНалога", Справочники.НалогиСборыОтчисления.НалогНаДобавленнуюСтоимость);
		ИначеЕсли ДанныеРасшифровки.НазваниеОтчетаИлиНалога = "Платежи по ИПН" Тогда
			ДанныеЗаполнения.Вставить("ВидНалога", Справочники.НалогиСборыОтчисления.ИндивидуальныйПодоходныйНалог);
		ИначеЕсли ДанныеРасшифровки.НазваниеОтчетаИлиНалога = "Окончательный платеж по КПН согласно декларации" Тогда
			ДанныеЗаполнения.Вставить("ВидНалога", Справочники.НалогиСборыОтчисления.НалогНаПрибыль);
		ИначеЕсли ДанныеРасшифровки.НазваниеОтчетаИлиНалога = "Платежи по социальному налогу" Тогда
			ДанныеЗаполнения.Вставить("ВидНалога", Справочники.НалогиСборыОтчисления.СоциальныйНалог);
		ИначеЕсли ДанныеРасшифровки.НазваниеОтчетаИлиНалога = "Текущий платеж по налогу на транспортные средства, форма 701.01"
			ИЛИ ДанныеРасшифровки.НазваниеОтчетаИлиНалога = "Текущий платеж по налогу на транспортные средства, форма 701.00" Тогда
			ДанныеЗаполнения.Вставить("ВидНалога", Справочники.НалогиСборыОтчисления.НалогНаТранспорт);
		ИначеЕсли ДанныеРасшифровки.НазваниеОтчетаИлиНалога = "Текущий платеж по налогу на имущество" Тогда
			ДанныеЗаполнения.Вставить("ВидНалога", Справочники.НалогиСборыОтчисления.НалогНаИмущество);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения.ВидНалога) Тогда
		
		РеквизитыВидаНалога = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ДанныеЗаполнения.ВидНалога, "КодБК, КодНазначенияПлатежа, Контрагент, СчетКонтрагента, НазначениеПлатежа, СчетУчетаРасчетовСКонтрагентомБУ, СчетУчетаРасчетовСКонтрагентомНУ, Контрагент.НаименованиеПолное, Контрагент.РНН, Контрагент.ИдентификационныйКодЛичности");
			
		ДанныеЗаполнения.Вставить("КодБК",                РеквизитыВидаНалога.КодБК);
		ДанныеЗаполнения.Вставить("КодНазначенияПлатежа", РеквизитыВидаНалога.КодНазначенияПлатежа);
		ДанныеЗаполнения.Вставить("Контрагент",           РеквизитыВидаНалога.Контрагент);
		ДанныеЗаполнения.Вставить("СчетКонтрагента",      РеквизитыВидаНалога.СчетКонтрагента);
		Если ЗначениеЗаполнено(РеквизитыВидаНалога.НазначениеПлатежа) Тогда
			ДанныеЗаполнения.Вставить("НазначениеПлатежа",СокрЛП(РеквизитыВидаНалога.НазначениеПлатежа));
		КонецЕсли;	
		
		Если ДанныеЗаполнения.Контрагент <> Справочники.Контрагенты.ПустаяСсылка() Тогда
			ДатаПрекращенияВыводаРНН = Константы.ДатаПрекращенияВыводаРННВПервичныхДокументах.Получить();
			ВыводитьРНН = НЕ ЗначениеЗаполнено(ДатаПрекращенияВыводаРНН) ИЛИ ДанныеРасшифровки.Срок < ДатаПрекращенияВыводаРНН;
			
			Если ВыводитьРНН Тогда 
				ДанныеЗаполнения.Вставить("РННПолучателя", ?(ЗначениеЗаполнено(РеквизитыВидаНалога.КонтрагентРНН), РеквизитыВидаНалога.КонтрагентРНН, ""));
			Иначе 
				ДанныеЗаполнения.Вставить("РННПолучателя", ?(ЗначениеЗаполнено(РеквизитыВидаНалога.КонтрагентИдентификационныйКодЛичности), РеквизитыВидаНалога.КонтрагентИдентификационныйКодЛичности, ""));
			КонецЕсли;
			
			ДанныеЗаполнения.Вставить("ТекстПолучателя",   ?(ЗначениеЗаполнено(РеквизитыВидаНалога.КонтрагентНаименованиеПолное), РеквизитыВидаНалога.КонтрагентНаименованиеПолное, ""));
		КонецЕсли;
		
		Если ДанныеЗаполнения.ВидОперации = Перечисления.ВидыОперацийППИсходящее.ПеречислениеНалога Тогда
			Если ЗначениеЗаполнено(РеквизитыВидаНалога.СчетУчетаРасчетовСКонтрагентомБУ) Тогда
				Если ИДКонфигурации() = "УППК" Тогда
					ДанныеЗаполнения.Вставить("СчетУчетаРасчетовСКонтрагентом", РеквизитыВидаНалога.СчетУчетаРасчетовСКонтрагентомБУ);
					Для Ном = 1 По РеквизитыВидаНалога.СчетУчетаРасчетовСКонтрагентомБУ.ВидыСубконто.Количество() Цикл
						ТекущийВидСубконто = РеквизитыВидаНалога.СчетУчетаРасчетовСКонтрагентом.ВидыСубконто[Ном-1].ВидСубконто;
						Если ТекущийВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоТиповые.НалогиСборыОтчисления Тогда
							ДанныеЗаполнения.Вставить("СубконтоДтБУ" + Ном, ДанныеЗаполнения.ВидНалога);
						КонецЕсли;
					КонецЦикла;	
				Иначе
					ДанныеЗаполнения.Вставить("СчетУчетаРасчетовСКонтрагентомБУ", РеквизитыВидаНалога.СчетУчетаРасчетовСКонтрагентомБУ);
					Для Ном = 1 По РеквизитыВидаНалога.СчетУчетаРасчетовСКонтрагентомБУ.ВидыСубконто.Количество() Цикл
						ТекущийВидСубконто = РеквизитыВидаНалога.СчетУчетаРасчетовСКонтрагентомБУ.ВидыСубконто[Ном-1].ВидСубконто;
						Если ТекущийВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоТиповые.НалогиСборыОтчисления Тогда
							ДанныеЗаполнения.Вставить("СубконтоДтБУ" + Ном, ДанныеЗаполнения.ВидНалога);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(РеквизитыВидаНалога.СчетУчетаРасчетовСКонтрагентомНУ) Тогда
				Если ИДКонфигурации() = "УППК" Тогда
					ДанныеЗаполнения.Вставить("СчетУчетаРасчетовСКонтрагентомНУ", РеквизитыВидаНалога.СчетУчетаРасчетовСКонтрагентомНУ);
					Для Ном = 1 По РеквизитыВидаНалога.СчетУчетаРасчетовСКонтрагентомНУ.ВидыСубконто.Количество() Цикл
						ТекущийВидСубконто = РеквизитыВидаНалога.СчетУчетаРасчетовСКонтрагентомНУ.ВидыСубконто[Ном-1].ВидСубконто;
						Если ТекущийВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоТиповые.НалогиСборыОтчисления Тогда
							ДанныеЗаполнения.Вставить("СубконтоДтНУ" + Ном, ДанныеЗаполнения.ВидНалога);
						КонецЕсли;
					КонецЦикла;	
				Иначе
					ДанныеЗаполнения.Вставить("СчетУчетаРасчетовСКонтрагентомНУ", РеквизитыВидаНалога.СчетУчетаРасчетовСКонтрагентомНУ);
					Для Ном = 1 По РеквизитыВидаНалога.СчетУчетаРасчетовСКонтрагентомНУ.ВидыСубконто.Количество() Цикл
						ТекущийВидСубконто = РеквизитыВидаНалога.СчетУчетаРасчетовСКонтрагентомНУ.ВидыСубконто[Ном-1].ВидСубконто;
						Если ТекущийВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоТиповые.НалогиСборыОтчисления Тогда
							ДанныеЗаполнения.Вставить("СубконтоДтНУ" + Ном, ДанныеЗаполнения.ВидНалога);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание", ДанныеЗаполнения);
	
	Возврат ПараметрыФормы;
	
КонецФункции

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ СТАТИСТИКИ
//

Процедура ЗаполнитьОтчетВФоне(ПараметрыОтчета, АдресХранилища) Экспорт
	
	ЗаполнитьОтчет(ПараметрыОтчета.ИДОтчета, ПараметрыОтчета.ИДРедакцииОтчета, ПараметрыОтчета.ПараметрыОтчета, ПараметрыОтчета.Контейнер);
	//ПоместитьВоВременноеХранилище(ПараметрыОтчета.Контейнер, АдресХранилища);
	ПоместитьВоВременноеХранилище(ПараметрыОтчета.ПараметрыОтчета, АдресХранилища);
	
КонецПроцедуры

// Функция возвращает краткое название конфигурации.
// Длина возвращаемого значения не должна превышать 30 символов.
//
// Пример:
//  Возврат "1С:Бухгалтерия";
//
Функция КраткоеНазваниеПрограммы() Экспорт
		
	МетаданныеИмя = Метаданные.Имя;
	
	Если МетаданныеИмя = "БухгалтерияДляКазахстана" 
		ИЛИ МетаданныеИмя = "БухгалтерияДляКазахстанаБазовая" 
		ИЛИ МетаданныеИмя = "БухгалтерияДляКазахстанаУчебная" Тогда
		Возврат "1С:Бухгалтерия для Казахстана";
	
	Иначе
		Возврат МетаданныеИмя;
	КонецЕсли;
	
КонецФункции

// Функция возвращает признак - является ли организация физ. или юр. лицом.
//
// Параметры:
//  Организация - ссылка на элемент справочника "Организации".
//
// Возвращаемое значение:
//  Истина - организация является юр. лицом;
//  Ложь   - организация является физ. лицом.
//
Функция ЭтоЮридическоеЛицо(Организация) Экспорт
	
	Если Организация.ИностраннаяОрганизация Тогда
		Возврат Истина;
	Иначе
		Возврат (Организация.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо);
	КонецЕсли;
	
КонецФункции

// Функция возвращает признак - является ли организация иностранной.
//
// Параметры:
//  Организация - ссылка на элемент справочника "Организации".
//
// Возвращаемое значение:
//  Истина - организация является иностранной;
//  Ложь   - организация не является иностранной.
//
Функция ЭтоИностраннаяОрганизация(Организация) Экспорт
	
	Если Организация.Метаданные().Реквизиты.Найти("ИностраннаяОрганизация") <> Неопределено Тогда
		Возврат Организация.ИностраннаяОрганизация;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Функция возвращает имя справочника обособленных подразделений,
// используемого для автоматического заполнения статистической отчетности.
//
// Пример:
//  Возврат "ПодразделенияОрганизаций";
//
Функция ИмяСправочникаОбособленныхПодразделений() Экспорт
	
	Возврат "ПодразделенияОрганизаций";
	
КонецФункции

Функция ПолучитьГражданство(ФизЛицо, ДатаЗначения) 
	
	Гражд = РегистрыСведений.ГражданствоФизЛиц.СрезПоследних(ДатаЗначения, Новый Структура("ФизЛицо", ФизЛицо));

	Если Гражд.Количество() > 0 Тогда
		Возврат Гражд[0].Страна;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФИНАНСОВЫХ ОТЧЕТОВ
//
// Функция формирует массив счетов 6000 и 7000 разделов
//
Функция СформироватьСписокСчетовДоходовРасходов(ВключатьДоходы = Истина, ВключатьРасходы = Истина) экспорт
	
	МассивСчетовДоходовРасходов = Новый Массив;
	Если ВключатьДоходы Тогда
		// Счета доходов
		МассивСчетовДоходовРасходов.Добавить(ПланыСчетов.Типовой.ДоходОтРеализацииПродукцииИОказанияУслуг_);
		МассивСчетовДоходовРасходов.Добавить(ПланыСчетов.Типовой.ДоходыОтФинансирования);
		МассивСчетовДоходовРасходов.Добавить(ПланыСчетов.Типовой.ПрочиеДоходы_);
		МассивСчетовДоходовРасходов.Добавить(ПланыСчетов.Типовой.ДоходыСвязанныеСПрекращаемойДеятельностью_);
		МассивСчетовДоходовРасходов.Добавить(ПланыСчетов.Типовой.ДоляПрибылиОрганизацийУчитываемыхПоМетодуДолевогоУчастия);
	КонецЕсли;
	Если ВключатьРасходы Тогда
		// Счета расходов
		МассивСчетовДоходовРасходов.Добавить(ПланыСчетов.Типовой.СебестоимостьРеализованнойПродукцииИОказанныхУслуг_);
		МассивСчетовДоходовРасходов.Добавить(ПланыСчетов.Типовой.РасходыПоРеализацииПродукцииИОказаниюУслуг_);
		МассивСчетовДоходовРасходов.Добавить(ПланыСчетов.Типовой.АдминистративныеРасходы_);
		МассивСчетовДоходовРасходов.Добавить(ПланыСчетов.Типовой.РасходыНаФинансирование);
		МассивСчетовДоходовРасходов.Добавить(ПланыСчетов.Типовой.ПрочиеРасходы_);
		МассивСчетовДоходовРасходов.Добавить(ПланыСчетов.Типовой.РасходыСвязанныеСПрекращаемойДеятельностью_);
		МассивСчетовДоходовРасходов.Добавить(ПланыСчетов.Типовой.ДоляВУбыткеОрганизацийУчитываемыхМетодомДолевогоУчастия);
		МассивСчетовДоходовРасходов.Добавить(ПланыСчетов.Типовой.РасходыПоКорпоративномуПодоходномуНалогу_);	
	КонецЕсли;
	Возврат МассивСчетовДоходовРасходов;
КонецФункции // СформироватьСписокСчетовДоходовРасходов


// Предназначена для получения имени элемента перечисления по значению.
//
// Параметры:
//	Элемент перечисления.
//
// Возвращаемое значение:
//	Строка - имя элемента перечисления в метаданных.
//
Функция ПолучитьИмяЭлементаПеречисленияПоЗначению(ЗначениеПеречисления) Экспорт
	
	ИмяЭлемента = Строка(ЗначениеПеречисления);
	Для каждого ЭлементПеречисления Из Метаданные.Перечисления[ЗначениеПеречисления.Метаданные().Имя].ЗначенияПеречисления Цикл
		Если ЭлементПеречисления.Синоним = Строка(ЗначениеПеречисления) Тогда
			ИмяЭлемента = ЭлементПеречисления.Имя;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	
	Возврат ИмяЭлемента;
	
КонецФункции // ПолучитьПериодичностьДляЗапросаПоЗначениюПеречисления()
