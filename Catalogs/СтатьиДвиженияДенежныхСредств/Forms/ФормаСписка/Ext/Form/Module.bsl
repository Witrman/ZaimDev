﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

&НаКлиенте
Процедура Заполнить(Команда)
	
	ОбработкаПрерыванияПользователя();
	
	ТекстСостояние = НСтр("ru='Выполняется заполнение справочника. Это может занять некоторое время. Пожалуйста, подождите.'");
	Состояние(ТекстСостояние);

	ЗаполнитьКлассификатор();
	
	Элементы.Список.Обновить();
	
	ТекстСообщения = НСтр("ru='Заполнение справочника завершено'");
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,,,);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьКлассификатор() 
	
	Макет 	= Справочники.СтатьиДвиженияДенежныхСредств.ПолучитьМакет("КлассификаторСтатейДДС");	
	Область = Макет.Области["Строки"];
	
	ЭлементРодитель = Справочники.СтатьиЗатрат.ПустаяСсылка();
	Для Ном = Область.Верх По Область.Низ Цикл
		
		НаименованиеСтроки 	= СокрЛП(Макет.Область(Ном, 1).Текст);
		ВидДвижения			= СокрЛП(Макет.Область(Ном, 2).Текст);
		РазрезДеятельности	= СокрЛП(Макет.Область(Ном, 3).Текст);
		ДДС					= СокрЛП(Макет.Область(Ном, 4).Текст);
		
		ЗаписатьЭлементСправочника(НаименованиеСтроки, ВидДвижения, РазрезДеятельности, ДДС);						
	КонецЦикла;
		
КонецПроцедуры	// ЗаполнитьКлассификатор()

&НаСервере
// Записывает текущий элемент классификатора с учетом
// иерархии 
Функция ЗаписатьЭлементСправочника(НаименованиеСтроки, ВидДвижения, РазрезДеятельности, ДДС)	
	
	НайденноеЗначение = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоНаименованию(НаименованиеСтроки);
	
	Если НайденноеЗначение.Пустая() Тогда
		
		НовыйЭлемент 							= Справочники.СтатьиДвиженияДенежныхСредств.СоздатьЭлемент();		
		НовыйЭлемент.Наименование 				= НаименованиеСтроки;
		НовыйЭлемент.ВидДвижения				= Перечисления.ВидыДвиженийДенежныхСредств[ВидДвижения];
		НовыйЭлемент.РазрезДеятельности 		= Перечисления.РазрезыДеятельности[РазрезДеятельности];
		НовыйЭлемент.ДвижениеДенежныхСредств 	= Справочники.ДвиженияДенежныхСредств[ДДС];		
		
		Попытка
			НовыйЭлемент.Записать();
		Исключение
			ТекстСообщения = НСтр("ru='Не удалось записать элемент: " + НаименованиеСтроки + Символы.ПС + ОписаниеОшибки()+"'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,,);

		КонецПопытки;					
		
	КонецЕсли;	 
	
  Возврат НайденноеЗначение.Ссылка;
	
КонецФункции // ЗаписатьЭлементСправочника
