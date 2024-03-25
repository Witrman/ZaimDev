﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВестиАналитическийУчетОС = Параметры.ВестиАналитическийУчетОС;
	ДатаНачала               = Параметры.ДатаНачала;
	Организация              = Справочники.Организации.ОрганизацияПоУмолчанию();
	
	Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаИзменениеСоставаАналитики;
	
	ДоступноИзменениеНастройки = Пользователи.РолиДоступны("ДобавлениеИзменениеНастроекБухгалтерии");
	Элементы.СтраницыПомощника.ТолькоПросмотр = НЕ ДоступноИзменениеНастройки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПередОткрытиемСтраницы(Элементы.СтраницаИзменениеСоставаАналитики);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ГиперссылкаДокументыПеремещенияНажатие(Элемент)
	
	ОписаниеОповещенияОВыборе = Новый ОписаниеОповещения("ГиперссылкаДокументыПеремещенияНажатиеЗавершение", ЭтотОбъект);
	ПоказатьВыборИзМеню(ОписаниеОповещенияОВыборе, СписокДокументовПеремещениеОС, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаДокументыПеремещенияНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Ключ", Результат.Значение);
	ОткрытьФорму("Документ.ПеремещениеОС.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КнопкаНазадНажатие(Команда)
	
	ОтработатьНажатиеКнопкиНазад();
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаДалееНажатие(Команда)
	
	ОбработатьНажатиеКнопкиДалее();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	ПараметрыОтбора = Новый Структура("НачальноеЗаполнениеАналитикиНаСчетахУчетаОС, Организация", Истина, Организация);
	ОписаниеОповещенияОВыборе = Новый ОписаниеОповещения("ОткрытьДокументЗавершение", ЭтотОбъект);
	ОткрытьФорму("Документ.ПеремещениеОС.ФормаВыбора", Новый Структура("Отбор", ПараметрыОтбора), ЭтотОбъект, , , , ОписаниеОповещенияОВыборе);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаполнения = Новый Структура("Дата, Организация, НачальноеЗаполнениеАналитикиНаСчетахУчетаОС", ДатаНачала, Организация, Истина);
	ОткрытьФорму("Документ.ПеремещениеОС.ФормаОбъекта", Новый Структура("Ключ, Основание", Результат, ДанныеЗаполнения), ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбработатьНажатиеКнопкиДалее()
	
	ОчиститьСообщения();
	ТекущаяСтраница			= Элементы.СтраницыПомощника.ТекущаяСтраница;
	Страницы				= Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	НоваяТекущаяСтраница	= ТекущаяСтраница;
	КнопкаДалее				= Элементы.КнопкаДалее;
	КнопкаНазад				= Элементы.КнопкаНазад;
	КнопкаЗакрыть			= Элементы.КнопкаЗакрыть;
	
	ТекущаяСтраница.Доступность	= Ложь;
	КнопкаДалее.Доступность		= Ложь;
	КнопкаНазад.Доступность		= Ложь;
	КнопкаЗакрыть.Доступность	= Ложь;
	
	Если ТекущаяСтраница = Страницы.СтраницаИзменениеСоставаАналитики Тогда
		НоваяСтраница = ОбработатьСтраницуИзменениеСоставаАналитики();
		Если НоваяСтраница = Неопределено Тогда
			Возврат;
		Иначе
			НоваяТекущаяСтраница = Страницы[НоваяСтраница];
		КонецЕсли;
	ИначеЕсли ТекущаяСтраница = Страницы.СтраницаРегистрацияПеремещенийОС Тогда
		НоваяСтраница = ОбработатьСтраницуРегистрацияПеремещенийОС();
		Если НоваяСтраница = Неопределено Тогда
			Возврат;
		Иначе
			НоваяТекущаяСтраница = Страницы[НоваяСтраница];
		КонецЕсли;
	КонецЕсли;
	
	Отказ = Ложь;
	
	ТекущаяСтраница.Доступность = Истина;
	
	ПередОткрытиемСтраницы(НоваяТекущаяСтраница);
	Элементы.СтраницыПомощника.ТекущаяСтраница = НоваяТекущаяСтраница;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтработатьНажатиеКнопкиНазад()
	
	Страницы             = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	ТекущаяСтраница      = Элементы.СтраницыПомощника.ТекущаяСтраница;
	НоваяТекущаяСтраница = ТекущаяСтраница;
	
	Если ТекущаяСтраница = Страницы.СтраницаИзменениеСоставаАналитики Тогда
		НоваяТекущаяСтраница = Страницы.СтраницаИзменениеСоставаАналитики;
	ИначеЕсли ТекущаяСтраница = Страницы.СтраницаРегистрацияПеремещенийОС Тогда
		НоваяТекущаяСтраница = Страницы.СтраницаИзменениеСоставаАналитики;
	КонецЕсли;
	
	ПередОткрытиемСтраницы(НоваяТекущаяСтраница);
	
	Элементы.СтраницыПомощника.ТекущаяСтраница = НоваяТекущаяСтраница;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередОткрытиемСтраницы(НоваяТекущаяСтраница = Неопределено) 
	
	Страницы		= Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	Если НоваяТекущаяСтраница = Неопределено Тогда
		НоваяТекущаяСтраница = Элементы.СтраницыПомощника.ТекущаяСтраница;
	КонецЕсли;
	
	ДоступноИзменениеНастройки  = НЕ Элементы.СтраницыПомощника.ТолькоПросмотр;

	ДоступностьКнопкиНазад		= Истина;
	ДоступностьКнопкиДалее		= Истина;
	ДоступностьКнопкиЗакрыть	= Истина;
	ДоступностьКнопкиСоздать    = Ложь;
	ДоступностьКнопкиОткрыть    = Ложь;
	ФункцияКнопкиДалее			= Истина; // Истина = "Далее", Ложь = "Готово"
	
	Если НоваяТекущаяСтраница = Страницы.СтраницаИзменениеСоставаАналитики Тогда
		ДоступностьКнопкиНазад   = Ложь;
	ИначеЕсли НоваяТекущаяСтраница = Страницы.СтраницаРегистрацияПеремещенийОС Тогда
		ФункцияКнопкиДалее	     = Ложь;
		ДоступностьКнопкиДалее   = ДоступноИзменениеНастройки;
		ДоступностьКнопкиОткрыть = Истина И ДоступноИзменениеНастройки;
	КонецЕсли;
	
	КнопкаДалее		= Элементы.КнопкаДалее;
	КнопкаНазад		= Элементы.КнопкаНазад;
	КнопкаЗакрыть	= Элементы.КнопкаЗакрыть;
	КнопкаНазад.Доступность		= ДоступностьКнопкиНазад;
	КнопкаДалее.Доступность		= ДоступностьКнопкиДалее;
	КнопкаЗакрыть.Доступность	= ДоступностьКнопкиЗакрыть;
	Если ДоступностьКнопкиДалее Тогда
		Если НЕ КнопкаДалее.КнопкаПоУмолчанию Тогда
			КнопкаДалее.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
	ИначеЕсли ДоступностьКнопкиЗакрыть Тогда
		Если НЕ КнопкаЗакрыть.КнопкаПоУмолчанию Тогда
			КнопкаЗакрыть.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ОткрытьДокумент.Видимость = ДоступностьКнопкиОткрыть;
	
	КнопкаДалее.Заголовок = ? (ФункцияКнопкиДалее, НСтр("ru = 'Далее >'"), НСтр("ru = 'Создать документ'"));
	
КонецПроцедуры

&НаКлиенте
Функция ОбработатьСтраницуИзменениеСоставаАналитики()
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Изменение состава аналитики на счетах учета ОС'"));
	Если ОбработатьСтраницуИзменениеСоставаАналитикиНаСервере() Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Изменение состава аналитики на счетах учета ОС успешно завершено'"));
		Оповестить("ИзменениеНастройкиВеденияАналитическогоУчетаОС");
		Возврат Элементы.СтраницаРегистрацияПеремещенийОС.Имя;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Не удалось изменить состав аналитики на счетах учета ОС '"));
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция ОбработатьСтраницуРегистрацияПеремещенийОС()
	
	ДанныеЗаполнения = Новый Структура("Дата, Организация, НачальноеЗаполнениеАналитикиНаСчетахУчетаОС", ДатаНачала, Организация, Истина);
	ОткрытьФорму("Документ.ПеремещениеОС.ФормаОбъекта", Новый Структура("Основание", ДанныеЗаполнения), ЭтотОбъект);
	
	Возврат Элементы.СтраницаРегистрацияПеремещенийОС.Имя;
	
КонецФункции

&НаСервере
Функция ОбработатьСтраницуИзменениеСоставаАналитикиНаСервере()
	
	Если НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеНастроекБухгалтерии") Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Изменение настроек параметров учета доступно только полноправным пользователям и пользователям с ролью ""Добавление изменение настроек бухгалтерии""'"),
		);
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ИзменитьНастройку() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Счета = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСписокСчетовУчетаВА();
		
	// записать параметры
	Если ВестиАналитическийУчетОС = 0 Тогда
			
		Для Каждого Счет Из Счета Цикл
			ПрименитьПараметрыСубконтоПодразделения(Счет.Значение, "Типовой", Истина, Истина, Ложь);
		КонецЦикла;

	ИначеЕсли ВестиАналитическийУчетОС = 1 Тогда
		
		Для Каждого Счет Из Счета Цикл
			ПрименитьПараметрыСубконтоМОЛ(Счет.Значение, "Типовой", Истина, Истина);
		КонецЦикла;

	Иначе
		
		Для Каждого Счет Из Счета Цикл
			ПрименитьПараметрыСубконтоПодразделения(Счет.Значение, "Типовой", Истина, Истина, Ложь);
		КонецЦикла;
		
		Для Каждого Счет Из Счета Цикл
			ПрименитьПараметрыСубконтоМОЛ(Счет.Значение, "Типовой", Истина, Истина);
		КонецЦикла;
		
	КонецЕсли;	
	
	ЗаполнитьСписокДокументовПеремещенияОС();
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ИзменитьНастройку()
	
	НачатьТранзакцию();
	МенеджерЗаписиДатаНачалаМОЛ = Константы.ДатаНачалаВеденияВБУУчетаОСВРазрезеМОЛ.СоздатьМенеджерЗначения();
	МенеджерЗаписиДатаНачалаПодразделения = Константы.ДатаНачалаВеденияВБУУчетаОСВРазрезеПодразделений.СоздатьМенеджерЗначения();
	
	// изменение значения константы
	Если ВестиАналитическийУчетОС = 0 Тогда
		
		МенеджерЗаписиДатаНачалаПодразделения.Значение = ДатаНачала;
		Попытка
			МенеджерЗаписиДатаНачалаПодразделения.Записать();
		Исключение
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Не удалось изменить значение константы ""Дата начала ведения учета ОС по подразделениям"": '") + ОписаниеОшибки());
			ОтменитьТранзакцию();
			Возврат Ложь;
		КонецПопытки;
		
	ИначеЕсли ВестиАналитическийУчетОС = 1 Тогда
		
		МенеджерЗаписиДатаНачалаМОЛ.Значение = ДатаНачала;
		Попытка
			МенеджерЗаписиДатаНачалаМОЛ.Записать();
		Исключение
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Не удалось изменить значение константы ""Дата начала ведения учета ОС по МОЛ"": '") + ОписаниеОшибки());
			ОтменитьТранзакцию();
			Возврат Ложь;
		КонецПопытки;
		
	ИначеЕсли ВестиАналитическийУчетОС = 2 Тогда
			МенеджерЗаписиДатаНачалаПодразделения.Значение = ДатаНачала;
			МенеджерЗаписиДатаНачалаМОЛ.Значение = ДатаНачала;
			
		Попытка
			МенеджерЗаписиДатаНачалаПодразделения.Записать();
			МенеджерЗаписиДатаНачалаМОЛ.Записать();
		Исключение
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Не удалось изменить значение константы ""Дата начала ведения учета ОС по подразделениям"", ""Дата начала ведения учета ОС по МОЛ"": '") + ОписаниеОшибки());
			ОтменитьТранзакцию();
			Возврат Ложь;
		КонецПопытки;
		
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ПрименитьПараметрыСубконтоМОЛ(ИмяСчета, ИмяПланаСчетов, ВестиПоМОЛ, ОбработкаПодчиненных = Истина)

	ВидСубконто = "ВидыСубконтоТиповые";
	
	ШаблонСообщения = НСтр("ru = 'План счетов ""%1"", счет ""%2"": %3'");
	
	Попытка
		
		Счет  = ПланыСчетов[ИмяПланаСчетов][ИмяСчета];
		Счета = Новый СписокЗначений();
		Счета.Добавить(Счет);
		
		Если ОбработкаПодчиненных Тогда
			
			ВыборкаСчетов = ПланыСчетов[ИмяПланаСчетов].ВыбратьИерархически(Счет);
			Пока ВыборкаСчетов.Следующий() Цикл
				
				Счета.Добавить(ВыборкаСчетов.Ссылка);
				
			КонецЦикла;
			
		КонецЕсли;
		
		Для Каждого Счет Из Счета Цикл
			
			СчетОбъект   = Счет.Значение.ПолучитьОбъект();
			КодСчета = СчетОбъект.Код;
			
			Сообщение = "";
			
			Субконто = СчетОбъект.ВидыСубконто.Найти(ПланыВидовХарактеристик[ВидСубконто].РаботникиОрганизаций, "ВидСубконто");
			
			Если ВестиПоМОЛ = Истина Тогда // Добавляем 
				
				Если Субконто = Неопределено Тогда
					
					НовыйВид = СчетОбъект.ВидыСубконто.Добавить();
					
					НовыйВид.ВидСубконто = ПланыВидовХарактеристик[ВидСубконто].РаботникиОрганизаций;
					
					НовыйВид.Количественный = Истина;
					НовыйВид.Суммовой = Истина;
					НовыйВид.Валютный = Истина;
					НовыйВид.ТолькоОбороты = Ложь;
					
					Сообщение = Сообщение + НСтр("ru = 'установлено субконто ""Работники организации"",'");
					
				КонецЕсли;
				
			ИначеЕсли ВестиПоМОЛ = Ложь Тогда // Удаляем
				
				Если Субконто <> Неопределено Тогда
					СчетОбъект.ВидыСубконто.Удалить(Субконто);
					Сообщение = Сообщение + НСтр("ru = 'удалено субконто ""Работники организации"",'");
				КонецЕсли;
				
			КонецЕсли;
			
			Если Сообщение <> "" Тогда
				Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонСообщения, ИмяПланаСчетов, Строка(СчетОбъект), Сообщение);
				
				Если Прав(Сообщение, 1) = "," Тогда
					Сообщение = Лев(Сообщение, СтрДлина(Сообщение)-1);
				КонецЕсли;
				
				ОбщегоНазначения.СообщитьПользователю(Сообщение);
			КонецЕсли; 
			
			СчетОбъект.Записать();
			
		КонецЦикла;
		
	Исключение
		
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, ИмяПланаСчетов, Строка(КодСчета), ОписаниеОшибки());
		
		ОбщегоНазначения.СообщитьПользователю(Сообщение);
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьПараметрыСубконтоПодразделения(ИмяСчета, ИмяПланаСчетов, ВестиПоПодразделениям, ОбработкаПодчиненных = Истина, ТолькоОбороты = Истина)

	ВидСубконто = "ВидыСубконтоТиповые";
	
	ШаблонСообщения = НСтр("ru = 'План счетов ""%1"", счет ""%2"": %3'");
	
	Попытка
		
		Счет  = ПланыСчетов[ИмяПланаСчетов][ИмяСчета];
		Счета = Новый СписокЗначений();
		Счета.Добавить(Счет);
		
		Если ОбработкаПодчиненных Тогда
			
			ВыборкаСчетов = ПланыСчетов[ИмяПланаСчетов].ВыбратьИерархически(Счет);
			Пока ВыборкаСчетов.Следующий() Цикл
				
				Счета.Добавить(ВыборкаСчетов.Ссылка);
				
			КонецЦикла;
			
		КонецЕсли;
		
		Для Каждого Счет Из Счета Цикл
			
			СчетОбъект = Счет.Значение.ПолучитьОбъект();
			КодСчета   = СчетОбъект.Код;
			
			Сообщение  = "";
			
			Субконто = СчетОбъект.ВидыСубконто.Найти(ПланыВидовХарактеристик[ВидСубконто].Подразделения, "ВидСубконто");
			
			Если ВестиПоПодразделениям = Истина Тогда // Добавляем 
				
				Если Субконто = Неопределено Тогда
					
					НовыйВид = СчетОбъект.ВидыСубконто.Добавить();
					
					НовыйВид.ВидСубконто = ПланыВидовХарактеристик[ВидСубконто].Подразделения;
					
					НовыйВид.Количественный = Истина;
					НовыйВид.Суммовой = Истина;
					НовыйВид.Валютный = Истина;
					НовыйВид.ТолькоОбороты = ТолькоОбороты;
					
					Сообщение = Сообщение + НСтр("ru = 'установлено субконто ""Подразделения"",'");
					
				КонецЕсли;
				
			ИначеЕсли ВестиПоПодразделениям = Ложь Тогда // Удаляем
				
				Если Субконто <> Неопределено Тогда
					СчетОбъект.ВидыСубконто.Удалить(Субконто);
					Сообщение = Сообщение + НСтр("ru = 'удалено субконто ""Подразделения"",'");
				КонецЕсли;
				
			КонецЕсли;
			
			Если Сообщение <> "" Тогда
				Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонСообщения, ИмяПланаСчетов, Строка(СчетОбъект), Сообщение);
				
				Если Прав(Сообщение, 1) = "," Тогда
					Сообщение = Лев(Сообщение, СтрДлина(Сообщение)-1);
				КонецЕсли;
				
				ОбщегоНазначения.СообщитьПользователю(Сообщение);
			КонецЕсли; 
			
			СчетОбъект.Записать();
			
		КонецЦикла;
		
	Исключение
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, ИмяПланаСчетов, Строка(КодСчета), ОписаниеОшибки());
		
		ОбщегоНазначения.СообщитьПользователю(Сообщение);
	КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДокументовПеремещенияОС();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПеремещениеОС.Ссылка
		|ИЗ
		|	Документ.ПеремещениеОС КАК ПеремещениеОС
		|ГДЕ
		|	НАЧАЛОПЕРИОДА(ПеремещениеОС.Дата, ДЕНЬ) = &Дата
		|	И ПеремещениеОС.Организация = &Организация
		|	И ПеремещениеОС.НачальноеЗаполнениеАналитикиНаСчетахУчетаОС = ИСТИНА
		|	И ПеремещениеОС.Проведен = ИСТИНА";

	Запрос.УстановитьПараметр("Дата",        ДатаНачала);
	Запрос.УстановитьПараметр("Организация", Организация);

	СписокДокументовПеремещениеОС.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));;
	
	ТекстПредупреждения = НСтр("ru = 'На %1 существуют проведенные документы ""Перемещение ОС"" по начальному заполнению аналитики на счетах учета ОС! Необходимо проверить заполнение и перепровести их.
		                             |
					                 |Заполнение значений начальной аналитики на одну дату рекомендуется осуществлять одним документом.'");

	Элементы.ГруппаПредупреждение.Видимость = СписокДокументовПеремещениеОС.Количество() <> 0;
	Элементы.ДекорацияПредупреждение.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, Формат(ДатаНачала, "ДЛФ=Д"));
	
КонецПроцедуры
