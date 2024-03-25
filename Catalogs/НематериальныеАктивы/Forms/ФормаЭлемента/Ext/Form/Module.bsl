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
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства	
	
	//обновление наименования строки ТНВЭД
	
	ОбновитьПредставлениеЭлемента("КодСтрокиТНВЭД");

	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства 
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства 

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если  ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.НоменклатураГСВС.Форма.ФормаВыбора") Тогда
		
		УстановитьКодТНВЭД(ВыбранноеЗначение);
		ДобавитьИнформациюОНоменклатуреГСВС();
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);

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
Процедура НаименованиеПриИзменении(Элемент)

	Объект.НаименованиеПолное = Объект.Наименование;	
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура("ФормаВладелец,ИмяРеквизита", ЭтаФорма, "НаименованиеПолное");
	Оповещение = Новый ОписаниеОповещения("НаименованиеПолноеЗавершениеВвода", ЭтотОбъект, ДополнительныеПараметры);
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, Объект.НаименованиеПолное, НСтр("ru='Полное наименование'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеСведенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура("ФормаВладелец,ИмяРеквизита", ЭтаФорма, "ПрочиеСведения");
	Оповещение = Новый ОписаниеОповещения("ПрочиеСведенияЗавершениеВвода", ЭтотОбъект, ДополнительныеПараметры);
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, Объект.ПрочиеСведения, НСтр("ru='Прочие сведения'"));
	
КонецПроцедуры

&НаКлиенте
Процедура КодТНВЭДПриИзменении(Элемент)
	
	ОбновитьПредставлениеЭлемента("КодСтрокиТНВЭД");
	
	УправлениеФормой(ЭтотОбъект)
    	
КонецПроцедуры

&НаКлиенте
Процедура КодТНВЭДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора"		  , Истина);
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ТипКодаГСВС", ПредопределенноеЗначение("Перечисление.ТипыКодовГСВС.ТНВЭД"));
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
	ПараметрыФормы.Вставить("ТекущийКодТНВЭД"	  , ?(НЕ ЗначениеЗаполнено(Объект.КодТНВЭД), Неопределено, СокрЛП(Объект.КодТНВЭД)));
	
	ОткрытьФорму("Справочник.НоменклатураГСВС.ФормаВыбора", ПараметрыФормы, ЭтаФорма, Истина);

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства


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

&НаКлиенте
Процедура НаименованиеПолноеЗавершениеВвода(Строка, Параметры) Экспорт
	
	Если Строка <> Неопределено Тогда
		
		Объект.НаименованиеПолное = Строка;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеСведенияЗавершениеВвода(Строка, Параметры) Экспорт 
	
	Если Строка <> Неопределено Тогда
		
		Объект.ПрочиеСведения = Строка;
		
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
    УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства 

&НаСервере
Процедура ОбновитьПредставлениеЭлемента(ИмяОбновляемогоЭлемента)
	
	Если ИмяОбновляемогоЭлемента = "КодСтрокиТНВЭД" Тогда
		
		Если ПустаяСтрока(СтрЗаменить(Объект.КодТНВЭД, ".", "")) Тогда
			Элементы.ДекорацияРасшифровкаКодСтрокиТНВЭД.Заголовок = НСтр("ru ='<не указано>'");
			Элементы.ДекорацияВедетсяУчетПоТоварамВС.Заголовок = "";
			Элементы.ДекорацияПереченьИзъятия.Заголовок = "";
			Элементы.ДекорацияУникальныйТовар.Заголовок = "";
		Иначе
			ДобавитьИнформациюОНоменклатуреГСВС();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьИнформациюОНоменклатуреГСВС() 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	Запрос.УстановитьПараметр("КодТНВЭД", Объект.КодТНВЭД);
	
	Запрос.Текст = "ВЫБРАТЬ
		|	СведенияОНоменклатуреГСВССрезПоследних.ПризнакУчетаНаВиртуальномСкладе КАК ПризнакУчетаНаВиртуальномСкладе,
		|	СведенияОНоменклатуреГСВССрезПоследних.ПризнакУникальногоТовара КАК ПризнакУникальногоТовара,
		|	СведенияОНоменклатуреГСВССрезПоследних.ПризнакПеречняИзьятий КАК ПризнакПеречняИзьятий,
		|	СпрНоменклатураГСВС.КодГСВС КАК КодТНВЭД,
		|	СпрНоменклатураГСВС.ПолноеНаименованиеRu КАК ПолноеНаименование
		|ИЗ
		|	РегистрСведений.СведенияОНоменклатуреГСВС.СрезПоследних(&Дата, ) КАК СведенияОНоменклатуреГСВССрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураГСВС КАК СпрНоменклатураГСВС
		|		ПО СведенияОНоменклатуреГСВССрезПоследних.НоменклатураГСВС = СпрНоменклатураГСВС.Ссылка
		|ГДЕ
		|	СпрНоменклатураГСВС.КодГСВС = &КодТНВЭД
		|	И СпрНоменклатураГСВС.ТипКодаГСВС = ЗНАЧЕНИЕ(Перечисление.ТипыКодовГСВС.ТНВЭД)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Выборка.ПризнакУчетаНаВиртуальномСкладе Тогда
			Элементы.ДекорацияВедетсяУчетПоТоварамВС.Заголовок = НСтр("ru ='Товар ВС;'");
		Иначе
			Элементы.ДекорацияВедетсяУчетПоТоварамВС.Заголовок = "";
		КонецЕсли;
		Если Выборка.ПризнакПеречняИзьятий Тогда
			Элементы.ДекорацияПереченьИзъятия.Заголовок = НСтр("ru ='Товар входит в перечень изъятий;'");
		Иначе
			Элементы.ДекорацияПереченьИзъятия.Заголовок = "";
		КонецЕсли;
		Если Выборка.ПризнакУникальногоТовара Тогда
			Элементы.ДекорацияУникальныйТовар.Заголовок = НСтр("ru ='Уникальный товар'");
		Иначе
			Элементы.ДекорацияУникальныйТовар.Заголовок = "";
		КонецЕсли;
		Если ПустаяСтрока(Выборка.ПолноеНаименование) Тогда
			Элементы.ДекорацияРасшифровкаКодСтрокиТНВЭД.Заголовок = НСтр("ru ='строка с кодом " + СокрЛП(Объект.КодТНВЭД) + " не найдена.'");
		Иначе
			Элементы.ДекорацияРасшифровкаКодСтрокиТНВЭД.Заголовок = Выборка.ПолноеНаименование;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
		
	Элементы.ДекорацияПереченьИзъятия.Видимость = НЕ (Элементы.ДекорацияПереченьИзъятия.Заголовок = "");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКодТНВЭД(НомеклатураГСВС)
	
	Объект.КодТНВЭД = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НомеклатураГСВС, "КодГСВС");
	
КонецПроцедуры

