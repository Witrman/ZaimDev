﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ОбъектИсточник = Параметры.ЗначениеКопирования.ПолучитьОбъект();
	Иначе
		ОбъектИсточник = РеквизитФормыВЗначение("Объект", Тип("СправочникОбъект.ХранилищеШаблоновИСМПТК"));
	КонецЕсли;
	
	СтруктураШаблона = ОбъектИсточник.Шаблон.Получить();
	СКД = ОбъектИсточник.СхемаКомпоновкиДанных.Получить();
	
	Если ТипЗнч(СтруктураШаблона) = Тип("Структура") Тогда
		СтруктураШаблона.Свойство("XMLОписаниеМакета", XMLОписаниеМакета);
	КонецЕсли;
	
	АдресШаблона = ПоместитьВоВременноеХранилище(СтруктураШаблона, УникальныйИдентификатор);
	
	Если СКД <> Неопределено Тогда
		АдресСКД = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	КонецЕсли;
	
	УстановитьВидимостьЭлементов();
		
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаданВопрос = Ложь;
	
	Если ЗначениеЗаполнено(АдресШаблона) Тогда
		СтруктураШаблона = ПолучитьИзВременногоХранилища(АдресШаблона);
		Если СтруктураШаблона <> Неопределено Тогда
			//Перезаполняем тип кода в параметрах макета если пользователь изменил признак НеGS1 после редактирования макета
			Если Объект.НеGS1 Тогда
				СтруктураШаблона.ТипКода = 18; 
			Иначе
				СтруктураШаблона.ТипКода = 24;
			КонецЕсли;
			ТекущийОбъект.Шаблон = Новый ХранилищеЗначения(СтруктураШаблона);
			Если СтруктураШаблона.Свойство("АдресСКДВХранилище") Тогда
				АдресСКД = СтруктураШаблона.АдресСКДВХранилище;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресСКД) Тогда
		СКД = ПолучитьИзВременногоХранилища(АдресСКД);
		ТекущийОбъект.СхемаКомпоновкиДанных = Новый ХранилищеЗначения(СКД);
		Если НЕ Отказ Тогда
			Если НЕ ОбязательныеПараметрыСКДЗаполнены(ТекущийОбъект) Тогда
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененШаблон" Тогда
		
		АдресШаблона = Параметр;
		Модифицированность = Истина;
		
		ПолеПредупреждение = НСтр("ru = 'Макет шаблона печати был изменен. Требуется сохранение!'");
		Элементы.ПолеПредупреждение.Видимость = Истина;
				
		Если ЗначениеЗаполнено(АдресШаблона) Тогда
			СтруктураШаблона = ПолучитьИзВременногоХранилища(АдресШаблона);
			Если СтруктураШаблона <> Неопределено Тогда
				Если СтруктураШаблона.Свойство("АдресСКДВХранилище")
					И ЗначениеЗаполнено(СтруктураШаблона.АдресСКДВХранилище) Тогда
					АдресСКД = СтруктураШаблона.АдресСКДВХранилище;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ПолеПредупреждение) Тогда
		Элементы.ПолеПредупреждение.Видимость = Ложь; //Убираем видимость поля после записи, если выводилось предупреждение
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	//СтандартнаяОбработка = Ложь;
	//Если МакетЭтикеткиНеЗаполнен() Тогда
	//	Отказ = Истина;
	//	ТекстВопроса = НСтр("ru = 'Не заполнен шаблон этикетки в редакторе макета! Закрыть форму?'");
	//	ЗакрытьФормуЗавершение = Новый ОписаниеОповещения("ЗакрытьФормуЗавершение", ЭтаФорма);
	//	ПоказатьВопрос(ЗакрытьФормуЗавершение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	//Иначе
	//	ЭтаФорма.Закрыть();
	//КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФормуРедактированияМакета(Команда)
	
	Если Модифицированность Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПерейтиКРедактированиюМакетаЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Для редактирования шаблона необходимо записать элемент. Записать?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		
	Иначе
		ПерейтиКРедактированиюМакета();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПерейтиКРедактированиюМакетаЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Если ПроверитьЗаполнение() Тогда
			
			ЭтотОбъект.Записать();
			ПерейтиКРедактированиюМакета();
			
		КонецЕсли;;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКРедактированиюМакета()
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ссылка", 	   Объект.Ссылка);
	ПараметрыОткрытия.Вставить("АдресШаблона", АдресШаблона);
	ПараметрыОткрытия.Вставить("АдресСКД", 	   АдресСКД);
	
	ОткрытьФорму("Справочник.ХранилищеШаблоновИСМПТК.Форма.ФормаРедактированияШаблона",
				 ПараметрыОткрытия,
				 ЭтотОбъект,
				 ,
				 ,
				 ,
				 ,
				 РежимОткрытияОкнаФормы.Независимый);
				 
	Если Не ЗначениеЗаполнено(ПолеПредупреждение) Тогда			 
		Элементы.ПолеПредупреждение.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	Элементы.ПолеПредупреждение.Видимость = Ложь;
	Элементы.НеGS1.Видимость = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйВызовСервера.ПроверитьЗначениеКонстанты("ВестиУчетМаркируемогоТабакаИСМПТК");
	
КонецПроцедуры                                                                                     

&НаСервере
Функция ОбязательныеПараметрыСКДЗаполнены(ТекущийОбъект)
	
	ВсеВерно = Истина;
	Если ТекущийОбъект.СхемаКомпоновкиДанных <> Неопределено Тогда
		
		ПроверяемаяСхема = ТекущийОбъект.СхемаКомпоновкиДанных.Получить();
		
		Если ПроверяемаяСхема = Неопределено Тогда
			Возврат ВсеВерно;
		КонецЕсли;
		
		// Подготовка компоновщика макета компоновки данных, загрузка настроек.
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПроверяемаяСхема));
		
		КомпоновщикНастроек.ЗагрузитьНастройки(ПроверяемаяСхема.НастройкиПоУмолчанию);

		НастройкиСКД = КомпоновщикНастроек.Настройки;
		СписокПараметровСКД = НастройкиСКД.ПараметрыДанных.Элементы;
		ИндексПараметра = 0;
		Для Каждого ПараметрСКД Из СписокПараметровСКД Цикл
			Если ТипЗнч(ПараметрСКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
				ПараметрНастроек = КомпоновщикНастроек.Настройки.ПараметрыДанных.ДоступныеПараметры.НайтиПараметр(ПараметрСКД.Параметр);
				Если ПараметрНастроек <> Неопределено И ПараметрНастроек.ЗапрещатьНезаполненныеЗначения Тогда
					Если (НЕ ПараметрСКД.Использование) ИЛИ (НЕ ЗначениеЗаполнено(ПараметрСКД.Значение)) Тогда
						ТекстСообщения = НСтр("ru = 'В схеме компоновки не заполнено значение обязательного параметра ""%1"". Откройте редактор макета и настройте параметры СКД.'");
						ИмяПараметраСКД = ?(ЗначениеЗаполнено(ПараметрСКД.ПредставлениеПользовательскойНастройки),
											ПараметрСКД.ПредставлениеПользовательскойНастройки,
											?(ЗначениеЗаполнено(ПараметрНастроек.Заголовок),
																ПараметрНастроек.Заголовок,
																ПараметрНастроек.Имя));
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ИмяПараметраСКД);
						ИнтеграцияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения,,"ФормаРедактироватьМакет","Объект");
						ВсеВерно = Ложь;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			ИндексПараметра = ИндексПараметра + 1;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ВсеВерно;
	
КонецФункции

&НаСервере
Функция МакетЭтикеткиНеЗаполнен()
		
	СтруктураШаблона = ПолучитьИзВременногоХранилища(АдресШаблона);
	Возврат ?(СтруктураШаблона = Неопределено, Истина, Ложь);
		
КонецФункции

&НаКлиенте
Процедура ЗакрытьФормуЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЭтаФорма.Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
