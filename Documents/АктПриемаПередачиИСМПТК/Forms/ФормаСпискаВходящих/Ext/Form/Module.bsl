﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидимостьКнопокИзмененияСтатуса();
	
	Если Параметры.Отбор.Свойство("Организация") Тогда
		Организация = Параметры.Отбор.Организация;
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		ЭтаФорма.Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ИнтеграцияИСМПТККлиентСервер.ИмяСобытияЗаписьАктПриемаПередачи() Тогда
		
		Элементы.Список.Обновить();
		УстановитьВидимостьКнопокИзмененияСтатуса();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)	
	
	УстановитьБыстрыйОтбор("Организация", Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	УстановитьБыстрыйОтбор("Контрагент", Контрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеПриИзменении(Элемент)
	
	УстановитьБыстрыйОтбор("Состояние", Состояние);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УстановитьВидимостьКнопокИзмененияСтатуса();
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокДокументАППОбновить", "Доступность", Ложь);
	Иначе
		ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокДокументАППОбновить", "Доступность", Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьБыстрыйОтбор(ВидЭлемента, ЗначениеЭлемента)
	
	ИнтеграцияИСМПТККлиентСерверПереопределяемый.ИзменитьЭлементОтбораСписка(Список, ВидЭлемента, ЗначениеЭлемента, ЗначениеЗаполнено(ЗначениеЭлемента));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКнопокИзмененияСтатуса()
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() > 0 Тогда		
		
		ПервыйВыделенныйАкт = Элементы.Список.ВыделенныеСтроки[0];
		СоответвствиеСтатусов = ИнтеграцияИСМПТК.РазрешенныеДействияПоСтатусамАкта(ПервыйВыделенныйАкт.Направление);
		ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокДокументАПППодтвердить",  "Доступность", ПервыйВыделенныйАкт.Проверен);
		
		УстановитьВидимостьКнопки(СоответвствиеСтатусов, "СписокДокументАПППодтвердить", ПервыйВыделенныйАкт, ИнтеграцияИСМПТККлиентСервер.ДействиеПодтверждение());
		УстановитьВидимостьКнопки(СоответвствиеСтатусов, "СписокДокументАППОтклонить", 	 ПервыйВыделенныйАкт, ИнтеграцияИСМПТККлиентСервер.ДействиеОтклонение());
		
	Иначе
		
		ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокДокументАПППодтвердить",  "Видимость", Ложь);
		ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокДокументАППОтклонить",    "Видимость", Ложь);
		
	КонецЕсли;
	
	УправлениеФормой();
		
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
		
	ДанныеАкта = Элементы.Список.ТекущаяСтрока;
	
	Если ДанныеАкта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеАкта.ТипАкта = ПредопределенноеЗначение("Перечисление.ВидыДокументаИСМПТК.Исходный") Тогда
		
		//Акт получен:
		Если ЗначениеЗаполнено(ДанныеАкта.УведомлениеОРасхождении) 
			ИЛИ (ДанныеАкта.Проверен И ДанныеАкта.Расхождения.Количество() = 0) Тогда
			//УОР уже введено ИЛИ выполнена проверка и расхожденя не обнаружены -вводить УОР не нужно
			ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаВвестиУведомлениеОРасхождении", "Видимость", Ложь);
		Иначе
			Если ДанныеАкта.Проверен Тогда
				//Проверка выполнена, есть расхождения - можем оформить УОР
				ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаВвестиУведомлениеОРасхождении", "Видимость", Истина);
			Иначе 
				//Проверка не выполнена - не можем вводить УОР
				ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаВвестиУведомлениеОРасхождении", "Видимость", Ложь);
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		//УОР не требуется
		ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаВвестиУведомлениеОРасхождении", "Видимость", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УстановитьВидимостьКнопки(СоответвствиеСтатусов, НазваниеКнопки, ПервыйВыделенныйАкт, Действие) 
	
	ВидимостьКнопки = СоответвствиеСтатусов[Действие][ПервыйВыделенныйАкт.Статус];
	
	Если ВидимостьКнопки <> Неопределено Тогда
		
		ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, НазваниеКнопки, "Видимость", ВидимостьКнопки);
		
	Иначе
		
		ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокДокументАППОтозвать", "Видимость", Истина);
		ТекстСообщения = НСтр("ru='Тех. ошибка! Для действия %1 и статуса Акта %2 не указано соответствие для отображения кнопки.'");
		ИнтеграцияИСМПТККлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстСообщения, ИнтеграцияИСМПТККлиентСервер.ДействиеОтзыв(), ПервыйВыделенныйАкт.Статус);
		ИнтеграцияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
		
КонецФункции

#Область УведомлениеОРасхождении

&НаКлиенте
Процедура ВвестиУведомлениеОРасхождении(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() > 0 Тогда
		
		Если Элементы.Список.ТекущиеДанные.ТипАкта = ПредопределенноеЗначение("Перечисление.ВидыДокументаИСМПТК.Исходный") Тогда
			Если МожноВводитьУОРпоАПП(Элементы.Список.ТекущиеДанные.Ссылка) Тогда
				ПараметрыФормы = Новый Структура;
				ПараметрыФормы.Вставить("Основание", Элементы.Список.ТекущиеДанные.Ссылка);
				ОткрытьФорму("Документ.УведомлениеОРасхожденииИСМПТК.ФормаОбъекта", ПараметрыФормы);
			Иначе
				ТекстСообщения = НСтр("ru='На основании %1 уже оформлено Уведомление о расхождениях!'");
				ТекстСообщения = ИнтеграцияИСМПТККлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстСообщения, Элементы.Список.ТекущиеДанные.Ссылка);
				ИнтеграцияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения, , , "Форма.Объект");
			КонецЕсли;
		Иначе
			ТекстСообщения = НСтр("ru='Документ %1 исправленный. Уведомление можно вводить только на основании первичного Акта.'");
			ТекстСообщения = ИнтеграцияИСМПТККлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстСообщения, Элементы.Список.ТекущиеДанные.Ссылка);
			ИнтеграцияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения, , , "Форма.Объект");
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция МожноВводитьУОРпоАПП(АПП)

	Возврат ?(ЗначениеЗаполнено(АПП.УведомлениеОРасхождении), Ложь, Истина);
	
КонецФункции

#КонецОбласти

