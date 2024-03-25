﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Префиксация объектов"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обработчик события "При получении номера на печать".
// Событие возникает перед стандартной обработкой получения номера.
// В обработчике можно переопределить стандартное поведение системы при формировании номера на печать.
//
// Пример реализации кода обработчика:
// 
//	НомерОбъекта = ПрефиксацияОбъектовКлиентСервер.УдалитьПользовательскиеПрефиксыИзНомераОбъекта(НомерОбъекта);
//	СтандартнаяОбработка = Ложь;
// 
// Параметры:
//  НомерОбъекта         - Строка - номер или код объекта, который обрабатывается
//  Источник             - ДокументСсылка, СправочникСсылка, ДокументОбъект, СправочникОбъект - объект информационной базы, либо ссылка на него
//  СтандартнаяОбработка – Булево – флаг стандартной обработки; если установить значение флага в Ложь,
//									то стандартная обработка формирования номера на печать выполняться не будет
//  ПредставлениеНомераОбъекта - ПеречислениеСсылка.ВидыПредставленийНомеровДокументов - представление, к которому будет приведен номер объекта
//                                                Указывается только когда требуется переопределить стандартное поведение.
//  СписокПрефиксовУзлов - Массив - массив префиксов узлов РИБ. Если параметр не указан, 
//                                  то получаются значения по-умолчанию, иначе используются переданные значения.
//                                  Указывается только когда требуется переопределить стандартное поведение.
// 
Процедура ПриПолученииНомераНаПечать(НомерОбъекта, Источник, СтандартнаяОбработка, ПредставлениеНомераОбъекта = Неопределено, СписокПрефиксовУзлов = Неопределено) Экспорт
	
КонецПроцедуры
