﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если НЕ ИспользоватьОтборПоОрганизациям Тогда
		Организации.Очистить();
	КонецЕсли;
	РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	Если НЕ ЗначениеЗаполнено(РежимВыгрузкиОбъектов) тогда
		РежимВыгрузкиОбъектов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
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