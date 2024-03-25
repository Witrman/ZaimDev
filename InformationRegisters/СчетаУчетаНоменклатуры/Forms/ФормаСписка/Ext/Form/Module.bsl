﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(Пользователи.ТекущийПользователь(), "УчетПоВсемОрганизациям") Тогда
		Возврат;	
	КонецЕсли;
	
	ОсновнаяОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
	
	МассивОтбора = Новый Массив;
	МассивОтбора.Добавить(ОсновнаяОрганизация);
	МассивОтбора.Добавить(Справочники.Организации.ПустаяСсылка());

	ОбщегоНазначенияБКВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект,,, МассивОтбора);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
