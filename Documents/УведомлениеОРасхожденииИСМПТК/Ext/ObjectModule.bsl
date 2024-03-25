﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ОбработкаОбменИСМПТ = ИнтеграцияИСМПТКПовтИсп.ОбработкаОбменИСМПТ();
	ОбработкаОбменИСМПТ.ДокументУОР_ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ОбработкаОбменИСМПТ = ИнтеграцияИСМПТКПовтИсп.ОбработкаОбменИСМПТ();
	ОбработкаОбменИСМПТ.ДокументУОР_ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	ОбработкаОбменИСМПТ = ИнтеграцияИСМПТКПовтИсп.ОбработкаОбменИСМПТ();
	ОбработкаОбменИСМПТ.ДокументУОР_ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ОбработкаОбменИСМПТ = ИнтеграцияИСМПТКПовтИсп.ОбработкаОбменИСМПТ();
	ОбработкаОбменИСМПТ.ДокументУОР_ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//В общем случае не проверяем заполненность реквизитов при записи
	//проверка необходимых реквизитов проходит при отправке документа
	//в случае необходимости можно указать реквизиты проверки отдельно
	//в процедуре ДокументУОР_ОбработкаПроверкиЗаполнения
	ПроверяемыеРеквизиты.Очистить();
	
	ОбработкаОбменИСМПТ = ИнтеграцияИСМПТКПовтИсп.ОбработкаОбменИСМПТ();
	ОбработкаОбменИСМПТ.ДокументУОР_ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	ОбработкаОбменИСМПТ = ИнтеграцияИСМПТКПовтИсп.ОбработкаОбменИСМПТ();
	ОбработкаОбменИСМПТ.ДокументУОР_ПередУдалением(ЭтотОбъект, Отказ);	
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	ОбработкаОбменИСМПТ = ИнтеграцияИСМПТКПовтИсп.ОбработкаОбменИСМПТ();
	ОбработкаОбменИСМПТ.ДокументУОР_ПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
	
КонецПроцедуры

#КонецЕсли
