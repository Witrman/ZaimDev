﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	Элементы.ОбменНаСервере.Видимость = НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая()
	                                  И НЕ ОбщегоНазначения.РазделениеВключено();
	
	СобытияФормИСМПТКПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормИСМПТККлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Сервер 1С:Предприятия';
																					|en = 'Сервер 1С:Предприятия'"));
	
КонецПроцедуры

#КонецОбласти