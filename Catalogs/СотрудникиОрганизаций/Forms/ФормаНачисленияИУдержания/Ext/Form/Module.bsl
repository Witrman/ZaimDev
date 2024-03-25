﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("СсылкаНаСотрудника",СсылкаНаСотрудника);
	Если Не ЗначениеЗаполнено(СсылкаНаСотрудника) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	СсылкаНаСотрудника = Параметры.СсылкаНаСотрудника;
	ФизическоеЛицоСсылка = Параметры.ФизЛицо;
	ОрганизацияСсылка = Параметры.Организация;
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Начисления, 			"Сотрудник", СсылкаНаСотрудника);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Удержания,   "ФизЛицо",	 ФизическоеЛицоСсылка);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Удержания,   "Организация",	 ОрганизацияСсылка);
	
КонецПроцедуры

