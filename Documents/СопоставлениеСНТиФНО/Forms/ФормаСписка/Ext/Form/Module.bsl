﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)	
	УстановитьБыстрыйОтбор("Организация", ОрганизацияОтбор);
КонецПроцедуры

&НаКлиенте
Процедура СтатусОтборПриИзменении(Элемент)
	УстановитьБыстрыйОтбор("Статус", СтатусОтбор);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьБыстрыйОтбор(ВидЭлемента, ЗначениеЭлемента)
	
	ЭСФКлиентСерверПереопределяемый.ИзменитьЭлементОтбораСписка(Список, ВидЭлемента, ЗначениеЭлемента, ЗначениеЗаполнено(ЗначениеЭлемента));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = СНТКлиентСервер.ИмяСобытияЗаписьСопоставленияСНТиФНО() Тогда
		Элементы.Список.Обновить();
	ИначеЕсли ИмяСобытия = "СопСНТсФНО_ПроверятьОповещенияФоновогоЗадания"
		И ЭтаФорма.КлючУникальности = Источник Тогда
		
		СНТКлиентПереопределяемый.ОбработкаОповещенияСНТ_ПроверятьОповещенияФоновогоЗадания(ЭтаФорма, Параметр);
		Элементы.Список.Обновить();
	КонецЕсли;

КонецПроцедуры

