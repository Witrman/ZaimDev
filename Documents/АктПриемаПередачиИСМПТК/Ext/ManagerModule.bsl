﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если Данные.ТипАкта = ПредопределенноеЗначение("Перечисление.ВидыДокументаИСМПТК.Исходный") Тогда
		ТипАкта = " (первичный)";
	Иначе
		ТипАкта = " (исправленный)";
	КонецЕсли;
	Представление = "Акт приема/передачи № " + Данные.Номер + " от " + Формат(Данные.Дата, "ДФ = dd.MM.yyyy HH:mm:ss") + ТипАкта + "";
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	Поля.Добавить("Номер");
	Поля.Добавить("Дата");
	Поля.Добавить("ТипАкта");
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#Область СтандартныеПодсистемы

Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	ИнтеграцияИСМПТКПереопределяемый.ПриЗаполненииОграниченияДоступа(Ограничение, "АктПриемаПередачиИСМПТК");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли