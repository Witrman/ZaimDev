﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СписокНаправленийУведомлений.Добавить(Перечисления.НаправленияДокументовИСМПТК.Входящий, НСтр("ru = 'Полученные Уведомления о расхождениях'"));
	СписокНаправленийУведомлений.Добавить(Перечисления.НаправленияДокументовИСМПТК.Исходящий, НСтр("ru = 'Отправленные Уведомления о расхождениях'"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыборГруппИЭлементов", 		 Параметры.ВыборГруппИЭлементов);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", 			 Параметры.ЗакрыватьПриВыборе);
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца", Параметры.ЗакрыватьПриЗакрытииВладельца);
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", 	 Параметры.КлючНазначенияИспользования);
	ПараметрыФормы.Вставить("МножественныйВыбор", 			 Параметры.МножественныйВыбор);
	ПараметрыФормы.Вставить("Отбор", 						 Параметры.Отбор);
	ПараметрыФормы.Вставить("ПараметрыФункциональныхОпций",  Параметры.ПараметрыФункциональныхОпций);
	ПараметрыФормы.Вставить("РазрешитьВыборКорня", 			 Параметры.РазрешитьВыборКорня);
	ПараметрыФормы.Вставить("РежимВыбора", 					 Параметры.РежимВыбора);
	ПараметрыФормы.Вставить("ТекущаяСтрока",				 Параметры.ТекущаяСтрока);
	ПараметрыФормы.Вставить("ТолькоПросмотр",				 Параметры.ТолькоПросмотр);
	ПараметрыФормы.Вставить("ФиксированныеНастройки",		 Параметры.ФиксированныеНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Контейнер = ИнтеграцияИСМПТККлиентСервер.КонтейнерМетодов();	
	Контейнер.ПриОткрытииФормы(ЭтаФорма, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ

&НаКлиенте
Процедура СписокНаправленийАктовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокНаправленийУведомлений.НайтиПоИдентификатору(ВыбраннаяСтрока);	
	ОткрытьСписокУведомлений(СтрокаТаблицы.Значение);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьСписок(Команда)
	
	СтрокаТаблицы = Элементы.СписокНаправленийУведомлений.ТекущиеДанные;
	
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		ОткрытьСписокУведомлений(СтрокаТаблицы.Значение);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОткрытьСписокУведомлений(НаправлениеУведомление)
	
	Если НаправлениеУведомление = ПредопределенноеЗначение("Перечисление.НаправленияДокументовИСМПТК.Входящий") Тогда
		ОткрытьФорму("Документ.УведомлениеОРасхожденииИСМПТК.Форма.ФормаСпискаВходящих", ПараметрыФормы);
	Иначе
		ОткрытьФорму("Документ.УведомлениеОРасхожденииИСМПТК.Форма.ФормаСпискаИсходящих", ПараметрыФормы);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры
