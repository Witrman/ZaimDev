﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
		
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	НастройкиКД = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакетаКД = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКД = КомпоновщикМакетаКД.Выполнить(СхемаКомпоновкиДанных, НастройкиКД, ДанныеРасшифровки);
	
	ПроцессорКД = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКД.Инициализировать(МакетКД,, ДанныеРасшифровки);
	
	ПроцессорВыводаРезультатаКД = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаРезультатаКД.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаРезультатаКД.Вывести(ПроцессорКД);
	
	Если ДокументРезультат.ВысотаТаблицы <= 3 Тогда
		ДокументРезультат.ТекущаяОбласть.Текст = НСтр("ru = 'Отчет не сформирован, отрицательных остатков не обнаружено!'");
	КонецЕсли;
	
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
