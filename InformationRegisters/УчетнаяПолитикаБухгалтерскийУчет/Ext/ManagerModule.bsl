﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает список всех используемых в информационной базе систем налогообложения
//
// Параметры:
//  ВидОрганизации         - Строка - имя вида организации
//  СистемаНалогообложения - Строка - имя системы налогообложения
//
// Возвращаемое значение:
//  Структура - где ключ - имя ресурса регистра УчетнаяПолитикаБухгалтерскийУчет
//
Функция СтруктураУчетнойПолитики(ВидОрганизации, СистемаНалогообложения) Экспорт
	
	СтруктураУчетнойПолитики = Новый Структура;
	
	Если СистемаНалогообложения = "Патент" Тогда
		
		СтруктураУчетнойПолитики.Вставить("УчетВременныхРазницПоНалогуНаПрибыль",         Ложь);
		СтруктураУчетнойПолитики.Вставить("ВедениеУчетаВременныхРазницБалансовымМетодом", Ложь);
		
	ИначеЕсли СистемаНалогообложения = "УпрощеннаяДекларация" Тогда
		
		СтруктураУчетнойПолитики.Вставить("УчетВременныхРазницПоНалогуНаПрибыль",         Ложь);
		СтруктураУчетнойПолитики.Вставить("ВедениеУчетаВременныхРазницБалансовымМетодом", Ложь);
		
	ИначеЕсли СистемаНалогообложения = "ФиксированныйВычет" Тогда
		
		СтруктураУчетнойПолитики.Вставить("УчетВременныхРазницПоНалогуНаПрибыль",         Ложь);
		СтруктураУчетнойПолитики.Вставить("ВедениеУчетаВременныхРазницБалансовымМетодом", Ложь);
		
	ИначеЕсли СистемаНалогообложения = "РозничныйНалог" Тогда
		
		СтруктураУчетнойПолитики.Вставить("УчетВременныхРазницПоНалогуНаПрибыль",         Ложь);
		СтруктураУчетнойПолитики.Вставить("ВедениеУчетаВременныхРазницБалансовымМетодом", Ложь);
		
	Иначе
		
		СтруктураУчетнойПолитики.Вставить("УчетВременныхРазницПоНалогуНаПрибыль",         Истина);
		СтруктураУчетнойПолитики.Вставить("ВедениеУчетаВременныхРазницБалансовымМетодом", Истина);
		
	КонецЕсли;
	
	Возврат СтруктураУчетнойПолитики;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли
