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

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		Документы.РеализацияУслугПоПереработке.ЗаполнитьПоДокументуОснованию(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);	
	Иначе
		СуммаВключаетНДС = Истина;
	КонецЕсли;

	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	
	Если Не ЗначениеЗаполнено(СпособВыпискиАктовВыполненныхРабот) Тогда		
		СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.ВБумажномВиде;		
	КонецЕсли;    

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив();

    Если НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
    КонецЕсли;
    
	Если ЭтотОбъект.Услуги.Количество() > 0 
		ИЛИ ЭтотОбъект.МатериалыЗаказчика.Количество() > 0
		ИЛИ ЭтотОбъект.УчастникиСовместнойДеятельности.Количество() > 0 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Услуги");
		МассивНепроверяемыхРеквизитов.Добавить("МатериалыЗаказчика");
		МассивНепроверяемыхРеквизитов.Добавить("УчастникиСовместнойДеятельности");
		
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

	ПараметрыПострочнойПроверки   = Новый Структура("ПроверятьЗаполнениеСчетаУчетаНУ", Услуги.Количество() > 0);
	
	Если НЕ ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата)
		ИЛИ НЕ УчитыватьКПН Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СчетДоходовНУ");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СчетСписанияСебестоимостиНУ");
		
		ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеСчетаУчетаНУ", Ложь);
		
	КонецЕсли;
	
	Если НЕ ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНДС(Организация, Дата)
		ИЛИ НЕ УчитыватьНДС Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.НДСВидОперацииРеализации");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если УчитыватьНДС ИЛИ ПараметрыПострочнойПроверки.ПроверятьЗаполнениеСчетаУчетаНУ Тогда 
		ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеСчетаУчетаНДС", УчитыватьНДС);
		ПроверитьЗаполнениеТабличнойЧастиПострочно(Услуги, "Услуги", Отказ, ПараметрыПострочнойПроверки);
	КонецЕсли;

	Если Не ЗначениеЗаполнено(СпособВыпискиАктовВыполненныхРабот) Тогда		
		СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.ВБумажномВиде;		
	КонецЕсли; 

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
		
	Если СпособВыпискиАктовВыполненныхРабот <> Перечисления.СпособыВыпискиАктовВыполненныхРабот.НаПорталеГосЗакупа 
		И СпособВыпискиАктовВыполненныхРабот <> Перечисления.СпособыВыпискиАктовВыполненныхРабот.НаПорталеИСЭСФ Тогда
		ДатаПодписанияГЗ = Дата;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
    
    РаботаСДоговорамиКонтрагентов.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);
	
	// Свойство ЗакрыватьФорму используется при проведении из формы документа
	Если ДополнительныеСвойства.Свойство("ЗакрыватьФорму") Тогда
		ДополнительныеСвойства.Удалить("ЗакрыватьФорму");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаПодписанияГЗ) И НЕ СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.ВБумажномВиде Тогда
		
		Если  РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			
			РежимЗаписи    = ?(Проведен, РежимЗаписиДокумента.ОтменаПроведения, РежимЗаписиДокумента.Запись);	
			Если СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.НаПорталеИСЭСФ Тогда
				
				ТекстСообщения =
				НСтр("ru = 'Проведение документа, выставленного на портале ИС ЭСФ возможно только после заполнения ""Даты подписания"". Документ будет записан без проведения'");
				
			ИначеЕсли СпособВыпискиАктовВыполненныхРабот = Перечисления.СпособыВыпискиАктовВыполненныхРабот.НаПорталеГосЗакупа Тогда
				ТекстСообщения =
				НСтр("ru = 'Проведение документа, выставленного на портале Гос.закупа возможно только после заполнения ""Даты подписания"". Документ будет записан без проведения'");
			КонецЕсли;
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДатаПодписанияГЗ", "Объект", Ложь);
			ДополнительныеСвойства.Вставить("ЗакрыватьФорму", Ложь);
		КонецЕсли;
		
	КонецЕсли;

	УчетНДСИАкциза.ОчиститьДанныеПоУчастникамСовместнойДеятельности(ЭтотОбъект, ДоговорКонтрагента);
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДСИАкциза.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Услуги");
	
	УчетНДСИАкциза.СинхронизацияПометкиНаУдалениеУСчетаФактуры(ЭтотОбъект,, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//синхронизируем данные счет-фактуры и документа основания
	УчетНДСИАкциза.СинхронизироватьДанныеДокументаИСчетаФактуры(ЭтотОбъект, Отказ, "СчетФактураВыданный"); 		
	Если Отказ Тогда
		ТекстСообщения = НСтр("ru = 'Документ не записан ...'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
				
		
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.РеализацияУслугПоПереработке.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ

	// Таблица взаиморасчетов с учетом зачета авансов
	ТаблицаВзаиморасчеты = УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ЗачетАвансовТаблицаДокумента, ПараметрыПроведения.ЗачетАвансовРеквизиты, Отказ);
		
	// Таблицы выручки от реализации: собственных товаров и услуг
	ТаблицыРеализация = УчетДоходовРасходов.ПодготовитьТаблицыВыручкиОтРеализации(
		ПараметрыПроведения.РеализацияТаблицаДокумента, ТаблицаВзаиморасчеты,
		ПараметрыПроведения.Реквизиты, Отказ);
						
	ОбщегоНазначенияБКВызовСервера.ДобавитьКолонкуВТаблицуЗначений(ТаблицаВзаиморасчеты, "НомерЖурнала", НСтр("ru = 'АВ'"));
	Документы.РеализацияУслугПоПереработке.ДобавитьКолонкуСодержание(ТаблицыРеализация.СобственныеТоварыУслуги);
	
	ТаблицаДокументаРеализацияТМЗ =
		Документы.РеализацияУслугПоПереработке.ПодготовитьТаблицуДокументаРеализация(ПараметрыПроведения.РеализацияТаблицаДокумента);
	
	ОпределятьДоходОтРеализацииПоКурсуАванса = УчетнаяПолитикаСервер.ОпределятьДоходОтРеализацииПоКурсуАванса(ПараметрыПроведения.Реквизиты[0].Организация, ПараметрыПроведения.Реквизиты[0].Период);
	Если ОпределятьДоходОтРеализацииПоКурсуАванса Тогда
		ТаблицаРеализацияТМЗ = УчетТоваров.ПодготовитьТаблицуРеализацияТМЗ(
			Неопределено, ТаблицыРеализация.СобственныеТоварыУслуги,
			ПараметрыПроведения.Реквизиты, Отказ);
	Иначе
		ТаблицаРеализацияТМЗ = УчетТоваров.ПодготовитьТаблицуРеализацияТМЗ(
			Неопределено, ТаблицаДокументаРеализацияТМЗ,
			ПараметрыПроведения.Реквизиты, Отказ);
	КонецЕсли;
	
	// Таблица списанных материалов давальца
	ТаблицаСписанныеМатериалыЗаказчика = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ПараметрыПроведения.ТаблицаМатериалыЗаказчика,
		ПараметрыПроведения.РеквизитыМатериалыЗаказчика, Отказ);
							
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	УправлениеВзаиморасчетамиСервер.СформироватьДвиженияЗачетАвансов(ТаблицаВзаиморасчеты,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);
		
	УчетДоходовРасходов.СформироватьДвиженияРеализация(
		ТаблицыРеализация.СобственныеТоварыУслуги, ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетТоваров.СформироватьДвиженияРеализацияТМЗ(ТаблицаРеализацияТМЗ, Движения, Отказ);
		
	УчетНДСИАкциза.СформироватьДвиженияРеализацияАктивовУслуг(ПараметрыПроведения.ТаблицаНДС, ПараметрыПроведения.ТаблицаУчастникиСовместнойДеятельности,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетПроизводства.СформироватьДвиженияПлановаяСтоимостьУслугПоПереработке(
		ПараметрыПроведения.ПлановаяСебестоимостьТаблица,
		ПараметрыПроведения.ПлановаяСебестоимостьРеквизиты, 
		Движения, 
		Отказ);
	
	УчетПроизводства.СформироватьДвиженияВыпускПродукцииУслуг(
		ПараметрыПроведения.ВыпускУслугТаблицаБУ,"БухгалтерскийУчет", 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетПроизводства.СформироватьДвиженияВыпускПродукцииУслуг(
		ПараметрыПроведения.ВыпускУслугТаблицаНУ,"НалоговыйУчет", 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ТаблицаСписанныеМатериалыЗаказчика,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УчетНДСИАкциза.СинхронизацияПризнакаПроведенияУСчетаФактуры(Ссылка, Отказ, Истина, "СчетФактураВыданный");
	
	ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	УчетНДСИАкциза.СинхронизацияПризнакаПроведенияУСчетаФактуры(Ссылка, Отказ, Ложь, "СчетФактураВыданный");
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(),,, ОбъектКопирования.Ссылка);
	
	Если ЗначениеЗаполнено(ОбъектКопирования.ДатаПодписанияГЗ) Тогда
		ДатаПодписанияГЗ = Дата(1,1,1);
	КонецЕсли;  
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьПоДокументуОснования(Основание) Экспорт
	
	Документы.РеализацияУслугПоПереработке.ЗаполнитьПоДокументуОснованию(ЭтотОбъект, Основание);
			
КонецПроцедуры

Процедура ПроверитьЗаполнениеТабличнойЧастиПострочно(ПроверяемаяТабличнаячасть, ИмяТабличнойЧасти, Отказ, ПараметрыПроверки)
	
	Для Каждого СтрокаТабличнойЧасти Из ПроверяемаяТабличнаячасть Цикл
		
		Если ПараметрыПроверки.Свойство("ПроверятьЗаполнениеСчетаУчетаНДС") И ПараметрыПроверки.ПроверятьЗаполнениеСчетаУчетаНДС
			И УчетНДСиАкцизаВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС) <> 0 И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаНДСПоРеализации) Тогда
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Счет НДС'"),
				СтрокаТабличнойЧасти.НомерСтроки, ?(ИмяТабличнойЧасти = "Услуги", "ТМЗ", ИмяТабличнойЧасти));
			Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетУчетаНДСПоРеализации";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если ПараметрыПроверки.Свойство("ПроверятьЗаполнениеСчетаУчетаНУ") И ПараметрыПроверки.ПроверятьЗаполнениеСчетаУчетаНУ
			И ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаБУ) И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаНУ) 
			И НЕ ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТабличнойЧасти.СчетУчетаБУ).Забалансовый Тогда
			
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Счет учета (НУ)'"),
				СтрокаТабличнойЧасти.НомерСтроки, ?(ИмяТабличнойЧасти = "Услуги", "ТМЗ", ИмяТабличнойЧасти));
			Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетУчетаНУ";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли



