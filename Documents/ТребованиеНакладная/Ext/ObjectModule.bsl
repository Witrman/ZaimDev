﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		Документы.ТребованиеНакладная.ЗаполнитьПоДокументуОснования(ЭтотОбъект, ДанныеЗаполнения);
		Возврат;
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, Константы.ВалютаРегламентированногоУчета.Получить());
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(),,, ОбъектКопирования.Ссылка);

	Если ЗначениеЗаполнено(ОбъектКопирования.НомераГТД) Тогда
		НомераГТД.Очистить();
	КонецЕсли;  	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если НЕ УчитыватьКПН Тогда
		 МассивНепроверяемыхРеквизитов.Добавить("Материалы.СчетНУ");
		 МассивНепроверяемыхРеквизитов.Добавить("СчетЗатратНУ");
		 МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
	КонецЕсли; 
	
	Если Материалы.Количество() > 0 
		И МатериалыЗаказчика.Количество() = 0 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("МатериалыЗаказчика");		
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");		
		
	ИначеЕсли Материалы.Количество() = 0 
		И МатериалыЗаказчика.Количество() > 0 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Материалы");		
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если Материалы.Количество() > 0 Тогда 
		Документы.ТребованиеНакладная.ПроверитьЗаполнениеСтатьиЗатрат(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ВыполненаПроверкаЗаполнения", Истина);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И НомераГТДСервер.ВедетсяУчетПоТоварамОрганизаций(Дата) Тогда
		ТаблицаДокумента = НомераГТДСервер.ПодготовитьТаблицуТоваровСУчетомСкладовВТЧ(Материалы, Истина, Склад);
		ТаблицаНомераГТД = НомераГТДСервер.ПодготовитьТаблицуНомеровГТД(ТаблицаДокумента, НомераГТД.Выгрузить());
		НомераГТДСервер.ЗаполнитьТаблицуНомераГТД(ЭтотОбъект,ТаблицаДокумента, ТаблицаНомераГТД);
	КонецЕсли;


	Если РежимЗаписи = РежимЗаписиДокумента.Проведение 
		И НЕ ДополнительныеСвойства.Свойство("ВыполненаПроверкаЗаполнения") 
		ИЛИ (ДополнительныеСвойства.Свойство("ВыполненаПроверкаЗаполнения") И НЕ ДополнительныеСвойства.ВыполненаПроверкаЗаполнения) Тогда 
		
		Отказ = НЕ ПроверитьЗаполнение();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ТребованиеНакладная.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	ТаблицаСписанныеМатериалы = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ПараметрыПроведения.ТаблицаМатериалы,
		ПараметрыПроведения.Реквизиты, Отказ);
		
	ТаблицаСписанныеМатериалыЗаказчика = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ПараметрыПроведения.ТаблицаМатериалыЗаказчика,
		ПараметрыПроведения.РеквизитыМатериалыЗаказчика, Отказ);
		
	//КОНТРОЛЬ ПО РЕГИСТРУ "ТОВАРЫ ОРГАНИЗАЦИЙ
	НомераГТДСервер.ВыполнитьКонтрольТоварыОрганизаций(ПараметрыПроведения.ТаблицаТоварыОрганизаций,
			ПараметрыПроведения.Реквизиты, , Отказ);

	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	// Товары организаций
	НомераГТДСервер.СформироватьДвиженияТоварыОрганизаций(ПараметрыПроведения.ТаблицаТоварыОрганизаций,
			ПараметрыПроведения.Реквизиты, Движения, Отказ);		
	
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ТаблицаСписанныеМатериалы,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ТаблицаСписанныеМатериалыЗаказчика,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(ПараметрыПроведения.Реквизиты, Движения, Отказ);

КонецПроцедуры

#КонецЕсли