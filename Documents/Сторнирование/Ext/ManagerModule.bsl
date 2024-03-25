﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами.
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	Если ОбщегоНазначенияБККлиентСервер.ЭтоПростаяВерсияКонфигурации() Тогда
		БлокируемыеРеквизиты.Добавить("Дата");
		БлокируемыеРеквизиты.Добавить("Номер");
		БлокируемыеРеквизиты.Добавить("ДокументОснование");
		БлокируемыеРеквизиты.Добавить("Организация; СтруктурноеПодразделениеОрганизация");
		БлокируемыеРеквизиты.Добавить("СтруктурноеПодразделение");
							
	КонецЕсли;
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Заполнение документа

Процедура ЗаполнитьПоДокументуОснования(Объект, Основание) Экспорт

	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(Объект, Основание);
	
	Если Не Объект.Метаданные().Реквизиты.ДокументОснование.Тип.СодержитТип(ТипЗнч(Основание)) Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ДокументОснование = Основание;

	ВыполнитьСторнированиеДвижений(Объект, Основание);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сторнирование движений

// Процедура выполняет сторнирование движений переданного документа
//
Процедура ВыполнитьСторнированиеДвижений(Объект, Основание) Экспорт

	// скопируем все движения
	ДвиженияДокументаОснования = Основание.Метаданные().Движения;
	ДвиженияСторно = Объект.Метаданные().Движения;
	
	Для Каждого МетаданныеРегистр Из ДвиженияДокументаОснования Цикл
	
		Если Метаданные.РегистрыСведений.Содержит(МетаданныеРегистр) Тогда
			// регистры сведений не сторнируем
			Продолжить; 
		КонецЕсли;	
		
		Если Не ДвиженияСторно.Содержит(МетаданныеРегистр) Тогда
			// регистр не сторнируется
			Продолжить;
		КонецЕсли;
		
		Попытка
			НаборЗаписей = Объект.Движения[МетаданныеРегистр.Имя];
			ЗаполнитьНаборЗаписей(Объект, НаборЗаписей, МетаданныеРегистр);
		Исключение
			ОбщегоНазначения.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при чтении данных регистра %1: %2'"), МетаданныеРегистр.Имя, ОписаниеОшибки()),
				Объект.Ссылка,
				,
				,
				);
		КонецПопытки;
	
	КонецЦикла;

КонецПроцедуры

// Копирует значения движения в строку сторно нового движения
// для измерений и реквизитов. Ресурсы инвертируются.
//
Процедура ЗаполнитьДвижениеСторно(Движение, Строка, МетаданныеОбъект)

	// измерения
	Для Каждого МДОбъект из МетаданныеОбъект.Измерения Цикл
		Движение[МДОбъект.Имя] = Строка[МДОбъект.Имя];
	КонецЦикла;

	// ресурсы
	Для Каждого МДОбъект из МетаданныеОбъект.Ресурсы Цикл
		Движение[МДОбъект.Имя] = - Строка[МДОбъект.Имя];
	КонецЦикла;

	// реквизиты
	Для Каждого МДОбъект из МетаданныеОбъект.Реквизиты Цикл
		Движение[МДОбъект.Имя] = Строка[МДОбъект.Имя];
	КонецЦикла;

КонецПроцедуры

// Копирует значения движения по регистру бухгалтерии в строку сторно я
// нового движени для измерений и реквизитов. Ресурсы инвертируются.
//
Процедура ЗаполнитьДвиженияСторноПоРегиструБухгалтерии(Движение, Строка, МетаданныеОбъект)

	Если МетаданныеОбъект.Корреспонденция Тогда

		Движение.СчетДт = Строка.СчетДт;
		Движение.СчетКт = Строка.СчетКт;

		ВыборкаСубконто = ПланыВидовХарактеристик[МетаданныеОбъект.ПланСчетов.ВидыСубконто.Имя].Выбрать();
		Пока ВыборкаСубконто.Следующий() Цикл

			Если ВыборкаСубконто.Предопределенный Тогда

				Если Строка.СубконтоДт[ВыборкаСубконто.Ссылка] <> Неопределено Тогда
					Движение.СубконтоДт[ВыборкаСубконто.Ссылка] = Строка.СубконтоДт[ВыборкаСубконто.Ссылка];
				КонецЕсли;
				
				Если Строка.СубконтоКт[ВыборкаСубконто.Ссылка] <> Неопределено Тогда
					Движение.СубконтоКт[ВыборкаСубконто.Ссылка] = Строка.СубконтоКт[ВыборкаСубконто.Ссылка];
				КонецЕсли;

			КонецЕсли;

		КонецЦикла;

	Иначе

		Движение.Счет   = Строка.Счет;

		ВыборкаСубконто = ПланыВидовХарактеристик[МетаданныеОбъект.ПланСчетов.ВидыСубконто.Имя].Выбрать();
		Пока ВыборкаСубконто.Следующий() Цикл
			Если ВыборкаСубконто.Предопределенный Тогда
				Если Строка.Субконто[ВыборкаСубконто.Ссылка] <> Неопределено Тогда
					Движение.Субконто[ВыборкаСубконто.Ссылка] = Строка.Субконто[ВыборкаСубконто.Ссылка];
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;

	КонецЕсли;

	// измерения
	Для Каждого МДОбъект из МетаданныеОбъект.Измерения Цикл

		Если МетаданныеОбъект.Корреспонденция Тогда
			Если МДОбъект.ПризнакУчета = Неопределено И МДОбъект.Балансовый Тогда
				Движение[МДОбъект.Имя] = Строка[МДОбъект.Имя];
			Иначе
				Движение[МДОбъект.Имя + "Дт"] = Строка[МДОбъект.Имя + "Дт"];
				Движение[МДОбъект.Имя + "Кт"] = Строка[МДОбъект.Имя + "Кт"];
			КонецЕсли;
		Иначе
		КонецЕсли;

	КонецЦикла;

	// ресурсы
	Для Каждого МДОбъект из МетаданныеОбъект.Ресурсы Цикл

		Если МДОбъект.ПризнакУчета = Неопределено И МДОбъект.Балансовый Тогда
			Движение[МДОбъект.Имя] = - Строка[МДОбъект.Имя];
		Иначе

			Если ЗначениеЗаполнено(Строка[МДОбъект.Имя + "Дт"]) Тогда
				Движение[МДОбъект.Имя + "Дт"] = - Строка[МДОбъект.Имя + "Дт"];
			КонецЕсли;

			Если ЗначениеЗаполнено(Строка[МДОбъект.Имя + "Кт"]) Тогда
				Движение[МДОбъект.Имя + "Кт"] = - Строка[МДОбъект.Имя + "Кт"];
			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

	// реквизиты
	Для Каждого МДОбъект из МетаданныеОбъект.Реквизиты Цикл

		Движение[МДОбъект.Имя] = Строка[МДОбъект.Имя];

	КонецЦикла;

КонецПроцедуры

// Заполняет набор записей по указанному регистру сторнирующими движениями.
//
Процедура ЗаполнитьНаборЗаписей(Объект, ЗаполняемыйНаборЗаписей, МетаданныеРегистр) Экспорт

	ЭтоРегистрРасчета     = Ложь;
	ЭтоРегистрБухгалтерии = Ложь;
	ЭтоРегистрНакопления  = Ложь;

	Если ОбщегоНазначения.ЭтоРегистрРасчета(МетаданныеРегистр) Тогда
		ЭтоРегистрРасчета     = Истина;
		НаборЗаписей          = РегистрыРасчета[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
		Периодичность		  = МетаданныеРегистр.Периодичность;
		ПериодРегистрации	  = Объект.Дата;
		
	ИначеЕсли ОбщегоНазначения.ЭтоРегистрБухгалтерии(МетаданныеРегистр) Тогда
		ЭтоРегистрБухгалтерии = Истина;
		НаборЗаписей          = РегистрыБухгалтерии[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
	Иначе
		ЭтоРегистрНакопления  = Истина;
		НаборЗаписей          = РегистрыНакопления[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
	КонецЕсли;
	
	ОтражениеПоПериодуРегистрации = УчетнаяПолитикаСервер.ОтражениеПоПериодуРегистрации(Объект.Организация, Объект.Дата);

	НаборЗаписей.Отбор.Регистратор.Значение = Объект.ДокументОснование;
	НаборЗаписей.Прочитать();

	Для Каждого ДвижениеСторнируемое Из НаборЗаписей Цикл

		Если ЭтоРегистрРасчета Тогда

			ДвижениеСторно = ЗаполняемыйНаборЗаписей.Добавить();

			ЗаполнитьДвижениеСторно(ДвижениеСторно, ДвижениеСторнируемое, МетаданныеРегистр);

			ДвижениеСторно.ПериодРегистрации = Объект.Дата;
			ДвижениеСторно.ВидРасчета        = ДвижениеСторнируемое.ВидРасчета;
			ДвижениеСторно.Сторно            = Истина;

			Если МетаданныеРегистр.ПериодДействия Тогда
				ДвижениеСторно.ПериодДействияНачало = ДвижениеСторнируемое.ПериодДействияНачало;
				ДвижениеСторно.ПериодДействияКонец  = ДвижениеСторнируемое.ПериодДействияКонец;
			КонецЕсли;

			Если МетаданныеРегистр.БазовыйПериод Тогда
				ДвижениеСторно.БазовыйПериодНачало = ДвижениеСторнируемое.БазовыйПериодНачало;
				ДвижениеСторно.БазовыйПериодКонец  = ДвижениеСторнируемое.БазовыйПериодКонец;
			КонецЕсли;

		ИначеЕсли ЭтоРегистрБухгалтерии Тогда

			ДвижениеСторно = ЗаполняемыйНаборЗаписей.Добавить();
			
			ЗаполнитьДвиженияСторноПоРегиструБухгалтерии(ДвижениеСторно, ДвижениеСторнируемое, МетаданныеРегистр);
			ДвижениеСторно.Период = Объект.Дата;

		Иначе

			ДвижениеСторно = ЗаполняемыйНаборЗаписей.Добавить();

			ЗаполнитьДвижениеСторно(ДвижениеСторно, ДвижениеСторнируемое, МетаданныеРегистр);
			
			Если МетаданныеРегистр.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
				ДвижениеСторно.ВидДвижения = ДвижениеСторнируемое.ВидДвижения
			КонецЕсли;
			
			Если МетаданныеРегистр.Имя = "ИПНСведенияОДоходах" 
					Или МетаданныеРегистр.Имя = "ОПВСведенияОДоходах"
					Или МетаданныеРегистр.Имя = "СНСведенияОДоходах"
					Или МетаданныеРегистр.Имя = "СОСведенияОДоходах" Тогда
				Если ОтражениеПоПериодуРегистрации Тогда
					ДвижениеСторно.Период = НачалоМесяца(Объект.Дата);
					ДвижениеСторно.ПериодРегистрации = НачалоМесяца(Объект.Дата);
				Иначе
					ДвижениеСторно.Период = НачалоМесяца(ДвижениеСторнируемое.Период);
					ДвижениеСторно.ПериодРегистрации = НачалоМесяца(Объект.Дата);
				КонецЕсли;
			ИначеЕсли МетаданныеРегистр.Имя = "ВыплаченныеДоходыРаботникамОрганизацийНУ" Тогда
				Если ОтражениеПоПериодуРегистрации Тогда
					ДвижениеСторно.Период = НачалоМесяца(Объект.Дата);
					ДвижениеСторно.МесяцНалоговогоПериода = НачалоМесяца(Объект.Дата);
				Иначе
					ДвижениеСторно.Период = НачалоМесяца(Объект.Дата);
					ДвижениеСторно.МесяцНалоговогоПериода = ДвижениеСторнируемое.МесяцНалоговогоПериода;
				КонецЕсли;
			ИначеЕсли МетаданныеРегистр.Имя = "СведенияСчетовФактурВыданных" ИЛИ МетаданныеРегистр.Имя = "СведенияСчетовФактурПолученных" Тогда
				ДвижениеСторно.Период = ДвижениеСторнируемое.Период;								
			ИначеЕсли МетаданныеРегистр.Имя = "РабочееВремяРаботниковОрганизаций" Тогда
				ДвижениеСторно.Период = ДвижениеСторнируемое.Период;
			Иначе
				ДвижениеСторно.Период = Объект.Дата;
			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

// Процедура обновляет период записей в движениях документа
//
// Параметры:
//  Объект	 - ДокументОбъект.Сторнирование - объект документа "Сторнирование"
//
Процедура ОбновитьПериодЗаписейДвижений(Объект) Экспорт
	
	Если Не ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеДокумента = Объект.ДокументОснование.Метаданные();

	ОтражениеПоПериодуРегистрации = УчетнаяПолитикаСервер.ОтражениеПоПериодуРегистрации(Объект.Организация, Объект.Дата);
	
	// закладки показываем
	Для Каждого МетаданныеРегистр Из МетаданныеДокумента.Движения Цикл

		// если документ-сторно не может иметь таких движений - это не сторнируемый регистр
		Если НЕ Объект.Метаданные().Движения.Содержит(МетаданныеРегистр) Тогда
			Продолжить;
		КонецЕсли;

		// Для каждого движения регистра создавалось ТП с аналогичным именем
		ИмяДвижений     = МетаданныеРегистр.Имя;
		НаборДвижений 	= Объект.Движения[ИмяДвижений];
		
		ЭтоРегистрРасчета = ОбщегоНазначения.ЭтоРегистрРасчета(МетаданныеРегистр);
		
		Для Каждого СтрокаДвижений Из НаборДвижений Цикл
			Если МетаданныеРегистр.Имя = "ИПНСведенияОДоходах" 
					Или МетаданныеРегистр.Имя = "ОПВСведенияОДоходах"
					Или МетаданныеРегистр.Имя = "СНСведенияОДоходах"
					Или МетаданныеРегистр.Имя = "СОСведенияОДоходах" Тогда
				Если ОтражениеПоПериодуРегистрации Тогда
					СтрокаДвижений.Период = НачалоМесяца(Объект.Дата);
					СтрокаДвижений.ПериодРегистрации = НачалоМесяца(Объект.Дата);
				Иначе
					СтрокаДвижений.ПериодРегистрации = НачалоМесяца(Объект.Дата);
				КонецЕсли;
			ИначеЕсли МетаданныеРегистр.Имя = "ВыплаченныеДоходыРаботникамОрганизацийНУ" Тогда
				Если ОтражениеПоПериодуРегистрации Тогда
					СтрокаДвижений.Период = НачалоМесяца(Объект.Дата);
					СтрокаДвижений.МесяцНалоговогоПериода = НачалоМесяца(Объект.Дата);
				Иначе
					СтрокаДвижений.Период = НачалоМесяца(Объект.Дата);
				КонецЕсли;
			ИначеЕсли МетаданныеРегистр.Имя = "РабочееВремяРаботниковОрганизаций"   Тогда
				// здесь менять не требуется
			ИначеЕсли ЭтоРегистрРасчета Тогда
				СтрокаДвижений.ПериодРегистрации = Объект.Дата;
			ИначеЕсли МетаданныеРегистр.Имя = "СведенияСчетовФактурВыданных" ИЛИ МетаданныеРегистр.Имя = "СведенияСчетовФактурПолученных" Тогда
				Если МетаданныеДокумента.Реквизиты.Найти("ДатаСовершенияОборотаПоРеализации") <> Неопределено И ЗначениеЗаполнено(Объект.ДокументОснование.ДатаСовершенияОборотаПоРеализации) Тогда
					СтрокаДвижений.Период = Объект.ДокументОснование.ДатаСовершенияОборотаПоРеализации;
				Иначе	
	            	СтрокаДвижений.Период = Объект.ДокументОснование.Дата;
				КонецЕсли;
			Иначе
				СтрокаДвижений.Период = Объект.Дата;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Бухгалтерская справка
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "БухгалтерскаяСправка";
	КомандаПечати.Представление = НСтр("ru = 'С-1 (Бухгалтерская справка)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.Порядок = 50;
	
	// Настраиваемый комплект документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "БухгалтерскаяСправка";
	КомандаПечати.Представление = НСтр("ru = 'Настраиваемый комплект документов'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Настраиваемый комплект'");
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	КомандаПечати.Порядок = 75;
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Печать бух. справки
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "БухгалтерскаяСправка") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"БухгалтерскаяСправка",
			НСтр("ru = 'Бухгалтерская справка'"),
			ПечатьБухгалтерскаяСправка(МассивОбъектов, ОбъектыПечати),
			,
			"ОбщийМакет.ПФ_MXL_БухгалтерскаяСправка");
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Подготовка табличных печатных документов.

Функция ПечатьБухгалтерскаяСправка(МассивОбъектов, ОбъектыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб				= Истина;
	ТабДокумент.ПолеСверху				= 10;
	ТабДокумент.ПолеСлева				= 0;
	ТабДокумент.ПолеСнизу				= 0;
	ТабДокумент.ПолеСправа				= 0;
	ТабДокумент.РазмерКолонтитулаСверху	= 10;
	ТабДокумент.ОриентацияСтраницы		= ОриентацияСтраницы.Ландшафт;
	ТабДокумент.ИмяПараметровПечати		= "ПАРАМЕТРЫ_ПЕЧАТИ_Сторнирование_БухгалтерскаяСправка";
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Сторнирование.Ссылка КАК Ссылка,
	               |	Сторнирование.Организация КАК Организация,
	               |	Сторнирование.Номер КАК Номер,
	               |	Сторнирование.Ответственный,
	               |	Сторнирование.Дата КАК Дата,
	               |	Сторнирование.СтруктурноеПодразделение
	               |ИЗ
	               |	Документ.Сторнирование КАК Сторнирование
	               |ГДЕ
	               |	Сторнирование.Ссылка В(&МассивОбъектов)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Дата,
	               |	Номер
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТиповойДвиженияССубконто.НомерСтроки КАК НомерСтроки,
	               |	ТиповойДвиженияССубконто.СчетДт,
	               |	ТиповойДвиженияССубконто.СтруктурноеПодразделениеДт,
	               |	ТиповойДвиженияССубконто.СубконтоДт1,
	               |	ТиповойДвиженияССубконто.СубконтоДт2,
	               |	ТиповойДвиженияССубконто.СубконтоДт3,
	               |	ТиповойДвиженияССубконто.СчетКт,
	               |	ТиповойДвиженияССубконто.СтруктурноеПодразделениеКт,
	               |	ТиповойДвиженияССубконто.СубконтоКт1,
	               |	ТиповойДвиженияССубконто.СубконтоКт2,
	               |	ТиповойДвиженияССубконто.СубконтоКт3,
	               |	ТиповойДвиженияССубконто.Организация,
	               |	ТиповойДвиженияССубконто.ВалютаДт,
	               |	ТиповойДвиженияССубконто.ВалютаКт,
	               |	ЕСТЬNULL(ТиповойДвиженияССубконто.Сумма, 0) КАК Сумма,
	               |	ТиповойДвиженияССубконто.ВалютнаяСуммаДт,
	               |	ТиповойДвиженияССубконто.ВалютнаяСуммаКт,
	               |	ТиповойДвиженияССубконто.КоличествоДт,
	               |	ТиповойДвиженияССубконто.КоличествоКт,
	               |	ТиповойДвиженияССубконто.Содержание,
	               |	ТиповойДвиженияССубконто.Регистратор КАК Регистратор,
	               |	ВЫБОР
	               |		КОГДА ТИПЗНАЧЕНИЯ(ТиповойДвиженияССубконто.СубконтоДт1) = ЗНАЧЕНИЕ(Справочник.Номенклатура)
	               |			ТОГДА ТиповойДвиженияССубконто.СубконтоДт1.БазоваяЕдиницаИзмерения
	               |		ИНАЧЕ ВЫБОР
	               |				КОГДА ТИПЗНАЧЕНИЯ(ТиповойДвиженияССубконто.СубконтоДт2) = ЗНАЧЕНИЕ(Справочник.Номенклатура)
	               |					ТОГДА ТиповойДвиженияССубконто.СубконтоДт2.БазоваяЕдиницаИзмерения
	               |				ИНАЧЕ ВЫБОР
	               |						КОГДА ТИПЗНАЧЕНИЯ(ТиповойДвиженияССубконто.СубконтоДт3) = ЗНАЧЕНИЕ(Справочник.Номенклатура)
	               |							ТОГДА ТиповойДвиженияССубконто.СубконтоДт3.БазоваяЕдиницаИзмерения
	               |						ИНАЧЕ """"
	               |					КОНЕЦ
	               |			КОНЕЦ
	               |	КОНЕЦ КАК БазоваяЕдиницаИзмеренияДт,
	               |	ВЫБОР
	               |		КОГДА ТИПЗНАЧЕНИЯ(ТиповойДвиженияССубконто.СубконтоКт1) = ЗНАЧЕНИЕ(Справочник.Номенклатура)
	               |			ТОГДА ТиповойДвиженияССубконто.СубконтоКт1.БазоваяЕдиницаИзмерения
	               |		ИНАЧЕ ВЫБОР
	               |				КОГДА ТИПЗНАЧЕНИЯ(ТиповойДвиженияССубконто.СубконтоКт2) = ЗНАЧЕНИЕ(Справочник.Номенклатура)
	               |					ТОГДА ТиповойДвиженияССубконто.СубконтоКт2.БазоваяЕдиницаИзмерения
	               |				ИНАЧЕ ВЫБОР
	               |						КОГДА ТИПЗНАЧЕНИЯ(ТиповойДвиженияССубконто.СубконтоКт3) = ЗНАЧЕНИЕ(Справочник.Номенклатура)
	               |							ТОГДА ТиповойДвиженияССубконто.СубконтоКт3.БазоваяЕдиницаИзмерения
	               |						ИНАЧЕ """"
	               |					КОНЕЦ
	               |			КОНЕЦ
	               |	КОНЕЦ КАК БазоваяЕдиницаИзмеренияКт
	               |ИЗ
	               |	РегистрБухгалтерии.Типовой.ДвиженияССубконто(
	               |			,
	               |			,
	               |			Активность
	               |				И Регистратор В (&МассивОбъектов),
	               |			,
	               |			) КАК ТиповойДвиженияССубконто
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерСтроки
	               |ИТОГИ ПО
	               |	Регистратор";
				   
	Выборка = Запрос.ВыполнитьПакет();
	ВыборкаШапка = Выборка[0].Выбрать();
	
	Пока ВыборкаШапка.Следующий() Цикл 
					
		Если ТабДокумент.ВысотаТаблицы > 0 Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		// Зададим параметры макета по умолчанию
		ТабДокумент.РазмерКолонтитулаСверху = 0;
		ТабДокумент.РазмерКолонтитулаСнизу  = 0;
		ТабДокумент.АвтоМасштаб             = Истина;
		ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Ландшафт;
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_С1");
		// Получаем области макета для вывода в табличный документ.
		ШапкаДокумента   = Макет.ПолучитьОбласть("Шапка");
		ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		СтрокаТаблицы    = Макет.ПолучитьОбласть("СтрокаТаблицы");
		ПодвалДокумента  = Макет.ПолучитьОбласть("Подвал");
		
		// Выведем шапку документа.
		СтруктурнаяЕдиницаОрганизация = ОбщегоНазначенияБК.ПолучитьСтруктурнуюЕдиницу(ВыборкаШапка.Организация, ВыборкаШапка.СтруктурноеПодразделение);
		СведенияОбОрганизации 		  = ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(СтруктурнаяЕдиницаОрганизация, ВыборкаШапка.Дата);
		
		ШапкаДокумента.Параметры.ПредставлениеОрганизации  = ОбщегоНазначенияБКВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации,"ПолноеНаименование,");
		ШапкаДокумента.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаШапка.Номер, ВыборкаШапка.Ссылка);
		ШапкаДокумента.Параметры.ДатаСоставления  = Формат(ВыборкаШапка.Дата, "ДЛФ=D");
		ШапкаДокумента.Параметры.ОрганизацияРНН_БИН       = ОбщегоНазначенияБКВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "БИН_ИИН,", Ложь, ВыборкаШапка.Дата, "ru");
		
		ТабДокумент.Вывести(ШапкаДокумента);
		
		// Выведем заголовок таблицы.
		ТабДокумент.Вывести(ЗаголовокТаблицы);
		
		СуммаПоДокументу  = 0;
		КоличествоСтрокВОперации = 0;

		ВыборкаДвиженийПоРегистраторам = Выборка[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		
		Если ВыборкаДвиженийПоРегистраторам.НайтиСледующий(ВыборкаШапка.Ссылка) Тогда
			ВыборкаДвижений = ВыборкаДвиженийПоРегистраторам.Выбрать();
		Иначе
			ВыборкаДвижений = Неопределено;
		КонецЕсли;

		Если ВыборкаДвижений <> Неопределено Тогда 
			// Выведем строки документа.
			Пока ВыборкаДвижений.Следующий() Цикл
				
				СтрокаТаблицы.Параметры.Заполнить(ВыборкаДвижений);
				
				АналитикаДт = Строка(ВыборкаДвижений.СубконтоДт1) + Символы.ПС
				+ Строка(ВыборкаДвижений.СубконтоДт2) + Символы.ПС
				+ Строка(ВыборкаДвижений.СубконтоДт3);
				
				АналитикаКт = Строка(ВыборкаДвижений.СубконтоКт1) + Символы.ПС
				+ Строка(ВыборкаДвижений.СубконтоКт2) + Символы.ПС
				+ Строка(ВыборкаДвижений.СубконтоКт3);
				
				СтрокаТаблицы.Параметры.АналитикаДт = АналитикаДт;
				СтрокаТаблицы.Параметры.АналитикаКт = АналитикаКт;
				
				СуммаПоДокументу = СуммаПоДокументу + ВыборкаДвижений.Сумма;
				КоличествоСтрокВОперации = КоличествоСтрокВОперации + 1;			
				
				// Проверим, помещается ли строка с подвалом.
				СтрокаСПодвалом = Новый Массив;
				СтрокаСПодвалом.Добавить(СтрокаТаблицы);
				СтрокаСПодвалом.Добавить(ПодвалДокумента);
				
				Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабДокумент, СтрокаСПодвалом) Тогда
					ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ТабДокумент.Вывести(ЗаголовокТаблицы);
				КонецЕсли;	
				
				ТабДокумент.Вывести(СтрокаТаблицы);
				
			КонецЦикла;
		КонецЕсли;
		
		Руководители = ОбщегоНазначенияБКВызовСервера.ОтветственныеЛицаОрганизаций(СтруктурнаяЕдиницаОрганизация,ВыборкаШапка.Дата);
		
		ПодвалДокумента.Параметры.РасшифровкаПодписиРуководитель	= Руководители.Руководитель;
		ПодвалДокумента.Параметры.РасшифровкаПодписиГлавБух			= Руководители.ГлавныйБухгалтер;  
		
		Если КоличествоСтрокВОперации <> 0 Тогда
			ПодвалДокумента.Параметры.ВсегоКорреспонденцийПрописью = ОбщегоНазначенияБКВызовСервера.КоличествоПрописью(КоличествоСтрокВОперации);
		КонецЕсли;
		
		ПодвалДокумента.Параметры.СуммаПрописью = ?(СуммаПоДокументу <> 0, ОбщегоНазначенияБКВызовСервера.СформироватьСуммуПрописью(СуммаПоДокументу, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета()),"");		
		
		// Выведем подвал таблицы.			
		ТабДокумент.Вывести(ПодвалДокумента);
		
	КонецЦикла;

	Возврат ТабДокумент;

КонецФункции

#КонецЕсли