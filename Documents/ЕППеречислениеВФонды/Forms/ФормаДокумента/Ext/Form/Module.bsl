﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Перем УИДЗамераЗаполнения;

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
		РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, Объект.Ссылка, ЭтаФорма);
		
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
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, Объект.Ссылка, ЭтаФорма);	
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
		
	ОбработкаИзмененияПереключенияСправки(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.Ключ.Пустая() И ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		
		СформироватьСписокМесяцевНалоговогоПериода();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.СотрудникиОрганизаций.Форма.ФормаСписка" Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ФизическиеЛица")Тогда
			
			Если Объект.ЕдиныеПлатежи.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение)).Количество() = 0 Тогда
				НоваяСтрока 					= Объект.ЕдиныеПлатежи.Добавить();	
				НоваяСтрока.ФизЛицо 			= ВыбранноеЗначение;
				НоваяСтрока.МесяцНалоговогоПериода = Объект.ПериодРегистрации;
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
			Для Каждого СтрокаМассива Из ВыбранноеЗначение Цикл
				
				Если Объект.ЕдиныеПлатежи.НайтиСтроки(Новый Структура("ФизЛицо", СтрокаМассива)).Количество() = 0 Тогда
					
					НоваяСтрока 					= Объект.ЕдиныеПлатежи.Добавить();	
					НоваяСтрока.ФизЛицо 			= СтрокаМассива;
					НоваяСтрока.МесяцНалоговогоПериода = Объект.ПериодРегистрации;
					
				КонецЕсли;
				
			КонецЦикла;
	
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	КлючеваяОперация = "Документ ""единый платеж перечисление в фонды"" (запись)";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
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
			СтруктураРезультатаВыполнения = Неопределено;
			СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(, СтруктураРезультатаВыполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Объект.Организация, Объект.СтруктурноеПодразделение, Истина);
	
КонецПроцедуры

&НаКлиенте                    
Процедура ПериодРегистрацииПриИзменении(Элемент)	
	
	РаботаСДиалогамиКлиент.ДатаКакМесяцПодобратьДатуПоТексту(МесяцНачисленияСтрокой, Объект.ПериодРегистрации);
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры 

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Объект.ПериодРегистрации = ДобавитьМесяц(Объект.ПериодРегистрации, Направление);
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);
	Модифицированность = Истина;
	УстановитьИмяКнопки(ЭтаФорма);
	ПодготовитьСправкуФормы(ЭтаФорма);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодборТекста(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если Текст = "" Тогда
		Ожидание = 0;
		РаботаСДиалогамиКлиент.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, Объект.ПериодРегистрации, ЭтаФорма, ,Истина);
	Иначе
		РаботаСДиалогамиКлиент.ДатаКакМесяцАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.ДатаКакМесяцОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	УстановитьИмяКнопки(ЭтаФорма);
	ПодготовитьСправкуФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЗакрытьСправкуФормыНажатие(Элемент)
	
	ОтображатьСправкуФормы = НЕ ОтображатьСправкуФормы;
	
	ОбработкаИзмененияПереключенияСправки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПлатежаПриИзменении(Элемент)
	
	Объект.ЕдиныеПлатежи.Очистить();
	ПодготовитьСправкуФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособРасчетаСуммКПеречислениюПриИзменении(Элемент)
	
    Объект.ЕдиныеПлатежи.Очистить();
	ПодготовитьСправкуФормы(ЭтаФорма);
	
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

&НаКлиенте
Процедура ВстроеннаяСправкаПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	РаботаСДиалогамиКлиентСервер.ПолеHTMLДокументаOnClick(Элементы.ВстроеннаяСправка, ДанныеСобытия, ЭтаФорма)
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Единый платеж

&НаКлиенте
Процедура ЕдиныйПлатежФизЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ТекущаяСтрока = Элементы.ЕдиныеПлатежи.ТекущиеДанные;
	Если  ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Истина);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
	ПараметрыФормы.Вставить("ВыбиратьФизЛицо", Истина);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	
	ОбработчикОповещения = Новый ОписаниеОповещения("СписокСотрудниковСписокЗавершениеВыбора", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, Элемент,,,,ОбработчикОповещения, Режим);
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиныеПлатежиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элементы.ЕдиныеПлатежи.ТекущиеДанные;
		ТекущиеДанные.МесяцНалоговогоПериода = Объект.ПериодРегистрации;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПереключениеСправкиФормы(Команда)
	
	ОтображатьСправкуФормы = НЕ ОтображатьСправкуФормы;
	
	ОбработкаИзмененияПереключенияСправки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоЗадолженности(Команда)
	
	Если Объект.ЕдиныеПлатежи.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru= 'Перед заполнением табличная часть будет очищена. Заполнить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередЗаполнениемПоЗадолжности", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		
	Иначе
		
		ЗаполнитьПоЗадолженностиНаКлиенте();
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Рассчитать(Команда)
	
	Если Модифицированность ИЛИ Объект.Ссылка.Пустая() Тогда
		
		ТекстВопроса = НСтр("ru= 'Перед расчетом необходимо записать документ. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередРасчетом", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		 				
	Иначе
		
		РассчитатьНаКлиенте();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)

	ТекстВопроса = НСтр("ru= 'Табличные части будут очищены. Продолжить?'");
	Режим = РежимДиалогаВопрос.ДаНет;
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОбОчисткеТабЧасти", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоСпискуСотрудников(Команда)
	
	Если Объект.ЕдиныеПлатежи.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Табличная часть будет полностью перезаполнена. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаЗаполнитьПоСпискуСотрудников", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)

	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",		ИспользованиеГруппИЭлементов.Элементы);
	ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
	ПараметрыФормы.Вставить("ВыбиратьФизЛицо", Истина);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;

	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, ЭтаФорма, , , ,,Режим)

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
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБККлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	// Заполним реквизит формы МесяцСтрока.
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);
	УстановитьИмяКнопки(ЭтаФорма);

	Если Параметры.Ключ.Пустая() Тогда
		
		Объект.Дата = КонецДня(Объект.Дата);
		Если НЕ ЗначениеЗаполнено(Объект.ВидПлатежа) Тогда
			Объект.ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.Налог;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.СпособРасчетаСуммКПеречислению) Тогда
			Объект.СпособРасчетаСуммКПеречислению = Перечисления.СпособыРасчетаСуммКПеречислениюЕП.ПоЗадолженностиЗаМесяц;
		КонецЕсли;
		
	Иначе
		
		ПроверитьДокументыВведенныеНаОсновании();
		
	КонецЕсли;
	
	УстановитьПараметрыВыбораДокументаОснования(Элементы.ДокументОснование);
	
	ИДКартинки = РаботаСДиалогами.ПолучитьИДКартинки(БиблиотекаКартинок.КартинкаВстроеннойСправкиФормы);
		
	ПодготовитьСправкуФормы(ЭтаФорма);

	// ПоддержкаРаботыСоСтруктурнымиПодразделениями отключен, на момент ввода единого платежа действует только для упрощенки 
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = Ложь;
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
		
	ОбщегоНазначенияБК.УстановитьТекстАвтора(НадписьАвтор, Объект.Автор);
		
КонецПроцедуры

&НаСервере
Процедура ПроверитьДокументыВведенныеНаОсновании()
	
	Если Не Параметры.Ключ.Пустая() Тогда
		Если ОбщегоНазначенияБК.СуществуютПроведенныеДокументыВведенныеНаОсновании(Объект.Ссылка) Тогда
			ЭтаФорма.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьИмяКнопки(Форма)
	
	Объект		= Форма.Объект;
	Элементы	= Форма.Элементы;
	
	ИППериодПеречисленияЕП = ПолучитьПредставлениеПериодаРегистрации(Объект);
	Элементы.ФормаПоЗадолженностиНаМесяцНачисления.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru ='По задолженности на конец %1 %2'"),
																	ИППериодПеречисленияЕП,Формат(Объект.ПериодРегистрации, "ДФ='гггг'"));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПредставлениеПериодаРегистрации(Объект)
	
	МесяцНачисленияСтрокой = Формат(Объект.ПериодРегистрации, "ДФ=ММММ");
	Если ПустаяСтрока(МесяцНачисленияСтрокой) Тогда
		Возврат НСтр("ru = 'месяц не выбран'");
	Иначе
		Возврат МесяцНачисленияСтрокой;
	КонецЕсли;
	
КонецФункции                         

&НаСервере
Процедура ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров, СтруктураРезультатаВыполнения)
	
	Если НЕ СтруктураПараметров.ИзмененаОрганизация И НЕ СтруктураПараметров.ИзмененоСтруктурноеПодразделение Тогда
		Возврат;
	КонецЕсли;
	
	ПриИзмененииЗначенияСтруктурногоПодразделенияСервер(СтруктураПараметров);
	УстановитьПараметрыВыбораДокументаОснования(Элементы.ДокументОснование);

	УстановитьФункциональныеОпцииФормы();

	РаботаСДиалогами.ПриИзмененииЗначенияОрганизации(Объект, , СтруктураРезультатаВыполнения);   
	
	// Очистим некорректные значения Субконто с подразделениями не входящими в выбранное структурное подразделение
	РаботаСДиалогами.ПроверитьСоответствиеПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, Объект.ПодразделениеОрганизации); 
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииЗначенияСтруктурногоПодразделенияСервер(СтруктураПараметров)
	
	Если СтруктураПараметров.Свойство("ОчищатьНекорректныеЗначения") И НЕ СтруктураПараметров.ОчищатьНекорректныеЗначения Тогда 
		Возврат;
	КонецЕсли;
	
	// Очистим некорректные значения Субконто с подразделениями не входящими в выбранное структурное подразделение
	РаботаСДиалогами.ПроверитьСоответствиеПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, Объект.ПодразделениеОрганизации); 

КонецПроцедуры

&НаСервере
Процедура СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(СтруктураПараметров = Неопределено, СтруктураРезультатаВыполнения = Неопределено)
	
	Если СтруктураПараметров = Неопределено 
		ИЛИ (СтруктураПараметров.Свойство("НеобходимоИзменитьЗначенияРеквизитовОбъекта") 
			И СтруктураПараметров.НеобходимоИзменитьЗначенияРеквизитовОбъекта) Тогда 
		РаботаСДиалогами.СтруктурноеПодразделениеПриИзменении(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктураПараметров);
	КонецЕсли;
	
	ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров, СтруктураРезультатаВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Параметры) Экспорт
	
	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
		Результат.Вставить("НеобходимоИзменитьЗначенияРеквизитовОбъекта", Ложь);
		СтруктураРезультатаВыполнения = Неопределено;
		РаботаСДиалогамиКлиент.ПоказатьВопросОбОчисткеНекорректныхЗначенийПодразделения(ЭтаФорма, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОбОчисткеНекорректныхЗначенийПодразделения(Результат, Параметры) Экспорт
	
	Параметры.Вставить("ОчищатьНекорректныеЗначения", Результат = КодВозвратаДиалога.Да);
	СтруктураРезультатаВыполнения = Неопределено;

	СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(Параметры, СтруктураРезультатаВыполнения);	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработкаИзмененияПереключенияСправки(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.ФормаПереключениеСправкиФормы.Пометка = Форма.ОтображатьСправкуФормы;	
	
	Элементы.ГруппаОсновнаяПравая.Видимость        = Форма.ОтображатьСправкуФормы;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаПриИзмененииДокументОснование(Результат, Параметры) Экспорт
	
	Если НЕ Результат = КодВозвратаДиалога.Да Тогда
		Возврат;	
	КонецЕсли;
	
	Объект.ЕдиныеПлатежи.Очистить();

	СформироватьСписокМесяцевНалоговогоПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСписокМесяцевНалоговогоПериода()
	
	СписокМесяцевНалоговогоПериода = ПроверитьКоличествоМесяцевНалоговогоПериода();
	
	Если СписокМесяцевНалоговогоПериода.Количество() = 0 Тогда
		ПослеЗакрытияВопросаПриИзмененииДокументОснованиеНаСервере();
		// вообще нет данных в документе-основании
		Возврат;
	ИначеЕсли СписокМесяцевНалоговогоПериода.Количество() = 1 Тогда
		Объект.ПериодРегистрации = СписокМесяцевНалоговогоПериода[0].Значение;
		ПослеЗакрытияВопросаПриИзмененииДокументОснованиеНаСервере();
		ПодготовитьФормуНаСервере();
	Иначе
		Оповещение = Новый ОписаниеОповещения("ПослеВыбораМесяцаНалоговогоПериода", ЭтаФорма);
		СписокМесяцевНалоговогоПериода.ПоказатьВыборЭлемента(Оповещение, "Выберите месяц налогового периода");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораМесяцаНалоговогоПериода(ЗначениеВыбора, Параметры) Экспорт
	
	Если ЗначениеВыбора = Неопределено Тогда
		Возврат;
	Иначе
		Объект.ПериодРегистрации = ЗначениеВыбора.Значение;
		ПослеЗакрытияВопросаПриИзмененииДокументОснованиеНаСервере();
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры
 
&НаСервере
Функция ПроверитьКоличествоМесяцевНалоговогоПериода() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Основание", Объект.ДокументОснование);
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	НАЧАЛОПЕРИОДА(РасчетПени.МесяцНалоговогоПериода, МЕСЯЦ) КАК МесяцНалоговогоПериода
	|ИЗ
	|	Документ.РасчетПениОПВиСО.ИсчислениеПени КАК РасчетПени
	|ГДЕ
	|	РасчетПени.Ссылка = &Основание
	|УПОРЯДОЧИТЬ ПО
	|	НАЧАЛОПЕРИОДА(РасчетПени.МесяцНалоговогоПериода, МЕСЯЦ)
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СписокМесяцевНалоговогоПериода = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
		СписокМесяцевНалоговогоПериода.Добавить(Выборка.МесяцНалоговогоПериода, Формат(Выборка.МесяцНалоговогоПериода, "ДФ='ММММ гггг'"));
	КонецЦикла;
	
	Возврат СписокМесяцевНалоговогоПериода; 
	
КонецФункции

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

	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.РасчетПениОПВиСО") Тогда
		
		Документы.ЕППеречислениеВФонды.ЗаполнитьПоРасчетПениОПВиСО(Объект, Объект.ДокументОснование);
		
	КонецЕсли;
	
КонецПроцедуры  

&НаСервереБезКонтекста
Процедура УстановитьПараметрыВыбораДокументаОснования(Элемент)
	
	МассивПараметровВыбора = Новый Массив;
	МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Отбор.ВидОперации", Документы.ЕППеречислениеВФонды.ДоступныеДокументыОснования()));
	
	Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаЗаполнитьПоСпискуСотрудников(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;

	Объект.ЕдиныеПлатежи.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОбОчисткеТабЧасти(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	Объект.ЕдиныеПлатежи.Очистить();

КонецПроцедуры

&НаКлиенте  
Процедура ПослеЗакрытияВопросаПередЗаполнениемПоЗадолжности(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	ЗаполнитьПоЗадолженностиНаКлиенте();
	
КонецПроцедуры

&НаКлиенте  
Процедура ПослеЗакрытияВопросаПередРасчетом(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	Если Модифицированность ИЛИ Объект.Ссылка.Пустая() Тогда
		
		ЭтотОбъект.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Запись));
		
	КонецЕсли;
	
	РассчитатьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьНаКлиенте()
	
	УИДЗамераЗаполнения = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Ложь, "Документ ""единый платеж перечисление в фонды"" (расчет)");
	
	РезультатВыполнения = РассчитатьНаСервере();		
	
	Если ТипЗнч(РезультатВыполнения) = Тип("Структура") 
		И НЕ РезультатВыполнения.ЗаданиеВыполнено Тогда
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		
	Иначе
		
		ЗафиксироватьДлительностьКлючевойОперации();
		
	КонецЕсли;         
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоЗадолженностиНаКлиенте()
	
	УИДЗамераЗаполнения = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Ложь, "Документ ""единый платеж перечисление в фонды"" (заполнение)");
	
	РезультатВыполнения = АвтозаполнениеНаСервере();		
	
	Если ТипЗнч(РезультатВыполнения) = Тип("Структура") 
		И НЕ РезультатВыполнения.ЗаданиеВыполнено Тогда
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		
	Иначе
		
		ЗафиксироватьДлительностьКлючевойОперации();
		
	КонецЕсли;         
	
КонецПроцедуры

&НаСервере
Функция АвтозаполнениеНаСервере() 
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнена организация, заполнение не выполнено'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ,"СтруктурноеПодразделениеОрганизация");
		Возврат Ложь;
	КонецЕсли;
	
	Объект.ЕдиныеПлатежи.Очистить();

	СтруктураПараметров = Новый Структура;	
	ДатаСреза = ?(КонецМесяца(Объект.Дата) > КонецМесяца(Объект.ПериодРегистрации), КонецМесяца(Объект.Дата), Макс(Объект.Дата, КонецМесяца(Объект.ПериодРегистрации)));

	ПоОстаткам 		= (Объект.СпособРасчетаСуммКПеречислению = Перечисления.СпособыРасчетаСуммКПеречислениюЕП.ПоОстаткамЗадолженностиНаКонецМесяца);
		
	ПеречислениеЕдиногоПлатежа = Объект.ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.Налог
								ИЛИ Объект.ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.НалогСам
								ИЛИ Объект.ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.НалогАкт;     
	ПеняЕдиногоПлатежа        = Объект.ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.ПениАкт
								ИЛИ Объект.ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.ПениСам;

								
	СтруктураПараметров.Вставить("парамГраницаОстатков", Новый Граница(ДатаСреза, ВидГраницы.Включая));
	СтруктураПараметров.Вставить("парамГоловнаяОрганизация", ОбщегоНазначенияБКВызовСервера.ГоловнаяОрганизацияДляУчетаЗарплаты(Объект.Организация));
	СтруктураПараметров.Вставить("парамОрганизация", Объект.Организация);
	СтруктураПараметров.Вставить("парамПустаяОрганизация", Справочники.Организации.ПустаяСсылка());
    СтруктураПараметров.Вставить("парамПустойВидДохода", Перечисления.ЮрФизЛицо.ПустаяСсылка());
	СтруктураПараметров.Вставить("парамСтруктурноеПодразделение", Объект.СтруктурноеПодразделение);
	СтруктураПараметров.Вставить("парамПодразделениеОрганизации", Объект.ПодразделениеОрганизации);
	СтруктураПараметров.Вставить("парамПенсионныйФонд", Объект.Контрагент);
	СтруктураПараметров.Вставить("парамМесяц", Объект.ПериодРегистрации);
	СтруктураПараметров.Вставить("парамНачало", КонецМесяца(Объект.ПериодРегистрации));
	СтруктураПараметров.Вставить("парамПеречислениеЕдиногоПлатежа", ПеречислениеЕдиногоПлатежа);   
	СтруктураПараметров.Вставить("парамПеняЕдиногоПлатежа", ПеняЕдиногоПлатежа);

	СтруктураПараметров.Вставить("парамВидПлатежа", Объект.ВидПлатежа);
	СтруктураПараметров.Вставить("ПоОстаткам", ПоОстаткам);
	СтруктураПараметров.Вставить("ТаблицаЕдиныйПлатеж", Объект.ЕдиныеПлатежи.Выгрузить());     		

	НаименованиеЗадания = НСтр("ru = 'Заполнение документа «Единый платеж перечисление в фонды»'");
	
	РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор, 
		"Документы.ЕППеречислениеВФонды.ПодготовитьДанныеДляЗаполнения", 
		СтруктураПараметров, 
		НаименованиеЗадания);
		
	АдресХранилища = РезультатВыполнения.АдресХранилища;

	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат РезультатВыполнения;  	
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаЕдиныйПлатеж = СтруктураДанных.ТаблицаЕдиныйПлатеж;
	Объект.ЕдиныеПлатежи.Загрузить(ТаблицаЕдиныйПлатеж);
	
	Если Объект.ЕдиныеПлатежи.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не обнаружены данные для записи в табличную часть документа'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , "Объект");
	КонецЕсли;  
	
КонецПроцедуры

&НаСервере
Функция РассчитатьНаСервере()
		
	СтруктураПараметров = Новый Структура;	
		
	ПоОстаткам 		= (Объект.СпособРасчетаСуммКПеречислению = Перечисления.СпособыРасчетаСуммКПеречислениюЕП.ПоОстаткамЗадолженностиНаКонецМесяца);
						
	ДатаСреза = ?(КонецМесяца(Объект.Дата) > КонецМесяца(Объект.ПериодРегистрации), КонецМесяца(Объект.Дата), Макс(Объект.Дата, КонецМесяца(Объект.ПериодРегистрации)));
		
	ПеречислениеЕдиногоПлатежа = Объект.ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.Налог
								ИЛИ Объект.ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.НалогСам
								ИЛИ Объект.ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.НалогАкт;
								
	ПеняЕдиногоПлатежа        = Объект.ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.ПениАкт
								ИЛИ Объект.ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.ПениСам;
							
	СтруктураПараметров.Вставить("парамГраницаОстатков", Новый Граница(ДатаСреза, ВидГраницы.Включая));
	СтруктураПараметров.Вставить("парамСсылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("парамОрганизация", Объект.Организация);
	СтруктураПараметров.Вставить("парамПустаяОрганизация", Справочники.Организации.ПустаяСсылка());
    СтруктураПараметров.Вставить("парамПустойВидДохода", Перечисления.ЮрФизЛицо.ПустаяСсылка());
	СтруктураПараметров.Вставить("парамМесяц", Объект.ПериодРегистрации);
	СтруктураПараметров.Вставить("парамВидПлатежа", Объект.ВидПлатежа);
	СтруктураПараметров.Вставить("парамПеречислениеЕдиногоПлатежа", ПеречислениеЕдиногоПлатежа); 
	СтруктураПараметров.Вставить("парамПеняЕдиногоПлатежа", ПеняЕдиногоПлатежа);
	СтруктураПараметров.Вставить("ПоОстаткам", ПоОстаткам);
	СтруктураПараметров.Вставить("ТаблицаЕдиныйПлатеж", Объект.ЕдиныеПлатежи.Выгрузить());     		
	
	НаименованиеЗадания = НСтр("ru = 'Расчет документа «Единый платеж перечисление в фонды»'");
	
	РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор, 
		"Документы.ЕППеречислениеВФонды.ПодготовитьДанныеДляРасчета", 
		СтруктураПараметров, 
		НаименованиеЗадания);
		
	АдресХранилища = РезультатВыполнения.АдресХранилища;

	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
		
	Возврат РезультатВыполнения;  	
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПодготовитьСправкуФормы(Форма) 
	
	ЦветФонаСправки		= РаботаСДиалогамиКлиентСервер.ВернутьШестнадцатиричноеПредставлениеЦвета(РаботаСДиалогамиКлиентСервер.ВстроеннаяСправка_ЦветФона());
	ЦветСсылкиСправки	= РаботаСДиалогамиКлиентСервер.ВернутьШестнадцатиричноеПредставлениеЦвета(РаботаСДиалогамиКлиентСервер.ВстроеннаяСправка_ЦветСсылки());

	Элементы = Форма.Элементы;
	Объект 	 = Форма.Объект;
	ТекстМакетаВстроеннойСправки = "";

	ИППериодПеречисленияЕП = ПолучитьПредставлениеПериодаРегистрации(Объект);	
	
	ТекстСпособаВыплат = "<B>Способ заполнения документа</B> <A id=АктивизироватьЭУ href=""V8:СпособРасчетаСуммКПеречислению""><P id=СпособРасчетаСуммКПеречислению style=""DISPLAY:inline"">" + Объект.СпособРасчетаСуммКПеречислению;
	
	Если Объект.СпособРасчетаСуммКПеречислению = ПредопределенноеЗначение("Перечисление.СпособыРасчетаСуммКПеречислениюЕП.ПоЗадолженностиЗаМесяц") Тогда
		
		ТекстСпособаВыплат = ТекстСпособаВыплат + "</P></A>&nbsp;(по задолженности ЕП за <A id=АктивизироватьЭУ href=""V8:МесяцНачисленияСтрокой""><P id=ПериодРегистрации style=""DISPLAY:inline"">" + ИППериодПеречисленияЕП + "</P></A>).";
		
	ИначеЕсли Объект.СпособРасчетаСуммКПеречислению = ПредопределенноеЗначение("Перечисление.СпособыРасчетаСуммКПеречислениюЕП.ПоОстаткамЗадолженностиНаКонецМесяца") Тогда		
				
		ТекстСпособаВыплат = ТекстСпособаВыплат + "</P></A>&nbsp;(по остаткам задолженности ЕП по <A id=АктивизироватьЭУ href=""V8:МесяцНачисленияСтрокой""><P id=ПериодРегистрации style=""DISPLAY:inline"">" + ИППериодПеречисленияЕП + "</P></A>&nbsp;(включительно)).";		
		
	Иначе
		
		ТекстСпособаВыплат = ТекстСпособаВыплат + " <не указан></P></A>";
		
	КонецЕсли;	
	
	Если Объект.ВидПлатежа = ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.Налог") Тогда
		ВидПлатежаТекст = "(суммы исчисленного ЕП).";	
	ИначеЕсли Объект.ВидПлатежа = ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.НалогАкт") Тогда
		ВидПлатежаТекст = "(суммы доначисленного ЕП на основании акта проверки).";
	ИначеЕсли Объект.ВидПлатежа = ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.НалогСам") Тогда
		ВидПлатежаТекст = "(суммы самостоятельно доначисленного ЕП).";
	ИначеЕсли Объект.ВидПлатежа = ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.ПениАкт") Тогда
		ВидПлатежаТекст = "(суммы исчисленной пени на основании акта проверки).";
	ИначеЕсли Объект.ВидПлатежа = ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.ПениСам") Тогда
		ВидПлатежаТекст = "(суммы самостоятельно исчисленной пени).";
	ИначеЕсли Объект.ВидПлатежа = ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.Штраф") Тогда
		ВидПлатежаТекст = "(суммы исчисленного штрафа).";
	Иначе
		ВидПлатежаТекст = "(прочие суммы ЕП).";
	КонецЕсли;

	
	ТекстМакетаВстроеннойСправки =
	"<HTML>
	|	<HEAD>
	|		<META http-equiv=Content-Type content=""text/html; charset=utf-8"">" + РаботаСДиалогамиКлиентСервер.ВстроеннаяСправка_СтилиДокумента() + "
	|	</HEAD>
	|
	|	<BODY aLink=" + ЦветСсылкиСправки + " vLink=" + ЦветСсылкиСправки + " link=" + ЦветСсылкиСправки + " bgColor=" + ЦветФонаСправки + " scroll=auto><FONT face=""MS Sans Serif"" size=1>
	|		<IMG src=" + РаботаСДиалогамиКлиентСервер.ПолучитьПутьККартинкеДляHTML(Форма.ИДКартинки) + ">
	|		<DIV>
	|		<DIV>
	|		" + ТекстСпособаВыплат + "</DIV>
	|		<DIV>
	|		<B>Вид платежа</B> <A id=АктивизироватьЭУ href=""V8:ВидПлатежа""><P id=ВидПлатежа style=""DISPLAY:inline"">" + Объект.ВидПлатежа + "</P></A>&nbsp;" + ВидПлатежаТекст + "</DIV>
	|		<BR>
	|	</FONT></BODY>
	|</HTML>";
	
	Форма.ВстроеннаяСправка = ТекстМакетаВстроеннойСправки;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудниковСписокЗавершениеВыбора(ВыбранноеЗначение, Параметры) Экспорт

	ТекущаяСтрока = Элементы.ЕдиныеПлатежи.ТекущиеДанные;
	Если  ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		ТекущаяСтрока.ФизЛицо = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеВыбораИзСпискаПредставленияПериодаРегистрации(ВыбранныйЭлемент, ДопПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	ИначеЕсли Год(ВыбранныйЭлемент.Значение) <> Год(ДопПараметры.ПериодРегистрации) Тогда
		РаботаСДиалогамиКлиент.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(ДопПараметры.Элемент, ВыбранныйЭлемент.Значение, ЭтаФорма, ВыбранныйЭлемент.Значение, Истина);
		Возврат;	
	КонецЕсли;
	
	Объект.ПериодРегистрации = ВыбранныйЭлемент.Значение; 
	МесяцНачисленияСтрокой   = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(ВыбранныйЭлемент.Значение);
	Модифицированность = Истина;
	УстановитьИмяКнопки(ЭтаФорма);
	ПодготовитьСправкуФормы(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанные();
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			ЗафиксироватьДлительностьКлючевойОперации();
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		УИДЗамераЗаполнения = Неопределено;
		ВремяНачалаОперации = Неопределено;
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ЕдиныйПлатежФизЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы	= Новый Структура;
		ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
		ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Истина);
		ПараметрыФормы.Вставить("РежимВыбора",						Истина);
			
		Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
		
		ОбработчикОповещения = Новый ОписаниеОповещения("СписокСотрудниковЕПСписокЗавершениеВыбора", ЭтотОбъект);
		
		
		ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
		ПараметрыФормы.Вставить("ВыбиратьФизЛицо", Истина);
		
		ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, Элемент,,,,ОбработчикОповещения, Режим);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудниковЕПСписокЗавершениеВыбора(ВыбранноеЗначение, Параметры) Экспорт

	ТекущаяСтрока = Элементы.ЕдиныеПлатежи.ТекущиеДанные;
	Если  ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		ТекущаяСтрока.ФизЛицо = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьДлительностьКлючевойОперации()
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамераЗаполнения);
	
КонецПроцедуры

