﻿
&НаКлиенте
Процедура ОК(Команда)
		
	ПеренестиВДокумент = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры,,"ЗакрыватьПриВыборе,ЗакрыватьПриЗакрытииВладельца");
	
	СтруктураПараметров = ИзменяемыеРеквизиты(Параметры);
	
	МассивЭлементов = Новый Массив();
	
	Для Каждого ЭлементСтруктуры из СтруктураПараметров Цикл
		МассивЭлементов.Добавить(ЭлементСтруктуры.Ключ);
	КонецЦикла;

	Если ТолькоПросмотр Тогда 	
				
		ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", Истина);
		
	КонецЕсли;  
	
	Для Каждого Элемент Из МассивЭлементов Цикл
		МетаданныеДокумента = Метаданные.Документы[Параметры.ТипОбъекта];
		ИмяРеквизита = Элемент;
		Если НЕ ОбщегоНазначенияБК.ЕстьРеквизитДокумента(ИмяРеквизита,МетаданныеДокумента) Тогда
			ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, Элемент, "Видимость", Ложь);		
		КонецЕсли;  
		
		Если Элемент = "ДокументОснование" Тогда
			Элементы.ДокументОснование.ОграничениеТипа = МетаданныеДокумента.Реквизиты.ДокументОснование.Тип;
		КонецЕсли; 		

		Если (Параметры.ТипОбъекта = "РасходныйКассовыйОрдер" ИЛИ Параметры.ТипОбъекта = "ПриходныйКассовыйОрдер" ИЛИ Параметры.ТипОбъекта = "СписаниеТоваров") 
			И Элемент = "Основание" Тогда 
			ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, Элемент, "Видимость", Ложь);		
		КонецЕсли;
		
		Если (Параметры.ТипОбъекта = "ПлатежноеПоручениеВходящее") 
			И (Элемент = "ДатаВходящегоДокумента" ИЛИ Элемент = "НомерВходящегоДокумента") Тогда 
			ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, Элемент, "Видимость", Ложь);		
		КонецЕсли;

		
		Если Параметры.ТипОбъекта = "ВозвратТоваровПоставщику" И Параметры.ВидОперации = "ИзПереработки"
			И Элемент = "СобытиеОС" Тогда
			ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, Элемент, "Видимость", Ложь);		
		КонецЕсли; 
	КонецЦикла;
	
	Если Параметры.ТипОбъекта = "РегистрацияНДСЗаНерезидента" Тогда
		
		ЭлементКонтрагентМассиваПараметровВыбора = 	Новый СвязьПараметраВыбора("Отбор.Контрагент","Контрагент");
		ЭлементДоговорМассиваПараметровВыбора = 	Новый СвязьПараметраВыбора("Отбор.ДоговорКонтрагента","ДоговорКонтрагента");
		
		МассивПараметровВыбора = Новый Массив;
		МассивПараметровВыбора.Добавить(ЭлементКонтрагентМассиваПараметровВыбора);
		МассивПараметровВыбора.Добавить(ЭлементДоговорМассиваПараметровВыбора);
		
		Элементы.ДокументОснование.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	КонецЕсли; 

	СтарыйДокументОснование = ДокументОснование;
	
	УправлениеФормой(ЭтотОбъект);
		
	ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ЗаблокироватьРеквизиты(ЭтотОбъект, Проведен,Параметры);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИзменяемыеРеквизиты(Источник)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("Ответственный",                  Источник.Ответственный);
	СтруктураПараметров.Вставить("ДокументОснование",              Источник.ДокументОснование);
	//СтруктураПараметров.Вставить("ТолькоПросмотр",                 Источник.ТолькоПросмотр);
	
	СтруктураПараметров.Вставить("ВиДВходящегоДокумента",      	   Источник.ВиДВходящегоДокумента);
	СтруктураПараметров.Вставить("ДатаВходящегоДокумента",         Источник.ДатаВходящегоДокумента);
	СтруктураПараметров.Вставить("НомерВходящегоДокумента",        Источник.НомерВходящегоДокумента);
	СтруктураПараметров.Вставить("Комментарий",        			   Источник.Комментарий);
	СтруктураПараметров.Вставить("СобытиеОС",        			   Источник.СобытиеОС);
	СтруктураПараметров.Вставить("Основание",        		   	   Источник.Основание);
			
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Ссылка) И ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг")
	   И ЗначениеЗаполнено(ДокументОснование) И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		ВидОперации = ОбщегоНазначенияБКВызовСервера.ЗначениеРеквизитаОбъекта(Ссылка, "ВидОперации");
		ВидОперацииДокументаОснования = ОбщегоНазначенияБКВызовСервера.ЗначениеРеквизитаОбъекта(ДокументОснование, "ВидОперации");
		Если ВидОперации <> ВидОперацииДокументаОснования Или ВидОперации <> ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Услуги") Тогда
			ДокументОснование = СтарыйДокументОснование;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтрШаблон("Нет данных для заполнения. Ввод на основании поступления ТМЗ и услуг доступен только для документов с видом операции ""%1""", ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Услуги"));
			Сообщение.Сообщить();
			Возврат
		КонецЕсли;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Если Форма.СтарыйДокументОснование <> Форма.ДокументОснование Тогда
		Форма.СтарыйДокументОснование = Форма.ДокументОснование;
	КонецЕсли;
	
	ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПерезаполнитьДокументПоОснованию", "Видимость", ЗначениеЗаполнено(Форма.ДокументОснование));
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли  Модифицированность И НЕ ПеренестиВДокумент Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемФормыЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	КонецЕсли;
	
	Если Отказ Тогда
		ПеренестиВДокумент = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ПеренестиВДокумент И Модифицированность Тогда
		СтруктураРезультат = Новый Структура("
			|ДокументОснование, Ответственный,
			|ПерезаполнитьДокументПоОснованию,
			|ВиДВходящегоДокумента,
			|ДатаВходящегоДокумента,
			|НомерВходящегоДокумента,
			|Комментарий,
			|СобытиеОС,
			|Основание");
		
		ЗаполнитьЗначенияСвойств(СтруктураРезультат, ЭтаФорма);
		
		ОповеститьОВыборе(СтруктураРезультат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВидВходящегоДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ВидДокумента", Элемент.ТекстРедактирования);
	
	ОткрытьФорму("Справочник.ВидыПервичныхДокументов.ФормаВыбора", СтруктураПараметров, ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ВидыПервичныхДокументов.Форма.ФормаВыбора" Тогда
		ВидВходящегоДокумента = СокрЛП(ВыбранноеЗначение);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РазблокироватьРеквизиты() Экспорт
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура("ФормаВладелец,ИмяРеквизита", ЭтаФорма, "Основание");
	Оповещение = Новый ОписаниеОповещения("ОснованиеЗавершениеВвода", ЭтотОбъект, ДополнительныеПараметры);
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(
		Оповещение,
		Основание,
		НСтр("ru='Основание'"));
		
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеЗавершениеВвода(Строка, Параметры) Экспорт

	Если Строка <> Неопределено И Основание <> Строка Тогда
		
		Основание = Строка;
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
