﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураПараметров = Новый Структура("ПоискПоБИН_ИИН, БИН_ИИН, ПоискПоРНН, РНН", Ложь, "", Ложь, "");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, Параметры);
	
	Для Каждого Параметр Из СтруктураПараметров Цикл
		СписокДублей.Параметры.УстановитьЗначениеПараметра(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	
	ДополнениеЗаголовка = "";
	Если СтруктураПараметров.ПоискПоБИН_ИИН И СтруктураПараметров.ПоискПоРНН Тогда 
		ДополнениеЗаголовка = НСтр("ru = 'БИН / ИИН и РНН'");
	ИначеЕсли СтруктураПараметров.ПоискПоБИН_ИИН Тогда 
		ДополнениеЗаголовка = НСтр("ru = 'БИН / ИИН'");
	ИначеЕсли СтруктураПараметров.ПоискПоРНН Тогда 
		ДополнениеЗаголовка = НСтр("ru = 'РНН'");
	КонецЕсли;
	
	ЭтаФорма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Список дублей по %1'"), ДополнениеЗаголовка);
	
	ОтборИнформацияИспользование = Истина;
	
	ОтборОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	
	УстановитьОтборПоСпискуДокументов(Список,
									  "Организация", 
									  ОтборОрганизация,
									  ,
									  ,
									  ОтборОрганизацияИспользование);
														
	НачалоПериода = НачалоДня((ТекущаяДатаСеанса() - 365*86400));
	
	УстановитьОтборПоПериодуДляСпискаДокументов(Список, НачалоПериода);
	
	УстановитьОтборПоСпискуДокументов(Список,
									  "Контрагент", 
									  Справочники.Контрагенты.ПустаяСсылка(),
									  ,
									  ,
									  Истина);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	УстановитьОтборПоСпискуДокументов(Список,
									  "Организация", 
									  ОтборОрганизация,
									  ,
									  ,
									  ОтборОрганизацияИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	
	УстановитьОтборПоСпискуДокументов(Список,
									  "Организация", 
									  ОтборОрганизация,
									  ,
									  ,
									  ОтборОрганизацияИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	
	УстановитьОтборПоСпискуДокументов(Список,
									  "Организация", 
									  ОтборОрганизация,
									  ,
									  ,
									  ОтборОрганизацияИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	УстановитьОтборПоПериодуДляСпискаДокументов(Список, НачалоПериода);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ СПИСКА ДУБЛЕЙ

&НаКлиенте
Процедура СписокДублейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
		
	ПараметрыПередачи = Новый Структура("Ключ", Элемент.ТекущиеДанные.Ссылка);
	ПараметрыПередачи.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта",
				  ПараметрыПередачи, 
	              Элемент,
	              ,
	              ,
	              ,
	              Новый ОписаниеОповещения("ОбработатьРедактированиеЭлемента", ЭтаФорма));
	
КонецПроцедуры
			  
&НаКлиенте
Процедура СписокДублейПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьОтборПоКонтрагентуВСпискеДокументовКлиент", 0.5, Истина);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ СПИСКА

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
		
	ПараметрыПередачи = Новый Структура("Ключ", Элемент.ТекущиеДанные.Ссылка);
	ПараметрыПередачи.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	
	ВидДокумента = ПолучитьВидДокумента(Элемент.ТекущиеДанные.Ссылка);
		
	ОткрытьФорму("Документ."+ВидДокумента+".ФормаОбъекта",
				  ПараметрыПередачи, 
				  Элемент,
				  ,
				  ,
				  ,
				  Новый ОписаниеОповещения("ОбработатьРедактированиеДокумента", ЭтаФорма));

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбработатьРедактированиеЭлемента(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Элементы.СписокДублей.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРедактированиеДокумента(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьОтборПоКонтрагентуВСпискеДокументовКлиент()

	Если НЕ Элементы.СписокДублей.ТекущиеДанные = Неопределено Тогда
	
		УстановитьОтборПоСпискуДокументов(Список,
										  "Контрагент", 
										  Элементы.СписокДублей.ТекущиеДанные.Ссылка,
										  ,
										  ,
										  Истина);
	КонецЕсли;	

КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСпискуДокументов(Список, ИмяПоля, ЗначениеОтбора, ВидСравнения = Неопределено, ПредставлениеОтбора = Неопределено, ИспользованиеОтбора)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.КомпоновщикНастроек.Настройки.Отбор, 
														ИмяПоля, 
														ЗначениеОтбора,
														ВидСравнения,
														ПредставлениеОтбора,
														ИспользованиеОтбора);
														
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПериодуДляСпискаДокументов(Список, НачальнаяДата = Неопределено)
	
	Если НЕ НачальнаяДата = Неопределено Тогда
		
		Если ЗначениеЗаполнено(НачальнаяДата) Тогда
			
			УстановитьОтборПоСпискуДокументов(Список,
											"Дата", 
											НачальнаяДата,
											ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
											"Начало периода",
											Истина);
			
		Иначе
			
			УстановитьОтборПоСпискуДокументов(Список,
											"Дата", 
											НачальнаяДата,
											ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
											"Начало периода",
											Ложь);
											
		КонецЕсли;
										
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВидДокумента(СсылкаНаДокумент)
	Возврат СсылкаНаДокумент.Метаданные().Имя;
КонецФункции
