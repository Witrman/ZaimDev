﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	
	ОбновитьПредставлениеЭлемента("СпособОтраженияВБухучете");

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	// Проверка правильности настройки вида расчета
	РезультатПроверки = ПроведениеРасчетовСервер.ПроверитьНастройкуВидаРасчета(ТекущийОбъект, Отказ);

	Если НЕ Отказ Тогда
		ЗаписатьКодСтрокиДекларации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Обновляем информацию о коде строк Декларации по ИПН и СН
	Оповестить("Запись_КодыСтрокДекларацииПоИПНиСН", ПараметрыЗаписи, Объект.Ссылка);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "ПланВидовРасчета.УдержанияОрганизаций.Форма.ФормаВыбора" Тогда
		
		Для Каждого СтрокаМассива Из ВыбранноеЗначение Цикл
			
			СтрокаВидыРасчета = Объект.КомпенсируемыеРасчетомОтОбратногоВидыУдержаний.Добавить();	
			СтрокаВидыРасчета.ВидРасчета = СтрокаМассива;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ФормаВыбораИзКлассификатора") Тогда
		
			Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда 
				МенеджерЗаписиКодСтрокиДекларации.КодСтроки = ВыбранноеЗначение;
			Иначе 
				МенеджерЗаписиКодСтрокиДекларации.КодСтроки		  = ВыбранноеЗначение.КодСтроки;
			КонецЕсли;
			
		РасшифровкаКодСтрокиДекларацииСН = ВыбранноеЗначение.Наименование;
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_КодыСтрокДекларацииПоСН"
		И ТипЗнч(Параметр) = Тип("Структура")
		И Параметр.Свойство("ИмяЭлемента")
		И Параметр.ИмяЭлемента = "МенеджерЗаписиКодСтрокиДекларацииКодСтроки" Тогда
		 УстановитьКодСтрокиДекларацииПоСН();
	 КонецЕсли;	
	 
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СпособРасчетаПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОтраженияВБухучетеПриИзменении(Элемент)
	
	ОбновитьПредставлениеЭлемента("СпособОтраженияВБухучете");
	
КонецПроцедуры

&НаКлиенте
Процедура МенеджерЗаписиКодСтрокиДекларацииКодСтрокиПриИзменении(Элемент)
	
	ОбновитьПредставлениеЭлемента("КодСтрокиДекларацииСН");
	
КонецПроцедуры

&НаКлиенте
Процедура МенеджерЗаписиКодСтрокиДекларацииКодСтрокиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора"		  , Истина);
	ПараметрыФормы.Вставить("ИмяМакета"			  , "КодыСтрокНалоговыхДеклараций");
	ПараметрыФормы.Вставить("ИмяСекции"			  ,	"СН");
	ПараметрыФормы.Вставить("ПолучатьПолныеДанные", Истина);
	ПараметрыФормы.Вставить("ТекущийКодСтроки"	  , ?(НЕ ЗначениеЗаполнено(МенеджерЗаписиКодСтрокиДекларации.КодСтроки), Неопределено, СокрЛП(МенеджерЗаписиКодСтрокиДекларации.КодСтроки)));
	
	ФормаВыбораКода = ОткрытьФорму("ОбщаяФорма.ФормаВыбораИзКлассификатора", ПараметрыФормы, ЭтаФорма, Истина);
	
	ФормаВыбораКода.Открыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ 

&НаКлиенте
Процедура ВключаемыеВРасчетОтОбратногоВидыНачисленийОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Для Каждого СтрокаМассива Из ВыбранноеЗначение Цикл
		
		СтрокаВидыРасчета = Объект.ВключаемыеВРасчетОтОбратногоВидыНачислений.Добавить();	
		СтрокаВидыРасчета.ВидРасчета = СтрокаМассива;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура БазовыеВидыРасчетаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Для Каждого СтрокаМассива Из ВыбранноеЗначение Цикл
		
		СтрокаВидыРасчета = Объект.БазовыеВидыРасчета.Добавить();	
		СтрокаВидыРасчета.ВидРасчета = СтрокаМассива;
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура История(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		ТекстВопроса = НСтр("ru = 'Для просмотра истории необходимо записать элемент.
									|Записать?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОЗаписиЭлемента", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	КонецЕсли;
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		ПараметрыФормы = Новый Структура("Отбор", Новый Структура("ВидРасчета", Объект.Ссылка));
		ОткрытьФорму("РегистрСведений.КодыСтрокДекларацииПоСН.ФормаСписка", ПараметрыФормы, ЭтаФорма, Истина, ЭтаФорма.Окно);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборВидыРасчета(Команда)
	
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",		ИспользованиеГруппИЭлементов.Элементы);
	
	ОткрытьФорму("ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ФормаВыбора", ПараметрыФормы, Элементы.БазовыеВидыРасчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборВключаемыеНачисления(Команда)
	
	ПараметрыФормы= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",ИспользованиеГруппИЭлементов.Элементы);

	ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных();
	ЭлементОтбора = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СпособРасчета");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	
	МассивСпособовРасчета = Новый Массив;
	МассивСпособовРасчета.Добавить(ПредопределенноеЗначение("Перечисление.СпособыРасчетаОплатыТруда.Процентом"));
	МассивСпособовРасчета.Добавить(ПредопределенноеЗначение("Перечисление.СпособыРасчетаОплатыТруда.ПоМесячнойТарифнойСтавкеОтОбратного"));
	МассивСпособовРасчета.Добавить(ПредопределенноеЗначение("Перечисление.СпособыРасчетаОплатыТруда.ПоМесячнойТарифнойСтавкеОтОбратногоПоДням"));
	МассивСпособовРасчета.Добавить(ПредопределенноеЗначение("Перечисление.СпособыРасчетаОплатыТруда.ПоМесячнойТарифнойСтавкеОтОбратногоПоЧасам"));

	ЭлементОтбора.ПравоеЗначение = Новый ФиксированныйМассив(МассивСпособовРасчета);

	ПараметрыФормы.Вставить("ФиксированныеНастройки", ФиксированныеНастройки);

	ОткрытьФорму("ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ФормаВыбора", ПараметрыФормы, Элементы.ВключаемыеВРасчетОтОбратногоВидыНачислений);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборИПН(Команда)
	
	ИндивидуальныйПодоходныйНалог = ПредопределенноеЗначение("Справочник.НалогиСборыОтчисления.ИндивидуальныйПодоходныйНалог");
	Объект.КомпенсируемыеРасчетомОтОбратногоВидыУдержаний.Добавить().ВидРасчета = ИндивидуальныйПодоходныйНалог;

КонецПроцедуры

&НаКлиенте
Процедура ПодборОПВ(Команда)

	ОбязательныеПенсионныеВзносы = ПредопределенноеЗначение("Справочник.НалогиСборыОтчисления.ОбязательныеПенсионныеВзносы");
	Объект.КомпенсируемыеРасчетомОтОбратногоВидыУдержаний.Добавить().ВидРасчета = ОбязательныеПенсионныеВзносы;

КонецПроцедуры

&НаКлиенте
Процедура ПодборУдержанияОрганизаций(Команда)
	
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",		ИспользованиеГруппИЭлементов.Элементы);
	
	МассивСпособовРасчета = Новый Массив;
	МассивСпособовРасчета.Добавить(ПредопределенноеЗначение("Перечисление.СпособыРасчетаОплатыТруда.ФиксированнойСуммой"));
	МассивСпособовРасчета.Добавить(ПредопределенноеЗначение("Перечисление.СпособыРасчетаОплатыТруда.Процентом"));

	ПараметрыФормы.Вставить("Отбор", 							Новый Структура("СпособРасчета", Новый ФиксированныйМассив(МассивСпособовРасчета)));

	ОткрытьФорму("ПланВидовРасчета.УдержанияОрганизаций.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	Если Параметры.Ключ.Пустая() Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.ВидПремии) Тогда
			Объект.ВидПремии 		 = Перечисления.ВидыПремии.НеПремия;
		КонецЕсли;	
		Если НЕ ЗначениеЗаполнено(Объект.УчетЗаработкаПриРасчетеСреднего) Тогда
			Объект.УчетЗаработкаПриРасчетеСреднего = Перечисления.СоставныеЧастиЗаработкаДляРасчетаСреднего.ИндексируемыйЗаработок;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.ОблагаетсяИПН) Тогда
			Объект.ОблагаетсяИПН 	 = Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.ОблагаетсяОПВ) Тогда
			Объект.ОблагаетсяОПВ	 = Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.ОблагаетсяСН) Тогда
			Объект.ОблагаетсяСН	 = Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.ОблагаетсяСО) Тогда
			Объект.ОблагаетсяСО	 = Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.ОблагаетсяОППВ) Тогда
			Объект.ОблагаетсяОППВ	 = Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом;
		КонецЕсли; 
		Если НЕ ЗначениеЗаполнено(Объект.ОблагаетсяОПВР) Тогда
			Объект.ОблагаетсяОПВР	 = Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.ОблагаетсяВОСМС) Тогда
			Объект.ОблагаетсяВОСМС	 = Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.ОблагаетсяООСМС) Тогда
			Объект.ОблагаетсяООСМС	 = Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.ОблагаетсяЕП) Тогда
			Объект.ОблагаетсяЕП	 	 = Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом;
		КонецЕсли;

	КонецЕсли;
	
	// Доступные способы расчета
	НовыеПараметры = Новый Массив;
	
	// Доступные способы отражения в учете ИПН и ОПВ
	СпособыОбложенияИПНиОПВ = Новый СписокЗначений;
	СпособыОбложенияИПНиОПВ.Добавить(Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом);
	СпособыОбложенияИПНиОПВ.Добавить(Справочники.СпособыНалогообложенияДоходов.НеОблагаетсяЦеликом);
	
	НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", СпособыОбложенияИПНиОПВ.ВыгрузитьЗначения()));
	Элементы.ОблагаетсяИПН.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);
	Элементы.ОблагаетсяОПВ.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);

	// Доступные способы отражения в учете СН
	СпособыОбложенияСН = Новый СписокЗначений;
	СпособыОбложенияСН.Добавить(Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом);
	СпособыОбложенияСН.Добавить(Справочники.СпособыНалогообложенияДоходов.НеОблагаетсяЦеликом);
	
	НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", СпособыОбложенияСН.ВыгрузитьЗначения()));
	Элементы.ОблагаетсяСН.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);

	// Доступные способы отражения в учете СО
	СпособыОбложенияСО = Новый СписокЗначений;
	СпособыОбложенияСО.Добавить(Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом);
	СпособыОбложенияСО.Добавить(Справочники.СпособыНалогообложенияДоходов.НеОблагаетсяЦеликом);
	
	НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", СпособыОбложенияСО.ВыгрузитьЗначения()));
	Элементы.ОблагаетсяСО.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);
	
	// Доступные способы отражения в учете ОППВ
	СпособыОбложенияОППВ = Новый СписокЗначений;
	СпособыОбложенияОППВ.Добавить(Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом);
	СпособыОбложенияОППВ.Добавить(Справочники.СпособыНалогообложенияДоходов.НеОблагаетсяЦеликом);
	
	НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", СпособыОбложенияОППВ.ВыгрузитьЗначения()));
	Элементы.ОблагаетсяОППВ.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);
	
	// Доступные способы отражения в учете ОПВР
	СпособыОбложенияОПВР = Новый СписокЗначений;
	СпособыОбложенияОПВР.Добавить(Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом);
	СпособыОбложенияОПВР.Добавить(Справочники.СпособыНалогообложенияДоходов.НеОблагаетсяЦеликом);
	
	НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", СпособыОбложенияОПВР.ВыгрузитьЗначения()));
	Элементы.ОблагаетсяОПВР.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);
	
	// Доступные способы отражения в учете ВОСМС
	СпособыОбложенияВОСМС = Новый СписокЗначений;
	СпособыОбложенияВОСМС.Добавить(Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом);
	СпособыОбложенияВОСМС.Добавить(Справочники.СпособыНалогообложенияДоходов.НеОблагаетсяЦеликом);
	
	НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", СпособыОбложенияВОСМС.ВыгрузитьЗначения()));
	Элементы.ОблагаетсяВОСМС.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);
	
	// Доступные способы отражения в учете ООСМС
	СпособыОбложенияООСМС = Новый СписокЗначений;
	СпособыОбложенияООСМС.Добавить(Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом);
	СпособыОбложенияООСМС.Добавить(Справочники.СпособыНалогообложенияДоходов.НеОблагаетсяЦеликом);
	
	НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", СпособыОбложенияООСМС.ВыгрузитьЗначения()));
	Элементы.ОблагаетсяООСМС.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);
	
	// Доступные способы отражения в учете ЕП
	СпособыОбложенияЕП = Новый СписокЗначений;
	СпособыОбложенияЕП.Добавить(Справочники.СпособыНалогообложенияДоходов.ОблагаетсяЦеликом);
	СпособыОбложенияЕП.Добавить(Справочники.СпособыНалогообложенияДоходов.НеОблагаетсяЦеликом);
	
	НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", СпособыОбложенияЕП.ВыгрузитьЗначения()));
	Элементы.ОблагаетсяЕП.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);
	
	// Для предопределённых элементов запрещено редактирование способа расчета 
	Элементы.СпособРасчета.Доступность = НЕ Объект.Предопределенный;
	
	Если НЕ Параметры.Ключ.Пустая() Тогда
		УстановитьКодСтрокиДекларацииПоСН()
	КонецЕсли;
	
	// Доступные способы расчета
	НовыеПараметры = Новый Массив;
	СписокОсновныхСпособовРасчета = ПроведениеРасчетовСервер.ПолучитьСписокОсновныхВариантовНачисленийОрганизации();
	НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", СписокОсновныхСпособовРасчета));
	Элементы.СпособРасчета.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);

	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаОплатыТруда.ПоМесячнойТарифнойСтавкеОтОбратного")
			ИЛИ Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаОплатыТруда.ПоМесячнойТарифнойСтавкеОтОбратногоПоДням")
			ИЛИ Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаОплатыТруда.ПоМесячнойТарифнойСтавкеОтОбратногоПоЧасам") Тогда
			
		Элементы.ГруппаРасчетОтОбратного.Видимость   = Истина;
		Элементы.ГруппаБазовыеВидыРасчета.Видимость  = Ложь;
		
	Иначе                             
		
		Элементы.ГруппаРасчетОтОбратного.Видимость    = Ложь;
		Элементы.ГруппаБазовыеВидыРасчета.Видимость   = Истина;
		
	КонецЕсли;
			
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставлениеЭлемента(ИмяОбновляемогоЭлемента, ЕстьЗаписьВРегистре = Ложь)
	
	Если ИмяОбновляемогоЭлемента = "СпособОтраженияВБухучете" Тогда
		
		РасшифровкаОтражениеВБухучете = Справочники.СпособыОтраженияЗарплатыВРеглУчете.ПолучитьПредставлениеСпособаОтраженияНачисленияВУчетах(Объект.СпособОтраженияВБухучете);
		
	КонецЕсли;
	
	Если ИмяОбновляемогоЭлемента = "КодСтрокиДекларацииСН" Тогда
		
		Если ПустаяСтрока(СтрЗаменить(МенеджерЗаписиКодСтрокиДекларации.КодСтроки, ".", "")) Тогда
			РасшифровкаКодСтрокиДекларацииСН = ?(ЕстьЗаписьВРегистре, НСтр("ru ='<Прочие доходы, значение не указано.>'"), НСтр("ru ='<Доходы работников (общеустановленный режим), по умолчанию>'")) ;
		Иначе
			
			Если МакетКодовСтрок.ВысотаТаблицы = 0 Тогда
				МакетКодовСтрок    = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_КодыСтрокНалоговыхДеклараций");
			КонецЕсли;
			
			ОбластьСтрокСН     = МакетКодовСтрок.Области.Найти("СН");     
			ОбластьДополнительныхСтрок = МакетКодовСтрок.Области.Найти("СН_200");
			
			Если ОбластьДополнительныхСтрок = Неопределено Тогда
				НаименованиеСтроки = РегламентированнаяОтчетность.ПолучитьНаименованиеСтрокиКлассификатораПоКоду(МакетКодовСтрок, ОбластьСтрокСН, МенеджерЗаписиКодСтрокиДекларации.КодСтроки);
				
			Иначе	
                КодДополнительнойСтроки = Прав(МенеджерЗаписиКодСтрокиДекларации.КодСтроки, СтрДлина(МенеджерЗаписиКодСтрокиДекларации.КодСтроки) - 2);
                Если КодДополнительнойСтроки <> "" Тогда
                    НаименованиеСтроки = РегламентированнаяОтчетность.ПолучитьНаименованиеСтрокиКлассификатораПоКоду(МакетКодовСтрок, ОбластьДополнительныхСтрок, КодДополнительнойСтроки);
                Иначе
                    НаименованиеСтроки = РегламентированнаяОтчетность.ПолучитьНаименованиеСтрокиКлассификатораПоКоду(МакетКодовСтрок, ОбластьСтрокСН, МенеджерЗаписиКодСтрокиДекларации.КодСтроки);
                КонецЕсли; 
            КонецЕсли;
			
			Если ПустаяСтрока(НаименованиеСтроки) Тогда
				РасшифровкаКодСтрокиДекларацииСН = НСтр("ru ='строка с кодом " + СокрЛП(МенеджерЗаписиКодСтрокиДекларации.КодСтроки) + " не найдена.'");
			Иначе
				РасшифровкаКодСтрокиДекларацииСН = НаименованиеСтроки;
            КонецЕсли;

			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьКодСтрокиДекларации()
	
	Если Не ЗначениеЗаполнено(МенеджерЗаписиКодСтрокиДекларации.КодСтроки) Тогда
		Возврат
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(МенеджерЗаписиКодСтрокиДекларации.ВидРасчета) Тогда
		Возврат
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПериодДанныхРегистра) Тогда
		ПериодДанныхРегистра = '19000101'; 
	Иначе
		ПериодДанныхРегистра = ОбщегоНазначения.ТекущаяДатаПользователя(); 
	КонецЕсли; 
	
	ЗначенияРесурсов = РегистрыСведений.КодыСтрокДекларацииПоСН.ПолучитьПоследнее(ПериодДанныхРегистра, Новый Структура("ВидРасчета", МенеджерЗаписиКодСтрокиДекларации.ВидРасчета));
	Если ЗначенияРесурсов.КодСтроки = МенеджерЗаписиКодСтрокиДекларации.КодСтроки Тогда
		Возврат
	КонецЕсли;
	
	НаборЗаписейКодСтрокиДекларации = РегистрыСведений.КодыСтрокДекларацииПоСН.СоздатьМенеджерЗаписи();
	
	ЗаполнитьЗначенияСвойств(НаборЗаписейКодСтрокиДекларации, МенеджерЗаписиКодСтрокиДекларации);
	НаборЗаписейКодСтрокиДекларации.Период = ПериодДанныхРегистра;
	
	Попытка
		НаборЗаписейКодСтрокиДекларации.Записать(Истина);
	Исключение
		Отказ = Истина;
		ТекстСообщения = НСтр("ru='Элемент """ + СокрЛП(Объект.Ссылка) + """ не записан. Не записана информация о коде строки для Декларации по СН.'");;
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , "Объект", Отказ);
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОЗаписиЭлемента(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЭтаФорма.Записать();
	КонецЕсли;
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		ПараметрыФормы = Новый Структура("Отбор", Новый Структура("ВидРасчета", Объект.Ссылка));
		ОткрытьФорму("РегистрСведений.КодыСтрокДекларацииПоСН.ФормаСписка", ПараметрыФормы, ЭтаФорма, Истина, ЭтаФорма.Окно);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
 Процедура УстановитьКодСтрокиДекларацииПоСН()
	 
	 ТаблицаРегистра = РегистрыСведений.КодыСтрокДекларацииПоСН.СрезПоследних(ОбщегоНазначения.ТекущаяДатаПользователя(), Новый Структура("ВидРасчета", Объект.Ссылка));
	 
	 ЕстьЗаписьВРегистре = Ложь;
	 
	 Если ТаблицаРегистра.Количество()> 0 Тогда
		 ПериодДанныхРегистра = ТаблицаРегистра[0].Период;
		 МенеджерЗаписиКодСтрокиДекларации.КодСтроки = ТаблицаРегистра[0].КодСтроки;
		 ЕстьЗаписьВРегистре = Истина;
	 КонецЕсли; 
	 
	 МенеджерЗаписиКодСтрокиДекларации.ВидРасчета = Объект.Ссылка;

	 МенеджерЗаписиКодСтрокиДекларации.Период = ПериодДанныхРегистра;
	 ОбновитьПредставлениеЭлемента("КодСтрокиДекларацииСН", ЕстьЗаписьВРегистре);

 КонецПроцедуры
