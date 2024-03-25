﻿////////////////////////////////////////////////////////////////////////////////
// Функции и процедуры обеспечения формирования бухгалтерских отчетов.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Получает параметр вывода компоновщика настроек или настройки СКД
//
// Параметры:
//		КомпоновщикНастроекГруппировка - компоновщик настроек или настройка/группировка СКД
//		ИмяПараметра - имя параметра СКД
//
Функция ПолучитьПараметрВывода(Настройка, ИмяПараметра) Экспорт
	
	МассивПараметров   = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяПараметра, ".");
	УровеньВложенности = МассивПараметров.Количество();
	
	Если УровеньВложенности > 1 Тогда
		ИмяПараметра = МассивПараметров[0];		
	КонецЕсли;
	
	Если ТипЗнч(Настройка) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройка.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	Иначе
		ЗначениеПараметра = Настройка.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	КонецЕсли;
	
	Если УровеньВложенности > 1 Тогда
		Для Индекс = 1 По УровеньВложенности - 1 Цикл
			ИмяПараметра = ИмяПараметра + "." + МассивПараметров[Индекс];
			ЗначениеПараметра = ЗначениеПараметра.ЗначенияВложенныхПараметров.Найти(ИмяПараметра); 
		КонецЦикла;
	КонецЕсли;
	
	Возврат ЗначениеПараметра;  
	
КонецФункции

// Устанавливает параметр вывода компоновщика настроек или настройки СКД
//
// Параметры:
//		КомпоновщикНастроекГруппировка - компоновщик настроек или настройка/группировка СКД
//		ИмяПараметра - имя параметра СКД
//		Значение - значение параметра вывода СКД
//		Использование - Признак использования параметра. По умолчанию всегда принимается равным истине.
//
Функция УстановитьПараметрВывода(Настройка, ИмяПараметра, Значение, Использование = Истина) Экспорт
	
	ЗначениеПараметра = ПолучитьПараметрВывода(Настройка, ИмяПараметра);
	
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Использование = Использование;
		ЗначениеПараметра.Значение      = Значение;
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

Функция НачалоПериода(Период, Периодичность) Экспорт
	
	НачалоПериода = Период;
	Если Периодичность = 6 Тогда       //День
		НачалоПериода = НачалоДня(Период);
	ИначеЕсли Периодичность = 7 Тогда  //Неделя
		НачалоПериода = НачалоНедели(Период);
	ИначеЕсли Периодичность = 8 Тогда  //Декада
		Если День(Период) <= 10 Тогда
			НачалоПериода = Дата(Год(Период), Месяц(Период), 1);
		ИначеЕсли День(Период) > 10 И День(Период) <= 20 Тогда
			НачалоПериода = Дата(Год(Период), Месяц(Период), 11);
		Иначе
			НачалоПериода = Дата(Год(Период), Месяц(Период), 21);
		КонецЕсли;
	ИначеЕсли Периодичность = 9 Тогда  //Месяц
		НачалоПериода = НачалоМесяца(Период);
	ИначеЕсли Периодичность = 10 Тогда //Квартал
		НачалоПериода = НачалоКвартала(Период);
	ИначеЕсли Периодичность = 11 Тогда //Полугодие
		НачалоПериода = ?(Месяц(Период) < 7, НачалоДня(Дата(Год(Период), 1, 1)), НачалоДня(Дата(Год(Период), 7, 1)));
	ИначеЕсли Периодичность = 12 Тогда //Год
		НачалоПериода = НачалоГода(Период);
	КонецЕсли;
	
	Возврат НачалоПериода;
	
КонецФункции

Функция КонецПериода(Период, Периодичность) Экспорт
	
	КонецПериода = Период;
	Если Периодичность = 6 Тогда       //День
		КонецПериода = КонецДня(Период);
	ИначеЕсли Периодичность = 7 Тогда  //Неделя
		КонецПериода = КонецНедели(Период);
	ИначеЕсли Периодичность = 8 Тогда  //Декада
		Если День(Период) > 20 Тогда
			КонецПериода = КонецМесяца(Период);
		Иначе
			КонецПериода = КонецДня(Период + 10 * 86400 - 1);
		КонецЕсли; 
	ИначеЕсли Периодичность = 9 Тогда  //Месяц
		КонецПериода = КонецМесяца(Период);
	ИначеЕсли Периодичность = 10 Тогда //Квартал
		КонецПериода = КонецКвартала(Период);
	ИначеЕсли Периодичность = 11 Тогда //Полугодие
		КонецПериода = ?(Месяц(Период) < 7, КонецДня(Дата(Год(Период), 6, 30)), КонецДня(Дата(Год(Период), 12, 31)));
	ИначеЕсли Периодичность = 12 Тогда //Год
		КонецПериода = КонецГода(Период);
	КонецЕсли;
	
	Возврат КонецПериода;
	
КонецФункции

Функция ПолучитьНаименованиеЗаданияВыполненияОтчета(Форма) Экспорт
	
	НаименованиеЗадания = НСтр("ru = 'Выполнение отчета: %1'");
	ИмяОтчета = ПолучитьИдентификаторОбъекта(Форма);
	НаименованиеЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НаименованиеЗадания, ИмяОтчета);
	
	Возврат НаименованиеЗадания;
	
КонецФункции

Функция ПолучитьСвойствоПоля(ЭлементСтруктура, Поле, Свойство = "Заголовок") Экспорт
	
	Если ТипЗнч(ЭлементСтруктура) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Коллекция = ЭлементСтруктура.Настройки.ДоступныеПоляВыбора;
	Иначе
		Коллекция = ЭлементСтруктура;
	КонецЕсли;
	
	ПолеСтрокой = Строка(Поле);
	ПозицияКвадратнойСкобки = Найти(ПолеСтрокой, "[");
	Окончание = "";
	Заголовок = "";
	Если ПозицияКвадратнойСкобки > 0 Тогда
		Окончание = Сред(ПолеСтрокой, ПозицияКвадратнойСкобки);
		ПолеСтрокой = Лев(ПолеСтрокой, ПозицияКвадратнойСкобки - 2);
	КонецЕсли;
	
	МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолеСтрокой, ".");
	
	Если Не ПустаяСтрока(Окончание) Тогда
		МассивСтрок.Добавить(Окончание);
	КонецЕсли;
	
	ДоступныеПоля = Коллекция.Элементы;
	ПолеПоиска = "";
	Для Индекс = 0 По МассивСтрок.Количество() - 1 Цикл
		ПолеПоиска = ПолеПоиска + ?(Индекс = 0, "", ".") + МассивСтрок[Индекс];
		ДоступноеПоле = ДоступныеПоля.Найти(ПолеПоиска);
		Если ДоступноеПоле <> Неопределено Тогда
			ДоступныеПоля = ДоступноеПоле.Элементы;
		КонецЕсли;
	КонецЦикла;
	
	Если ДоступноеПоле <> Неопределено Тогда
		Если Свойство = "ДоступноеПоле" Тогда
			Результат = ДоступноеПоле;
		Иначе
			Результат = ДоступноеПоле[Свойство]; 
		КонецЕсли;
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция возвращает представление всех элементов списка в виде строки для вывода в текстовые поля
// 
// Параметры
//	Список - объект список значений
//	МаксЧислоСимволовНаЭлемент - предельное число символов, выводимых для одного элемента, если больше, то окончание заменяется "..."
//	РазделительЭлеменов - строка, используемая для разделения элементов друг от друга
//
Функция ВыгрузитьСписокВСтроку(Список, МаксЧислоСимволовНаЭлемент = 50, РазделительЭлементов = "; ", ВыгружатьПолныеНаименованияОрганизаций=Ложь, ПредставлениеПустойСсылки = "") Экспорт

	Результат = "";
	Для Каждого ЭлементСписка Из Список Цикл
		Если НЕ ВыгружатьПолныеНаименованияОрганизаций Тогда
			Если Не ПустаяСтрока(ЭлементСписка.Представление) Тогда
				ПредставлениеЭлемента = ЭлементСписка.Представление;
			Иначе
				ПредставлениеЭлемента = Строка(ЭлементСписка.Значение);
			КонецЕсли;
			ПредставлениеЭлемента = СокрЛП(ПредставлениеЭлемента);
			Если Не ПустаяСтрока(ПредставлениеЭлемента) Тогда
				
				Если МаксЧислоСимволовНаЭлемент > 0 И Список.Количество() > 1 Тогда
					Если СтрДлина(ПредставлениеЭлемента) > МаксЧислоСимволовНаЭлемент Тогда
						ПредставлениеЭлемента = Лев(ПредставлениеЭлемента, МаксЧислоСимволовНаЭлемент) + "...";
					КонецЕсли;
				КонецЕсли;
			
				Если Не ПустаяСтрока(Результат) Тогда
					Результат = Результат + РазделительЭлементов;
				КонецЕсли;
			
				Результат = Результат + ПредставлениеЭлемента;
				
			КонецЕсли;
		Иначе
			Попытка 
				ПредставлениеЭлемента = ЭлементСписка.Значение.НаименованиеПолное;
			Исключение
				ПредставлениеЭлемента = "";
			КонецПопытки;
			Если Не ПустаяСтрока(Результат) Тогда
				Результат = Результат + РазделительЭлементов;
			КонецЕсли;
		
			Результат = Результат + ПредставлениеЭлемента;
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции // ВыгрузитьСписокВСтроку()

Функция ПолучитьИдентификаторОбъекта(Форма) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Форма.ИмяФормы, ".")[1];
	
КонецФункции

Функция ПростойТип(Значение) Экспорт
	
	ОписаниеПростыхТипов = Новый ОписаниеТипов("Дата, Строка, Булево, Число");
	
	Возврат ОписаниеПростыхТипов.СодержитТип(ТипЗнч(Значение));
	
КонецФункции

Процедура ИзменитьЗаголовокКнопкиПанельНастроек(Кнопка, ВидимостьПанелиНастроек) Экспорт
	
	Если ВидимостьПанелиНастроек Тогда
		Кнопка.Заголовок = НСтр("ru = 'Скрыть настройки'");
	Иначе
		Кнопка.Заголовок = НСтр("ru = 'Показать настройки'");
	КонецЕсли;
		
КонецПроцедуры

// Функция возвращает значение параметра компоновки данных
//
// Параметры:
//  Настройки - Пользовательские настройки СКД, Настройки СКД, Компоновщик настроек
//  Параметр - имя параметра СКД для которого нужно вернуть значение параметра
Функция ПолучитьПараметр(Настройки, Параметр) Экспорт
	
	ЗначениеПараметра = Неопределено;
	ПолеПараметр = ?(ТипЗнч(Параметр) = Тип("Строка"), Новый ПараметрКомпоновкиДанных(Параметр), Параметр);
	
	Если ТипЗнч(Настройки) = Тип("НастройкиКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
	ИначеЕсли ТипЗнч(Настройки) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
		Для Каждого ЭлементНастройки Из Настройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ЭлементНастройки.Параметр = ПолеПараметр Тогда
				ЗначениеПараметра = ЭлементНастройки;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(Настройки) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Для Каждого ЭлементНастройки Из Настройки.ПользовательскиеНастройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ЭлементНастройки.Параметр = ПолеПараметр Тогда
				ЗначениеПараметра = ЭлементНастройки;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЗначениеПараметра = Неопределено Тогда
			ЗначениеПараметра = Настройки.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
		КонецЕсли;
	#Если Сервер Тогда
	ИначеЕсли ТипЗнч(Настройки) = Тип("ДанныеРасшифровкиКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
	#КонецЕсли		
	ИначеЕсли ТипЗнч(Настройки) = Тип("КоллекцияЗначенийПараметровКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.Найти(ПолеПараметр);
	ИначеЕсли ТипЗнч(Настройки) = Тип("ОформлениеКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.НайтиЗначениеПараметра(ПолеПараметр);
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

// Функция устанавливает значение параметра компоновки данных
//
// Параметры:
//		Настройки     - Пользовательские настройки СКД, Настройки СКД, Компоновщик настроек
//		Параметр      - имя параметра СКД для которого нужно вернуть значение параметра
//      Значение      - значение параметра
//		Использование - Признак использования параметра. По умолчанию всегда принимается равным истине.
//
Функция УстановитьПараметр(Настройки, Параметр, Значение, Использование = Истина) Экспорт
	
	ЗначениеПараметра = ПолучитьПараметр(Настройки, Параметр);
	
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Использование = Использование;
		ЗначениеПараметра.Значение      = Значение;
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

Процедура ДобавитьПараметр(ЭлементСтруктуры, Знач Поле, Значение, Использовать = Истина) Экспорт
	
	Если ТипЗнч(Поле) = Тип("Строка") Тогда
		Поле = Новый ПараметрКомпоновкиДанных(Поле);
	КонецЕсли;
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("Массив") Тогда
		СтруктураПараметра = Новый Структура("Параметр, Значение, Использование", Поле, Значение, Истина);
		ЭлементСтруктуры.Добавить(СтруктураПараметра);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьПредставлениеПериода(НачалоПериода = '00010101', КонецПериода = '00010101', ТолькоДаты  = Ложь) Экспорт
	
	ТекстПериод = "";
	
	Если ЗначениеЗаполнено(КонецПериода) Тогда 
		Если КонецПериода >= НачалоПериода Тогда
			ТекстПериод = ?(ТолькоДаты, "", " за ") + ПредставлениеПериода(НачалоДня(НачалоПериода), КонецДня(КонецПериода), "ФП = Истина");
		Иначе
			ТекстПериод = "";
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(НачалоПериода) И Не ЗначениеЗаполнено(КонецПериода) Тогда
		ТекстПериод = ?(ТолькоДаты, "", " за ") + ПредставлениеПериода(НачалоДня(НачалоПериода), КонецДня(Дата(3999, 11, 11)), "ФП = Истина");
		ТекстПериод = СтрЗаменить(ТекстПериод, Сред(ТекстПериод, Найти(ТекстПериод, " - ")), " - ...");
	КонецЕсли;
	
	Возврат ТекстПериод;
	
КонецФункции

// Функция формирует полное представление периода по дате начала и дате окончания
// (полное название месяца и 4 цифры года)
//
// Параметры
//  ДатаНачала	   – Дата – дата начала периода.
//  ДатаОкончания  – Дата – дата окончания периода.
//  СДатами		   – Булево – признак того, что описание периода будет сформирован 
//					 без указания чисел месяца.
//
// Возвращаемое значение:
//   Строка   – строковое представление периода.
//
Функция ПолноеОписаниеПериода(ДатаНачала, ДатаОкончания, СДатами = Истина) Экспорт
	
	ЧислоНачала		= День(ДатаНачала);
	ЧислоОкончания	= День(ДатаОкончания);
	ОписаниеМесяцаГода = Формат(ДатаНачала,   "ДФ = 'MMMM'") + " "+ Формат(ДатаНачала,    "ДФ = 'гггг'");
	ОписаниеМесяца2    = Формат(ДатаОкончания,"ДФ = 'MMMM'") + " "+ Формат(ДатаОкончания, "ДФ = 'гггг'");
	
	Если НачалоМесяца(ДатаНачала) <> НачалоМесяца(ДатаОкончания) Тогда  
		
		Если (НачалоДня(ДатаНачала) = НачалоМесяца(ДатаНачала)) Тогда
			Перваяполовинадат = "" + ОписаниеМесяцаГода;
		Иначе
			Перваяполовинадат = ?(СДатами, "" + ЧислоНачала, "") + " " + ОписаниеМесяцаГода; 
		КонецЕсли;
		
		Если (КонецДня(ДатаОкончания) = КонецМесяца(ДатаОкончания)) Тогда
			ВтораяПоловинаДат = ОписаниеМесяца2 ;
		Иначе
			ВтораяПоловинаДат = ?(СДатами, "" + ЧислоОкончания, "") + " " + ОписаниеМесяца2;
		КонецЕсли;
		
		Возврат Перваяполовинадат + "-" + ВтораяПоловинаДат;
		
	Иначе
		
		Если (НачалоДня(ДатаНачала) = НачалоМесяца(ДатаНачала)) И (КонецДня(ДатаОкончания) = КонецМесяца(ДатаОкончания)) Тогда
			Возврат ОписаниеМесяцаГода;
		ИначеЕсли ЧислоНачала = ЧислоОкончания Тогда
			Возврат ?(СДатами, "" + ЧислоНачала, "") + " " + ОписаниеМесяцаГода;
		Иначе
			Возврат ?(СДатами ,"" + ЧислоНачала + "-" + ЧислоОкончания, "") + " " + ОписаниеМесяцаГода;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции	// ПолноеОписаниеПериода 

// Добавляет отбор в коллекцию отборов компоновщика или группы отборов
//
// Параметры:
//		ЭлементСтруктуры - элемент структуры
//		Поле             - имя поля, по которому добавляется отбор
//		Значение         - значение отбора
//		ВидСравнения     - вид сравнений компоновки данных (по умолчанию: вид сравнения)
//		Использование    - признак использования отбора (по умолчанию: истина)
//
Функция ДобавитьОтбор(ЭлементСтруктуры, Знач Поле, Значение, ВидСравнения = Неопределено, Использование = Истина, ВПользовательскиеНастройки = Ложь, Применение = Неопределено) Экспорт
	
	Если ТипЗнч(Поле) = Тип("Строка") Тогда
		Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЕсли;
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Настройки.Отбор;
		
		Если ВПользовательскиеНастройки Тогда
			Для Каждого ЭлементНастройки Из ЭлементСтруктуры.ПользовательскиеНастройки.Элементы Цикл	
				Если ЭлементНастройки.ИдентификаторПользовательскойНастройки = ЭлементСтруктуры.Настройки.Отбор.ИдентификаторПользовательскойНастройки Тогда
					Отбор = ЭлементНастройки;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Отбор;
	Иначе
		Отбор = ЭлементСтруктуры;
	КонецЕсли;
		
	Если ВидСравнения = Неопределено Тогда
		ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
	НовыйЭлемент = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйЭлемент.Использование  = Использование;
	НовыйЭлемент.ЛевоеЗначение  = Поле;
	НовыйЭлемент.ВидСравнения   = ВидСравнения;
	НовыйЭлемент.ПравоеЗначение = Значение;
	
	Если Применение <> Неопределено Тогда
		НовыйЭлемент.Применение = Применение;
	КонецЕсли;
	
	Возврат НовыйЭлемент;
	
КонецФункции

// Функция добавляет выбранное поле и возвращает элемент выбранного поля. 
//
// Параметры:
//		ЭлементСтруктуры - компоновщик настроек, настройка СКД, элемент структуры настройки отчета
//		Поле - имя поля, которое нужно добавить в СКД
//		Заголовок - заголовок добавляемого поля
//
Функция ДобавитьВыбранноеПоле(ЭлементСтруктуры, Знач Поле, Заголовок = Неопределено) Экспорт
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		ВыбранныеПоля = ЭлементСтруктуры.Настройки.Выбор;
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиКомпоновкиДанных") Тогда
		ВыбранныеПоля = ЭлементСтруктуры.Выбор;
	Иначе
		ВыбранныеПоля = ЭлементСтруктуры;
	КонецЕсли;
		
	Если ТипЗнч(Поле) = Тип("Строка") Тогда
		Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЕсли;
	ВыбранноеПоле = ВыбранныеПоля.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле = Поле;
	Если Заголовок <> Неопределено Тогда
		ВыбранноеПоле.Заголовок = Заголовок;
	КонецЕсли;
	
	Возврат ВыбранноеПоле;
	
КонецФункции

Функция ДобавитьВыбранноеПолеПользовательскиеНастройки(ЭлементСтруктуры, Знач Поле, Заголовок = Неопределено) Экспорт
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Для Каждого ЭлементНастройки Из ЭлементСтруктуры.ПользовательскиеНастройки.Элементы Цикл	
			Если ЭлементНастройки.ИдентификаторПользовательскойНастройки = ЭлементСтруктуры.Настройки.Выбор.ИдентификаторПользовательскойНастройки Тогда
				ВыбранныеПоля = ЭлементНастройки;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ВыбранныеПоляКомпоновкиДанных") Тогда
		ВыбранныеПоля = ЭлементСтруктуры;
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
		ВыбранныеПоля = ЭлементСтруктуры;
	КонецЕсли;
	
	Если ТипЗнч(Поле) = Тип("Строка") Тогда
		Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЕсли;
	ВыбранноеПоле = ВыбранныеПоля.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле = Поле;
	Если Заголовок <> Неопределено Тогда
		ВыбранноеПоле.Заголовок = Заголовок;
	КонецЕсли;
	
	Возврат ВыбранноеПоле;
	
КонецФункции

Процедура ЗаполнитьДополнительныеПоляПоУмолчанию(Отчет) Экспорт
	
	КомпоновщикНастроек = Отчет.КомпоновщикНастроек;
	
	Отчет.ДополнительныеПоля.Очистить();
	
	Для Каждого Группировка Из Отчет.Группировка Цикл 
		ТипПоля = ПолучитьСвойствоПоля(КомпоновщикНастроек, Группировка.Поле, "Тип");	
		
		Если ТипЗнч(ТипПоля) <> Тип("ОписаниеТипов") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипПоля.СодержитТип(Тип("СправочникСсылка.Контрагенты")) Тогда
			НоваяСтрока = Отчет.ДополнительныеПоля.Добавить();
			НоваяСтрока.Использование = Ложь;
			НоваяСтрока.Поле          = Строка(Группировка.Поле) + ".ИдентификационныйКодЛичности";
			НоваяСтрока.Представление = ПолучитьСвойствоПоля(КомпоновщикНастроек, НоваяСтрока.Поле);
		ИначеЕсли ТипПоля.СодержитТип(Тип("СправочникСсылка.ОсновныеСредства")) Тогда
			НоваяСтрока = Отчет.ДополнительныеПоля.Добавить();
			НоваяСтрока.Использование = Ложь;
			НоваяСтрока.Поле          = Строка(Группировка.Поле) + ".СвязанноеПолеИнвентарныйНомер_ОС";
			НоваяСтрока.Представление = ПолучитьСвойствоПоля(КомпоновщикНастроек, НоваяСтрока.Поле);	
		ИначеЕсли ТипПоля.СодержитТип(Тип("СправочникСсылка.СтатьиДвиженияДенежныхСредств")) Тогда
			НоваяСтрока = Отчет.ДополнительныеПоля.Добавить();
			НоваяСтрока.Использование = Ложь;
			НоваяСтрока.Поле          = Строка(Группировка.Поле) + ".ВидДвижения";
			НоваяСтрока.Представление = ПолучитьСвойствоПоля(КомпоновщикНастроек, НоваяСтрока.Поле);
		ИначеЕсли ТипПоля.СодержитТип(Тип("СправочникСсылка.РасходыБудущихПериодов")) Тогда
			НоваяСтрока = Отчет.ДополнительныеПоля.Добавить();
			НоваяСтрока.Использование = Ложь;
			НоваяСтрока.Поле          = Строка(Группировка.Поле) + ".ДатаНачалаСписания";
			НоваяСтрока.Представление = ПолучитьСвойствоПоля(КомпоновщикНастроек, НоваяСтрока.Поле);	
			НоваяСтрока = Отчет.ДополнительныеПоля.Добавить();
			НоваяСтрока.Использование = Ложь;
			НоваяСтрока.Поле          = Строка(Группировка.Поле) + ".ДатаОкончанияСписания";
			НоваяСтрока.Представление = ПолучитьСвойствоПоля(КомпоновщикНастроек, НоваяСтрока.Поле);
		ИначеЕсли ТипПоля.СодержитТип(Тип("ДокументСсылка.ВозвратТоваровПоставщику"))
			ИЛИ ТипПоля.СодержитТип(Тип("ДокументСсылка.ГТДИмпорт"))
			ИЛИ ТипПоля.СодержитТип(Тип("ДокументСсылка.ИПНЗаявлениеНаПредоставлениеВычета"))
			ИЛИ ТипПоля.СодержитТип(Тип("ДокументСсылка.ПлатежноеПоручениеВходящее"))
			ИЛИ ТипПоля.СодержитТип(Тип("ДокументСсылка.ПлатежныйОрдерПоступлениеДенежныхСредств"))
			ИЛИ ТипПоля.СодержитТип(Тип("ДокументСсылка.ПоступлениеДопРасходов"))
			ИЛИ ТипПоля.СодержитТип(Тип("ДокументСсылка.ПоступлениеИзПереработки"))
			ИЛИ ТипПоля.СодержитТип(Тип("ДокументСсылка.ПоступлениеНМА"))
			ИЛИ ТипПоля.СодержитТип(Тип("ДокументСсылка.ПоступлениеТоваровУслуг"))
			ИЛИ ТипПоля.СодержитТип(Тип("ДокументСсылка.РегистрацияПрочихОперацийПоПриобретеннымТоварамВЦеляхНДС"))
			ИЛИ ТипПоля.СодержитТип(Тип("ДокументСсылка.СчетФактураПолученный")) Тогда
			НоваяСтрока = Отчет.ДополнительныеПоля.Добавить();
			НоваяСтрока.Использование = Ложь;
			НоваяСтрока.Поле          = Строка(Группировка.Поле) + ".НомерВходящегоДокумента";
			НоваяСтрока.Представление = ПолучитьСвойствоПоля(КомпоновщикНастроек, НоваяСтрока.Поле);
			НоваяСтрока = Отчет.ДополнительныеПоля.Добавить();
			НоваяСтрока.Использование = Ложь;
			НоваяСтрока.Поле          = Строка(Группировка.Поле) + ".ДатаВходящегоДокумента";
			НоваяСтрока.Представление = ПолучитьСвойствоПоля(КомпоновщикНастроек, НоваяСтрока.Поле);	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьОтборПриСменеСчета(СчетСтарый, СчетНовый, КомпоновщикНастроек, ПоддержкаРаботыСоСтруктурнымиПодразделениями) Экспорт
	
	// Добавление неактивных отборов по субконто в соответствии с выбранным счетом
	
	Если Тип("ПланСчетовСсылка.Типовой") = ТипЗнч(СчетНовый.Ссылка) Тогда
		ПланСчетовТиповой = Истина;
	Иначе
		ПланСчетовТиповой = Ложь;
	КонецЕсли;
	
	Если ПланСчетовТиповой Тогда
		ПризнакУчетаВалютный = СчетНовый.Валютный;
	Иначе
		ПризнакУчетаВалютный = Ложь;
	КонецЕсли;
	
	ИмяПоляПрефикс     = "Субконто";
	КоличествоСубконто = СчетНовый.КоличествоСубконто;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("СчетСтарый", СчетСтарый);
	СтруктураПараметров.Вставить("СчетНовый" , СчетНовый);
	СтруктураПараметров.Вставить("КомпоновщикНастроек" , КомпоновщикНастроек);
	СтруктураПараметров.Вставить("КоличествоСубконто"  , КоличествоСубконто);
	СтруктураПараметров.Вставить("ИмяПоляПрефикс"      , ИмяПоляПрефикс);
	СтруктураПараметров.Вставить("ПризнакУчетаВалютный", ПризнакУчетаВалютный);
	
	ОтборыДляУдаления = Новый Массив;
	
	Для Каждого ЭлементОтбора Из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
			
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных")
			 ИЛИ (ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
			 И (Найти(ЭлементОтбора.ЛевоеЗначение, "Субконто") > 0
			 ИЛИ Строка(ЭлементОтбора.ЛевоеЗначение) = "Валюта"
			 ИЛИ (Найти(ЭлементОтбора.ЛевоеЗначение, "Подразделение") = 1
			 И НЕ ПоддержкаРаботыСоСтруктурнымиПодразделениями))) Тогда
			 
			ОтборыДляУдаления.Добавить(ЭлементОтбора);
			
		КонецЕсли;
			
	КонецЦикла;

	КонецМассива = ОтборыДляУдаления.ВГраница();
	Для ИндексМассив = 0 По КонецМассива Цикл
		
		ТекущийИндекс = КонецМассива - ИндексМассив;
		ЭлементОтбора = ОтборыДляУдаления[ТекущийИндекс];
		КомпоновщикНастроек.Настройки.Отбор.Элементы.Удалить(ЭлементОтбора);
		
		Удалять = Истина;
		
		Если СчетСтарый <> Неопределено
			 И (НЕ СчетСтарый.Ссылка.Пустая()) Тогда
			 
			 Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
				 Удалять = ОбработатьГруппуОтбора(ЭлементОтбора, СтруктураПараметров);
			 Иначе
				 Удалять = ОбработатьЭлементОтбора(ЭлементОтбора, СтруктураПараметров);
			 КонецЕсли;
			 
		КонецЕсли;
		
		Если Удалять Тогда
			ОтборыДляУдаления.Удалить(ТекущийИндекс);
		КонецЕсли;
		
	КонецЦикла;
	
	СтруктураПараметров.Вставить("ГруппаОтбора", Неопределено);
		
	Для Каждого ЭлементОтбора Из ОтборыДляУдаления Цикл
			
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			ДобавитьГруппуОтбора(ЭлементОтбора, СтруктураПараметров);
		Иначе
			ДобавитьЭлементОтбора(ЭлементОтбора, СтруктураПараметров);
		КонецЕсли;
			
	КонецЦикла;
	
	ОбязательныеПоляОтбора = Новый Массив;
	Для Индекс = 1 По КоличествоСубконто Цикл
		ОбязательныеПоляОтбора.Добавить(Новый ПолеКомпоновкиДанных(ИмяПоляПрефикс + Индекс));
	КонецЦикла;
	Если ПризнакУчетаВалютный И СчетНовый.Валютный И ОбщегоНазначенияБКВызовСервера.ИспользоватьВалютныйУчет()  Тогда
		ОбязательныеПоляОтбора.Добавить(Новый ПолеКомпоновкиДанных("Валюта"));
	КонецЕсли;
	
	ЭлементыОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы;
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		Если ТипЗнч(ЭлементОтбора) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		ТекущееПолеКомпоновки = ЭлементОтбора.ЛевоеЗначение;
		Индекс = ОбязательныеПоляОтбора.Найти(ТекущееПолеКомпоновки);
		Если Индекс <> Неопределено Тогда
			ОбязательныеПоляОтбора.Удалить(Индекс);
		КонецЕсли;	
	КонецЦикла;
	
	Для Каждого Поле Из ОбязательныеПоляОтбора Цикл
		ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(Поле);
		ДобавитьОтбор(КомпоновщикНастроек, Строка(Поле), ДоступноеПоле.Тип.ПривестиЗначение(Неопределено), , Ложь);
	КонецЦикла;
					
КонецПроцедуры

Функция ПолучитьЗначениеПериодичности(Периодичность, НачалоПериода, КонецПериода) Экспорт
	
	Результат = Периодичность;
	Если Периодичность = 0 Тогда
		Если ЗначениеЗаполнено(НачалоПериода)
			И ЗначениеЗаполнено(КонецПериода) Тогда
			Разность = КонецПериода - НачалоПериода;
			Если Разность / 86400 < 45 Тогда
				Результат = 6; // день
			Иначе
				Результат = 9; // месяц
			КонецЕсли;
		Иначе
			Результат = 9; // месяц
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает последний элемент структуры - группировку
Функция ПолучитьПоследнийЭлементСтруктуры(КомпоновщикНастроек, Строки = Истина) Экспорт
	
	Структура = КомпоновщикНастроек.Настройки.Структура;
	Если Структура.Количество() = 0 Тогда
		Возврат КомпоновщикНастроек.Настройки;
	КонецЕсли;
	
	Если Строки Тогда
		ИмяСтруктурыТаблицы = "Строки";
		ИмяСтруктурыДиаграммы = "Серии";
	Иначе
		ИмяСтруктурыТаблицы = "Колонки";
		ИмяСтруктурыДиаграммы = "Точки";
	КонецЕсли;
	
	Пока Истина Цикл
		ЭлементСтруктуры = Структура[0];
		Если ТипЗнч(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") И ЭлементСтруктуры[ИмяСтруктурыТаблицы].Количество() > 0 Тогда
			Если ЭлементСтруктуры[ИмяСтруктурыТаблицы][0].Структура.Количество() = 0 Тогда
				Структура = ЭлементСтруктуры[ИмяСтруктурыТаблицы];
				Прервать;
			КонецЕсли;
			Структура = ЭлементСтруктуры[ИмяСтруктурыТаблицы][0].Структура;
		ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных") И ЭлементСтруктуры[ИмяСтруктурыДиаграммы].Количество() > 0 Тогда
			Если ЭлементСтруктуры[ИмяСтруктурыДиаграммы][0].Структура.Количество() = 0 Тогда
				Структура = ЭлементСтруктуры[ИмяСтруктурыДиаграммы];
				Прервать;
			КонецЕсли;
			Структура = ЭлементСтруктуры[ИмяСтруктурыДиаграммы][0].Структура;
		ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных")
			  ИЛИ ТипЗнч(ЭлементСтруктуры) = Тип("ГруппировкаТаблицыКомпоновкиДанных")
			  ИЛИ ТипЗнч(ЭлементСтруктуры) = Тип("ГруппировкаДиаграммыКомпоновкиДанных") Тогда
			Если ЭлементСтруктуры.Структура.Количество() = 0 Тогда
				Прервать;
			КонецЕсли;
			Структура = ЭлементСтруктуры.Структура;
		ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Возврат ЭлементСтруктуры[ИмяСтруктурыТаблицы];
		ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных")	Тогда
			Возврат ЭлементСтруктуры[ИмяСтруктурыДиаграммы];
		Иначе
			Возврат ЭлементСтруктуры;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Структура[0];
	
КонецФункции

// Возвращает группировку - детальные записи компоновщика настроек
Функция ПолучитьЭлементСтруктурыДетальныеЗаписи(КомпоновщикНастроек) Экспорт
	
	ПоследнийЭлементСтруктуры = ПолучитьПоследнийЭлементСтруктуры(КомпоновщикНастроек, Истина);
	Если ТипЗнч(ПоследнийЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных")
	 ИЛИ ТипЗнч(ПоследнийЭлементСтруктуры) = Тип("ГруппировкаТаблицыКомпоновкиДанных")
	 ИЛИ ТипЗнч(ПоследнийЭлементСтруктуры) = Тип("ГруппировкаДиаграммыКомпоновкиДанных") Тогда
		Если ПоследнийЭлементСтруктуры.ПоляГруппировки.Элементы.Количество() = 0 Тогда
			Возврат ПоследнийЭлементСтруктуры;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Добавляет группировку в компоновщик настроек в самый нижний уровень структуры, если поле не укзано - детальные поля
Функция ДобавитьГруппировку(КомпоновщикНастроек, Знач Поле = Неопределено, Строки = Истина) Экспорт
	
	ЭлементСтруктуры = ПолучитьПоследнийЭлементСтруктуры(КомпоновщикНастроек, Строки);
	Если ЭлементСтруктуры = Неопределено 
	 ИЛИ ПолучитьЭлементСтруктурыДетальныеЗаписи(КомпоновщикНастроек) <> Неопределено 
	   И Поле = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(Поле) = Тип("Строка") Тогда
		Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЕсли;
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("ГруппировкаТаблицыКомпоновкиДанных") 
	 ИЛИ ТипЗнч(ЭлементСтруктуры) = Тип("ГруппировкаДиаграммыКомпоновкиДанных") Тогда
		НоваяГруппировка = ЭлементСтруктуры.Структура.Добавить();
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных")
			ИЛИ ТипЗнч(ЭлементСтруктуры) = Тип("КоллекцияЭлементовСтруктурыДиаграммыКомпоновкиДанных") Тогда
		НоваяГруппировка = ЭлементСтруктуры.Добавить();
	Иначе
		НоваяГруппировка = ЭлементСтруктуры.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	КонецЕсли;
	
	НоваяГруппировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	НоваяГруппировка.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	Если Поле <> Неопределено Тогда
		ПолеГруппировки = НоваяГруппировка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Поле;
	КонецЕсли;
	Возврат НоваяГруппировка;
	
КонецФункции

// Возвращает массив найденных элементов отбора
//
// Параметры:
//		ЭлементСтруктуры - элемент структуры
//		СписокПолей      - Массив - массив строк (имен полей) для поиска
//		Использование    - Неопределено, Булево - признак использования отбора (по умолчанию: Неопределено).
//                         Если Неопределено, то отбираются все элементы, независимо от их использования
//
Функция НайтиЭлементыОтбора(ЭлементСтруктуры, СписокПолей, Использование = Неопределено, СписокЭлементов = Неопределено) Экспорт
	
	Если СписокЭлементов = Неопределено Тогда
		СписокЭлементов = Новый Массив;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Настройки.Отбор;
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Отбор;
	Иначе
		Отбор = ЭлементСтруктуры;
	КонецЕсли;
	
	Для Каждого ЭлементОтбора Из Отбор.Элементы Цикл
		Если Использование <> Неопределено И ЭлементОтбора.Использование <> Использование Тогда
			Продолжить;
		КонецЕсли;
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ИмяОтбора = Строка(ЭлементОтбора.ЛевоеЗначение);
			Если СписокПолей.Найти(ИмяОтбора) <> Неопределено Тогда
				СписокЭлементов.Добавить(ЭлементОтбора);
			КонецЕсли;
		ИначеЕсли ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			СписокЭлементов = НайтиЭлементыОтбора(ЭлементОтбора, СписокПолей, Использование, СписокЭлементов);
		КонецЕсли;
	КонецЦикла;
		
	Возврат СписокЭлементов;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ДобавитьГруппуОтбора(ГруппаЭлементовОтбора, СтруктураПараметров)
	
	КомпоновщикНастроек  = СтруктураПараметров.КомпоновщикНастроек;
	Отбор = КомпоновщикНастроек.Настройки.Отбор;
	
	НоваяГруппа                = Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	НоваяГруппа.Использование  = ГруппаЭлементовОтбора.Использование;
	НоваяГруппа.ТипГруппы 	   = ГруппаЭлементовОтбора.ТипГруппы;
	
	СтруктураПараметров.ГруппаОтбора = НоваяГруппа;

	ЭлементыГруппы = ГруппаЭлементовОтбора.Элементы;
	Для Каждого Элемент Из ЭлементыГруппы Цикл
		Если ТипЗнч(Элемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			ДобавитьГруппуОтбора(Элемент, СтруктураПараметров);
		Иначе
			ДобавитьЭлементОтбора(Элемент, СтруктураПараметров);
		КонецЕсли;
	КонецЦикла;
	
	СтруктураПараметров.ГруппаОтбора = Неопределено;
	
КонецФункции

Процедура ДобавитьЭлементОтбора(ЭлементОтбора, СтруктураПараметров)
	
	СчетСтарый = СтруктураПараметров.СчетСтарый;
	СчетНовый  = СтруктураПараметров.СчетНовый;
	КоличествоСубконто   = СтруктураПараметров.КоличествоСубконто;
	КомпоновщикНастроек  = ?(СтруктураПараметров.ГруппаОтбора = Неопределено, СтруктураПараметров.КомпоновщикНастроек, СтруктураПараметров.ГруппаОтбора);
	ПризнакУчетаВалютный = СтруктураПараметров.ПризнакУчетаВалютный;
	ИмяПоляПрефикс       = СтруктураПараметров.ИмяПоляПрефикс;
	
	ИмяПоляОтбора = Строка(ЭлементОтбора.ЛевоеЗначение);
	
	Если Найти(ИмяПоляОтбора, "Субконто") > 0 Тогда
		Для Индекс = 1 По КоличествоСубконто Цикл
			ТипСубконтоНовый = СчетНовый["ВидСубконто" + Строка(Индекс) + "ТипЗначения"];
			Если СтрДлина(ИмяПоляОтбора) = 9 Тогда
				Если ТипСубконтоНовый.СодержитТип(ТипЗнч(ЭлементОтбора.ПравоеЗначение)) Тогда
					Если ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("СправочникСсылка.Субконто") Тогда
						Если СчетНовый["ВидСубконто" + Строка(Индекс)] = ЭлементОтбора.ПравоеЗначение.Владелец Тогда
							БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек, ИмяПоляПрефикс + Индекс, ЭлементОтбора.ПравоеЗначение, ЭлементОтбора.ВидСравнения, ЭлементОтбора.Использование);	
						КонецЕсли;	 
					Иначе
						ДобавитьОтбор(КомпоновщикНастроек, ИмяПоляПрефикс + Индекс, ЭлементОтбора.ПравоеЗначение, ЭлементОтбора.ВидСравнения, ЭлементОтбора.Использование);	
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			Если СтрДлина(ИмяПоляОтбора) > 9 Тогда
				ИндексСубконто = Число(Сред(ИмяПоляОтбора, 9, 1)) - 1;
				ТипыСубконтоСтарые = СчетСтарый["ВидСубконто" + ИндексСубконто + "ТипЗначения"].Типы();
				Для Каждого ТипСубконтоСтарый Из ТипыСубконтоСтарые Цикл
					Если ТипСубконтоНовый.СодержитТип(ТипСубконтоСтарый) Тогда
						ИмяПоляПостФикс = Сред(ИмяПоляОтбора, 10);
						ДобавитьОтбор(КомпоновщикНастроек, ИмяПоляПрефикс + Индекс + ИмяПоляПостФикс, ЭлементОтбора.ПравоеЗначение, ЭлементОтбора.ВидСравнения, ЭлементОтбора.Использование);	
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Найти(Строка(ЭлементОтбора.ЛевоеЗначение), "Валюта") > 0
		 И ПризнакУчетаВалютный И СчетНовый.Валютный Тогда
		ДобавитьОтбор(КомпоновщикНастроек, "Валюта", ЭлементОтбора.ПравоеЗначение, ЭлементОтбора.ВидСравнения, ЭлементОтбора.Использование);
	КонецЕсли;
	
КонецПроцедуры

Функция ОбработатьГруппуОтбора(ГруппаЭлементовОтбора, СтруктураПараметров)
	
	ЭлементыГруппы = ГруппаЭлементовОтбора.Элементы;
	КонечныйИндекс = ЭлементыГруппы.Количество() - 1;
	Для Индекс = 0 По КонечныйИндекс Цикл
		ТекущийИндекс = КонечныйИндекс - Индекс;
		Элемент = ЭлементыГруппы[ТекущийИндекс];
		Если ТипЗнч(Элемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			УдалятьГруппу = ОбработатьГруппуОтбора(Элемент, СтруктураПараметров);
			Если УдалятьГруппу Тогда
				ЭлементыГруппы.Удалить(Элемент);
			КонецЕсли;	
		Иначе
			УдалятьЭлемент = ОбработатьЭлементОтбора(Элемент, СтруктураПараметров);
			Если УдалятьЭлемент Тогда
				ЭлементыГруппы.Удалить(Элемент);
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;
	
	Если ГруппаЭлементовОтбора.Элементы.Количество() = 0 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция ОбработатьЭлементОтбора(ЭлементОтбора, СтруктураПараметров)
	
	СчетСтарый = СтруктураПараметров.СчетСтарый;
	СчетНовый  = СтруктураПараметров.СчетНовый;
	КоличествоСубконто   = СтруктураПараметров.КоличествоСубконто;
	КомпоновщикНастроек  = СтруктураПараметров.КомпоновщикНастроек;
	ПризнакУчетаВалютный = СтруктураПараметров.ПризнакУчетаВалютный;
	
	Удалять = Истина;
	
	Если ЗначениеЗаполнено(ЭлементОтбора.ПравоеЗначение) Тогда
		
			ИмяПоляОтбора = Строка(ЭлементОтбора.ЛевоеЗначение);
			Если (ПризнакУчетаВалютный
				 И СчетНовый.Валютный
				 И Найти(ИмяПоляОтбора, "Валюта") > 0)
				 ИЛИ Найти(ИмяПоляОтбора, "Подразделение") > 0 Тогда
			    Удалять = Ложь;
			ИначеЕсли Найти(ИмяПоляОтбора, "Субконто") > 0 Тогда    
				ИндексСубконто = Число(Сред(ИмяПоляОтбора, 9, 1));
				ТипыСубконтоОтбора = СчетСтарый["ВидСубконто" + ИндексСубконто + "ТипЗначения"].Типы();
				// проверим вхождение типов старых Субконто в типы новых Субконто 
				Для Индекс = 0 По КоличествоСубконто - 1 Цикл
					// ТипСубконто - набор типов нового Субконто 
					ТипСубконто = СчетНовый["ВидСубконто" + Строка(Индекс + 1) + "ТипЗначения"];
					Для Каждого ТипСубконтоОтбора Из ТипыСубконтоОтбора Цикл
						Если ТипСубконто.СодержитТип(ТипСубконтоОтбора) Тогда
							
							Если СтрДлина(ИмяПоляОтбора) > 9 Тогда   // т.е. отбор по одному из реквизитов Субконто - "СубконтоN. ..."
								// проверим возможность установки отбора для нового Субконто
								// по полю ИмяПоляОтбора 
								ДоступныеЭлементыОтбора = КомпоновщикНастроек.Настройки.Отбор.ДоступныеПоляОтбора.Элементы;
								ДоступноеПолеОтбораПоСубконто = ДоступныеЭлементыОтбора.Найти("Субконто" + Строка(Индекс + 1));
								Если ДоступноеПолеОтбораПоСубконто <> Неопределено Тогда
									ДоступныеПоляСубконто = ДоступноеПолеОтбораПоСубконто.Элементы;
									ПолеОтбора = ДоступныеПоляСубконто.Найти("Субконто" + Строка(Индекс + 1) + Сред(ИмяПоляОтбора, 10));
									Если ПолеОтбора <> Неопределено Тогда
										Удалять = Ложь;
									КонецЕсли;
								КонецЕсли;
							Иначе  // т.е. отбор непосредственно по Субконто
								Если ТипСубконтоОтбора = Тип("СправочникСсылка.Субконто") Тогда
									СубконтоВладелец = ЭлементОтбора.ПравоеЗначение.Владелец;
									Если СчетНовый.ВидСубконто1 = СубконтоВладелец 
										ИЛИ СчетНовый.ВидСубконто2 = СубконтоВладелец 
										ИЛИ СчетНовый.ВидСубконто3 = СубконтоВладелец Тогда
										Удалять = Ложь;
									КонецЕсли;	
								Иначе
									Удалять = Ложь;
								КонецЕсли;	
							КонецЕсли;
							
						КонецЕсли;
					КонецЦикла;
				КонецЦикла;
			Иначе
				Удалять = Ложь;
			КонецЕсли;
		
	КонецЕсли;
	
	Возврат Удалять;
	
КонецФункции




