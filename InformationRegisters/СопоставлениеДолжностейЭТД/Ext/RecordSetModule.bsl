﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЭТДСервер.ИспользоватьШтатноеРасписание() Тогда
		
		СтрокаДолжностьПоШтатномуРасписанию = ПроверяемыеРеквизиты.Найти("ДолжностьПоШтатномуРасписанию");
		
		Если НЕ СтрокаДолжностьПоШтатномуРасписанию = Неопределено Тогда
			 ПроверяемыеРеквизиты.Удалить(СтрокаДолжностьПоШтатномуРасписанию);
		КонецЕсли;
		 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#КонецЕсли