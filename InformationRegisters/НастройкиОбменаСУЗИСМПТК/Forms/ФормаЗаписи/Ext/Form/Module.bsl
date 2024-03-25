﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Записано Тогда
		Запись.ОбменНаСервере = Истина;
		ОбменНаСервере        = 1;
		ПриСозданииЧтенииНаСервере();
		ЭтаФорма.ПроверкаВыполнена = Ложь;
		
		//Заполняем предопределенные значения
		АдресСУЗКонстанта = ИнтеграцияИСМПТК.ПолучитьАдресаСерверовИСМПТ().АдресСУЗ;
		АдресСУЗ = ИнтеграцияИСМПТК.ОбработатьАдресИСМПТКонстанта(АдресСУЗКонстанта);
		Если НЕ СтрНайти(АдресСУЗКонстанта, "https://") = 0 Тогда
			Порт = 443;
			Таймаут = 60;
			ИспользоватьЗащищенноеСоединение = Истина;
		Иначе
			Порт = 80;
			Таймаут = 60;
			ИспользоватьЗащищенноеСоединение = Ложь;
		КонецЕсли;
		
		Запись.Адрес = АдресСУЗ; 
		Запись.Порт = Порт;
		Запись.Таймаут = Таймаут;
		Запись.ИспользоватьЗащищенноеСоединение = ИспользоватьЗащищенноеСоединение;
		
	КонецЕсли;
	
	Элементы.Подсказка.Видимость = НЕ ОбщегоНазначения.РазделениеВключено();
	
	СобытияФормИСМПТКПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ЗначениеЗаполнено(Запись.Адрес)
		И ЗначениеЗаполнено(Запись.Порт)
		И ЗначениеЗаполнено(Запись.Токен) Тогда
		
		СброситьПроверкуПодключения(3);
		
	Иначе
		
		Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.ПроверкаНеПодключенияНеВыполнялась;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормИСМПТККлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Записано = Истина;
	
	КлючЗаписиКеш = Новый Структура("Организация, СтанцияУправленияЗаказами");
	ЗаполнитьЗначенияСвойств(КлючЗаписиКеш, ТекущийОбъект);
	
	ОбменНаСервере = ТекущийОбъект.ОбменНаСервере;
	
	Если Не ОбменНаСервере Тогда
		ОбменПоРасписанию = ТекущийОбъект.ОбменНаКлиентеПоРасписанию;
		РасписаниеОбмена  = ТекущийОбъект.ОбменНаКлиентеРасписание.Получить();
	Иначе
		ОбменПоРасписанию = Ложь;
		РасписаниеОбмена  = Неопределено;
	КонецЕсли;
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	//Если Не ПроверкаВыполнена Тогда
	//	ИнтеграцияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(НСтр("ru = 'Не выполнена проверка подключения или при проверке выявлены ошибки!'")
	//									   + Символы.ПС + НСтр("ru = 'Данные могут быть некорректны!'"));
	//КонецЕсли;
	
	СобытияФормИСМПТККлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ОбменНаСервере = ОбменНаСервере;
	
	Если Не ОбменНаСервере Тогда
		ТекущийОбъект.ОбменНаКлиентеПоРасписанию = ОбменПоРасписанию;
		ТекущийОбъект.ОбменНаКлиентеРасписание   = Новый ХранилищеЗначения(РасписаниеОбмена);
	Иначе
		ТекущийОбъект.ОбменНаКлиентеПоРасписанию = Ложь;
		ТекущийОбъект.ОбменНаКлиентеРасписание   = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	КлючЗаписиКеш = Новый Структура("Организация, СтанцияУправленияЗаказами");
	ЗаполнитьЗначенияСвойств(КлючЗаписиКеш, Запись);
	
	Записано = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.УправлениеДоступом
	СобытияФормИСМПТКПереопределяемый.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТребуетсяПроверкаНаДубли = Ложь;
	Если КлючЗаписиКеш = Неопределено Тогда
		ТребуетсяПроверкаНаДубли = Истина;
	Иначе
		Для Каждого КлючИЗначение Из КлючЗаписиКеш Цикл
			Если Запись[КлючИЗначение.Ключ]<>КлючИЗначение.Значение Тогда
				ТребуетсяПроверкаНаДубли = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ТребуетсяПроверкаНаДубли Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	РегистрСведений.НастройкиОбменаСУЗИСМПТК КАК НастройкиОбменаСУЗИСМПТК
		|ГДЕ
		|	НастройкиОбменаСУЗИСМПТК.Организация = &Организация
		|	И НастройкиОбменаСУЗИСМПТК.СтанцияУправленияЗаказами = &СУЗ");
		
		Запрос.УстановитьПараметр("Организация",  Запись.Организация);
		Запрос.УстановитьПараметр("СУЗ",          Запись.СтанцияУправленияЗаказами);
		
		Если НЕ Запрос.Выполнить().Пустой() Тогда
			ИнтеграцияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Настройка обмена для организации %1 с СУЗ %2 уже существует';
						|en = 'Настройка обмена для организации %1 с СУЗ %2 уже существует'"),
					Запись.Организация,
					Запись.СтанцияУправленияЗаказами),,
				"Запись.СтанцияУправленияЗаказами",,
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОбменПоРасписаниюПриИзменении(Элемент)
	
	Если ОбменНаСервере = 1 Тогда
		
		ИзменитьРасписаниеОбменаНаСервере();
		
	Иначе
		
		ИзменитьРасписаниеОбменаНаКлиенте(ЭтотОбъект, РасписаниеОбмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресСУЗПриИзменении(Элемент)
	
	ПроверкаВыполнена = Ложь;
	//СброситьПроверкуПодключения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПортСУЗПриИзменении(Элемент)

	ПроверкаВыполнена = Ложь;
	//СброситьПроверкуПодключения();
	
КонецПроцедуры

&НаКлиенте
Процедура ТокенПриИзменении(Элемент)
	
	ПроверкаВыполнена = Ложь;
	//СброситьПроверкуПодключения();
	
КонецПроцедуры

&НаКлиенте
Процедура СтанцияУправленияЗаказамиПриИзменении(Элемент)
	
	СтанцияУправленияЗаказамиПриИзмененииНаСервере();
	ПроверкаВыполнена = Ложь;
	//СброситьПроверкуПодключения();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПроверкаВыполнена = Ложь;
	//СброситьПроверкуПодключения();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗащищенноеСоединениеПриИзменении(Элемент)
	
	ПроверкаВыполнена = Ложь;
	
	Если Запись.ИспользоватьЗащищенноеСоединение Тогда 
		Запись.Порт = 443;
	Иначе 
		Запись.Порт = 80;
	КонецЕсли;
	
	//СброситьПроверкуПодключения();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбменНаСервереПриИзменении(Элемент)
	
	ПриИзмененииВариантаПодключения(ЭтотОбъект);
	
	Если ОбменНаСервере = 1 Тогда
		
		Если ОбменНаКлиентеРасписаниеКеш <> РасписаниеОбмена
			И РасписаниеОбмена <> Неопределено Тогда
			
			ОбменНаКлиентеПоРасписаниюКеш = ОбменПоРасписанию;
			ОбменНаКлиентеРасписаниеКеш   = РасписаниеОбмена;
			
		КонецЕсли;
		
		ПрочитатьРасписаниеОбменаНаСервере();
		
	Иначе
		
		Если ОбменНаКлиентеРасписаниеКеш <> Неопределено Тогда
			
			ОбменПоРасписанию = ОбменНаКлиентеПоРасписаниюКеш;
			РасписаниеОбмена  = ОбменНаКлиентеРасписаниеКеш;
			
			ОбменНаКлиентеПоРасписаниюКеш = Неопределено;
			ОбменНаКлиентеРасписаниеКеш =   Неопределено;
			
		КонецЕсли;
		
		ИзменитьРасписаниеОбменаНаКлиенте(ЭтотОбъект, РасписаниеОбмена);
		
	КонецЕсли;
	
	СброситьПроверкуПодключения();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаВыполняетсяПроверкаПодключенияКСУЗНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОбработатьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаНетСвязиССУЗНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОбработатьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаПодключениеНастроеноКорректноНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОбработатьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаГруппаПроверкаНеПодключенияНеВыполняласьНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОбработатьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеОбмена", ЭтотОбъект);
	ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПроверку(Команда)
	
	СброситьПроверкуПодключения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ИнформационнаяБазаФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ЦветаСтиляКлиент = Новый Структура;
	ЦветаСтиляКлиент.Вставить("ЦветГиперссылкиИСМПТК",    ЦветаСтиля.ЦветГиперссылкиИСМПТК);
	ЦветаСтиляКлиент.Вставить("ЦветТекстаПроблемаИСМПТК", ЦветаСтиля.ЦветТекстаПроблемаИСМПТК);
	
	ПриИзмененииВариантаПодключения(ЭтотОбъект);
	
	Если ОбменНаСервере Тогда
		
		ПрочитатьРасписаниеОбменаНаСервере();
		
	Иначе
		
		ИзменитьРасписаниеОбменаНаКлиенте(ЭтотОбъект, РасписаниеОбмена);
		
	КонецЕсли;
	
	Элементы.ГруппаРасписание.ТолькоПросмотр = ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииВариантаПодключения(Форма)
	
	Если Форма.ОбменНаСервере = 0 Тогда
		Форма.Подсказка = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Подключение будет осуществляться с компьютера пользователя';
				|en = 'Подключение будет осуществляться с компьютера пользователя'"));
	ИначеЕсли Форма.ОбменНаСервере = 1 И Форма.ИнформационнаяБазаФайловая Тогда
		Форма.Подсказка = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Подключение будет осуществляться с компьютера пользователя (файловый вариант)';
				|en = 'Подключение будет осуществляться с компьютера пользователя (файловый вариант)'"));
	ИначеЕсли Форма.ОбменНаСервере = 1 И Не Форма.ИнформационнаяБазаФайловая Тогда
		Форма.Подсказка = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Подключение будет осуществляться с компьютера,
			           |на котором установлен сервер 1С:Предприятия (клиент-сервер)';
			           |en = 'Подключение будет осуществляться с компьютера,
			           |на котором установлен сервер 1С:Предприятия (клиент-сервер)'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьОшибкуПоискаРегламентногоЗадания()
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'ИС МП';
			|en = 'ИС МП'"),
		УровеньЖурналаРегистрации.Ошибка,
		Метаданные.РегламентныеЗадания.ОтправкаПолучениеДанныхИСМПТК,,
		НСтр("ru = 'Не найдено регламентное задание обмена с ИС МП';
			|en = 'Не найдено регламентное задание обмена с ИС МП'"));
КонецПроцедуры

&НаСервере
Процедура ПрочитатьРасписаниеОбменаНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", "ОтправкаПолучениеДанныхИСМПТК");
	
	ЗаданияОбмена = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора);
	
	Если ЗаданияОбмена.Количество() <> 1 Тогда
		ЗаписатьОшибкуПоискаРегламентногоЗадания();
		ЗаданиеОбмена     = Неопределено;
		РасписаниеОбмена  = Неопределено;
		ОбменПоРасписанию = Ложь;
	Иначе
		ЗаданиеОбмена     = ЗаданияОбмена[0];
		РасписаниеОбмена  = ЗаданиеОбмена.Расписание;
		ОбменПоРасписанию = ЗаданиеОбмена.Использование;
	КонецЕсли;
	
	Элементы.ОтправкаПолучениеДанныхИСМП.Доступность = ОбменПоРасписанию;
	УстановитьТекстНадписиРегламентнойНастройки(ЗаданиеОбмена, Элементы.ОтправкаПолучениеДанныхИСМП);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасписаниеОбменаНаСервере()
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", "ОтправкаПолучениеДанныхИСМПТК");
	
	ЗаданияОбмена = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора);
	
	Если ЗаданияОбмена.Количество() <> 1 Тогда
		ЗаписатьОшибкуПоискаРегламентногоЗадания();
		ИнтеграцияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(НСтр("ru = 'Не найдено регламентное задание обмена с ИС МП';
																|en = 'Не найдено регламентное задание обмена с ИС МП'"));
		ОбменПоРасписанию = Ложь;
	Иначе
		ИзменитьИспользованиеЗадания("ОтправкаПолучениеДанныхИСМПТК", ОбменПоРасписанию);
		ИзменитьРасписаниеЗадания("ОтправкаПолучениеДанныхИСМПТК", РасписаниеОбмена);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьИспользованиеЗадания(ИмяЗадания, Использование)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", Использование);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасписаниеЗадания(ИмяЗадания, РасписаниеРегламентногоЗадания)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание", РасписаниеРегламентногоЗадания);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстНадписиРегламентнойНастройки(Задание, Элемент)
	
	Перем ТекстРасписания;
	
	ИнтеграцияИСМПТК.ПолучитьТекстЗаголовкаИРасписанияРегламентнойНастройки(Задание, ТекстРасписания, ОбменПоРасписанию);
	Элемент.Заголовок   = ТекстРасписания;
	Элемент.Доступность = ОбменПоРасписанию;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьРасписаниеОбменаНаКлиенте(Форма, НовоеРасписание)
	
	Если НовоеРасписание = Неопределено Тогда
		
		ТекстРасписания = НСтр("ru = '<Расписание не задано>';
								|en = '<Расписание не задано>'");
		
	Иначе
		
		Если Форма.ОбменПоРасписанию Тогда
			ТекстРасписания = СтрШаблон(НСтр("ru = 'Расписание: %1';
											|en = 'Расписание: %1'"), Строка(НовоеРасписание));
		Иначе
			ТекстРасписания = СтрШаблон(НСтр("ru = 'Расписание (НЕ АКТИВНО): %1';
											|en = 'Расписание (НЕ АКТИВНО): %1'"), Строка(НовоеРасписание));
		КонецЕсли;
		
	КонецЕсли;
	
	Форма.Элементы.ОтправкаПолучениеДанныхИСМП.Доступность = Форма.ОбменПоРасписанию;
	Форма.Элементы.ОтправкаПолучениеДанныхИСМП.Заголовок = ТекстРасписания;
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьПроверкуПодключения(ИнтервалОжидания = 1)
	
	ПодключениеНастроеноКорректно = Ложь;
	Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.ВыполняетсяПроверкаПодключенияКСУЗ;
	ПодключитьОбработчикОжидания("ПроверкаПодключениеКСУЗОбработчикОжидания", ИнтервалОжидания, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаПодключениеКСУЗОбработчикОжидания()
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОтображатьСообщенияОбОшибках", Ложь);
	
	ПроверитьПодключениеСУЗ(Новый ОписаниеОповещения("ПослеПроверкиПодключенияСУЗ", ЭтотОбъект, ДополнительныеПараметры), 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеСУЗ(ОписаниеОповещения, Таймаут)
	
	ОчиститьСообщения();
	
	Если ОбменНаСервере = 1 Тогда
		Результат = ПроверитьПодключениеСУЗНаСервере();
	Иначе
		Результат = ПроверитьПодключениеСУЗНаКлиенте();
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, Результат);
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьПодключениеСУЗНаКлиенте()
	
	Возврат Новый Структура("ТекстОшибки, ОтветПолучен", НСтр("ru = 'Недоступно';
												|en = 'Недоступно'"), Ложь);
	
КонецФункции

&НаСервере
Функция ПроверитьПодключениеСУЗНаСервере()
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ЗапросОтправлен");
	ВозвращаемоеЗначение.Вставить("ОтветПолучен");
	ВозвращаемоеЗначение.Вставить("КодСостояния");
	ВозвращаемоеЗначение.Вставить("ТекстОшибки");
	
	ПараметрыСУЗ = ИнтерфейсИСМПТК.НоваяНастройкаОбменаСУЗ();
	ПараметрыСУЗ.Токен = Запись.Токен;
	
	//Получаем предопределенные данные
	АдресСУЗКонстанта = ИнтеграцияИСМПТК.ПолучитьАдресаСерверовИСМПТ().АдресСУЗ;
	АдресСУЗ = ИнтеграцияИСМПТК.ОбработатьАдресИСМПТКонстанта(АдресСУЗКонстанта);
	Если НЕ СтрНайти(АдресСУЗКонстанта, "https://") = 0 Тогда
		Порт = 443;
		Таймаут = 60;
		ИспользоватьЗащищенноеСоединение = Истина;
	Иначе
		Порт = 80;
		Таймаут = 60;
		ИспользоватьЗащищенноеСоединение = Ложь;
	КонецЕсли;
	
	ПараметрыСУЗ.Сервер 							= АдресСУЗ;
	ПараметрыСУЗ.Порт 								= Порт;
	ПараметрыСУЗ.Таймаут 							= Таймаут;
	ПараметрыСУЗ.ИспользоватьЗащищенноеСоединение 	= ИспользоватьЗащищенноеСоединение;
	
	ДанныеНастройкиСУЗ = РазборИОбработкаКодовМаркировкиИСМПТКСлужебный.ЗначенияРеквизитовОбъекта(Запись.СтанцияУправленияЗаказами, "Идентификатор", Истина);
	ПараметрыСУЗ.Идентификатор = ДанныеНастройкиСУЗ.Идентификатор;
	
	МассивИспользуемыхВидовПродукции = РазборИОбработкаКодовМаркировкиИСМПТКСлужебный.УчитываемыеВидыМаркируемойПродукции();
	
	Если Не МассивИспользуемыхВидовПродукции.Количество() = 0 Тогда
		
		//При наличии нескольких товарных групп проверяем по первой
		СтруктураРезультат = ИнтерфейсИСМПТК.ПроверитьДоступностьСУЗ_V2(МассивИспользуемыхВидовПродукции[0], ПараметрыСУЗ);
		
		ЗаполнитьЗначенияСвойств(ВозвращаемоеЗначение, СтруктураРезультат.РезультатОтправкиЗапроса);
		ВозвращаемоеЗначение.ТекстОшибки = УдалитьНедопустимыеСимволыИзСтроки(СтруктураРезультат.ТекстОшибки);
		
	Иначе
		
		//При отсутсутствии настроек товарных групп подключаться некуда
		Возврат Новый Структура("ТекстОшибки, ОтветПолучен", НСтр("ru = 'Недоступно';
												|en = 'Недоступно'"), Ложь);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаСервере
Функция УдалитьНедопустимыеСимволыИзСтроки(Знач ДанныеСтроки)
	
	Пока Истина Цикл
		
		ПозицияНедопустимогоСимвола = ИнтеграцияИСМПТКПереопределяемый.ПозицияНедопустимогоСимвола(ДанныеСтроки);
		Если ПозицияНедопустимогоСимвола = 0 Тогда
			Прервать
		КонецЕсли;
		ДанныеСтроки = Лев(ДанныеСтроки, ПозицияНедопустимогоСимвола - 1)
			+ Сред(ДанныеСтроки, ПозицияНедопустимогоСимвола + 1);
		
	КонецЦикла;
	
	Возврат ДанныеСтроки;
	
КонецФункции

&НаКлиенте
Процедура ПослеПроверкиПодключенияСУЗ(РезультатПроверки, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатПроверки = Неопределено Тогда
		
		ПодключениеНастроеноКорректно = Истина;
		Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.ПроверкаПодключенияНедоступна;
		ПроверкаВыполнена = Ложь;
		
	ИначеЕсли РезультатПроверки.ОтветПолучен = Истина И РезультатПроверки.КодСостояния = 200 Тогда
		
		ПодключениеНастроеноКорректно = Истина;
		Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.ПроверкаПодключенияКорректно;
		ПроверкаВыполнена = Истина;
	Иначе
		
		Если ДополнительныеПараметры.ОтображатьСообщенияОбОшибках Тогда
			ИнтеграцияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(РезультатПроверки.ТекстОшибки);
		КонецЕсли;
		ПроверкаВыполнена = Ложь;
		Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.НетСвязиССУЗ;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеРегламентногоЗадания)
	
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеОбмена(РасписаниеЗадания, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасписаниеОбмена = РасписаниеЗадания;
	
	Если ОбменНаСервере = 1 Тогда
		
		ИзменитьРасписаниеОбменаНаСервере();
		
	Иначе
		
		ИзменитьРасписаниеОбменаНаКлиенте(ЭтотОбъект, РасписаниеОбмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНавигационнуюСсылку(Знач НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОтображатьСообщенияОбОшибках", Истина);
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПроверитьПодключениеКСУЗ" Тогда
		
		СтандартнаяОбработка = Ложь;
		ПроверитьПодключениеСУЗ(
			Новый ОписаниеОповещения("ПослеПроверкиПодключенияСУЗ", ЭтотОбъект, ДополнительныеПараметры), Запись.Таймаут);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "Повторить" Тогда
		
		СтандартнаяОбработка = Ложь;
		ПроверитьПодключениеСУЗ(
			Новый ОписаниеОповещения("ПослеПроверкиПодключенияСУЗ", ЭтотОбъект, ДополнительныеПараметры), Запись.Таймаут);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СтанцияУправленияЗаказамиПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Запись.СтанцияУправленияЗаказами) Тогда
		Запись.ИспользоватьЗащищенноеСоединение = Истина;
	Иначе
		Запись.ИспользоватьЗащищенноеСоединение = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти