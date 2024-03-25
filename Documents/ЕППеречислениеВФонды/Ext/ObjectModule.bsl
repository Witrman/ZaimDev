﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

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
	
	СписокФизЛиц = ЕдиныеПлатежи.ВыгрузитьКолонку("ФизЛицо");
	
	РасчетЗарплатыСервер.ЗаполнитьНаборыПоОрганизацииСтрутурномуПодразделениюСпискуФизЛиц(ЭтотОбъект, Таблица, "Организация", "СтруктурноеПодразделение", СписокФизЛиц);
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
		
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснования(ДанныеЗаполнения);
		Возврат;
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;

	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(ЕдиныеПлатежи);
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналомСервер.ЗаполнитьКраткийСоставДокумента(МассивТЧ, "ФизЛицо");

	// при ручном редактировании строк может возникнуть ситуация, когда период в шапке может отличаться от периода в строках 
	// ЕП перечисляется в рамках одной платежки за один период
	Для Каждого СтрокаЕП Из ЕдиныеПлатежи Цикл

		Если НЕ СтрокаЕП.МесяцНалоговогоПериода = ПериодРегистрации Тогда
			СтрокаЕП.МесяцНалоговогоПериода = ПериодРегистрации;
		КонецЕсли;
		
	КонецЦикла;
	
	СуммаДокумента = ЕдиныеПлатежи.Итог("Сумма");

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, , , , ОбъектКопирования.Ссылка);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ЭтоПеречислениеПлатежа = (ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.Налог
		ИЛИ ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.НалогСам
		ИЛИ ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.НалогАкт);
	
	Если НЕ ЭтоПеречислениеПлатежа Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ЕдиныеПлатежи.СуммаПлатежа");	
		
	КонецЕсли;

	СтруктураПоиска = Новый Структура("ФизЛицо, МесяцНалоговогоПериода");
	
	Для Каждого СтрокаЕП Из ЕдиныеПлатежи Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаЕП);
		ПовторныеСтроки = ЕдиныеПлатежи.НайтиСтроки(СтруктураПоиска);
		
		Если ПовторныеСтроки.Количество() > 1 Тогда
			
			ТекстСообщения = НСтр("ru='В строке номер %1 физическое лицо %2 за один и тот же период указано повторно.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаЕП.НомерСтроки, СтрокаЕП.ФизЛицо);
			
			Поле = "ЕдиныеПлатежи" + "[" + Формат(СтрокаЕП.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].МесяцНалоговогоПериода";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
		КонецЕсли;
		
		Если ЭтоПеречислениеПлатежа И НЕ СтрокаЕП.ВключаетВОСМС И НЕ СтрокаЕП.ВключаетОПВ И НЕ СтрокаЕП.ВключаетИПН
				 И НЕ СтрокаЕП.ВключаетСО И НЕ СтрокаЕП.ВключаетООСМС  И НЕ СтрокаЕП.ВключаетОПВР Тогда
				 
			ТекстСообщения = НСтр("ru='В строке номер %1 физическое лицо %2 не отмечено какие компоненты (ОПВ, ИПН, ВОСМС, СО и т.д.) включены в единый платеж.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаЕП.НомерСтроки, СтрокаЕП.ФизЛицо);
			
			Поле = "ЕдиныеПлатежи" + "[" + Формат(СтрокаЕП.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ВключаетИПН";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				 
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура выполняет заполнение документа по документу-основанию
//
Процедура ЗаполнитьПоДокументуОснования(Основание) Экспорт
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.РасчетПениОПВиСО") Тогда

		Документы.ЕППеречислениеВФонды.ЗаполнитьПоРасчетПениОПВиСО(ЭтотОбъект, Основание);
		
	КонецЕсли;

КонецПроцедуры

#КонецЕсли  
