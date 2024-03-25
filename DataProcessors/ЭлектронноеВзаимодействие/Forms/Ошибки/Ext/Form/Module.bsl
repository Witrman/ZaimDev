﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КлючСохраненияПоложенияОкна = "" + Новый УникальныйИдентификатор;
	
	КонтекстОперации = Неопределено;
	Если Не Параметры.Свойство("КонтекстОперации", КонтекстОперации) Тогда
		Возврат; 
	КонецЕсли;
	
	Параметры.Свойство("ВозможенПовторДействия", ВозможенПовторДействия);
	
	Если КонтекстОперации.ЗаголовокОперации = "" Тогда
		Заголовок = НСтр("ru = 'При выполнении операции произошли ошибки:'");
	Иначе 
		Заголовок = КонтекстОперации.ЗаголовокОперации + " " + НСтр("ru = 'произошли ошибки:'");
	КонецЕсли;
	
	КонтекстОперации.ТекущийПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	
	ПараметрыВидовОшибок = Неопределено;
	
	Если Не Параметры.Свойство("ПараметрыВидовОшибок", ПараметрыВидовОшибок) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не заполнен параметр ""ПараметрыВидовОшибок"", использование формы невозможно'"));
		Возврат; 
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ОбщегоНазначения.СообщитьПользователю(Заголовок, , , , Отказ);
		Для каждого Ошибка Из КонтекстОперации.Диагностика.Ошибки Цикл
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(
				Заголовок, Ошибка.ПодробноеПредставлениеОшибки, Ошибка.КраткоеПредставлениеОшибки);
		КонецЦикла;
	Иначе
		ВывестиОшибки(ПараметрыВидовОшибок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентами = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСКонтрагентамиСлужебныйКлиент");
		Элементы.Техподдержка.Заголовок = МодульОбменСКонтрагентами.СформироватьГиперссылкуДляОбращенияВСлужбуПоддержки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ИмяСобытияИсправлениеОшибок() Тогда
		
		Если ТипЗнч(Параметр) = Тип("Массив") И Параметр.Количество() > 0 И ТипЗнч(Параметр[0]) = Тип("Строка") Тогда // переданы виды ошибок
			ВидыОшибок = Параметр;
			Для Сч = - (Ошибки.Количество() - 1) По 0 Цикл 
				Если ВидыОшибок.Найти(Ошибки[-Сч].ВидОшибки) <> Неопределено Тогда
					Ошибки.Удалить(-Сч);
				КонецЕсли;
			КонецЦикла;
			ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.УдалитьОшибки(КонтекстОперации, Новый Структура("ВидОшибки", ВидыОшибок));
		ИначеЕсли ТипЗнч(Параметр) = Тип("Структура") Или ТипЗнч(Параметр) = Тип("Соответствие") Тогда // передан отбор
			ВидыОшибок = Новый Массив;
			Отбор = Параметр;
			Для Сч = - (Ошибки.Количество() - 1) По 0 Цикл 
				Если ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.ОшибкаСоответствуетОтбору(Ошибки[-Сч].Ошибка, Отбор) Тогда
					ВидыОшибок.Добавить(Ошибки[-Сч].ВидОшибки);
					Ошибки.Удалить(-Сч);
				КонецЕсли;
			КонецЦикла;
			ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.УдалитьОшибки(КонтекстОперации, Отбор);
		Иначе // передан массив ошибок 
			ИдентификаторыОшибок = Новый Массив;
			ВидыОшибок = Новый Массив;
			Для каждого Ошибка Из Параметр Цикл
				ИдентификаторыОшибок.Добавить(Ошибка.Идентификатор);
				СтрокиТЗ = Ошибки.НайтиСтроки(Новый Структура("Идентификатор", Ошибка.Идентификатор)); 
				Если СтрокиТЗ.Количество() Тогда
					Ошибки.Удалить(СтрокиТЗ[0]);
				КонецЕсли;
				Если ВидыОшибок.Найти(Ошибка.ВидОшибки) = Неопределено Тогда
					ВидыОшибок.Добавить(Ошибка.ВидОшибки);
				КонецЕсли;
			КонецЦикла;
			ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.УдалитьОшибки(КонтекстОперации, Новый Структура("Идентификатор", ИдентификаторыОшибок));
		КонецЕсли;
		
		Для каждого ВидОшибки Из ВидыОшибок Цикл
			ОбновитьЭлементыФормыРешения(ВидОшибки);
		КонецЦикла;
		Если ВозможенПовторДействия И Ошибки.Количество() = 0 Тогда
			Элементы.ПовторитьОперацию.Видимость = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПовторитьОперацию(Команда)
	
	Закрыть(ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ДействиеПовторитьДействие());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВывестиОшибки(ПараметрыВидовОшибок)
	
	Сч = 0;
	ОбработанныеВидыОшибок = Новый Соответствие;
	
	Для каждого Ошибка Из КонтекстОперации.Диагностика.Ошибки Цикл
		ПараметрыВидаОшибки = ПараметрыВидовОшибок[Ошибка.ВидОшибки];
		НоваяСтрока = Ошибки.Добавить();
		НоваяСтрока.Ошибка = Ошибка;
		НоваяСтрока.Идентификатор = Ошибка.Идентификатор;
		НоваяСтрока.ВидОшибки = Ошибка.ВидОшибки;
		
		СвойстваОшибокВидаДиагностики = ОбработанныеВидыОшибок.Получить(Ошибка.ВидОшибки);
		Если СвойстваОшибокВидаДиагностики = Неопределено Тогда
			СвойстваОшибок = Новый Структура;
			СвойстваОшибок.Вставить("Количество", 1);
			ОбработанныеВидыОшибок.Вставить(Ошибка.ВидОшибки, СвойстваОшибок);
		Иначе 
			СвойстваОшибокВидаДиагностики.Количество = СвойстваОшибокВидаДиагностики.Количество + 1;
			Продолжить;
		КонецЕсли;
		ГруппаОшибка = Элементы.Добавить(Ошибка.ВидОшибки + "_ГруппаОшибка", Тип("ГруппаФормы"), Элементы.ГруппаОшибки);
		ГруппаОшибка.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаОшибка.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
		ГруппаОшибка.Объединенная = Ложь;
		ГруппаОшибка.ОтображатьЗаголовок = Ложь;
		Если Сч%2 <> 0 Тогда
			ГруппаОшибка.ЦветФона = ЦветаСтиля.ЦветФонаЧередованияСтрокиБЭД;
		КонецЕсли;
		
		ЭлементыКолонки = СоздатьКолонкуТаблицыОшибок(ГруппаОшибка, Ошибка.ВидОшибки, Истина);
		Если ПараметрыВидаОшибки.Статус = ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.СтатусОшибкиОбычная() Тогда
			КартинкаОшибки = БиблиотекаКартинок.ЖелтыйШарБЭД;
		ИначеЕсли ПараметрыВидаОшибки.Статус = ЭлектронноеВзаимодействиеОбработкаОшибокКлиентСервер.СтатусОшибкиВажная() Тогда
			КартинкаОшибки = БиблиотекаКартинок.КрасныйШарБЭД;
		Иначе
			КартинкаОшибки = БиблиотекаКартинок.КрасныйШарБЭД;
		КонецЕсли;
		ЭлементыКолонки.ДекорацияКартинка.Картинка = КартинкаОшибки;
		ЭлементыКолонки.ДекорацияОписание.Заголовок = ПараметрыВидаОшибки.ЗаголовокПроблемы;
		ЭлементыКолонки.ДекорацияПояснение.Заголовок = ПараметрыВидаОшибки.ОписаниеПроблемы;
		Если Не ЗначениеЗаполнено(ПараметрыВидаОшибки.ОписаниеПроблемы) Тогда
			ЭлементыКолонки.ДекорацияПояснение.Видимость = Ложь;
		КонецЕсли;
		
		Если ПараметрыВидаОшибки.ВыводитьСсылкуНаСписокОшибок Тогда
			ДекорацияСписокОшибок = Элементы.Добавить(Ошибка.ВидОшибки + "_ДекорацияСписокОшибок", Тип("ДекорацияФормы"), ЭлементыКолонки.ГруппаОписание);
			ДекорацияСписокОшибок.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(НСтр("ru = 'См. <a href = ""список ошибок"">список ошибок</a>'"));
			ДекорацияСписокОшибок.УстановитьДействие("ОбработкаНавигационнойСсылки", "Подключаемый_ОбработкаНавигационнойСсылки");
		КонецЕсли;
	
		ЭлементыКолонки = СоздатьКолонкуТаблицыОшибок(ГруппаОшибка, Ошибка.ВидОшибки, Ложь);
		ЭлементыКолонки.ДекорацияКартинка.Картинка = БиблиотекаКартинок.Информация;
		ЭлементыКолонки.ДекорацияОписание.Заголовок = НСтр("ru = 'Решение'");
		ЭлементыКолонки.ДекорацияПояснение.Заголовок = ПараметрыВидаОшибки.ОписаниеРешения;
		
		Сч = Сч + 1;
	КонецЦикла;
	
	Для каждого КлючИЗначение Из ОбработанныеВидыОшибок Цикл
		ПараметрыВидаОшибки = ПараметрыВидовОшибок[КлючИЗначение.Ключ];
		УстановитьЗаголовокОписаниеОшибки(ЭтаФорма, ПараметрыВидаОшибки, КлючИЗначение.Ключ, КлючИЗначение.Значение.Количество);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СоздатьКолонкуТаблицыОшибок(Родитель, ВидОшибки, ЭтоКолонкаОшибка)
	
	Если ЭтоКолонкаОшибка Тогда
		ПостфиксИмениЭлементов = "Ошибка";
		ИмяЭлементаДекорацияОписание = ИмяЭлементаОписаниеОшибки(ВидОшибки);
		ИмяЭлементаДекорацияПояснение = ИмяЭлементаПояснениеОшибки(ВидОшибки);
		ИмяЭлементаДекорацияКартинка = ИмяЭлементаКартинкаОшибки(ВидОшибки);
	Иначе 
		ИмяЭлементаДекорацияОписание = ИмяЭлементаОписаниеРешения(ВидОшибки);
		ИмяЭлементаДекорацияПояснение = ИмяЭлементаПояснениеРешения(ВидОшибки);
		ИмяЭлементаДекорацияКартинка = ВидОшибки + "_ДекорацияКартинкаРешение";
		ПостфиксИмениЭлементов = "Решение";
	КонецЕсли;
	
	ЭлементыКолонки = Новый Структура;
	
	ГруппаОписание = Элементы.Добавить(ВидОшибки + "_ГруппаОписание" + ПостфиксИмениЭлементов, Тип("ГруппаФормы"), Родитель);
	ГруппаОписание.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаОписание.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаОписание.Объединенная = Истина;
	ГруппаОписание.ОтображатьЗаголовок = Ложь;
	ЭлементыКолонки.Вставить("ГруппаОписание", ГруппаОписание);
	
	ГруппаЗаголовок = Элементы.Добавить(ВидОшибки + "_ГруппаЗаголовок" + ПостфиксИмениЭлементов, Тип("ГруппаФормы"), ГруппаОписание);
	ГруппаЗаголовок.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаЗаголовок.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	ГруппаЗаголовок.ОтображатьЗаголовок = Ложь;
	
	ДекорацияКартинка = Элементы.Добавить(ИмяЭлементаДекорацияКартинка, Тип("ДекорацияФормы"), ГруппаЗаголовок);
	ДекорацияКартинка.Вид = ВидДекорацииФормы.Картинка;
	ЭлементыКолонки.Вставить("ДекорацияКартинка", ДекорацияКартинка);
	
	ДекорацияОписание = Элементы.Добавить(ИмяЭлементаДекорацияОписание, Тип("ДекорацияФормы"), ГруппаЗаголовок);
	ДекорацияОписание.Шрифт = ШрифтыСтиля.УвеличенныйПолужирныйШрифтБЭД;
	ДекорацияОписание.АвтоМаксимальнаяШирина = Ложь;
	ЭлементыКолонки.Вставить("ДекорацияОписание", ДекорацияОписание);
	
	ДекорацияПояснение = Элементы.Добавить(ИмяЭлементаДекорацияПояснение, Тип("ДекорацияФормы"), ГруппаОписание);
	ДекорацияПояснение.АвтоМаксимальнаяШирина = Ложь;
	ДекорацияПояснение.РастягиватьПоГоризонтали = Истина;
	ДекорацияПояснение.МаксимальнаяШирина = 70;
	ДекорацияПояснение.УстановитьДействие("ОбработкаНавигационнойСсылки", "Подключаемый_ОбработкаНавигационнойСсылки");
	ЭлементыКолонки.Вставить("ДекорацияПояснение", ДекорацияПояснение);
	
	Возврат ЭлементыКолонки;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	МассивСоставляющих = СтрРазделить(Элемент.Имя, "_");
	ВидОшибки = МассивСоставляющих[0];
	
	ПараметрыВидаОшибки = ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ПараметрыВидаОшибки(ВидОшибки);
	Обработчик = ПараметрыВидаОшибки.ОбработчикиНажатия.Получить(НавигационнаяСсылкаФорматированнойСтроки);
	Если Обработчик <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыОбработчика = ПараметрыВидаОшибки.ПараметрыОбработчиков.Получить(НавигационнаяСсылкаФорматированнойСтроки);
		ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ВыполнитьОбработчикВидаОшибки(ВидОшибки, Обработчик, КонтекстОперации, ПараметрыОбработчика);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЭлементыФормыРешения(ВидОшибки) 
	
	КоличествоОшибок = Ошибки.НайтиСтроки(Новый Структура("ВидОшибки", ВидОшибки)).Количество();
	Если КоличествоОшибок = 0 Тогда
		Элементы[ИмяЭлементаКартинкаОшибки(ВидОшибки)].Картинка = БиблиотекаКартинок.ЗеленыйШарБЭД;
		Элементы[ИмяЭлементаПояснениеРешения(ВидОшибки)].Заголовок = НСтр("ru = 'Не требуется'");
		Элементы[ИмяЭлементаПояснениеОшибки(ВидОшибки)].Заголовок = НСтр("ru = 'Проблемы устранены'");
	КонецЕсли;
	ПараметрыВидаОшибки = ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ПараметрыВидаОшибки(ВидОшибки);
	УстановитьЗаголовокОписаниеОшибки(ЭтаФорма, ПараметрыВидаОшибки, ВидОшибки, КоличествоОшибок);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяЭлементаКартинкаОшибки(ВидОшибки) 
	
	Возврат ВидОшибки + "_ДекорацияКартинкаОшибка";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяЭлементаПояснениеРешения(ВидОшибки) 
	
	Возврат ВидОшибки + "_ДекорацияПояснениеРешения";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяЭлементаПояснениеОшибки(ВидОшибки) 
	
	Возврат ВидОшибки + "_ДекорацияПояснениеОшибки";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяЭлементаОписаниеОшибки(ВидОшибки) 
	
	Возврат ВидОшибки + "_ДекорацияОписаниеОшибки";
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ИмяЭлементаОписаниеРешения(ВидОшибки) 
	
	Возврат ВидОшибки + "_ДекорацияОписаниеРешения";
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокОписаниеОшибки(Форма, ПараметрыВидаОшибки, ВидОшибки, КоличествоОшибок = Неопределено)
	
	Если КоличествоОшибок = Неопределено Тогда
		КоличествоОшибок = Форма.Ошибки.НайтиСтроки(Новый Структура("ВидОшибки", ВидОшибки)).Количество();
	КонецЕсли;
	Если КоличествоОшибок > 1 Тогда
		ЗаголовокОписаниеОшибки = СтрШаблон("%1 (%2)", ПараметрыВидаОшибки.ЗаголовокПроблемы, КоличествоОшибок);
	Иначе 
		ЗаголовокОписаниеОшибки = ПараметрыВидаОшибки.ЗаголовокПроблемы;
	КонецЕсли;
	
	Форма.Элементы[ИмяЭлементаОписаниеОшибки(ВидОшибки)].Заголовок = ЗаголовокОписаниеОшибки;
	
КонецПроцедуры

#КонецОбласти

