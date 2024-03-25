﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Если ИспользоватьВнешнююОбработку() Тогда
		ИмяОбработки = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(ПредопределенноеЗначение("Справочник.ДополнительныеОтчетыИОбработки.ОбработкаКлиентБанк"));
		ПараметрыФормы = Новый Структура("", );
		ОткрытьФорму("ВнешняяОбработка." + ИмяОбработки + ".Форма.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	Иначе
		ПараметрыФормы = Новый Структура("", );
		ОткрытьФорму("Обработка.КлиентБанк.Форма.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИспользоватьВнешнююОбработку()
	
	Если Справочники.ДополнительныеОтчетыИОбработки.ОбработкаКлиентБанк.ВнешнийОбъектИспользовать = 1 Тогда
		Возврат Истина;	
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

