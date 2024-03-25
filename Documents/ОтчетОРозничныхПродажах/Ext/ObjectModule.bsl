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

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		//ЗаполнитьПоДокументуОснования(ДанныеЗаполнения);
		Возврат;
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(), "Продажа");
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда 
		Контрагент = Справочники.Контрагенты.ПолучитьРозничногоКонтрагента();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДоговорКонтрагента) Тогда 
		ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПолучитьДоговорРозничногоКонтрагента(Контрагент, Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента.ТипЦен) Тогда 
		ТипЦен = ДоговорКонтрагента.ТипЦен;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Касса) И ЗначениеЗаполнено(Организация) Тогда 
		Касса = Справочники.Кассы.КассаПоУмолчанию(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПользовательУправляетСчетамиУчета = СчетаУчетаВДокументахВызовСервераПовтИсп.ПользовательУправляетСчетамиУчета();
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	ПараметрыПострочнойПроверки   = Новый Структура("ПроверятьЗаполнениеСчетаУчетаНУ", Товары.Количество() > 0 И ПользовательУправляетСчетамиУчета);
	
	Если Товары.Количество() > 0 
		ИЛИ Услуги.Количество() > 0 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги");		
		
	КонецЕсли;
	
	Если Товары.Количество() = 0 Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	Если НЕ УчетнаяПолитикаСервер.ПлательщикНалогаНаПрибыль(Организация, Дата)
		ИЛИ НЕ УчитыватьКПН Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетДоходовНУ");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетСписанияСебестоимостиНУ");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СчетДоходовНУ");
		
		ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеСчетаУчетаНУ", Ложь);
		
	КонецЕсли;
	
	Если НЕ ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНДС(Организация, Дата)
		ИЛИ НЕ УчитыватьНДС Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.НДСВидОперацииРеализации");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СтавкаНДС");
		
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.НДСВидОперацииРеализации");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
		
	КонецЕсли;
	
	// !!! Нужно ли заполнять для Услуг?
	МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетУчетаБУ");
	МассивНепроверяемыхРеквизитов.Добавить("Услуги.СчетУчетаБУ");
	// !!!

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	//проверим построчно заполнение ТМЗ
	ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеСчетаУчетаНДС", УчитыватьНДС И ПользовательУправляетСчетамиУчета);
	ПроверитьЗаполнениеТабличнойЧастиПострочно(Товары, "Товары", Отказ, ПараметрыПострочнойПроверки);
	
	//проверим построчно заполнение Услуг	
	ПараметрыПострочнойПроверки.Очистить();
	ПараметрыПострочнойПроверки = Новый Структура("ПроверятьЗаполнениеСчетаУчетаНДС, ПользовательУправляетСчетамиУчета", Истина, ПользовательУправляетСчетамиУчета);
	ПроверитьЗаполнениеТабличнойЧастиПострочно(Услуги, "Услуги", Отказ, ПараметрыПострочнойПроверки);
	
	Если УчитыватьАкциз Тогда
		ВыполнитьПроверкиСвязанныеСАкцизомВТабличнойЧасти(Товары, "Товары", Отказ, ПользовательУправляетСчетамиУчета);
	КонецЕсли;
	
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, Новый Соответствие);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Если НЕ ЗначениеЗаполнено(ОбменДанными.Отправитель) Тогда
			Возврат;
		ИначеЕсли ОбменДанными.Отправитель.Метаданные() <> Метаданные.ПланыОбмена.ОбменРозницаБухгалтерияПредприятия30 
			И ОбменДанными.Отправитель.Метаданные() <> Метаданные.ПланыОбмена.ОбменУправлениеТорговлейБухгалтерияПредприятия30 Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда 
		Контрагент = Справочники.Контрагенты.ПолучитьРозничногоКонтрагента();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДоговорКонтрагента) Тогда 
		ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПолучитьДоговорРозничногоКонтрагента(Контрагент, Организация);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда 
		ВалютаДокумента = Константы.ВалютаРегламентированногоУчета.Получить();
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И НомераГТДСервер.ВедетсяУчетПоТоварамОрганизаций(Дата) Тогда
		ТаблицаДокумента = НомераГТДСервер.ПодготовитьТаблицуТоваровСУчетомСкладовВТЧ(Товары, Истина, Склад);
		ТаблицаНомераГТД = НомераГТДСервер.ПодготовитьТаблицуНомеровГТД(ТаблицаДокумента, НомераГТД.Выгрузить());
		НомераГТДСервер.ЗаполнитьТаблицуНомераГТД(ЭтотОбъект,ТаблицаДокумента, ТаблицаНомераГТД);
	КонецЕсли;
		
	СуммаДокумента = УчетНДСИАкциза.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Товары") + УчетНДСИАкциза.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Услуги");
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УчетНДСИАкциза.СинхронизацияПометкиНаУдалениеУСчетаФактуры(ЭтотОбъект, "СчетФактураВыданный", Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(),,, ОбъектКопирования.Ссылка);

	Если ЗначениеЗаполнено(ОбъектКопирования.НомераГТД) Тогда
		НомераГТД.Очистить();
	КонецЕсли;  	
	
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
	
	ПараметрыПроведения = Документы.ОтчетОРозничныхПродажах.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	// Таблица списанных товаров
	ТаблицаСписанныеТовары = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ПараметрыПроведения.ТаблицаТовары,
			ПараметрыПроведения.Реквизиты, Отказ);
			
		// Таблица взаиморасчетов с учетом зачета авансов
	ТаблицаВзаиморасчеты = УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ЗачетАвансовТаблицаДокумента, ПараметрыПроведения.ЗачетАвансовРеквизиты, Отказ);
	
	// Таблицы выручки от реализации: собственных товаров и услуг
	ТаблицыРеализация = УчетДоходовРасходов.ПодготовитьТаблицыВыручкиОтРеализации(
		ПараметрыПроведения.РеализацияТаблицаДокумента, ТаблицаВзаиморасчеты,
		ПараметрыПроведения.Реквизиты, Отказ);
		
	ОбщегоНазначенияБКВызовСервера.ДобавитьКолонкуВТаблицуЗначений(ТаблицаВзаиморасчеты, "НомерЖурнала", НСтр("ru = 'АВ'"));
	
	Документы.ОтчетОРозничныхПродажах.ДобавитьКолонкуСодержание(ТаблицыРеализация.СобственныеТоварыУслуги);
	
	ТаблицаРеализацияТМЗ = УчетТоваров.ПодготовитьТаблицуРеализацияТМЗ(
		ТаблицаСписанныеТовары, ПараметрыПроведения.РеализацияТаблицаДокумента,
		ПараметрыПроведения.Реквизиты, Отказ);
		
	//КОНТРОЛЬ ПО РЕГИСТРУ "ТОВАРЫ ОРГАНИЗАЦИЙ
	НомераГТДСервер.ВыполнитьКонтрольТоварыОрганизаций(ПараметрыПроведения.ТаблицаТоварыОрганизаций,ПараметрыПроведения.Реквизиты, , Отказ);
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ  	
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ТаблицаСписанныеТовары,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Товары организаций
	НомераГТДСервер.СформироватьДвиженияТоварыОрганизаций(ПараметрыПроведения.ТаблицаТоварыОрганизаций,ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияРеализация(
		ТаблицыРеализация.СобственныеТоварыУслуги, ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетНДСИАкциза.СформироватьДвиженияРеализацияАктивовУслуг(ПараметрыПроведения.ТаблицаНДС, Неопределено,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	//Сформировать движения переноса задолженности по безналичным платежам
	СформироватьДвиженияПоПлатежам(ПараметрыПроведения.Платежи, ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	
	УчетТоваров.СформироватьДвиженияРеализацияТМЗ(ТаблицаРеализацияТМЗ, Движения, Отказ);
	

		// Отражение ПР в НУ 
	ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетНДСИАкциза.СинхронизацияПризнакаПроведенияУСчетаФактуры(Ссылка, Отказ, Истина, "СчетФактураВыданный");
	
КонецПроцедуры

Процедура СформироватьДвиженияПоПлатежам(ТаблицаПлатежей, Реквизиты, Движения, Отказ)
	
	РеквизитыДокумента = Реквизиты[0];
	
	Если ТаблицаПлатежей = Неопределено Или ТаблицаПлатежей.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ТаблицаПлатежей Цикл
		
		Проводка = Движения.Типовой.Добавить();
		
		Проводка.Период       = СтрокаТаблицы.Период;
		Проводка.Организация  = СтрокаТаблицы.Организация;
		Проводка.Сумма        = СтрокаТаблицы.СуммаПроводки;
		Проводка.Содержание   = СтрокаТаблицы.Содержание;
		
		Проводка.СчетДт = СтрокаТаблицы.СчетДт;
		
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, СтрокаТаблицы.СубконтоДт1);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, СтрокаТаблицы.СубконтоДт2);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, СтрокаТаблицы.СубконтоДт3);
		
		Проводка.СчетКт = СтрокаТаблицы.СчетКт;
		
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, СтрокаТаблицы.СубконтоКт1);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, СтрокаТаблицы.СубконтоКт2);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 3, СтрокаТаблицы.СубконтоКт3);
		
		ПроцедурыБухгалтерскогоУчета.УстановитьПодразделенияПроводки(
		Проводка, СтрокаТаблицы.СтруктурноеПодразделение, СтрокаТаблицы.СтруктурноеПодразделение);
		
		СвойстваСчетаДт = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетДт);
		
		Если СвойстваСчетаДт.Валютный Тогда 
			Проводка.ВалютаДт        = СтрокаТаблицы.ВалютаДокумента;
			Проводка.ВалютнаяСуммаДт = СтрокаТаблицы.СуммаПроводки;
		КонецЕсли;
		
		СвойстваСчетаКт = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетКт);
		
		Если СвойстваСчетаКт.Валютный Тогда 
			Проводка.ВалютаКт        = СтрокаТаблицы.ВалютаДокумента;
			Проводка.ВалютнаяСуммаКт = СтрокаТаблицы.СуммаПроводки;
		КонецЕсли;
		
		Если РеквизитыДокумента.НеобходимостьОтраженияВНУ Тогда
			
			ПроводкаНУ = Движения.Налоговый.Добавить();

			ПроводкаНУ.Период       = РеквизитыДокумента.Период;
			ПроводкаНУ.Организация  = РеквизитыДокумента.Организация;
			
			ПроводкаНУ.Сумма = СтрокаТаблицы.СуммаПроводки;

			ПроводкаНУ.СчетДт = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПреобразоватьСчетаБУвСчетНУ(
			Новый Структура("СчетБУ", Проводка.СчетДт));

			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетДт, ПроводкаНУ.СубконтоДт, 1, СтрокаТаблицы.СубконтоДт1);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетДт, ПроводкаНУ.СубконтоДт, 2, СтрокаТаблицы.СубконтоДт2);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетДт, ПроводкаНУ.СубконтоДт, 3, СтрокаТаблицы.СубконтоДт3);
						
			ПроводкаНУ.СчетКт = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПреобразоватьСчетаБУвСчетНУ(
			Новый Структура("СчетБУ", Проводка.СчетКт));

			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетКт, ПроводкаНУ.СубконтоКт, 1, СтрокаТаблицы.СубконтоКт1);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетКт, ПроводкаНУ.СубконтоКт, 2, СтрокаТаблицы.СубконтоКт2);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетКт, ПроводкаНУ.СубконтоКт, 3, СтрокаТаблицы.СубконтоКт3);

			ПроцедурыБухгалтерскогоУчета.УстановитьПодразделенияПроводки(
				ПроводкаНУ, РеквизитыДокумента.СтруктурноеПодразделение, РеквизитыДокумента.СтруктурноеПодразделение);
				
			ПроводкаНУ.Содержание = СтрокаТаблицы.Содержание;

			ПроцедурыНалоговогоУчета.ВидУчетаНУ(ПроводкаНУ, РеквизитыДокумента.ВидУчетаНУ);			
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	УчетНДСИАкциза.СинхронизацияПризнакаПроведенияУСчетаФактуры(Ссылка, Отказ, Ложь, "СчетФактураВыданный");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПроверитьЗаполнениеТабличнойЧастиПострочно(ПроверяемаяТабличнаячасть, ИмяТабличнойЧасти, Отказ, ПараметрыПроверки)
	
	Для Каждого СтрокаТабличнойЧасти Из ПроверяемаяТабличнаячасть Цикл
		
		Если СтрокаТабличнойЧасти.Количество < 0 Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В колонке ""Количество"" нельзя указывать отрицательные значения в строке %1 списка %2'"),
			 СтрокаТабличнойЧасти.НомерСтроки,?(ИмяТабличнойЧасти = "Товары", "ТМЗ", ИмяТабличнойЧасти));
			Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Количество";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);			
		КонецЕсли;

		Если ПараметрыПроверки.Свойство("ПроверятьЗаполнениеСчетаУчетаНДС") И ПараметрыПроверки.ПроверятьЗаполнениеСчетаУчетаНДС
			И УчетНДСиАкцизаВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС) <> 0 И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаНДСПоРеализации) Тогда
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Счет НДС'"),
				СтрокаТабличнойЧасти.НомерСтроки, ?(ИмяТабличнойЧасти = "Товары", "ТМЗ", ИмяТабличнойЧасти));
			Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетУчетаНДСПоРеализации";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если ПараметрыПроверки.Свойство("ПроверятьЗаполнениеСчетаУчетаНУ") И ПараметрыПроверки.ПроверятьЗаполнениеСчетаУчетаНУ
			И ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаБУ) И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаНУ) 
			И НЕ ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТабличнойЧасти.СчетУчетаБУ).Забалансовый Тогда
			
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Счет учета (НУ)'"),
				СтрокаТабличнойЧасти.НомерСтроки, ?(ИмяТабличнойЧасти = "Товары", "ТМЗ", ИмяТабличнойЧасти));
			Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетУчетаНУ";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьПроверкиСвязанныеСАкцизомВТабличнойЧасти(ПроверяемаяТабличнаячасть, ИмяТабличнойЧасти, Отказ, ПользовательУправляетСчетамиУчета)
	
	Если ПроверяемаяТабличнаячасть.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаДокумента", ПроверяемаяТабличнаячасть);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки,
	|	ТаблицаДокумента.Номенклатура,
	|	ТаблицаДокумента.СтавкаАкциза,
	|	ТаблицаДокумента.СуммаАкциза,
	|	ТаблицаДокумента.АкцизВидОперацииРеализации,
	|	ТаблицаДокумента.СчетУчетаАкцизаПоРеализации
	|ПОМЕСТИТЬ ВТ_ТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК ТаблицаДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТаблицаДокумента.НомерСтроки,
	|	ВТ_ТаблицаДокумента.Номенклатура,
	|	ВТ_ТаблицаДокумента.СтавкаАкциза,
	|	ЕстьNULL(ВТ_ТаблицаДокумента.СуммаАкциза, 0) КАК СуммаАкциза,
	|	ВТ_ТаблицаДокумента.АкцизВидОперацииРеализации,
	|	ВТ_ТаблицаДокумента.СчетУчетаАкцизаПоРеализации,
	|	СправочникНоменклатура.ВидПодакцизногоТМЗ,
	|	ЕстьNULL(СтавкиАкциза.Ставка, 0) КАК Ставка
	|ИЗ
	|	ВТ_ТаблицаДокумента КАК ВТ_ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ВТ_ТаблицаДокумента.Номенклатура = СправочникНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтавкиАкциза КАК СтавкиАкциза
	|		ПО ВТ_ТаблицаДокумента.СтавкаАкциза = СтавкиАкциза.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		
		ПутьКСтрокеТЧ = ИмяТабличнойЧасти + "[" + Формат(Выборка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "]";
		Если (ЗначениеЗаполнено(Выборка.ВидПодакцизногоТМЗ) ИЛИ Выборка.СуммаАкциза <> 0) И НЕ ЗначениеЗаполнено(Выборка.СтавкаАкциза) Тогда 
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Ставка акциза'"),
				Выборка.НомерСтроки, ?(ИмяТабличнойЧасти = "Товары", "ТМЗ", ИмяТабличнойЧасти));
			Поле = ПутьКСтрокеТЧ + ".СтавкаАкциза";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Выборка.ВидПодакцизногоТМЗ) И ЗначениеЗаполнено(Выборка.СтавкаАкциза) Тогда 
			ТекстСообщения = НСтр("ru='Необходимо очистить ставку акциза или указать ""Вид подакцизного товара"" у номенклатуры'");
			Поле = ПутьКСтрокеТЧ + ".СтавкаАкциза";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.СтавкаАкциза) И НЕ ЗначениеЗаполнено(Выборка.АкцизВидОперацииРеализации) Тогда 
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Вид реализации (акциз)'"),
				Выборка.НомерСтроки, ?(ИмяТабличнойЧасти = "Товары", "ТМЗ", ИмяТабличнойЧасти));
			Поле = ПутьКСтрокеТЧ + ".АкцизВидОперацииРеализации";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.СтавкаАкциза) И НЕ ЗначениеЗаполнено(Выборка.СчетУчетаАкцизаПоРеализации) И ПользовательУправляетСчетамиУчета Тогда 
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Счет акциза'"),
				Выборка.НомерСтроки, ?(ИмяТабличнойЧасти = "Товары", "ТМЗ", ИмяТабличнойЧасти));
			Поле = ПутьКСтрокеТЧ + ".СчетУчетаАкцизаПоРеализации";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли