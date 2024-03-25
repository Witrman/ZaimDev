﻿
#Область ПрограммныйИнтерфейс

// Определяет значения счетов в строке табличной части или шапке документа.
// Предназначена для неконтекстных вызовов в форме документа при изменении реквизитов, от которых зависят счета учета.
// Вызывать следует только тогда, когда известно, что заполнять - нужно.
//
// Параметры:
//  МенеджерДокумента			 - ДокументМенеджер - менеджер заполняемого документа. 
//                                 Должен соответствовать требованиям, описанным в ЗаполнениеВнеФормы модуля СчетаУчетаВДокументах
//  КЗаполнению					 - Соответствие - Содержит полные имена реквизитов, которые нужно заполнить
//  Контекст					 - Структура - содержит данные шапки заполняемого документа, необходимые для заполнения
//  ИмяТабличнойЧасти			 - Строка - имя заполняемой табличной части
//  ДанныеСтроки				 - Структура - содержит данные заполняемой строки табличной части, необходимые для заполнения
//  ВозвращатьТолькоИзмененные	 - Булево - позволяет 
// 		- при неконтекстных вызовах сократить данные, передаваемые с сервера
// 		- при контекстных - сократить время выполнения за счет отказа от вычисления измененных значений
// Возвращаемое значение:
//  Структура - измененные реквизиты; Ключ - имя реквизита (для табличных частей не включает имя табличной части!)
Функция ЗаполнитьРеквизитыПриИзменении(Знач ИмяДокумента, Знач КЗаполнению, Знач ДанныеОбъекта, Знач ИмяТабличнойЧасти = "", Знач ДанныеСтроки = Неопределено) Экспорт
	
	Возврат СчетаУчетаВДокументах.ЗаполнитьРеквизитыПриИзменении(Документы[ИмяДокумента], КЗаполнению, ДанныеОбъекта, ИмяТабличнойЧасти, ДанныеСтроки);
	
КонецФункции

#КонецОбласти
