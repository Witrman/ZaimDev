﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Контейнер = ИнтеграцияИСМПТККлиентСервер.КонтейнерМетодов();	
	Контейнер.ПриОткрытииФормы(ЭтаФорма, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	
	
	Отказ = Истина;
	ПоказатьПредупреждение(, НСтр("ru = 'Обработка является служебной и не предназначена для интерактивной работы.'"));

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры
