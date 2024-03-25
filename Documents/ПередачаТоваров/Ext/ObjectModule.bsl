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
	
	УчетТоваров.ЗаполнитьНаборыПоОрганизацииСтрутурномуПодразделениюСкладу(ЭтотОбъект, Таблица, "Организация", "СтруктурноеПодразделение", "Склад");
	
КонецПроцедуры

#КонецОбласти

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	// Проверка заполнения табличной части "Товары"
	Если ВидОперации <> Перечисления.ВидыОперацийПередачаТоваров.ВПереработку Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетУчетаБУ");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетУчетаНУ");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетПередачиБУ");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетПередачиНУ");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
		
	КонецЕсли;
	
	//ОрганизацияПлательщикНалогаНаПрибыль 			= ПолучитьФункциональнуюОпцию("ПлательщикКПН", Новый Структура("Организация, Период", Организация, Дата));
	ОрганизацияПлательщикНалогаНаПрибыль 			= УчетнаяПолитикаСервер.ПлательщикНалогаНаПрибыль(Организация, Дата);
	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль 	= ОрганизацияПлательщикНалогаНаПрибыль И ПроцедурыНалоговогоУчета.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль(Организация, Дата);
	
	// Проверка заполнения табличной части "Товары"
	//Если НЕ УчитыватьКПН ИЛИ (НЕ ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль ИЛИ НЕ ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ) Тогда 		
	Если НЕ ОрганизацияПлательщикНалогаНаПрибыль
		ИЛИ НЕ УчитыватьКПН
		ИЛИ (НЕ ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль
			ИЛИ НЕ ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ) Тогда 		
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетУчетаНУ");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетПередачиНУ");
		МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
		
	КонецЕсли;
    
	//Если НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
	//	МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
	//КонецЕсли;
    
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, Новый Соответствие);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(),,, ОбъектКопирования.Ссылка);

	Если ЗначениеЗаполнено(ОбъектКопирования.НомераГТД) Тогда
		НомераГТД.Очистить();
	КонецЕсли;  	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
    
	//РаботаСДоговорамиКонтрагентов.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);
    
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И НомераГТДСервер.ВедетсяУчетПоТоварамОрганизаций(Дата) Тогда
		ТаблицаДокумента = НомераГТДСервер.ПодготовитьТаблицуТоваровСУчетомСкладовВТЧ(Товары, Истина, Склад);
		ТаблицаНомераГТД = НомераГТДСервер.ПодготовитьТаблицуНомеровГТД(ТаблицаДокумента, НомераГТД.Выгрузить());
		НомераГТДСервер.ЗаполнитьТаблицуНомераГТД(ЭтотОбъект,ТаблицаДокумента, ТаблицаНомераГТД);
	КонецЕсли;
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ПередачаТоваров.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
				
	//КОНТРОЛЬ ПО РЕГИСТРУ "ТОВАРЫ ОРГАНИЗАЦИЙ
	НомераГТДСервер.ВыполнитьКонтрольТоварыОрганизаций(ПараметрыПроведения.ТаблицаТоварыОрганизаций,ПараметрыПроведения.Реквизиты, , Отказ);

	// Товары организаций
	НомераГТДСервер.СформироватьДвиженияТоварыОрганизаций(ПараметрыПроведения.ТаблицаТоварыОрганизаций,ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	Если ВидОперации <> Перечисления.ВидыОперацийПередачаТоваров.ВПереработку  Тогда
		Возврат;
	КонецЕсли;

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	// Таблица списанных товаров
	ТаблицаСписанныеТовары = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ПараметрыПроведения.СписаниеТоваровТаблицаТовары,
			ПараметрыПроведения.Реквизиты, Отказ);
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ	
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ТаблицаСписанныеТовары,
			ПараметрыПроведения.Реквизиты, Движения, Отказ);
			
			
	// Отражение ПР в НУ 
	ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(ПараметрыПроведения.Реквизиты, Движения, Отказ);

КонецПроцедуры // ОбработкаПроведения()


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ	

#КонецЕсли

