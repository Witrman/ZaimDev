﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ПодготовитьФормуНаСервере();
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ТаблицыИдентичны(ЭтотОбъект) Тогда
		
		ТекущийГод = Год(ПроизводственныйКалендарь);
		
		СтруктураПараметров = Новый Структура("ТекущийГод", ТекущийГод);
		Оповещение = Новый ОписаниеОповещения("ПослеВопросаОЗаписиДанных", ЭтаФорма, СтруктураПараметров);
		
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Записать измененные данные за '") + Формат(ТекущийГод,"ЧГ=0") + НСтр("ru = ' год?'"), РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПроизводственныйКалендарьВыбор(Элемент, ВыбраннаяДата)
	
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораВидаДня", ЭтаФорма);
	ПоказатьВыборИзМеню(Оповещение, СписокВидовДней, Элементы.ПроизводственныйКалендарь);

КонецПроцедуры

&НаКлиенте
Процедура ПроизводственныйКалендарьПриВыводеПериода(Элемент, ОформлениеПериода)
		
	Коллекция_ОформленияДаты = ОформлениеПериода.Даты;

	Для Каждого Строка_ОформленияДаты Из Коллекция_ОформленияДаты Цикл
		
		ЗначениеВидДня = ВидыДней.Получить(Строка_ОформленияДаты.Дата);
		
		Если ЗначениеВидДня = Неопределено Тогда
			Продолжить;
		КонецЕсли;
			
		Строка_ОформленияДаты.ЦветТекста = ЦветаВидовДней.Получить(ЗначениеВидДня);
		
		Если ЗначениеВидДня = ПредопределенноеЗначение("Перечисление.УдалитьВидыДнейПроизводственногоКалендаря.Праздник") ИЛИ
			ЗначениеВидДня = ПредопределенноеЗначение("Перечисление.УдалитьВидыДнейПроизводственногоКалендаря.ДополнительныйВыходной") Тогда
			Строка_ОформленияДаты.Шрифт = ШрифтВыделения;
		КонецЕсли;
		
	КонецЦикла; 
		
КонецПроцедуры

&НаКлиенте
Процедура ГодВФормеПриИзменении(Элемент)
	
	Если НЕ ТаблицыИдентичны(ЭтотОбъект) Тогда
		ТекущийГод = Год(ПроизводственныйКалендарь);
		СтруктураПараметров = Новый Структура("ТекущийГод, ПрочитатьНовыйГод", ТекущийГод, Истина);
		Оповещение = Новый ОписаниеОповещения("ПослеВопросаОЗаписиДанных", ЭтаФорма, СтруктураПараметров);
		
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Записать измененные данные за '") + Формат(ТекущийГод,"ЧГ=0") + НСтр("ru = ' год?'"), РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		Если НЕ ЗначениеЗаполнено(ГодВФорме) Тогда 
			ТекстСообщения = НСтр("ru = 'Не указан год!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,);
			Возврат;
		КонецЕсли;
			
		ДатаУстановки = Дата(ГодВФорме, 1, 1);

		ПрочитатьДанныеКалендаря(ДатаУстановки);
		
		ПроизводственныйКалендарь = ДатаУстановки;
		УправлениеФормой();	

		// Отображение заполненого календаря
		Элементы.ПроизводственныйКалендарь.Обновить();

	КонецЕсли;
	
	Элементы.ДекорацияСообщение.Заголовок = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ГодВФормеАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Ожидание = 0;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Для СчГод = ГодВФорме - 50 По ГодВФорме + 50 Цикл
		ДанныеВыбора.Добавить(СчГод,Формат(СчГод,"ЧГ=0"));
	КонецЦикла;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПроизводственныйКалендарьПечать(Команда)

	Если Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
								  |Выполнение действия ""Печать"" возможно только после записи данных.
								  |Данные будут записаны.'");
			
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьКомандуПечатиПодтверждениеЗаписи", ЭтаФорма);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
	Иначе 
		ВыполнитьКомандуПечатиПодтверждениеЗаписи(Неопределено, Неопределено);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПервоначальноеЗаполнение(Команда)
	
	Если НЕ ЗначениеЗаполнено(ГодВФорме) Тогда 
		ТекстСообщения = НСтр("ru = 'Не указан год!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,);
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПослеВопросаОПервоначальномЗаполнении", ЭтаФорма);
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Восстановить первоначальное заполнение производственного календаря?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)

	ЗаписатьДанныеРегистраНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ПроизводственныйКалендарь = ОбщегоНазначения.ТекущаяДатаПользователя();
	ГодВФорме = Год(ПроизводственныйКалендарь);
	
	ПрочитатьДанныеКалендаря(ПроизводственныйКалендарь);
	
	ШрифтВыделения = Новый Шрифт(,,Истина);
	
	// Назначим Цвета
	ЦветаОформления = Новый Соответствие;
	
	ЦветаОформления.Вставить(Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.Рабочий,			Новый Цвет(  0,   0,   0));	// Черный
	ЦветаОформления.Вставить(Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.Суббота,			Новый Цвет(153,  51,   0));	// Темно-красный
	ЦветаОформления.Вставить(Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.Воскресенье,		Новый Цвет(255,   0,   0));	// Красный
	ЦветаОформления.Вставить(Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.ДополнительныйВыходной, Новый Цвет(0,0, 186));	// Темно-синий
	ЦветаОформления.Вставить(Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.Праздник,			Новый Цвет(208,   32,   144));	// Фиолетовый
	ЦветаОформления.Вставить(Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.ПустаяСсылка(),	Новый Цвет(0,  	  0,   0));	// Черный

	ЦветаВидовДней = Новый ФиксированноеСоответствие(ЦветаОформления);	
	
	// Заполним список для выбора
	СписокВидовДней.Добавить(Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.Рабочий, 		 "Рабочий");
	СписокВидовДней.Добавить(Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.Праздник,		 "Праздник");
	СписокВидовДней.Добавить(Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.Суббота,		 "Суббота");
	СписокВидовДней.Добавить(Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.Воскресенье,	 "Воскресенье");
	СписокВидовДней.Добавить(Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.ДополнительныйВыходной,	 "Дополнительный выходной");

КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормой()
	
	Элементы.ПроизводственныйКалендарь.НачалоПериодаОтображения = НачалоГода(ПроизводственныйКалендарь);
	Элементы.ПроизводственныйКалендарь.КонецПериодаОтображения = КонецГода(ПроизводственныйКалендарь);
	
	Заголовок = НСтр("ru = 'Регламентированный производственный календарь на '") + Формат(ГодВФорме,"ЧГ=0") + НСтр("ru = ' год'");

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораВидаДня(ВыбранныйЭлемент, Параметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;		
	КонецЕсли;
	
	ИзменитьВидыДней(Элементы.ПроизводственныйКалендарь.ВыделенныеДаты, ВыбранныйЭлемент.Значение);
	Элементы.ПроизводственныйКалендарь.Обновить();
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте 
Процедура ПослеВопросаОЗаписиДанных(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьИзТаблицыВРегистр(Параметры.ТекущийГод);
	КонецЕсли;
	
	Если Параметры.Свойство("ПрочитатьНовыйГод") И Параметры.ПрочитатьНовыйГод Тогда
		
		Если НЕ ЗначениеЗаполнено(ГодВФорме) Тогда 
			ТекстСообщения = НСтр("ru = 'Не указан год!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,);
			Возврат;
		КонецЕсли;
			
		ДатаУстановки = Дата(ГодВФорме, 1, 1);

		ПрочитатьДанныеКалендаря(ДатаУстановки);
		
		ПроизводственныйКалендарь = ДатаУстановки;
		УправлениеФормой();	

		// Отображение заполненого календаря
		Элементы.ПроизводственныйКалендарь.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОПервоначальномЗаполнении(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ПослеВопросаОПервоначальномЗаполненииНаСервере();
	// Отображение заполненого календаря
	Элементы.ПроизводственныйКалендарь.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ПослеВопросаОПервоначальномЗаполненииНаСервере() Экспорт

	ДанныеКалендаря = ПервоначальноеЗаполнениеРегистра(Дата(ГодВФорме, 1, 1));
	ПреобразоватьДанныеПроизводственногоКалендаря(ДанныеКалендаря);
	ЭталонныеВидыДней = ВидыДней;
	
КонецПроцедуры

&НаСервере
Функция СформироватьЗапросПоКалендарю(ДатаНачалаЗапроса, ДатаОкончанияЗапроса)
	
	ЗапросПоКалендарю = Новый Запрос();
	ЗапросПоКалендарю.УстановитьПараметр("ДатаКалендаря1", ДатаНачалаЗапроса);
	ЗапросПоКалендарю.УстановитьПараметр("ДатаКалендаря2", ДатаОкончанияЗапроса);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря КАК ДатаКалендаря,
	|	РегламентированныйПроизводственныйКалендарь.ВидДня
	|ИЗ
	|	РегистрСведений.РегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
	|ГДЕ
	|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ &ДатаКалендаря1 И &ДатаКалендаря2
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаКалендаря";	
	
	ЗапросПоКалендарю.Текст = ТекстЗапроса;
	Возврат ЗапросПоКалендарю.Выполнить();
	
КонецФункции     

&НаСервере
Функция ПервоначальноеЗаполнениеРегистра(КонтрольнаяДата, Сообщать = Истина) Экспорт
	
	ТаблицаРегистра = Новый ТаблицаЗначений;
	ТаблицаРегистра.Колонки.Добавить("ДатаКалендаря");
	ТаблицаРегистра.Колонки.Добавить("ВидДня");
	
	ДлинаСуток = 24*60*60; // = 86400 секунд
	
	// Заполнение регистра за год
	ПервоеЯнваря = НачалоГода(КонтрольнаяДата);
	СписокПраздниковВВыходные = Новый СписокЗначений;
	
	СписокПраздников = РегистрыСведений.УдалитьРегламентированныйПроизводственныйКалендарь.СписокПраздниковРК(Год(КонтрольнаяДата));
	
	Для НомерДня = 1 По ДеньГода(КонецГода(КонтрольнаяДата)) Цикл
		
		НоваяЗаписьРегистра = РегистрыСведений.УдалитьРегламентированныйПроизводственныйКалендарь.СоздатьМенеджерЗаписи();
		ЗаписываемаяДата 	= НачалоДня(ПервоеЯнваря + ДлинаСуток * (НомерДня - 1));
		НоваяЗаписьРегистра.ДатаКалендаря = ЗаписываемаяДата;
		НоваяЗаписьРегистра.Год = Год(ЗаписываемаяДата);
		
		ДеньМесяцЗаписываемаяДата = "" + Формат(ЗаписываемаяДата, "ДФ = 'ММ'") + Формат(ЗаписываемаяДата, "ДФ = 'дд'");
		ПраздничныйДень = СписокПраздников.НайтиПоЗначению(ДеньМесяцЗаписываемаяДата);
		
		Если ПраздничныйДень <> Неопределено Тогда
			
			ПредставлениеДня = ПраздничныйДень.Представление;
			
			Если Лев(ПредставлениеДня, 1) = "!" Тогда 
				// дополнительный выходной
				НоваяЗаписьРегистра.ВидДня = Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.ДополнительныйВыходной;
			
			Иначе
		    	// праздник			
				НоваяЗаписьРегистра.ВидДня = Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.Праздник;
				
				Если ДеньНедели(ЗаписываемаяДата) > 5 Тогда
					СписокПраздниковВВыходные.Добавить(ЗаписываемаяДата, ПраздничныйДень);
				КонецЕсли;
			
			КонецЕсли;
			
		Иначе
			
			Если ДеньНедели(ЗаписываемаяДата) = 6 Тогда
				НоваяЗаписьРегистра.ВидДня = Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.Суббота
			ИначеЕсли ДеньНедели(ЗаписываемаяДата) = 7 Тогда
				НоваяЗаписьРегистра.ВидДня = Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.Воскресенье
			Иначе
				НоваяЗаписьРегистра.ВидДня = Перечисления.УдалитьВидыДнейПроизводственногоКалендаря.Рабочий
			КонецЕсли; 
			
		КонецЕсли; 
		
		// Установим ресурсы "Пятидневка"
		ЗаполнитьРесурсыЗаписиРегистра(НоваяЗаписьРегистра);
		
		НоваяЗаписьРегистра.Записать();
		
		// Запишем в таблицу значений
		НоваяСтрокаТаблицыРегистра = ТаблицаРегистра.Добавить();
		НоваяСтрокаТаблицыРегистра.ДатаКалендаря = ЗаписываемаяДата;
		НоваяСтрокаТаблицыРегистра.ВидДня        = НоваяЗаписьРегистра.ВидДня;
		
	КонецЦикла; 
	
	Если Сообщать и СписокПраздниковВВыходные.Количество() > 0 Тогда
		
		ЗаКакойГод = Год(КонтрольнаяДата);
		
		ТекстСообщения = НСтр("ru = 'При заполнении календаря на '") + Формат(ЗаКакойГод,"ЧЦ=4; ЧГ=0") + НСтр("ru = ' год обнаружены государственные праздники, попадающие на выходные дни:'");
		
		Для Сч = 1 По СписокПраздниковВВыходные.Количество() Цикл
			ТекстСообщения = ТекстСообщения + Символы.ПС + 
				"   " + Формат(СписокПраздниковВВыходные[Сч - 1].Значение, "ДФ ='дд ММММ'") + " - " + СписокПраздниковВВыходные[Сч - 1];
		КонецЦикла; 
		
		ТекстСообщения = ТекстСообщения + Символы.ПС + 
			НСтр("ru = 'Необходимо перенести эти выходные дни на следующий после праздничного рабочий день.'");
			
		Элементы.ДекорацияСообщение.Заголовок = ТекстСообщения;
		
	КонецЕсли; 
	
	ТаблицаРегистра.Сортировать("ДатаКалендаря");
	
	Возврат ТаблицаРегистра;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗаполнитьРесурсыЗаписиРегистра(ЗаписьРегистра)
	
	// рабочий день
	Если ЗаписьРегистра.ВидДня = ПредопределенноеЗначение("Перечисление.УдалитьВидыДнейПроизводственногоКалендаря.Рабочий") Тогда
		ЗаписьРегистра.Пятидневка  = 1;
	    			
	// суббота	
	// воскресение
	// дополнительный выходной
	// празничный день	
	Иначе
		ЗаписьРегистра.Пятидневка  = 0;
		
	КонецЕсли;

КонецФункции 

&НаСервере
Процедура ПрочитатьДанныеКалендаря(ПериодКалендаря)
	
	РезультатЗапроса = СформироватьЗапросПоКалендарю(НачалоГода(ПериодКалендаря), КонецГода(ПериодКалендаря));
	
	Если РезультатЗапроса.Пустой() Тогда
		ДанныеКалендаря = ПервоначальноеЗаполнениеРегистра(ПериодКалендаря);
	Иначе
		ДанныеКалендаря = РезультатЗапроса.Выгрузить();
	КонецЕсли; 
	
	ПреобразоватьДанныеПроизводственногоКалендаря(ДанныеКалендаря);
	ЭталонныеВидыДней = ВидыДней;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТаблицыИдентичны(Форма)
	
	ВидыДней = Форма.ВидыДней;
	ЭталонныеВидыДней = Форма.ЭталонныеВидыДней;
	
	Для Каждого День Из ЭталонныеВидыДней Цикл
		Если День.Значение <> ВидыДней[День.Ключ] Тогда
			Возврат Ложь;
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат Истина;
	
КонецФункции

// Выполняет запись в регистр сведений "РегламентированныйПроизводственныйКалендарь" данных из временной таблицы 
&НаСервере
Процедура ЗаписатьИзТаблицыВРегистр(ГодДляСохранения)

	// Очистим старые данные за год
	НаборЗаписей = РегистрыСведений.УдалитьРегламентированныйПроизводственныйКалендарь.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Год.Значение		 = ГодДляСохранения;
	НаборЗаписей.Отбор.Год.Использование = Истина;
	НаборЗаписей.Прочитать();
	
	ЕстьЗаписиВРегистре = НаборЗаписей.Количество() > 0;
	
	// Запишем новые данные за год
	Если ЕстьЗаписиВРегистре Тогда
		Для Каждого Запись Из НаборЗаписей Цикл
			Запись.ВидДня = ВидыДней.Получить(Запись.ДатаКалендаря);
			// Установим ресурсы "Пятидневка"
			ЗаполнитьРесурсыЗаписиРегистра(Запись);
		КонецЦикла; 
	Иначе
		Для Каждого ЗначениеДень ИЗ ВидыДней Цикл
			НоваяЗаписьРегистра = НаборЗаписей.Добавить();
			НоваяЗаписьРегистра.ДатаКалендаря = ЗначениеДень.Ключ;
			НоваяЗаписьРегистра.Год			  = Год(ЗначениеДень.Ключ);
			НоваяЗаписьРегистра.ВидДня		  = ЗначениеДень.Значение;
			
			// Установим ресурсы "Пятидневка"
			ЗаполнитьРесурсыЗаписиРегистра(НоваяЗаписьРегистра);
		КонецЦикла; 
	КонецЕсли;
	
	// запишем набор записей
	НаборЗаписей.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеРегистраНаСервере()
	
	Если НЕ ТаблицыИдентичны(ЭтотОбъект) Тогда
	
		ЗаписатьИзТаблицыВРегистр(ГодВФорме);
		
		ДатаУстановки = Дата(ГодВФорме, 1, 1);
		РезультатЗапроса = СформироватьЗапросПоКалендарю(ДатаУстановки, КонецГода(ДатаУстановки));
		
		Если РезультатЗапроса.Пустой() Тогда
			ДанныеКалендаря = ПервоначальноеЗаполнениеРегистра(ДатаУстановки);
		Иначе
			ДанныеКалендаря = РезультатЗапроса.Выгрузить();
		КонецЕсли;
		
		ПреобразоватьДанныеПроизводственногоКалендаря(ДанныеКалендаря);
		ЭталонныеВидыДней = ВидыДней;
		
	КонецЕсли;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ПреобразоватьДанныеПроизводственногоКалендаря(ДанныеКалендаря)
	
	ВидыДнейСоответствие = Новый Соответствие;
	
	Для Каждого СтрокаТаблицы Из ДанныеКалендаря Цикл
		ВидыДнейСоответствие.Вставить(СтрокаТаблицы.ДатаКалендаря, СтрокаТаблицы.ВидДня);
	КонецЦикла;
	
	ВидыДней = Новый ФиксированноеСоответствие(ВидыДнейСоответствие);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидыДней(ДатыДней, ВидДня)
	
	ВидыДнейСоответствие = СоответствиеПоФиксированномуСоответствию(ВидыДней);
	
	Для Каждого ВыбраннаяДата Из ДатыДней Цикл
		ВидыДнейСоответствие.Вставить(ВыбраннаяДата, ВидДня);
	КонецЦикла;
	
	ВидыДней = Новый ФиксированноеСоответствие(ВидыДнейСоответствие);
	
КонецПроцедуры

// Создает и заполняет соответствие по данным фиксированного соответствия
//
&НаКлиенте
Функция СоответствиеПоФиксированномуСоответствию(ФиксированноеСоответствие)
	
	НовоеСоответствие = Новый Соответствие;
	
	Для Каждого КлючИЗначение Из ФиксированноеСоответствие Цикл
		НовоеСоответствие.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Возврат НовоеСоответствие;
	
КонецФункции

&НаКлиенте 
Процедура ВыполнитьКомандуПечатиПодтверждениеЗаписи(Результат, Параметры) Экспорт
	
	ВыполнитьПредварительнуюЗапись = Ложь;
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Результат <> Неопределено Тогда
		ВыполнитьПредварительнуюЗапись = Истина;
	КонецЕсли;
	
	ТабличныйДокумент = ВыполнитьКомандуПечатиПодтверждениеЗаписиНаСервере(ВыполнитьПредварительнуюЗапись);
	
	ТабличныйДокумент.Показать(НСтр("ru = 'Производственный календарь на '" + Год(ПроизводственныйКалендарь) + НСтр("ru = ' год'")));
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьКомандуПечатиПодтверждениеЗаписиНаСервере(ВыполнитьПредварительнуюЗапись)
	
	Если ВыполнитьПредварительнуюЗапись Тогда
		ЗаписатьИзТаблицыВРегистр(Год(ПроизводственныйКалендарь));
		Модифицированность = Ложь;
	КонецЕсли;
		
	Возврат РегистрыСведений.УдалитьРегламентированныйПроизводственныйКалендарь.Печать(Новый Структура("Год", Год(ПроизводственныйКалендарь)));

КонецФункции

