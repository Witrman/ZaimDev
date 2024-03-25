﻿Функция ПолучитьТикет(serviceNick) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатПолученияТикета = ИнтернетПоддержкаПользователей.ТикетАутентификацииНаПорталеПоддержки(serviceNick);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатПолученияТикета.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
		ПолучитьТикетЛокально(РезультатПолученияТикета, serviceNick);
	КонецЕсли;
	
	Если Не ПустаяСтрока(РезультатПолученияТикета.Тикет) Тогда
		Возврат РезультатПолученияТикета;
	Иначе
		Возврат НСтр("ru = 'Не удалось получить тикет.'") + " " + РезультатПолученияТикета.СообщениеОбОшибке;
	КонецЕсли;
	
КонецФункции

Функция РезультатЗапросаСервиса(БИН,НомерДокумента,СуммаДокумента,ДанныеКомпании) Экспорт
	
	URLСервиса 		= "https://pk.1capp.kz/service/kaspiqr/v1/getImageQrCode?bin="+БИН;
	serviceNick 	= "1c-qr-pay";
	
	Тикет = ПолучитьТикет(serviceNick);
	
	Если НЕ ЗначениеЗаполнено(Тикет) Тогда
		Возврат НСтр("ru='KaspiQR. Получен пустой ответ при запросе тикета'");
	ИначеЕсли ТипЗнч(Тикет) = Тип("Строка") Тогда
		Возврат "KaspiQR. "+Тикет;
	КонецЕсли;
	
	ШаблонСсылки = "https://kaspi.kz/pay/%1?service_id=%2&%3=%4&amount=%5";
	
	ИнформационнаяСсылка = СтрШаблон(ШаблонСсылки,
									ДанныеКомпании.НаименованиеОрганизации,
									Формат(ДанныеКомпании.IDПартнера,"ЧГ=0"),
									Формат(ДанныеКомпании.IDПараметра,"ЧГ=0"),
									НомерДокумента,
									Формат(СуммаДокумента,"ЧРД=.; ЧГ=0"));

	Результат = Новый Структура;
	Результат.Вставить("КодОшибки"         , "");
	Результат.Вставить("СообщениеОбОшибке" , "");
	Результат.Вставить("ИнформацияОбОшибке", "");
	Результат.Вставить("Тикет"             , Неопределено);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	
	ДопПараметрыЗапроса = Новый Структура;
	ДопПараметрыЗапроса.Вставить("Метод"                   , "POST");
	ДопПараметрыЗапроса.Вставить("Заголовки"               , Заголовки);
	ДопПараметрыЗапроса.Вставить("ФорматОтвета"            , 1);
	ДопПараметрыЗапроса.Вставить("ДанныеДляОбработки"      , ПараметрыЗапросаJSON(Тикет.Тикет, serviceNick, ИнформационнаяСсылка));
	ДопПараметрыЗапроса.Вставить("ФорматДанныхДляОбработки", 1);
	ДопПараметрыЗапроса.Вставить("Таймаут"                 , 30);

	РезультатОперации = ИнтернетПоддержкаПользователей.ЗагрузитьСодержимоеИзИнтернет(URLСервиса, , , ДопПараметрыЗапроса);
	
	Если РезультатОперации.КодСостояния = 200 Тогда
		
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(РезультатОперации.Содержимое);
		ОтветОбъект = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
		
		Возврат Base64Значение(ОтветОбъект.base64StringImage);
			
	Иначе
		
		Результат.КодОшибки 			= РезультатОперации.КодСостояния;	
		Результат.СообщениеОбОшибке 	= СтрШаблон(НСтр("ru = 'Сервис %1 недоступен пользователю. %2'"),serviceNick,РезультатОперации.Содержимое);
		Результат.ИнформацияОбОшибке 	= РезультатОперации.ИнформацияОбОшибке;
		
		ЗаписатьОшибкуВЖурналРегистрации(Результат.ИнформацияОбОшибке);
		Результат.Тикет 				= Тикет;
		
		Возврат Результат.СообщениеОбОшибке;
		
	КонецЕсли;		
	
КонецФункции

Функция ПараметрыЗапросаJSON(ticket, serviceNick, Ссылка)

	ЗаписьДанныхСообщения = Новый ЗаписьJSON;
	ЗаписьДанныхСообщения.УстановитьСтроку();
	ЗаписьДанныхСообщения.ЗаписатьНачалоОбъекта();

	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("ticket");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ticket);
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("serviceNick");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(serviceNick);
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("qrUrl");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(Ссылка);
	
	ЗаписьДанныхСообщения.ЗаписатьКонецОбъекта();
	
	Возврат ЗаписьДанныхСообщения.Закрыть();

КонецФункции

// Получает из базы сохраненные данные по организации, необходимые для генерации QR кода
Функция СохраненныеРеквизитыКода(Организация, СтруктурноеПодразделение = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеОрганизаций = Новый Массив();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиОнлайнПлатежей.НаименованиеОрганизации КАК НаименованиеОрганизации,
	|	НастройкиОнлайнПлатежей.IDПартнера КАК IDПартнера,
	|	НастройкиОнлайнПлатежей.IDПараметра КАК IDПараметра,
	|	НастройкиОнлайнПлатежей.ВыводитьQRКод КАК ВыводитьQRКод
	|ИЗ
	|	РегистрСведений.НастройкиОнлайнПлатежей КАК НастройкиОнлайнПлатежей
	|ГДЕ
	|	НастройкиОнлайнПлатежей.Организация = &Организация
	|	И НастройкиОнлайнПлатежей.СтруктурноеПодразделение = &СтруктурноеПодразделение
	|	И НастройкиОнлайнПлатежей.ТипПлатежнойСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыПлатежныхСистем.KaspiQR)";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Если Не ЗначениеЗаполнено(СтруктурноеПодразделение) Или СтруктурноеПодразделение.УказыватьРеквизитыГоловнойОрганизации Тогда
		Запрос.УстановитьПараметр("СтруктурноеПодразделение", Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
	Иначе
		Запрос.УстановитьПараметр("СтруктурноеПодразделение", СтруктурноеПодразделение);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		РеквизитыЗаполненияФормы = Новый Структура();
		РеквизитыЗаполненияФормы.Вставить("Организация"            , Организация);
		РеквизитыЗаполненияФормы.Вставить("ВыводитьQRКод"          , ВыборкаДетальныеЗаписи.ВыводитьQRКод);
		РеквизитыЗаполненияФормы.Вставить("НаименованиеОрганизации", ВыборкаДетальныеЗаписи.НаименованиеОрганизации);
		РеквизитыЗаполненияФормы.Вставить("IDПартнера"             , ВыборкаДетальныеЗаписи.IDПартнера);
		РеквизитыЗаполненияФормы.Вставить("IDПараметра"            , ВыборкаДетальныеЗаписи.IDПараметра);
		ДанныеОрганизаций.Добавить(РеквизитыЗаполненияФормы);
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ДанныеОрганизаций;
	
КонецФункции

Процедура ЗаписатьОшибкуВЖурналРегистрации(СообщениеОбОшибке)
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		СообщениеОбОшибке);
	
КонецПроцедуры

Функция ИмяСобытияЖурналаРегистрации()
	Возврат НСтр("ru = 'Генерация QR-кода'", ОбщегоНазначения.КодОсновногоЯзыка());
КонецФункции

Процедура ПолучитьТикетЛокально(ДанныеТикета, serviceNick)
	
	ТелоЗапроса = Новый Структура("login,password,serviceNick");
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеАвторизации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НЕ ДанныеАвторизации = Неопределено Тогда
		ДанныеАвторизации.Свойство("Логин", ТелоЗапроса.login);
		ДанныеАвторизации.Свойство("Пароль", ТелоЗапроса.password);
	КонецЕсли;
	
	ТелоЗапроса.serviceNick = serviceNick;
	
	Если ЗначениеЗаполнено(ТелоЗапроса.login) И ЗначениеЗаполнено(ТелоЗапроса.password) Тогда
		
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON, ТелоЗапроса);
		СтрокаТелаЗапроса = ЗаписьJSON.Закрыть();
		
		URLСервиса = "https://pk.1capp.kz/rest/ticket/get";
		
		СтрукутраURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URLСервиса); 
				
		Заголовки = Новый Соответствие;
		Заголовки.Вставить("Content-Type", "application/json");
		
		SSL = ?(СтрукутраURI.Схема = "https", Новый ЗащищенноеСоединениеOpenSSL(), Неопределено);
		
		Попытка
			
			HTTPСоединение = Новый HTTPСоединение(СтрукутраURI.Хост, СтрукутраURI.Порт,,,,,SSL);
			
			HTTPЗапрос = Новый HTTPЗапрос(СтрукутраURI.ПутьНаСервере,Заголовки);
			
			HTTPЗапрос.УстановитьТелоИзСтроки(СтрокаТелаЗапроса);
			
			ОтветСервиса = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос);
			
			ТелоОтветаСтрокой = ОтветСервиса.ПолучитьТелоКакСтроку();
			
			ЧтениеJSON = Новый ЧтениеJSON;
			ЧтениеJSON.УстановитьСтроку(ТелоОтветаСтрокой);
			СтрукутраТела = ПрочитатьJSON(ЧтениеJSON);
			ЧтениеJSON.Закрыть();
			
			Если ОтветСервиса.КодСостояния = 200 Тогда
				ДанныеТикета.КодОшибки = "";
				ДанныеТикета.СообщениеОбОшибке = "";
				ДанныеТикета.ИнформацияОбОшибке = "";
				ДанныеТикета.Тикет = СтрукутраТела.ticket;
			Иначе
				ДанныеТикета.КодОшибки = ОтветСервиса.КодСостояния;
				ДанныеТикета.СообщениеОбОшибке = СтрукутраТела.message;
				ДанныеТикета.ИнформацияОбОшибке = СтрукутраТела.errorType;
				ДанныеТикета.Тикет = Неопределено;
			КонецЕсли;
			
		Исключение
			ДанныеТикета.КодОшибки = "";
			ДанныеТикета.СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ДанныеТикета.ИнформацияОбОшибке = "Системная ошибка";
			ДанныеТикета.Тикет = Неопределено;
		КонецПопытки;
		
	Иначе
		ТекстОтвета = НСтр("ru='Не найден логин или пароль пользователя'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОтвета);
	КонецЕсли;
	
КонецПроцедуры
