﻿////////////////////////////////////////////////////////////////////////////////
// ПроцедурыУправленияПерсоналомКлиентСервер
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

//Функция раскладывает строку с данными о месте рождения на элементы структуры
//
// Параметры
//  СтрокаМестоРождения - строка - текстовое представление места рождения
//  ВерхнийРегистр 		- булево - преобразовать в верхний регистр
//
// Возвращаемое значение
//  Структура - возвращается структура наименований по типам населенных пунктов
//
Функция РазложитьМестоРождения(Знач СтрокаМестоРождения, ВерхнийРегистр = Истина) Экспорт

	НаселенныйПункт		= "";
	Район				= "";
	Область				= "";
	Страна				= "";
	МассивМестоРождения	= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(?(ВерхнийРегистр, Врег(СтрокаМестоРождения), СтрокаМестоРождения));
	ЭлементовВМассиве	= МассивМестоРождения.Количество();   
	
	Если ЭлементовВМассиве	>	0	тогда
		НаселенныйПункт	=	СокрЛП(МассивМестоРождения[0]);
	КонецЕсли;
	
	Если ЭлементовВМассиве	>	1	тогда
		Район	=	СокрЛП(МассивМестоРождения[1]);
	КонецЕсли;
	
	Если ЭлементовВМассиве	>	2	тогда
		Область	=	СокрЛП(МассивМестоРождения[2]);
	КонецЕсли;
	
	Если ЭлементовВМассиве	>	3	тогда
		Страна	=	СокрЛП(МассивМестоРождения[3]);
	КонецЕсли;

	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("НаселенныйПункт",НаселенныйПункт);
	СтруктураВозврата.Вставить("Район",Район);
	СтруктураВозврата.Вставить("Область",Область);
	СтруктураВозврата.Вставить("Страна",Страна);
	
	Возврат СтруктураВозврата;
	
КонецФункции // РазложитьМестоРождения()

//Возвращает строковое представление места рождения
//
Функция ПредставлениеМестаРождения(Знач СтрокаМестоРождения) Экспорт

	СтруктураМестоРождения = РазложитьМестоРождения(СтрокаМестоРождения, Ложь);
	
	Представление	= "" + ?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.НаселенныйПункт),		"",	НСтр("ru = 'Населенный пункт: '") + СокрЛП(СтруктураМестоРождения.НаселенныйПункт))
	+?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.Район),	"",	НСтр("ru = ', район: '") + СокрЛП(СтруктураМестоРождения.Район))
	+?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.Область),	"",	НСтр("ru = ', область: '")	+	СокрЛП(СтруктураМестоРождения.Область))
	+?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.Страна),	"",	НСтр("ru = ', страна: '")	+	СокрЛП(СтруктураМестоРождения.Страна));
	
	Если Лев(Представление, 1) = ","  Тогда
		Представление = ВРег(Сред(Представление, 3, 1)) + Сред(Представление, 4);
	КонецЕсли;

	Возврат Представление;
	
КонецФункции // ПредставлениеМестаРождения()

// Функция определяет пол физлица по его отчеству. 
//
Функция УстановитьПол(ОтчествоРаботника) Экспорт

	Если НРег(Прав(ОтчествоРаботника, 2)) = "ич" Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ПолФизическихЛиц.Мужской");
	ИначеЕсли НРег(Прав(ОтчествоРаботника, 2)) = "на" Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ПолФизическихЛиц.Женский");
	КонецЕсли; 

	Возврат ПредопределенноеЗначение("Перечисление.ПолФизическихЛиц.ПустаяСсылка");

КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ