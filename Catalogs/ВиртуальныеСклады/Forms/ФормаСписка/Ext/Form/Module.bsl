﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВССерверПереопределяемый.ВиртуальныеСкладыВСФормаСпискаИВыбораПриСозданииНаСервере(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ВСКлиентСервер.ИмяСобытияЗаписьВС() Тогда
		Элементы.Список.Обновить();
	ИначеЕсли ИмяСобытия = "ВС_ПроверятьОповещенияФоновогоЗадания"
		И ЭтаФорма.КлючУникальности = Источник Тогда
		
		ВСКлиентПереопределяемый.ОбработкаОповещенияВС_ПроверятьОповещенияФоновогоЗадания(ЭтаФорма, Параметр);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ФормаКоманднаяПанель.ПодчиненныеЭлементы.ФормаСправочникВиртуальныеСкладыСменитьСтатус.Видимость = Ложь;
	Элементы.ФормаКоманднаяПанель.ПодчиненныеЭлементы.ФормаСправочникВиртуальныеСкладыСменитьСтатус.Доступность = Ложь;
	
КонецПроцедуры



