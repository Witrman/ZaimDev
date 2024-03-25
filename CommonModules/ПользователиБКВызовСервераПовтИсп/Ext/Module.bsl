﻿////////////////////////////////////////////////////////////////////////////////
// ПользователиБКВызовСервераПовтИсп: В модуле должны содержаться процедуры и функции
// выполяемые на сервере и связанные с получением/установкой настроек пользователя.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция возвращает значение по умолчанию для передаваемого пользователя и настройки.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - текущий пользователь программы
//  Настройка    - Строка - настройка, для которой возвращается значение по умолчанию
//
// Возвращаемое значение:
//  Значение по умолчанию для настройки.
//
Функция ПолучитьЗначениеПоУмолчанию(Пользователь = Неопределено, Настройка) Экспорт
	
	Если Настройка = "ОсновнойСклад" Тогда
		Возврат Справочники.Склады.ПолучитьСкладПоУмолчанию(Пользователь);
	КонецЕсли;
	
	Если Пользователь = Неопределено Тогда 
		Пользователь = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	Результат = ЗначенияНастроекПользователя(Пользователь, Настройка);
	Возврат Результат[СтрЗаменить(Настройка, ".", "")];
	
КонецФункции

// Функция возвращает структуру значений по умолчанию для передаваемого пользователя и списка настроек.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - текущий пользователь программы
//  Настройки    - Строка - настройки, значения которых необходимо получить
//
// Возвращаемое значение:
//  Структура значений по умолчанию для настройки.
//
Функция ЗначенияНастроекПользователя(Пользователь = Неопределено, Знач Настройки) Экспорт 
	
	Если Пользователь = Неопределено Тогда 
		Пользователь = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	СтрокаНастроек = "";
	МассивНастроек = Новый Массив;
	Если ТипЗнч(Настройки) = Тип("Строка") Тогда
		Если ПустаяСтрока(Настройки) Тогда
			Возврат Новый Структура;
		КонецЕсли;
		СтрокаНастроек = Настройки;
		МассивНастроек = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаНастроек, ",", Истина);
	ИначеЕсли ТипЗнч(Настройки) = Тип("Структура") Или ТипЗнч(Настройки) = Тип("ФиксированнаяСтруктура") Тогда
		СтрокаНастроек = ОбщегоНазначенияКлиентСервер.КлючиСтруктурыВСтроку(Настройки, ",");
		МассивНастроек = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаНастроек, ",", Истина);
	ИначеЕсли ТипЗнч(Настройки) = Тип("Массив") Или ТипЗнч(Настройки) = Тип("ФиксированныйМассив") Тогда
		СтрокаНастроек = СтрСоединить(Настройки, ",");
		МассивНастроек = Настройки;
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неверный тип второго параметра Реквизиты: %1'"),
			Строка(ТипЗнч(Настройки)));
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("МассивНастроек", МассивНастроек);
	Запрос.Текст = "ВЫБРАТЬ
	               |	НастройкиПользователей.Ссылка,
	               |	НастройкиПользователей.ТипЗначения,
	               |	НастройкиПользователей.Идентификатор
	               |ПОМЕСТИТЬ ВТ_НастройкиПользователя
	               |ИЗ
	               |	ПланВидовХарактеристик.НастройкиПользователей КАК НастройкиПользователей
	               |ГДЕ
	               |	НастройкиПользователей.Идентификатор В(&МассивНастроек)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	РегистрЗначениеПрав.Значение,
	               |	ВТ_НастройкиПользователя.ТипЗначения,
	               |	ВТ_НастройкиПользователя.Идентификатор
	               |ИЗ
	               |	ВТ_НастройкиПользователя КАК ВТ_НастройкиПользователя
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиПользователей КАК РегистрЗначениеПрав
	               |		ПО ВТ_НастройкиПользователя.Ссылка = РегистрЗначениеПрав.Настройка
	               |			И (РегистрЗначениеПрав.Пользователь = &Пользователь)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = Новый Структура(СтрокаНастроек);
	
	Если НЕ Выборка.Количество() = 0 Тогда
		
		Результат.Вставить("ОтражатьДокументыВНалоговомУчете", 		Истина);
		Результат.Вставить("ОтражатьДокументыВУправленческомУчете", Истина);
		Результат.Вставить("ОтражатьДокументыВБухгалтерскомУчете", 	Истина);
		
		Пока Выборка.Следующий() И Результат.Свойство(Выборка.Идентификатор) Цикл
			ЗначениеНастройки = Выборка.ТипЗначения.ПривестиЗначение(Выборка.Значение);
			Результат[Выборка.Идентификатор] = ЗначениеНастройки;
		КонецЦикла;
		
	Иначе
		// приведем к типу настройки по умолчанию
		Для Каждого ЗначениеСтруктуры Из Результат Цикл
			НастройкаПользователя = ПланыВидовХарактеристик.НастройкиПользователей.НайтиПоРеквизиту("Идентификатор", ЗначениеСтруктуры.Ключ);
			Если ЗначениеЗаполнено(НастройкаПользователя) Тогда
				Результат[ЗначениеСтруктуры.Ключ] = НастройкаПользователя.ТипЗначения.ПривестиЗначение();
			КонецЕсли;
			
		КонецЦикла;
		
		Результат.Вставить("ОтражатьДокументыВНалоговомУчете", 		Истина);
		Результат.Вставить("ОтражатьДокументыВУправленческомУчете", Истина);
		Результат.Вставить("ОтражатьДокументыВБухгалтерскомУчете", 	Истина);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция возвращает список значений права, установленных для пользователя.
// Если количество значений меньше количество доступных ролей, то возвращается значение по умолчанию
//
// Параметры:
//  Право               - ПланВидовХарактеристиксСсылка.ПраваПользователей - право, для которого определяются значения
//  ЗначениеПоУмолчанию - значение по умолчанию для передаваемого права (возвращается в случае
//                        отсутствия значений в регистре сведений)
//
// Возвращаемое значение:
//  Список всех значений, установленных наборам прав (ролям), доступных пользователю
//
Функция ПолучитьЗначениеПраваДляТекущегоПользователя(Право, ЗначениеПоУмолчанию = Неопределено) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	ВозвращаемыеЗначения = Новый СписокЗначений;

	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("Пользователь"     , Пользователи.ТекущийПользователь());
	Запрос.УстановитьПараметр("ПравоПользователя", Право);

	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	РегистрЗначениеПрав.Значение
	|ИЗ
	|	РегистрСведений.ЗначенияПравПользователя КАК РегистрЗначениеПрав
	|ГДЕ
	|	РегистрЗначениеПрав.Право = &ПравоПользователя
	|	И РегистрЗначениеПрав.Пользователь В
	|			(ВЫБРАТЬ
	|				ПользователиГруппы.Ссылка КАК Ссылка
	|			ИЗ
	|				Справочник.ГруппыПользователей.Состав КАК ПользователиГруппы
	|			ГДЕ
	|				ПользователиГруппы.Пользователь = &Пользователь
	|		
	|			ОБЪЕДИНИТЬ ВСЕ
	|		
	|			ВЫБРАТЬ
	|				ЗНАЧЕНИЕ(Справочник.ГруппыПользователей.ВсеПользователи)
	|		
	|			ОБЪЕДИНИТЬ ВСЕ
	|		
	|			ВЫБРАТЬ
	|				&Пользователь)";

	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Количество() = 0 Тогда
		ВозвращаемыеЗначения.Добавить(ЗначениеПоУмолчанию);
	Иначе
		Пока Выборка.Следующий() Цикл
			ВозвращаемыеЗначения.Добавить(Выборка.Значение);
		КонецЦикла;
	КонецЕсли;

	Возврат ВозвращаемыеЗначения;

КонецФункции

// Функция возвращает право печати непроведенных документов.
//
// Параметры:
//  нет.
//
// Возвращаемое значение:
//  Истина - если можно печатать, иначе Ложь.
//
Функция РазрешитьПечатьНепроведенныхДокументов() Экспорт

	РазрешеноПечатать = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПраваДляТекущегоПользователя(ПланыВидовХарактеристик.ПраваПользователей.ПечатьНепроведенныхДокументов, Истина);
	Если (РазрешеноПечатать.Количество() = 0)
	 ИЛИ (РазрешеноПечатать.Количество() > 1) Тогда
		Возврат Истина;
	Иначе
		Возврат РазрешеноПечатать[0].Значение;
	КонецЕсли;

КонецФункции

// Функция возвращает право проведения кассовых документов без проверки достаточности средств на счете.
//
// Параметры:
//  нет.
//
// Возвращаемое значение:
//  Истина - если можно печатать, иначе Ложь.
//
Функция ЗапретитьПроводитьОперацииПриНедостаточностиСредствНаСчете(ЗначениеПоУмолчанию) Экспорт

	ЗапрещеноПроводитьОперацииПриНедостаточностиСредствНаСчете = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПраваДляТекущегоПользователя(ПланыВидовХарактеристик.ПраваПользователей.КонтрольОстатковПриПроведенииОпераций, ЗначениеПоУмолчанию);
	Если (ЗапрещеноПроводитьОперацииПриНедостаточностиСредствНаСчете.Количество() = 0) Тогда
		Возврат ЗначениеПоУмолчанию;
    ИначеЕсли (ЗапрещеноПроводитьОперацииПриНедостаточностиСредствНаСчете.Количество() = 1) Тогда
		Возврат ЗапрещеноПроводитьОперацииПриНедостаточностиСредствНаСчете[0].Значение;
	Иначе
		Возврат Ложь; // в одной из ролей пользователя провеление разрешено, следовательно пользователю разрешено проводить документы без контроля	
	КонецЕсли;  
КонецФункции

// Функция возвращает право на выполнение регл.операции "Закрытие счетов НУ" в документе "Закрытие месяца".
//
// Параметры:
//  нет.
//
// Возвращаемое значение:
//  Истина - если можно печатать, иначе Ложь.
//
Функция ДоступностьВыполненииОперацииЗакрытиеСчетовНУ() Экспорт

	ДоступностьОперации = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПраваДляТекущегоПользователя(ПланыВидовХарактеристик.ПраваПользователей.ВыполнятьРеглОперациюЗакрытиеСчетовНУ, Истина);
	Если (ДоступностьОперации.Количество() = 0)
	 ИЛИ (ДоступностьОперации.Количество() > 1) Тогда
		Возврат Истина;
	Иначе
		Возврат ДоступностьОперации[0].Значение;
	КонецЕсли;

КонецФункции


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
