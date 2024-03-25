﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура СформироватьОтчет(Знач ПараметрыОтчета, АдресХранилища) Экспорт
	
	Результат = Новый ТабличныйДокумент;
	СформироватьЖурналПриходныхИРасходныхКассовыхДокументов(Результат, ПараметрыОтчета);
	ПоместитьВоВременноеХранилище(Новый Структура("Результат", Результат), АдресХранилища);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура СформироватьЖурналПриходныхИРасходныхКассовыхДокументов(ТабличныйДокумент, ПараметрыОтчета)
	
	Перем ДатаЛиста;
	
	ТабличныйДокумент.ОриентацияСтраницы  = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ТабличныйДокумент.Очистить();
	
	ТипДата  = ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата);
	ТипЧисло = ОбщегоНазначения.ОписаниеТипаЧисло(15,2);
	
	Макет = ПолучитьМакет("ПриходныеИРасходныеКассовыеДокументы");
	
	/////////////////////////////////////////////////////////
	// Вывод шапки	
	Секция =  Макет.ПолучитьОбласть("Шапка|ОбластьОтчета");
	Секция.Параметры.НачалоПериода = Формат(ПараметрыОтчета.НачалоПериода, "ДФ=dd.MM.yyyy");
	Секция.Параметры.КонецПериода  = Формат(ПараметрыОтчета.КонецПериода, "ДФ=dd.MM.yyyy");
	Секция.Параметры.НазваниеОрганизации = ПараметрыОтчета.ПредставлениеСпискаОрганизаций;
	Если ПараметрыОтчета.СписокСтруктурныхЕдиниц.Количество()=1 Тогда
		Секция.Параметры.БИН = ОбщегоНазначенияБКВызовСервера.ОписаниеОрганизации(ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(ПараметрыОтчета.СписокСтруктурныхЕдиниц[0].Значение, ПараметрыОтчета.КонецПериода), "ИдентификационныйНомер,",Ложь,ПараметрыОтчета.КонецПериода);
	КонецЕсли;
	ТабличныйДокумент.Вывести(Секция);
	
	//выводим шапку таблицы	
	СекцияШапкаТаблицы =  Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьОтчета");	
	
	// именуем область для возможности повтора шапки таблицы при печати
	СекцияШапкаТаблицы.Область("R1:R4").Имя = "ШапкаТаблицы";
	ТабличныйДокумент.Вывести(СекцияШапкаТаблицы);
	
	
	//////////////////////////////////////////////////////////////////////////////////////////
	ОбластьСтрокаОтчетПКО 			= Макет.ПолучитьОбласть("Строка|ОбластьОтчетаПКО");
	ОбластьСтрокаОтчетРКО			= Макет.ПолучитьОбласть("Строка|ОбластьОтчетаРКО");
	ОбластьПустаяСтрокаОтчетПКО		= Макет.ПолучитьОбласть("ПустаяСтрока|ОбластьОтчетаПКО");
	ОбластьПустаяСтрокаОтчетРКО		= Макет.ПолучитьОбласть("ПустаяСтрока|ОбластьОтчетаРКО");
	ОбластьСтрокаИтог			    = Макет.ПолучитьОбласть("Итог");
	ОбластьРазделительГруппировка	= Макет.ПолучитьОбласть("РазделительГруппировка");
	ИтогПКО                         = Макет.ПолучитьОбласть("Итог|ОбластьОтчетаПКО");
	ИтогРКО                         = Макет.ПолучитьОбласть("Итог|ОбластьОтчетаРКО");
	
	////////////////////////////////////////////////////////////////////////////////////////////////
	
	ЗначенияИтогов   = Новый Структура("ИтогоСуммаПКО, ИтогоСуммаРКО", 0, 0);

	РезультатПКО     = ПодготовитьДанныеПоКассовымПриходнымДокументам(ПараметрыОтчета);
	ВыборкаПоДнямПКО = РезультатПКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"День");
	РезультатРКО     = ПодготовитьДанныеПоКассовымРасходнымДокументам(ПараметрыОтчета);	
	ВыборкаПоДнямРКО = РезультатРКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"День");

	КоличествоДней   = Макс(ВыборкаПоДнямПКО.Количество(),ВыборкаПоДнямРКО.Количество());
	
	//Отчет формируем только в случае, если в указанном периоде есть документы
	Если КоличествоДней > 0 Тогда

		Если ПараметрыОтчета.ГруппироватьПоДням Тогда
			//Формирование отчета с группировкой по датам
			ПериодВыборки = Новый ТаблицаЗначений;
			ПериодВыборки.Колонки.Добавить("День", ТипДата);
			Для СчетчикЦикла = 1 По  КоличествоДней Цикл
				Если ВыборкаПоДнямПКО.Следующий() Тогда
					НовыйПериодВыборки = ПериодВыборки.Добавить();
					ЗаполнитьЗначенияСвойств(НовыйПериодВыборки, ВыборкаПоДнямПКО);
				КонецЕсли;
				Если ВыборкаПоДнямРКО.Следующий() Тогда
					НовыйПериодВыборки = ПериодВыборки.Добавить();
					ЗаполнитьЗначенияСвойств(НовыйПериодВыборки, ВыборкаПоДнямРКО);
				КонецЕсли;
			КонецЦикла;
			ПериодВыборки.Свернуть("День");
			ПериодВыборки.Сортировать("День");
			
			ВыборкаПоДнямПКО = РезультатПКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "День");
			ВыборкаПоДнямРКО = РезультатРКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "День");
			
			Для Каждого СтрокаПериодВыборки Из ПериодВыборки Цикл
				ОбластьРазделительГруппировка.Параметры.ДатаЗаписи = СтрокаПериодВыборки.День;
				ТабличныйДокумент.Вывести(ОбластьРазделительГруппировка);
				ТабличныйДокумент.НачатьГруппуСтрок(Формат(СтрокаПериодВыборки.День, "ДЛФ=Д"), Истина);
				
				ВыборкаПКОНеПустая = ВыборкаПоДнямПКО.НайтиСледующий(СтрокаПериодВыборки.День, "День");
				ВыборкаРКОНеПустая = ВыборкаПоДнямРКО.НайтиСледующий(СтрокаПериодВыборки.День, "День");
				ВыборкаПоДокументамПКО 	= ВыборкаПоДнямПКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Документ");
				ВыборкаПоДокументамРКО 	=ВыборкаПоДнямРКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Документ");
				
				КоличествоДокументов	=  Макс(?(ВыборкаПКОНеПустая, ВыборкаПоДокументамПКО.Количество(), 0),?(ВыборкаРКОНеПустая, ВыборкаПоДокументамРКО.Количество(), 0));
				Для СчетчикЦикла = 1 По КоличествоДокументов Цикл
					Если ВыборкаПоДокументамПКО.Следующий() И ВыборкаПКОНеПустая Тогда
						НомерДокПечатнойФормы = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаПоДокументамПКО.Номер, ВыборкаПоДокументамРКО.Документ);
						ОбластьСтрокаОтчетПКО.Параметры.Номер = НомерДокПечатнойФормы;
						ОбластьСтрокаОтчетПКО.Параметры.Заполнить(ВыборкаПоДокументамПКО);
						ТабличныйДокумент.Вывести(ОбластьСтрокаОтчетПКО);
						ЗначенияИтогов.ИтогоСуммаПКО = ЗначенияИтогов.ИтогоСуммаПКО + ВыборкаПоДокументамПКО.Сумма;
						
					Иначе
						ТабличныйДокумент.Вывести(ОбластьПустаяСтрокаОтчетПКО);
					КонецЕсли;
					Если ВыборкаПоДокументамРКО.Следующий() И ВыборкаРКОНеПустая Тогда
						НомерДокПечатнойФормы = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаПоДокументамРКО.Номер, ВыборкаПоДокументамРКО.Документ);
						ОбластьСтрокаОтчетРКО.Параметры.Номер = НомерДокПечатнойФормы;
						
						ЗаполнитьЗначенияСвойств(ОбластьСтрокаОтчетРКО.Параметры,ВыборкаПоДокументамРКО);
						ТабличныйДокумент.Присоединить(ОбластьСтрокаОтчетРКО);
						ЗначенияИтогов.ИтогоСуммаРКО = ЗначенияИтогов.ИтогоСуммаРКО + ВыборкаПоДокументамРКО.Сумма;
						
					Иначе
						ТабличныйДокумент.Присоединить(ОбластьПустаяСтрокаОтчетРКО);
					КонецЕсли;
				КонецЦикла;
				ТабличныйДокумент.ЗакончитьГруппуСтрок();
			КонецЦикла;
			
		Иначе
			//Формирование отчета без группировки по датам
			ВыборкаПоДокументамПКО 	= РезультатПКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Документ");
			ВыборкаПоДокументамРКО 	= РезультатРКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Документ");
			КоличествоДокументов	=  Макс(ВыборкаПоДокументамПКО.Количество(),ВыборкаПоДокументамРКО.Количество());
			Для СчетчикЦикла = 1 По КоличествоДокументов Цикл
				Если ВыборкаПоДокументамПКО.Следующий()  Тогда
					НомерДокПечатнойФормы = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаПоДокументамПКО.Номер, ВыборкаПоДокументамРКО.Документ);
					ОбластьСтрокаОтчетПКО.Параметры.Номер = НомерДокПечатнойФормы;
					
					ЗаполнитьЗначенияСвойств(ОбластьСтрокаОтчетПКО.Параметры,ВыборкаПоДокументамПКО);
					ТабличныйДокумент.Вывести(ОбластьСтрокаОтчетПКО);	
					ЗначенияИтогов.ИтогоСуммаПКО = ЗначенияИтогов.ИтогоСуммаПКО + ВыборкаПоДокументамПКО.Сумма;
					
				Иначе
					ТабличныйДокумент.Вывести(ОбластьПустаяСтрокаОтчетПКО);	
				КонецЕсли;
				Если ВыборкаПоДокументамРКО.Следующий() Тогда
					НомерДокПечатнойФормы = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаПоДокументамРКО.Номер, ВыборкаПоДокументамРКО.Документ);
					ОбластьСтрокаОтчетРКО.Параметры.Номер = НомерДокПечатнойФормы;
					
					ЗаполнитьЗначенияСвойств(ОбластьСтрокаОтчетРКО.Параметры,ВыборкаПоДокументамРКО);
					ТабличныйДокумент.Присоединить(ОбластьСтрокаОтчетРКО);
					ЗначенияИтогов.ИтогоСуммаРКО = ЗначенияИтогов.ИтогоСуммаРКО + ВыборкаПоДокументамРКО.Сумма;
					
				Иначе
					ТабличныйДокумент.Присоединить(ОбластьПустаяСтрокаОтчетРКО);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	
	//Вывод итогов

	ИтогПКО.Параметры.ИтогоСуммаПКО = ЗначенияИтогов.ИтогоСуммаПКО;
	ИтогРКО.Параметры.ИтогоСуммаРКО = ЗначенияИтогов.ИтогоСуммаРКО;
	ТабличныйДокумент.Вывести(ИтогПКО); 
	ТабличныйДокумент.Присоединить(ИтогРКО);

	//Для вывода подписей
	
	ИскомаяОрганизация = Неопределено;
	
	//выберем первую организацию в списке организаций
	Если ТипЗнч(ПараметрыОтчета.СписокСтруктурныхЕдиниц) = Тип("СписокЗначений") Тогда
		Если ПараметрыОтчета.СписокСтруктурныхЕдиниц.Количество() > 0 Тогда
			ИскомаяОрганизация = ПараметрыОтчета.СписокСтруктурныхЕдиниц[0].Значение;
		КонецЕсли;
	КонецЕсли;
	
	Если ИскомаяОрганизация = Неопределено Тогда
		ИскомаяОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;  	
	
	ОбластьПодписи = Макет.ПолучитьОбласть("Подписи");
	
	ОтветЛица = ОбщегоНазначенияБКВызовСервера.ОтветственныеЛицаОрганизаций(ИскомаяОрганизация, КонецДня(ПараметрыОтчета.КонецПериода), Пользователи.ТекущийПользователь().ФизЛицо);
	ОбластьПодписи.Параметры.Заполнить(ОтветЛица);
	ТабличныйДокумент.Вывести(ОбластьПодписи);
	
	ТабличныйДокумент.ПовторятьПриПечатиСтроки = ТабличныйДокумент.Области.ШапкаТаблицы;
	
КонецПроцедуры

Функция ПодготовитьДанныеПоКассовымПриходнымДокументам(ПараметрыОтчета)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("НачалоПериода", 	НачалоДня(ПараметрыОтчета.НачалоПериода));
	Запрос.УстановитьПараметр("КонецПериода", 	КонецДня(ПараметрыОтчета.КонецПериода));
	Запрос.УстановитьПараметр("Организация", 	ПараметрыОтчета.СписокСтруктурныхЕдиниц);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Док.Ссылка КАК Документ,
	|	НАЧАЛОПЕРИОДА(Док.Дата, ДЕНЬ) КАК День,
	|	Док.Номер КАК Номер,
	|	Док.Дата КАК Дата,
	|	ВЫРАЗИТЬ(Док.Комментарий КАК СТРОКА(200)) КАК Примечание,
	|	СУММА(Док.СуммаДокумента * КурсыВалют.Курс / КурсыВалют.Кратность) КАК Сумма
	|ИЗ
	|	Документ.ПриходныйКассовыйОрдер КАК Док
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалют
	|		ПО Док.ВалютаДокумента = КурсыВалют.Валюта
	|			И (КурсыВалют.Период В
	|				(ВЫБРАТЬ
	|					МАКСИМУМ(КурсыВалют.Период) КАК Период
	|				ИЗ
	|					РегистрСведений.КурсыВалют КАК КурсыВалют
	|				ГДЕ
	|					КурсыВалют.Период <= Док.Дата
	|					И Док.ВалютаДокумента = КурсыВалют.Валюта))
	|ГДЕ
	|	Док.Проведен
	|	И Док.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И Док.Организация В(&Организация)
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(Док.Дата, ДЕНЬ),
	|	Док.Ссылка,
	|	Док.Номер,
	|	Док.Дата,
	|	ВЫРАЗИТЬ(Док.Комментарий КАК СТРОКА(200))
	|
	|УПОРЯДОЧИТЬ ПО
	|	День,
	|	Документ
	|ИТОГИ ПО
	|	День,
	|	Документ
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция ПодготовитьДанныеПоКассовымРасходнымДокументам(ПараметрыОтчета)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("НачалоПериода", 	ПараметрыОтчета.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", 	КонецДня(ПараметрыОтчета.КонецПериода));
	Запрос.УстановитьПараметр("Организация", 	ПараметрыОтчета.СписокСтруктурныхЕдиниц);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Док.Ссылка КАК Документ,
	|	НАЧАЛОПЕРИОДА(Док.Дата, ДЕНЬ) КАК День,
	|	Док.Номер КАК Номер,
	|	Док.Дата КАК Дата,
	|	ВЫРАЗИТЬ(Док.Комментарий КАК СТРОКА(200)) КАК Примечание,
	|	СУММА(Док.СуммаДокумента * КурсыВалют.Курс / КурсыВалют.Кратность) КАК Сумма
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК Док
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалют
	|		ПО Док.ВалютаДокумента = КурсыВалют.Валюта
	|			И (КурсыВалют.Период В
	|				(ВЫБРАТЬ
	|					МАКСИМУМ(КурсыВалют.Период) КАК Период
	|				ИЗ
	|					РегистрСведений.КурсыВалют КАК КурсыВалют
	|				ГДЕ
	|					КурсыВалют.Период <= Док.Дата
	|					И Док.ВалютаДокумента = КурсыВалют.Валюта))
	|ГДЕ
	|	Док.Проведен
	|	И Док.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И Док.Организация В(&Организация)
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(Док.Дата, ДЕНЬ),
	|	Док.Ссылка,
	|	Док.Номер,
	|	Док.Дата,
	|	ВЫРАЗИТЬ(Док.Комментарий КАК СТРОКА(200))
	|
	|УПОРЯДОЧИТЬ ПО
	|	День,
	|	Документ
	|ИТОГИ ПО
	|	День,
	|	Документ
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

#КонецЕсли