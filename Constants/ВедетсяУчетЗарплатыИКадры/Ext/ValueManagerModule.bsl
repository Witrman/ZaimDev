﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если Не Значение Тогда
		
		ИспользоватьИсполнительныеЛисты = Константы.ИспользоватьИсполнительныеЛисты.СоздатьМенеджерЗначения();
		ИспользоватьИсполнительныеЛисты.Значение = Ложь;
		ИспользоватьИсполнительныеЛисты.ОбменДанными.Загрузка = Истина;
		ИспользоватьИсполнительныеЛисты.Записать();
		
		ИспользоватьДепонированиеЗаработнойПлаты = Константы.ИспользоватьДепонированиеЗаработнойПлаты.СоздатьМенеджерЗначения();
		ИспользоватьДепонированиеЗаработнойПлаты.Значение = Ложь;
		ИспользоватьДепонированиеЗаработнойПлаты.ОбменДанными.Загрузка = Истина;
		ИспользоватьДепонированиеЗаработнойПлаты.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли