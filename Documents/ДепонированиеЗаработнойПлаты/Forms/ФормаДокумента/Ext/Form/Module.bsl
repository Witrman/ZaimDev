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
		КлючеваяОперация = "Документ ""депонирование заработной платы"" (проведение)";
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
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <ИМЯ ТАБЛИЦЫ ФОРМЫ>

&НаКлиенте
Процедура ДепонированнаяЗаработнаяПлатаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда
		Если НЕ ЗначениеЗаполнено(Элементы.ДепонированнаяЗаработнаяПлата.ТекущиеДанные.Ведомость) Тогда
			Элементы.ДепонированнаяЗаработнаяПлата.ТекущиеДанные.Ведомость = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа("ДокументСсылка.ЗарплатаКВыплатеОрганизаций");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДепонированнаяЗаработнаяПлатаВедомостьПриИзменении(Элемент)
	
	ДанныеСтрокиТаблицы = Новый Структура("Ведомость, ДепонированнаяСумма");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, Элементы.ДепонированнаяЗаработнаяПлата.ТекущиеДанные);
	
	ПараметрыОбъекта = Новый Структура("Организация, СтруктурноеПодразделение, Дата, Ссылка");
	ЗаполнитьЗначенияСвойств(ПараметрыОбъекта, Объект);
	
	ДепонированнаяЗаработнаяПлатаВедомостьПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ПараметрыОбъекта);
	
	ЗаполнитьЗначенияСвойств(Элементы.ДепонированнаяЗаработнаяПлата.ТекущиеДанные, ДанныеСтрокиТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДепонированнаяЗаработнаяПлатаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НЕ ОтменаРедактирования Тогда
	
		Если НЕ ЗначениеЗаполнено(Объект.Организация) И НЕ Элементы.ДепонированнаяЗаработнаяПлата.ТекущиеДанные.Ведомость=Неопределено Тогда
			Объект.Организация=Элементы.ДепонированнаяЗаработнаяПлата.ТекущиеДанные.Ведомость.Организация;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

/// СтандартныеПодсистемы.ПодключаемыеКоманды
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
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБККлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);

	ОбщегоНазначенияБК.УстановитьТекстАвтора(НадписьАвтор, Объект.Автор);

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

&НаСервере
Процедура  ДепонированнаяЗаработнаяПлатаВедомостьПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ПараметрыОбъекта)

	Запрос = Новый Запрос;

	Запрос.Текст=
	"ВЫБРАТЬ
	|	СУММА(Сумма) КАК Сумма
	|ИЗ
	|	Документ.ЗарплатаКВыплатеОрганизаций.Зарплата КАК ЗарплатаКВыплатеЗарплата
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОВыплатахРаботникамОрганизацийПоПлатежнымВедомостям КАК РанееВыплаченныеСуммы
	|		ПО ЗарплатаКВыплатеЗарплата.ФизЛицо = РанееВыплаченныеСуммы.ФизЛицо 
	|		   И ЗарплатаКВыплатеЗарплата.Ссылка = РанееВыплаченныеСуммы.Ведомость
	|		   И РанееВыплаченныеСуммы.Регистратор <> &парамРегистратор
	|
	|ГДЕ
	|	ЗарплатаКВыплатеЗарплата.Ссылка = &Ссылка И
	|	ЗарплатаКВыплатеЗарплата.ВыплаченностьЗарплаты = &Задепонировано И
	|	РанееВыплаченныеСуммы.ФизЛицо ЕСТЬ NULL
	|";

	Запрос.УстановитьПараметр("Ссылка", ДанныеСтрокиТаблицы.Ведомость);
	Запрос.УстановитьПараметр("Задепонировано",Перечисления.ВыплаченностьЗарплаты.Задепонировано);
	Запрос.УстановитьПараметр("парамРегистратор", ПараметрыОбъекта.Ссылка);


	РезультатЗапроса=Запрос.Выполнить().Выбрать();
	Если РезультатЗапроса.Следующий() Тогда
		
		ДанныеСтрокиТаблицы.ДепонированнаяСумма = РезультатЗапроса.Сумма;
		
	КонецЕсли;

КонецПроцедуры

