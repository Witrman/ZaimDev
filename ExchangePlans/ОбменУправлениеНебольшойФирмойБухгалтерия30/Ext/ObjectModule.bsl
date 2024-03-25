﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ЭтоНовый() Тогда
		
		Если НЕ ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
			Организации.Очистить();
		ИначеЕсли Организации.Количество() = 0 И ИспользоватьОтборПоОрганизациям Тогда
			ИспользоватьОтборПоОрганизациям = Ложь;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(РежимВыгрузкиПриНеобходимости) Тогда
			РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);	
	
	Попытка
		Константы.ВедетсяРозничнаяТорговля.Установить(Истина);
		Константы.ВедетсяУчетИмпортныхТоваров.Установить(Истина);
		Константы.ВестиУчетПоДоговорам.Установить(Истина);
		Константы.ИспользоватьВалютныйУчет.Установить(Истина);
		Константы.ИспользоватьКомплектациюНоменклатуры.Установить(Истина);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка при изменении значения константы'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
		
	УстановитьПривилегированныйРежим(Ложь);	
		
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	РегистрыСведений.ПрефиксыИнформационныхБаз.ЗаписатьПрефиксИБ(ЭтотОбъект.Код);
	
КонецПроцедуры

#КонецЕсли
