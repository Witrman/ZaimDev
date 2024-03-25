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
	
	ОбщегоНазначенияБК.ЗаполнитьНаборыПоОрганизацииСтурктурномуПодразделению(ЭтотОбъект, Таблица, "Организация", "СтруктурноеПодразделение");
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ОрганизацияПлательщикНалогаНаПрибыль 			= ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата);
	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль 	= ОрганизацияПлательщикНалогаНаПрибыль И ПроцедурыНалоговогоУчета.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль(Организация, Дата);
	
	НеобходимостьОтраженияВНУ 						= ОрганизацияПлательщикНалогаНаПрибыль И УчитыватьКПН И (ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль ИЛИ ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ);
    ВестиУчетПоДоговорам                            = ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам");
    
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если НЕ ОрганизацияПлательщикНалогаНаПрибыль ИЛИ НЕ УчитыватьКПН Тогда	
		МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
	КонецЕсли;
	
	Если НЕ НеобходимостьОтраженияВНУ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетДтНУ");
		МассивНепроверяемыхРеквизитов.Добавить("СчетКтНУ");
	КонецЕсли;
	
	Если НЕ (ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.ПереносЗадолженности
		И НЕ ЗначениеЗаполнено(ДоговорКонтрагента)) ИЛИ НЕ ВестиУчетПоДоговорам Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
	КонецЕсли; 

    Если НЕ ВестиУчетПоДоговорам Тогда
        МассивНепроверяемыхРеквизитов.Добавить("СуммыДолга.ДоговорКонтрагента");
    КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.ПроведениеВзаимозачета Тогда
		Если НЕ ИспользоватьВспомогательныйСчет Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СчетДт");
		КонецЕсли;
		
		Если НЕ ИспользоватьВспомогательныйСчет ИЛИ НЕ НеобходимостьОтраженияВНУ Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СчетДтНУ");
		КонецЕсли;        		
		
		МассивНепроверяемыхРеквизитов.Добавить("СчетКт");
		МассивНепроверяемыхРеквизитов.Добавить("СчетКтНУ");
		
	Иначе
		Если НЕ ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.ПереносЗадолженности Тогда
			МассивНепроверяемыхРеквизитов.Добавить("КонтрагентКредитор");
		КонецЕсли;
		
		Если  ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.СписаниеЗадолженности Тогда
			
			Если СуммыДолга.Найти(Перечисления.ВидыЗадолженности.Дебиторская, "ВидЗадолженности") = Неопределено Тогда
				МассивНепроверяемыхРеквизитов.Добавить("СчетДт");
				МассивНепроверяемыхРеквизитов.Добавить("СчетДтНУ");
			КонецЕсли;
			
			Если СуммыДолга.Найти(Перечисления.ВидыЗадолженности.Кредиторская, "ВидЗадолженности") = Неопределено Тогда
				МассивНепроверяемыхРеквизитов.Добавить("СчетКт");
				МассивНепроверяемыхРеквизитов.Добавить("СчетКтНУ");
			КонецЕсли;
		Иначе
			МассивНепроверяемыхРеквизитов.Добавить("СчетДт");
			МассивНепроверяемыхРеквизитов.Добавить("СчетДтНУ");
			МассивНепроверяемыхРеквизитов.Добавить("СчетКт");
			МассивНепроверяемыхРеквизитов.Добавить("СчетКтНУ"); 			
		КонецЕсли;
		
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

	// Если проведение взаимозачета - проверим на совпадение суммы дебиторской и кредиторской задолженности. 
	// Взаимозачет проводится только при полном совпадении сумм
	Если ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.ПроведениеВзаимозачета Тогда
		
		
		ТабСумм = СуммыДолга.Выгрузить(,"ВидЗадолженности, Сумма");
		ТабСумм.Свернуть("ВидЗадолженности", "Сумма");
	
		СуммаДеб  = 0;
		СуммаКред = 0;
		
		Для Каждого СтрокаСумм Из ТабСумм Цикл
			Если  СтрокаСумм.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
				СуммаДеб  = СтрокаСумм.Сумма;
			ИначеЕсли  СтрокаСумм.ВидЗадолженности = Перечисления.ВидыЗадолженности.Кредиторская Тогда
				СуммаКред = СтрокаСумм.Сумма;
			КонецЕсли; 
		КонецЦикла; 
		
		Разница = СуммаДеб - СуммаКред;
		
		Если НЕ Разница = 0 Тогда
			
			ТекстСообщения = НСтр("ru = 'Не совпадают суммы дебиторской и кредиторской задолженности при проведении взаимозачета. Взаимозачет не может быть проведен.
			|Дебиторская задолженность: %1 %2
			|Кредиторская задолженность: %3 %2
			|Разница: %4 %2'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Формат(СуммаДеб, "ЧЦ=15; ЧДЦ=2; ЧН=0,00"), Строка(ВалютаДокумента), Формат(СуммаКред, "ЧЦ=15; ЧДЦ=2; ЧН=-"), Формат(Разница, "ЧЦ=15;ЧДЦ=2"));
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,,, Отказ);
			
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
		
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
		
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
		Возврат;
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.КорректировкаДолга.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ	
	
	// Таблица взаиморасчетов - перенос задолженности
	ТаблицаПереносЗадолженностиДебиторскаяЗадолженность = 
		УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовПогашениеЗадолженности(
		ПараметрыПроведения.ТаблицаПереносЗадолженностиДебиторскаяЗадолженность, 
		ПараметрыПроведения.РеквизитыДебиторскаяЗадолженность, Отказ, "КорректировкаДолга");

	ТаблицаПереносЗадолженностиКредиторскаяЗадолженность = 
		УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовПогашениеЗадолженности(
		ПараметрыПроведения.ТаблицаПереносЗадолженностиКредиторскаяЗадолженность, 
		ПараметрыПроведения.РеквизитыКредиторскаяЗадолженность, Отказ, "КорректировкаДолга");

	
	ТаблицаВзаиморасчетовПереносЗадолженностиДебиторскаяЗадолженность = 
		УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовЗадолженностиКорректировкаДолга(
		ТаблицаПереносЗадолженностиДебиторскаяЗадолженность, 
		ПараметрыПроведения.РеквизитыДебиторскаяЗадолженность, Отказ);
		
	ТаблицаВзаиморасчетовПереносЗадолженностиКредиторскаяЗадолженность = 
		УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовЗадолженностиКорректировкаДолга(
		ТаблицаПереносЗадолженностиКредиторскаяЗадолженность, 
		ПараметрыПроведения.РеквизитыКредиторскаяЗадолженность, Отказ);

	// Таблица взаиморасчетов - списание задолженности
	ТаблицаВзаиморасчетовСписаниеЗадолженностиДебиторскаяЗадолженность = 
		УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовПогашениеЗадолженности(
		ПараметрыПроведения.ТаблицаСписаниеЗадолженностиДебиторскаяЗадолженность, 
		ПараметрыПроведения.РеквизитыДебиторскаяЗадолженность, Отказ, "КорректировкаДолга");
		
	ТаблицаВзаиморасчетовСписаниеЗадолженностиКредиторскаяЗадолженность = 
		УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовПогашениеЗадолженности(
		ПараметрыПроведения.ТаблицаСписаниеЗадолженностиКредиторскаяЗадолженность, 
		ПараметрыПроведения.РеквизитыКредиторскаяЗадолженность, Отказ, "КорректировкаДолга");
	
		
	// Таблица взаиморасчетов - взаимозачет задолженности
	ТаблицаВзаимозачетЗадолженностиДебиторскаяЗадолженность = 
		УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовПогашениеЗадолженности(
		ПараметрыПроведения.ТаблицаВзаимозачетЗадолженностиДебиторскаяЗадолженность, 
		ПараметрыПроведения.РеквизитыДебиторскаяЗадолженность, Отказ, "КорректировкаДолга");
		
	ТаблицаВзаимозачетЗадолженностиКредиторскаяЗадолженность = 
		УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовПогашениеЗадолженности(
		ПараметрыПроведения.ТаблицаВзаимозачетЗадолженностиКредиторскаяЗадолженность, 
		ПараметрыПроведения.РеквизитыКредиторскаяЗадолженность, Отказ, "КорректировкаДолга");

	СтруктураТаблицВзаимозачета = УправлениеВзаиморасчетамиСервер.ПодготовитьСтруктуруТаблицВзаимозачета(
		ТаблицаВзаимозачетЗадолженностиДебиторскаяЗадолженность, 
		ТаблицаВзаимозачетЗадолженностиКредиторскаяЗадолженность, 
		ПараметрыПроведения.Реквизиты, Отказ);
		
	ТаблицаВзаимозачетаДебиторскаяЗадолженность = СтруктураТаблицВзаимозачета.ТаблицаДебиторскаяЗадолженность;
	ТаблицаВзаимозачетаКредиторскаяЗадолженность = СтруктураТаблицВзаимозачета.ТаблицаКредиторскаяЗадолженность;

		
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	// ПЕРЕНОС ЗАДОЛЖЕННОСТИ
	УправлениеВзаиморасчетамиСервер.СформироватьДвиженияЗадолженностиКорректировкаДолга(
		ТаблицаВзаиморасчетовПереносЗадолженностиДебиторскаяЗадолженность,
		ПараметрыПроведения.РеквизитыДебиторскаяЗадолженность, Движения, Отказ, Истина);
		
	УправлениеВзаиморасчетамиСервер.СформироватьДвиженияЗадолженностиКорректировкаДолга(
		ТаблицаВзаиморасчетовПереносЗадолженностиКредиторскаяЗадолженность,
		ПараметрыПроведения.РеквизитыКредиторскаяЗадолженность, Движения, Отказ, Истина);
		
	// СПИСАНИЕ ЗАДОЛЖЕННОСТИ
	УправлениеВзаиморасчетамиСервер.СформироватьДвиженияЗадолженностиКорректировкаДолга(
		ТаблицаВзаиморасчетовСписаниеЗадолженностиДебиторскаяЗадолженность,
		ПараметрыПроведения.РеквизитыДебиторскаяЗадолженность, Движения, Отказ, ,ПараметрыПроведения.ТаблицаСписаниеЗадолженностиДебиторскаяЗадолженность);
		
	УправлениеВзаиморасчетамиСервер.СформироватьДвиженияЗадолженностиКорректировкаДолга(
		ТаблицаВзаиморасчетовСписаниеЗадолженностиКредиторскаяЗадолженность,
		ПараметрыПроведения.РеквизитыКредиторскаяЗадолженность, Движения, Отказ, ,ПараметрыПроведения.ТаблицаСписаниеЗадолженностиКредиторскаяЗадолженность); 

	// ВЗАИМОЗАЧЕТ ЗАДОЛЖЕННОСТИ 		
	УправлениеВзаиморасчетамиСервер.СформироватьДвиженияЗадолженностиКорректировкаДолга(
		ТаблицаВзаимозачетаДебиторскаяЗадолженность,
		ПараметрыПроведения.РеквизитыДебиторскаяЗадолженность, Движения, Отказ);
		
	УправлениеВзаиморасчетамиСервер.СформироватьДвиженияЗадолженностиКорректировкаДолга(
		ТаблицаВзаимозачетаКредиторскаяЗадолженность,
		ПараметрыПроведения.РеквизитыКредиторскаяЗадолженность, Движения, Отказ);

	// ПЕРЕОЦЕНКА  

	// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	// ПОСТОЯННЫЕ РАЗНИЦЫ  
	ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(ПараметрыПроведения.Реквизиты, Движения, Отказ);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


#КонецЕсли