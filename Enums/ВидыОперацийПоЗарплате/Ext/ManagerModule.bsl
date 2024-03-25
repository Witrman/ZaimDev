﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор <> Неопределено Тогда
		ЗаполнитьДанныеВыбораПоПараметрамОтбора(ДанныеВыбора, Параметры);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет заполнение списка значений данных выбора с учетом параметров отбора.
// Поддерживается параметр отбора ГруппаОпераций, в качестве значения которого может быть указана 
// группа видов операций по зарплате в виде строки, например, "Начисления" или "Удержания".
// Полный список поддерживаемых групп операций см. в функции ВидыОперацийПоГруппам.
// В качестве значения может быть указано несколько групп операций в виде фиксированного массива.
// Обрабатывается также строка поиска.
//
Процедура ЗаполнитьДанныеВыбораПоПараметрамОтбора(ДанныеВыбора, Параметры)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаОпераций.Ссылка,
	|	ТаблицаОпераций.Синоним,
	|	ТаблицаОпераций.Порядок
	|ПОМЕСТИТЬ ВТТаблицаОпераций
	|ИЗ
	|	&ТаблицаОпераций КАК ТаблицаОпераций
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОпераций.Ссылка,
	|	ТаблицаОпераций.Порядок КАК Порядок
	|ИЗ
	|	ВТТаблицаОпераций КАК ТаблицаОпераций
	|ГДЕ
	|	(ТаблицаОпераций.Ссылка В (&ВидыОпераций)
	|			ИЛИ &ПоВсемВидамОпераций)
	|	И ТаблицаОпераций.Синоним ПОДОБНО &СтрокаПоиска
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	
	Если Параметры.СтрокаПоиска = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И ТаблицаОпераций.Синоним ПОДОБНО &СтрокаПоиска", "");
	КонецЕсли;
	
	// Составляем таблицу операций.
	ТаблицаОпераций = Новый ТаблицаЗначений;
	ТаблицаОпераций.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыОперацийПоЗарплате"));
	ТаблицаОпераций.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	ТаблицаОпераций.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число"));
	
	ВидыОпераций = Неопределено;
	Если Параметры.Отбор.Свойство("ГруппаОпераций") Тогда
		ВидыОпераций = ВидыОперацийПоГруппам(Параметры.Отбор.ГруппаОпераций);
	КонецЕсли;
	
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.ВидыОперацийПоЗарплате.ЗначенияПеречисления Цикл
		НоваяСтрока = ТаблицаОпераций.Добавить();
		НоваяСтрока.Ссылка = Перечисления.ВидыОперацийПоЗарплате[ЗначениеПеречисления.Имя];
		НоваяСтрока.Синоним = ЗначениеПеречисления.Синоним;
		// Расставляем заданный порядок.
		Если ВидыОпераций <> Неопределено Тогда
			НоваяСтрока.Порядок = ВидыОпераций.Найти(НоваяСтрока.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	// Отбор только по действующим категориям с учетом введенной строки.
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ВидыОпераций", ВидыОпераций);
	Запрос.УстановитьПараметр("ПоВсемВидамОпераций", ВидыОпераций = Неопределено);
	
	Запрос.УстановитьПараметр("ТаблицаОпераций", ТаблицаОпераций);
	Запрос.УстановитьПараметр("СтрокаПоиска", Строка(Параметры.СтрокаПоиска) + "%");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

// Формируется массив видов операций по зарплате с учетом отбора по группе операций.
// При добавлении вида операций, его нужно упомянуть в одной из групп.
//
Функция ВидыОперацийПоГруппам(ГруппаОпераций)
	
	// Формируем массив групп операций, по которым осуществляется отбор.
	ГруппыОпераций = Новый Массив;
	Если ТипЗнч(ГруппаОпераций) = Тип("ФиксированныйМассив") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ГруппыОпераций, ГруппаОпераций);
	Иначе
		ГруппыОпераций.Добавить(ГруппаОпераций);
	КонецЕсли;
	
	ВидыОпераций = Новый Массив;
	
	Если ГруппыОпераций.Найти("Начисления") <> Неопределено Тогда
		// Начисления
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НачисленоДоход);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НачисленоСдельноДоход);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НатуральныйДоход);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.КомпенсацияЗаЗадержкуЗарплаты);  
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпуск);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.КомпенсацияЕжегодногоОтпуска);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюРаботодатель);
		
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускОценочныеОбязательства);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускОценочныеОбязательстваИРезервы);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускРезервы);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.КомпенсацияЕжегодногоОтпускаОценочныеОбязательства);
		
		// Договоры подряда
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ДоговорАвторскогоЗаказа);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ДоговорРаботыУслуги);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ДоходыСубъектаПредпринимательства);
		// Прочее
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВыплатыБывшимСотрудникам);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ДоходыКонтрагентов);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.Дивиденды);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПрочиеРасчетыСПерсоналом);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.МатериальнаяПомощь);
	КонецЕсли;

	Если ГруппыОпераций.Найти("Дивиденды") <> Неопределено Тогда
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.Дивиденды);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ДивидендыСотрудников);
	КонецЕсли;

	Если ГруппыОпераций.Найти("ЕжегодныеОтпускаОценочныеОбязательстваИРезервы") <> Неопределено Тогда
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускОценочныеОбязательства);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускОценочныеОбязательстваИРезервы);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускРезервы);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.КомпенсацияЕжегодногоОтпускаОценочныеОбязательства);
	КонецЕсли;

	// Удержания
	Если ГруппыОпераций.Найти("Удержания") <> Неопределено Тогда
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.АлиментыПрочиеИсполнительныеЛисты);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВозвратИзлишнеВыплаченныхСуммВследствиеСчетныхОшибок);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВозмещениеУщерба);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВознаграждениеПлатежногоАгента);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.Профвзносы);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПрочиеУдержания);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.УдержаниеЗаОтпуск);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.УдержаниеНеизрасходованныхПодотчетныхСумм);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.УдержаниеПоПрочимОперациямСРаботниками);
   		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ДобровольныеВзносыВНПФ);
		// Займы
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НачисленоПроцентовПоЗайму);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПогашениеЗаймов);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПроцентыПоЗайму);
		// удержания с доходов контрагентов
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.АлиментыПрочиеИсполнительныеЛистыКонтрагенты);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВознаграждениеПлатежногоАгентаКонтрагенты);
	КонецЕсли;
	
	// Регламентированные Удержания
	Если ГруппыОпераций.Найти("РегламентированныеУдержания") <> Неопределено Тогда
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ИПН);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ИПНДоходыКонтрагентов);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ИПНРасчетыСБывшимиСотрудниками);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ИПНДивиденды);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ИПНДоходыСубъектаПредпринимательства);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ОПВ);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ОПВДоходыКонтрагентов);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ОПВРасчетыСБывшимиСотрудниками);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ОПВДоходыСубъектаПредпринимательства);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВОСМС);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВОСМСДоходыКонтрагентов);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВОСМСРасчетыСБывшимиСотрудниками);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВОСМСДоходыСубъектаПредпринимательства);
	КонецЕсли;
	
	// Пеня по взносам и отчислениям
	Если ГруппыОпераций.Найти("Пеня") <> Неопределено Тогда
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ОПВПеня);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ОПВРПеня);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ОППВПеня);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.СОПеня);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВОСМСПеня);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ООСМСПеня);
	КонецЕсли;
	
	Возврат ВидыОпераций;
	
КонецФункции

Функция ВидыОперацийУдержанийТребующиеВВодаКонтрагента() Экспорт

	ВидыОпераций = Новый Массив;
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.АлиментыПрочиеИсполнительныеЛисты); 
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.АлиментыПрочиеИсполнительныеЛистыКонтрагенты); 
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВознаграждениеПлатежногоАгента);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВознаграждениеПлатежногоАгентаКонтрагенты);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.Профвзносы);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПрочиеУдержания);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПогашениеЗаймов);
	
	Возврат ВидыОпераций;

КонецФункции

Функция ВидыОперацийУдержанийТребующиеВВодаРаботникаОрганизации() Экспорт

	ВидыОпераций = Новый Массив;
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВозмещениеУщерба); 
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.УдержаниеПоПрочимОперациямСРаботниками); 
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.УдержаниеНеизрасходованныхПодотчетныхСумм);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВозвратИзлишнеВыплаченныхСуммВследствиеСчетныхОшибок);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПогашениеЗаймов);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПроцентыПоЗайму);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.УдержаниеЗаОтпуск);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПрочиеУдержания);
	
	Возврат ВидыОпераций;

КонецФункции

Функция ВидыОперацийУдержанийТребующиеВВодаДокументаОснования() Экспорт

	ВидыОпераций = Новый Массив;
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.АлиментыПрочиеИсполнительныеЛисты); 
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.АлиментыПрочиеИсполнительныеЛистыКонтрагенты); 
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВознаграждениеПлатежногоАгента);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВознаграждениеПлатежногоАгентаКонтрагенты);
	
	Возврат ВидыОпераций;

КонецФункции

#КонецОбласти

#КонецЕсли