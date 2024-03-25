﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВестиУчетМаркируемойПродукции = Константы.ВестиУчетМаркируемогоТабакаИСМПТК.Получить()
		ИЛИ Константы.ВестиУчетМаркируемойОбувиИСМПТК.Получить();
	
	Если Значение <> ВестиУчетМаркируемойПродукции Тогда
		Константы.ВестиУчетМаркируемогоТабакаИСМПТК.Установить(Значение);
		Константы.ВестиУчетМаркируемойОбувиИСМПТК.Установить(Значение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
