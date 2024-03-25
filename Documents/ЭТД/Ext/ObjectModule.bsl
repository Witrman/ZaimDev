﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область УправлениеДоступом

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЭТДСервер.ЗаполнитьНаборыЗначенийДоступа(ЭтотОбъект, Таблица);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЭтотОбъект.Дата = ТекущаяДатаСеанса();
	
	ЭтотОбъект.Автор = ЭТДСервер.ПолучитьТекущегоПользователя();
	
	// формируем ЭТД с учетом данных заполненных на рабочем месте ЭТД
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
	// формируем дополнительное соглашение
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЭТД") Тогда
		
		// обязательные поля доп соглашения
		ЗаполняемыеРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "НомерДоговора, Организация, БИНОрганизации, Сотрудник, ИИНРаботника");
		ЗаполняемыеРеквизиты.Вставить("ЭтоДополнительноеСоглашение", Истина);
		ЗаполняемыеРеквизиты.Вставить("Статус", Перечисления.СтатусыЭТД.Сформирован);
		ЗаполняемыеРеквизиты.Вставить("ИдентификаторОсновногоЭТД", ДанныеЗаполнения.Идентификатор);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗаполняемыеРеквизиты);
		
		ЭтотОбъект.НомерДоговора = ЗаполняемыеРеквизиты.НомерДоговора + "/" + ЭтотОбъект.Номер;
		ЭтотОбъект.ДатаНачала = ТекущаяДатаСеанса();
		ЭтотОбъект.ОсновнойЭТД = ДанныеЗаполнения;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.ДатаНачала) Тогда
		Если ЗначениеЗаполнено(ЭтотОбъект.ДатаЗаключения) Тогда
			ЭтотОбъект.ДатаНачала = ЭтотОбъект.ДатаЗаключения;
		Иначе
			ЭтотОбъект.ДатаНачала = ТекущаяДатаСеанса();
		КонецЕсли;
	КонецЕсли;
	
	// данные организации
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.Организация) Тогда
		ЭтотОбъект.Организация = ЭТДСервер.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЭтотОбъект.Организация) Тогда
		
		Если НЕ ЗначениеЗаполнено(ЭтотОбъект.БИНОрганизации) Тогда
			ЭтотОбъект.БИНОрганизации = ЭТДСервер.БИНОрганизации(ЭтотОбъект.Организация);	
		КонецЕсли;
		
		ПериодДанных = ?(ЗначениеЗаполнено(ЭтотОбъект.ДатаНачала), ЭтотОбъект.ДатаНачала, ТекущаяДатаСеанса());
		ДанныеДляАвтозаполненияЭТД = ЭТДСервер.ПолучитьДанныеДляАвтозаполненияЭТД(ЭтотОбъект.Организация, ПериодДанных);
		
		Для Каждого СтрокаАвтозаполнения Из ДанныеДляАвтозаполненияЭТД Цикл
			
			Если НЕ ЗначениеЗаполнено(ЭтотОбъект[СтрокаАвтозаполнения.Ключ]) Тогда
				ЭтотОбъект[СтрокаАвтозаполнения.Ключ] = СтрокаАвтозаполнения.Значение;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// данные сотрудника
	ДополнительныеДанныеСотрудника = ЭТДСервер.ПолучитьДанныеСотрудника(ЭтотОбъект.ДатаНачала, ЭтотОбъект.Сотрудник);
	
	Если ДополнительныеДанныеСотрудника.Количество() > 0 Тогда
		
		Для Каждого СтрокаДанныхСотрудника Из ДополнительныеДанныеСотрудника Цикл
			
			ЗаполняемыйРеквизит = ЭтотОбъект[СтрокаДанныхСотрудника.Ключ];
			
			Если ТипЗнч(ЗаполняемыйРеквизит) = Тип("Булево") ИЛИ НЕ ЗначениеЗаполнено(ЗаполняемыйРеквизит) Тогда
				
				Если ТипЗнч(СтрокаДанныхСотрудника.Значение) = Тип("ТаблицаЗначений") Тогда
					
					ЭтотОбъект[СтрокаДанныхСотрудника.Ключ].Загрузить(СтрокаДанныхСотрудника.Значение);
					
				Иначе
					
					ЭтотОбъект[СтрокаДанныхСотрудника.Ключ] = СтрокаДанныхСотрудника.Значение;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЭтотОбъект.УсловияТруда.Количество() = 0 Тогда
		УсловияТрудаСтрока = ЭТДСервер.ПолучитьУсловияТрудаПоУмолчанию();
		
		ЭТДКлиентСервер.ЗаполнитьУсловияТруда(УсловияТруда, УсловияТрудаСтрока);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.ДатаЗаключения) Тогда
		Если ЗначениеЗаполнено(ЭтотОбъект.ДатаНачала) Тогда
			ЭтотОбъект.ДатаЗаключения = ЭтотОбъект.ДатаНачала;
		Иначе
			ЭтотОбъект.ДатаЗаключения = ТекущаяДатаСеанса();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Статус.Пустая() Тогда
		Статус = Перечисления.СтатусыЭТД.Сформирован;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЭтотОбъект.Автор = Неопределено;
	ЭтотОбъект.ДокументОснование = Неопределено;
	ЭтотОбъект.Идентификатор = "";
	ЭтотОбъект.НомерДоговора = "";
	ЭтотОбъект.Статус = Перечисления.СтатусыЭТД.ПустаяСсылка();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли