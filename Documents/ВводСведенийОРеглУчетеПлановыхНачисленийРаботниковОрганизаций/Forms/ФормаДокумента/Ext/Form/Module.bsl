﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ПодготовитьФормуНаСервере();
		РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// РедактированиеДокументовПользователей
	ПраваДоступаКОбъектам.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец РедактированиеДокументовПользователей
	
	ПодготовитьФормуНаСервере();
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.СотрудникиОрганизаций.Форма.ФормаСписка" Тогда
		
		Для Каждого СтрокаМассива Из ВыбранноеЗначение Цикл
			Если Объект.ОсновныеНачисления.НайтиСтроки(Новый Структура("Сотрудник", СтрокаМассива)).Количество() = 0 Тогда
				СтрокаРаботники = Объект.ОсновныеНачисления.Добавить();	
				СтрокаРаботники.Сотрудник = СтрокаМассива;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.СпособыОтраженияЗарплатыВРеглУчете.Форма.ФормаВыбора" Тогда
		
		Для Каждого СтрокаМассива Из Объект.ОсновныеНачисления Цикл
			СтрокаМассива.СпособОтраженияВБухучете = ВыбранноеЗначение[0];
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияБККлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "Документ ""ввод сведений о регл. учете плановых начислений сотрудников организаций"" (проведение)";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизация) Тогда 
		Объект.Организация = Неопределено;
		Объект.СтруктурноеПодразделение = Неопределено;
	Иначе 
		Результат = РаботаСДиалогамиКлиент.ПроверитьИзменениеЗначенийОрганизацииСтруктурногоПодразделения(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение);
		Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
			СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Объект.Организация, Объект.СтруктурноеПодразделение, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	Если ТекущийДокументОснование = Объект.ДокументОснование Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ТекстВопроса = НСтр("ru='Заполнить текущий документ данными документа-основания?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПриИзмененииДокументОснование", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	КонецЕсли;
	ТекущийДокументОснование = Объект.ДокументОснование;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ОсновныеНачисления

&НаКлиенте
Процедура ОсновныеНачисленияСотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Истина);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	
	ОбработчикОповещения = Новый ОписаниеОповещения("СписокСотрудниковСписокЗавершениеВыбора", ЭтотОбъект);

	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, Элемент,,,,ОбработчикОповещения, Режим);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ


&НаКлиенте
Процедура Подбор(Команда)

	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",		ИспользованиеГруппИЭлементов.Элементы);
	ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;

	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, ЭтаФорма, , , ,,Режим)

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоСпискуСотрудников(Команда)
	
	Если Объект.ОсновныеНачисления.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Табличная часть будет полностью перезаполнена. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаЗаполнитьПоСпискуСотрудников", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДокументу(Команда)
	
	Если Объект.ОсновныеНачисления.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Табличная часть будет полностью перезаполнена. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаЗаполнитьПоДокументу", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВсемОдинаковыйСпособОтражения(Команда)
	
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Истина);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",		ИспользованиеГруппИЭлементов.Элементы);
	
	ОткрытьФорму("Справочник.СпособыОтраженияЗарплатыВРеглУчете.ФормаВыбора", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();

	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	
	ОбщегоНазначенияБК.УстановитьТекстАвтора(НадписьАвтор, Объект.Автор);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБККлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
КонецПроцедуры 

&НаСервере
Процедура СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(СтруктураПараметров = Неопределено)
	
	Если СтруктураПараметров = Неопределено 
		ИЛИ (СтруктураПараметров.Свойство("НеобходимоИзменитьЗначенияРеквизитовОбъекта") 
				И СтруктураПараметров.НеобходимоИзменитьЗначенияРеквизитовОбъекта) Тогда 
		РаботаСДиалогами.СтруктурноеПодразделениеПриИзменении(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктураПараметров);
	КонецЕсли;
	
	ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров,Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Параметры) Экспорт
	
	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
		ПриИзмененииЗначенияОрганизацииСервер(Результат,Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров,СтруктураРезультатаВыполнения)
	
	Если НЕ СтруктураПараметров.ИзмененаОрганизация И НЕ СтруктураПараметров.ИзмененоСтруктурноеПодразделение Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьФункциональныеОпцииФормы();
	
	СтруктураРезультатаВыполнения = Неопределено;
	
	РаботаСДиалогами.ПриИзмененииЗначенияОрганизации(Объект,,СтруктураРезультатаВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаЗаполнитьПоСпискуСотрудников(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;

	Объект.ОсновныеНачисления.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаЗаполнитьПоДокументу(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	Объект.ОсновныеНачисления.Очистить();

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаПриИзмененииДокументОснование(Результат, Параметры) Экспорт
	
	Если НЕ Результат = КодВозвратаДиалога.Да Тогда
		Возврат;	
	КонецЕсли;

	Объект.ОсновныеНачисления.Очистить();
	
	ПослеЗакрытияВопросаПриИзмененииДокументОснованиеНаСервере();

КонецПроцедуры

&НаСервере
Процедура ПослеЗакрытияВопросаПриИзмененииДокументОснованиеНаСервере()
	
	ИсходныеДанные = Новый Структура("Организация, СтруктурноеПодразделение");
	ЗаполнитьЗначенияСвойств(ИсходныеДанные, Объект);
	
	ЗаполнитьПоДокументуОснованиюНаСервере();
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("ИзмененаОрганизация", ИсходныеДанные.Организация <> Объект.Организация);
	ПараметрыОбработки.Вставить("ИзмененоСтруктурноеПодразделение", ИсходныеДанные.СтруктурноеПодразделение <> Объект.СтруктурноеПодразделение);
	ПараметрыОбработки.Вставить("ОчищатьНекорректныеЗначения", Истина);
	
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);

	ПриИзмененииЗначенияОрганизацииСервер(ПараметрыОбработки, Неопределено);

	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДокументуОснованиюНаСервере()

	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ПриемНаРаботуВОрганизацию") Тогда

		Документы.ВводСведенийОРеглУчетеПлановыхНачисленийРаботниковОрганизаций.ЗаполнитьПоПриемНаРаботуВОрганизацию(Объект, Объект.ДокументОснование);
		
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.КадровоеПеремещениеОрганизаций") Тогда
		
		Документы.ВводСведенийОРеглУчетеПлановыхНачисленийРаботниковОрганизаций.ЗаполнитьПоКадровоеПеремещениеОрганизаций(Объект, Объект.ДокументОснование);
		
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ОтражениеЗарплатыВРеглУчете") Тогда
		
		Документы.ВводСведенийОРеглУчетеПлановыхНачисленийРаботниковОрганизаций.ЗаполнитьПоОтражениеЗарплатыВРеглУчете(Объект, Объект.ДокументОснование);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудниковСписокЗавершениеВыбора(ВыбранноеЗначение, Параметры) Экспорт

	ТекущаяСтрока = Элементы.ОсновныеНачисления.ТекущиеДанные;
	Если  ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		ТекущаяСтрока.Сотрудник = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

