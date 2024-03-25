﻿////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Получение данных для поиска соответствий

Функция НовоеСоответствиеВалюты() Экспорт
	
	Запрос 			= Новый Запрос;
	ТекстЗапроса 	= 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Валюты.%БуквенныйКодВалюты КАК Код,
	|	Валюты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	НЕ Валюты.ПометкаУдаления";	
	
	СоответсвиеИменРеквизитов = Новый Соответствие;
	СоответсвиеИменРеквизитов.Вставить("%БуквенныйКодВалюты", "");
	
	ЭСФСерверПереопределяемый.ЗаполнитьСоответсвиеИменРеквизитовПолейЗапросов(СоответсвиеИменРеквизитов);
	
	ЭСФСервер.ЗаменитьИменаРеквизитовПолейЗапросов(ТекстЗапроса, СоответсвиеИменРеквизитов);
	
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СоответствиеВалюты = Новый Соответствие;	
	Пока Выборка.Следующий() Цикл
		СоответствиеВалюты.Вставить(Выборка.Код, Выборка.Ссылка);
	КонецЦикла;
	
	Возврат СоответствиеВалюты;
	
КонецФункции

// Возвращает соответствие числовой ставки акциза и ссылки на акциз.
//
// Возвращаемое значение:
//  Соответствие - Соответствие числовой ставки акциза и ссылки на акциз.
//   |- Ключ - Число - Ставка акциза числом.
//   |- Значение - СправочникСсылка.<Имя> - Ссылка на ставку акциза.
//
Функция НовоеСоответствиеАкцизы() Экспорт
	
	Возврат ЭСФСерверПереопределяемый.НовоеСоответствиеАкцизы();
	
КонецФункции

Функция НоваяТаблицаНДС() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтавкиНДС.Ставка КАК СтавкаНДСЧисло,
	|	СтавкиНДС.ДляОсвобожденногоОборота КАК БезНДС,
	|	СтавкиНДС.МестоРеализацииНеРК КАК МестоРеализацииНеРК,
	|	СтавкиНДС.Ссылка КАК СтавкаНДС
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	НЕ СтавкиНДС.ПометкаУдаления";
	ТаблицаНДС = Запрос.Выполнить().Выгрузить();
	ТаблицаНДС.Индексы.Добавить("СтавкаНДСЧисло, БезНДС, МестоРеализацииНеРК");
	
	Возврат ТаблицаНДС;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Получение данных профилей ИС ЭСФ

// Возврашает данные профиля ИС ЭСФ.
//
// Параметры:
//  ПрофильИСЭСФ - СправочникСсылка.ПрофилиИСЭСФ - Профиль, данные которого необходимо получить.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура - Данные профиля ИС ЭСФ.
//   |- Ссылка - СправочникСсылка.ПрофилиИСЭСФ - Ссылка на профиль.
//   |- СтруктурнаяЕдиница - См. Справочники.ПрофилиИСЭСФ.СтруктурнаяЕдиница - Структурная единица от имени которой позволяет работать профиль.
//   |- ПользовательИСЭСФ - СправочникСсылка.ПользователиИСЭСФ - Владелец профиля.
//   |- ИспользоватьДляСинхронизации - Булево - Использовать профиль для синхронизации с ИС ЭСФ.
//
Функция ДанныеПрофиляИСЭСФ(Знач ПрофильИСЭСФ) Экспорт
	                           
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПрофилиИСЭСФ.Ссылка КАК ПрофильИСЭСФ,
	|	ПрофилиИСЭСФ.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ПрофилиИСЭСФ.Владелец КАК ПользовательИСЭСФ,
	|	ПрофилиИСЭСФ.ИспользоватьДляСинхронизации КАК ИспользоватьДляСинхронизации,
	|	ПрофилиИСЭСФ.ИспользоватьДляРегламентногоЗадания КАК ИспользоватьДляРегламентногоЗадания
	|ИЗ
	|	Справочник.ПрофилиИСЭСФ КАК ПрофилиИСЭСФ
	|ГДЕ
	|	ПрофилиИСЭСФ.Ссылка = &Ссылка";	
	Запрос.УстановитьПараметр("Ссылка", ПрофильИСЭСФ);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ДанныеПрофиляИСЭСФ = Новый Структура;
		ДанныеПрофиляИСЭСФ.Вставить("Ссылка", Выборка.ПрофильИСЭСФ);
		ДанныеПрофиляИСЭСФ.Вставить("СтруктурнаяЕдиница", Выборка.СтруктурнаяЕдиница);
		ДанныеПрофиляИСЭСФ.Вставить("ПользовательИСЭСФ", Выборка.ПользовательИСЭСФ);
		ДанныеПрофиляИСЭСФ.Вставить("ИспользоватьДляСинхронизации", Выборка.ИспользоватьДляСинхронизации);
		ДанныеПрофиляИСЭСФ.Вставить("ИспользоватьДляРегламентногоЗадания", Выборка.ИспользоватьДляРегламентногоЗадания);		
		ДанныеПрофиляИСЭСФ = Новый ФиксированнаяСтруктура(ДанныеПрофиляИСЭСФ);
	КонецЕсли;
	
	Возврат ДанныеПрофиляИСЭСФ;
	
КонецФункции

// Возврашает данные пользователя ИС ЭСФ.
//
// Параметры:
//  ПрофильИСЭСФ - СправочникСсылка.ПользователиИСЭСФ - Пользователь, данные которого необходимо получить.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура - Данные пользователя ИС ЭСФ.
//   |- Ссылка - СправочникСсылка.ПользователиИСЭСФ - Ссылка на пользователя.
//   |- Пользователь - СправочникСсылка.Пользователи - Пользователь ИБ, которому принадлежит данный пользователь ИС ЭСФ.
//   |- ИмяАутентификации - Строка - Имя для открытия сессии с ИС ЭСФ.
//   |- ПарольАутентификации - Строка - Имя для открытия сессии с ИС ЭСФ.
//   |- СертификатАутентификации - Строка - Сертификат аутентификации для открытия сессии с ИС ЭСФ. Кодировка Base64.
//
Функция ДанныеПользователяИСЭСФ(Знач ПользовательИСЭСФ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПользователиИСЭСФ.Ссылка КАК Ссылка,
	|	ПользователиИСЭСФ.Владелец КАК Пользователь,
	|	ПользователиИСЭСФ.ИмяАутентификации КАК ИмяАутентификации,
	|	ПользователиИСЭСФ.ПарольАутентификации КАК ПарольАутентификации,
	|	ПользователиИСЭСФ.СертификатАутентификации КАК СертификатАутентификации
	|ИЗ
	|	Справочник.ПользователиИСЭСФ КАК ПользователиИСЭСФ
	|ГДЕ
	|	ПользователиИСЭСФ.Ссылка = &Ссылка";	
	Запрос.УстановитьПараметр("Ссылка", ПользовательИСЭСФ);	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ДанныеПользователя = Новый Структура;
		ДанныеПользователя.Вставить("Ссылка", Выборка.Ссылка);
		ДанныеПользователя.Вставить("Пользователь", Выборка.Пользователь);
		ДанныеПользователя.Вставить("ИмяАутентификации", Выборка.ИмяАутентификации);
		ДанныеПользователя.Вставить("ПарольАутентификации", Выборка.ПарольАутентификации);
		
		СертификатАутентификации = Выборка.СертификатАутентификации.Получить();	
		СертификатАутентификации = ?(СертификатАутентификации = Неопределено, "", СертификатАутентификации);
		ДанныеПользователя.Вставить("СертификатАутентификации", СертификатАутентификации);
		
		ДанныеПользователя = Новый ФиксированнаяСтруктура(ДанныеПользователя);
		
	КонецЕсли;
	
	Возврат ДанныеПользователя; 
	
КонецФункции

// Возврашает данные структурной единицы.
//
// Параметры:
//  СтруктурнаяЕдиница - См. Справочники.ПрофилиИСЭСФ.СтруктурнаяЕдиница - Структурная единица, данные которой необходимо получить.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура - Данные структурной единицы.
//   |- Ссылка - См. Справочники.ПрофилиИСЭСФ.СтруктурнаяЕдиница - Ссылка на структурную единицу.
//   |- ИдентификационныйНомер - "" - БИН или ИИН структурной единицы.
//
Функция ДанныеСтруктурнойЕдиницы(Знач СтруктурнаяЕдиница) Экспорт
	
	Запрос 		 = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтруктурнаяЕдиница.Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(СтруктурнаяЕдиница.Ссылка) КАК Представление,
	|	СтруктурнаяЕдиница.%СтруктурнаяЕдиницаИдентификационныйНомер КАК ИдентификационныйНомер
	|ИЗ
	|	Справочник.[СтруктурнаяЕдиница] КАК СтруктурнаяЕдиница
	|ГДЕ
	|	СтруктурнаяЕдиница.Ссылка = &Ссылка";	
	
	ИмяТаблицы 	 = ?(ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.Организации"), "Организации", "ПодразделенияОрганизаций");
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[СтруктурнаяЕдиница]", ИмяТаблицы);
	
	СоответсвиеИменРеквизитов = Новый Соответствие;
	СоответсвиеИменРеквизитов.Вставить("%СтруктурнаяЕдиницаИдентификационныйНомер", "");
	
	ЭСФСерверПереопределяемый.ЗаполнитьСоответсвиеИменРеквизитовПолейЗапросов(СоответсвиеИменРеквизитов);
	
	ЭСФСервер.ЗаменитьИменаРеквизитовПолейЗапросов(ТекстЗапроса, СоответсвиеИменРеквизитов);
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Ссылка", СтруктурнаяЕдиница);	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ДанныеСтруктурнойЕдиницы = Новый Структура;
		
		ДанныеСтруктурнойЕдиницы.Вставить("Ссылка", Выборка.Ссылка);
		ДанныеСтруктурнойЕдиницы.Вставить("Представление", Выборка.Представление);
		ДанныеСтруктурнойЕдиницы.Вставить("ИдентификационныйНомер", Выборка.ИдентификационныйНомер);
		
		ЭтоИндивидуальныйПредприниматель = ЭСФСервер.ЭтоИндивидуальныйПредприниматель(Выборка.Ссылка);
		ДанныеСтруктурнойЕдиницы.Вставить("ЭтоИндивидуальныйПредприниматель", ЭтоИндивидуальныйПредприниматель);
		
		ДанныеСтруктурнойЕдиницы = Новый ФиксированнаяСтруктура(ДанныеСтруктурнойЕдиницы);
		
	КонецЕсли;
	
	Возврат ДанныеСтруктурнойЕдиницы;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Получение внешней или встроенной обработки "ОбменЭСФ"

Функция ОбработкаОбменЭСФ() Экспорт
	
	Возврат ЭСФСерверПереопределяемый.ОбработкаОбменЭСФ();
	
КонецФункции

Функция ИспользоватьВнешнююОбработку() Экспорт
	
	Возврат ЭСФСерверПереопределяемый.ИспользоватьВнешнююОбработку();
	
КонецФункции

Функция НовыйЭкземплярВнешнейОбработкиОбменЭСФ() Экспорт 
	
	Возврат ЭСФСерверПереопределяемый.НовыйЭкземплярВнешнейОбработкиОбменЭСФ();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции

Функция НовыйПроксиСерверИСЭСФ() Экспорт
	
	НастройкиПрокси = ЭСФСервер.ПолучитьПараметрыПодключенияКСерверуИСЭСФ();
	
	Если НастройкиПрокси.ПроксиСервер_ВариантИспользования = ЭСФКлиентСервер.ПроксиНеИспользовать() Тогда
		
		ИнтернетПрокси = Новый ИнтернетПрокси(Ложь);	
		
	ИначеЕсли НастройкиПрокси.ПроксиСервер_ВариантИспользования = ЭСФКлиентСервер.ПроксиСистемныеНастройки() Тогда
		
		ИнтернетПрокси = Новый ИнтернетПрокси(Истина);	
		
	ИначеЕсли НастройкиПрокси.ПроксиСервер_ВариантИспользования = ЭСФКлиентСервер.ПроксиДругиеНастройки() Тогда
		
		ИнтернетПрокси = Новый ИнтернетПрокси(Ложь);
		ИнтернетПрокси.Установить("http", НастройкиПрокси.ПроксиСервер_Сервер, НастройкиПрокси.ПроксиСервер_Порт);
		ИнтернетПрокси.Установить("https", НастройкиПрокси.ПроксиСервер_Сервер, НастройкиПрокси.ПроксиСервер_Порт);
		ИнтернетПрокси.Пользователь = НастройкиПрокси.ПроксиСервер_Пользователь;
		ИнтернетПрокси.Пароль = НастройкиПрокси.ПроксиСервер_Пароль;
		
	Иначе
		
		ИнтернетПрокси = Неопределено; 
		
	КонецЕсли;
	
	Возврат ИнтернетПрокси;
	
КонецФункции

Функция НоваяТаблицаОшибокИСЭСФ() Экспорт
	
	ТабЗначОшибки = Новый ТаблицаЗначений;
	
	ТипСтрока200 = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(200));
	
	ТабЗначОшибки.Колонки.Добавить("ТекстИСЭСФ",  ТипСтрока200);
	ТабЗначОшибки.Колонки.Добавить("ТекстИБ",     ТипСтрока200);
	ТабЗначОшибки.Колонки.Добавить("ПолеИСЭСФ",   ТипСтрока200);
	ТабЗначОшибки.Колонки.Добавить("ПолеИБ",      ТипСтрока200);	
	ТабЗначОшибки.Колонки.Добавить("ИмяСтраницы", ТипСтрока200);
	
	ТабЗначОшибки.Индексы.Добавить("ТекстИСЭСФ, ПолеИСЭСФ");
	
	ТабДокОшибки = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ().ПолучитьМакет("ПредставленияОшибокИСЭСФ");
	
	Для НомерСтроки = 1 По ТабДокОшибки.ВысотаТаблицы Цикл
		
		ТекстИСЭСФ  = ТабДокОшибки.Область(НомерСтроки, 1, НомерСтроки, 1).Текст;
		ТекстИБ     = ТабДокОшибки.Область(НомерСтроки, 2, НомерСтроки, 2).Текст;
		ПолеИСЭСФ   = ТабДокОшибки.Область(НомерСтроки, 3, НомерСтроки, 3).Текст;
		ПолеИБ      = ТабДокОшибки.Область(НомерСтроки, 4, НомерСтроки, 4).Текст;
		ИмяСтраницы = ТабДокОшибки.Область(НомерСтроки, 5, НомерСтроки, 5).Текст;
		
		ЭСФСервер.НоваяСтрокаТаблицыОшибокИСЭСФ(ТабЗначОшибки, ТекстИСЭСФ, ТекстИБ, ПолеИСЭСФ, ПолеИБ, ИмяСтраницы);
		
	КонецЦикла;
	
	Возврат ТабЗначОшибки;
	
КонецФункции

//++ НЕ ЭСФ
Функция НовоеСоответствиеПолей() Экспорт
	
	Поля = Новый Соответствие;
	
	
	
	ТабДокПоляИРазделы = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ().ПолучитьМакет("ПредставлениеПолейИРазделов");
	ОбластьПоля = ТабДокПоляИРазделы.Области.Поля;	
	Для НомерСтроки = 1 По ТабДокПоляИРазделы.ВысотаТаблицы Цикл
		
		ПолеИС 			= ТабДокПоляИРазделы.Область(НомерСтроки, ОбластьПоля.Лево, НомерСтроки, ОбластьПоля.Лево).Текст;
		
		Если ПустаяСтрока(ПолеИС)Тогда
			Прервать;	
		КонецЕсли;

		
		ПолеСиноним  	= ТабДокПоляИРазделы.Область(НомерСтроки, ОбластьПоля.Лево+1, НомерСтроки, ОбластьПоля.Лево+1).Текст;
		ПолеИБ 			= ТабДокПоляИРазделы.Область(НомерСтроки, ОбластьПоля.Право, НомерСтроки, ОбластьПоля.Право).Текст;
		
		Результат = новый Структура;
		Результат.Вставить("Поле", ПолеИБ);
		Результат.Вставить("Синоним", ПолеСиноним);

		Поля.Вставить(ПолеИС, Результат);
		
		
	КонецЦикла;
	
	Возврат Поля;
	
КонецФункции

Функция НовоеСоответствиеРазделов() Экспорт
	
	Разделы = Новый Соответствие;
	
	
	
	ТабДокПоляИРазделы = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ().ПолучитьМакет("ПредставлениеПолейИРазделов");
	ОбластьРазделы = ТабДокПоляИРазделы.Области.Разделы;	
	Для НомерСтроки = 1 По ТабДокПоляИРазделы.ВысотаТаблицы Цикл
		
		РазделИС 		= ТабДокПоляИРазделы.Область(НомерСтроки, ОбластьРазделы.Лево, НомерСтроки, ОбластьРазделы.Лево).Текст;
		
		Если ПустаяСтрока(РазделИС)Тогда
			Прервать;	
		КонецЕсли;

		
		ИмяСтраницы 	= ТабДокПоляИРазделы.Область(НомерСтроки, ОбластьРазделы.Лево+1, НомерСтроки, ОбластьРазделы.Лево+1).Текст;
		РазделСиноним 	= ТабДокПоляИРазделы.Область(НомерСтроки, ОбластьРазделы.Лево+2, НомерСтроки, ОбластьРазделы.Лево+2).Текст;
		ТабличнаяЧасть 	= ТабДокПоляИРазделы.Область(НомерСтроки, ОбластьРазделы.Право, НомерСтроки, ОбластьРазделы.Право).Текст;

		
		Результат = новый Структура;
		Результат.Вставить("ИмяСтраницы", ИмяСтраницы);
		Результат.Вставить("Синоним", РазделСиноним);
		Результат.Вставить("ТабличнаяЧасть", ТабличнаяЧасть);

		
		
		Разделы.Вставить(РазделИС, Результат);	
		
	КонецЦикла;
	
	Возврат Разделы;
	
КонецФункции
//-- НЕ ЭСФ

// Возвращает список префиксов узлов.
//
// Возвращаемое значение:
//  Произвольный - Список префиксов узлов.
//
Функция СписокПрефиксовУзлов() Экспорт
	
	Возврат ЭСФСерверПереопределяемый.СписокПрефиксовУзлов(); 
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Настройки подключения к серверу ИС ЭСФ

Функция ПолучитьПараметрыПодключенияКСерверуИСЭСФ() Экспорт 
	
	Возврат ЭСФСервер.ПолучитьПараметрыПодключенияКСерверуИСЭСФ();
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Настройки ЭСФ

Функция ПолучитьПараметрыЭСФ() Экспорт 
	
	Возврат ЭСФСервер.ПолучитьПараметрыЭСФ();
	
КонецФункции

Функция ПолучитьАктуальныйПереченьИзъятий(ВозвращатьМассив = Истина) Экспорт
	
	Результат = Новый Массив;
	Макет = Неопределено;
	Попытка
		Макет = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ().ПолучитьМакет("ПереченьИзъятий");
	Исключение
	КонецПопытки;
	
	Если Макет = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ВозвращатьМассив Тогда
		Возврат ЭСФСерверПереопределяемый.ЗначениеИзСтрокиXML(Макет.ПолучитьТекст()).ВыгрузитьКолонку("КодТНВЭД");
	КонецЕсли;
	
	Возврат ЭСФСерверПереопределяемый.ЗначениеИзСтрокиXML(Макет.ПолучитьТекст());
	
КонецФункции
