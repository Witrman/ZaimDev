﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования
Функция ЛичныеСертификаты(СвойстваСертификатовНаКлиенте, Отбор, Ошибка = "") Экспорт
	
	ТаблицаСвойствСертификатов = Новый ТаблицаЗначений;
	ТаблицаСвойствСертификатов.Колонки.Добавить("Отпечаток", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(255)));
	ТаблицаСвойствСертификатов.Колонки.Добавить("КемВыдан");
	ТаблицаСвойствСертификатов.Колонки.Добавить("Представление");
	ТаблицаСвойствСертификатов.Колонки.Добавить("НаКлиенте",        Новый ОписаниеТипов("Булево"));
	ТаблицаСвойствСертификатов.Колонки.Добавить("НаСервере",        Новый ОписаниеТипов("Булево"));
	ТаблицаСвойствСертификатов.Колонки.Добавить("ЭтоЗаявление",     Новый ОписаниеТипов("Булево"));
	ТаблицаСвойствСертификатов.Колонки.Добавить("ВОблачномСервисе", Новый ОписаниеТипов("Булево"));
	ТаблицаСвойствСертификатов.Колонки.Добавить("ТипРазмещения",	Новый ОписаниеТипов("Число"));
	
	Для Каждого СвойстваСертификата Из СвойстваСертификатовНаКлиенте Цикл
		НоваяСтрока = ТаблицаСвойствСертификатов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СвойстваСертификата);
		НоваяСтрока.НаКлиенте = Истина;
	КонецЦикла;
	
	ТаблицаСвойствСертификатов.Индексы.Добавить("Отпечаток");
	
	Если ЭлектроннаяПодпись.СоздаватьЭлектронныеПодписиНаСервере() Тогда
		
		ПараметрыСоздания = ЭлектроннаяПодписьСлужебный.ПараметрыСозданияМенеджераКриптографии();
		МенеджерКриптографии = ЭлектроннаяПодписьСлужебный.МенеджерКриптографии("ПолучениеСертификатов", ПараметрыСоздания);
		
		Ошибка = ПараметрыСоздания.ОписаниеОшибки;
		Если МенеджерКриптографии <> Неопределено Тогда
			МассивСертификатов = МенеджерКриптографии.ПолучитьХранилищеСертификатов(
				ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты).ПолучитьВсе();
			ЭлектроннаяПодписьСлужебныйКлиентСервер.ДобавитьСвойстваСертификатов(ТаблицаСвойствСертификатов, МассивСертификатов, Истина,
				ЭлектроннаяПодписьСлужебный.ДобавкаВремени(), ТекущаяДатаСеанса());
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭлектроннаяПодписьСлужебный.ИспользоватьЭлектроннуюПодписьВМоделиСервиса() Тогда
		
		МодульХранилищеСертификатов = ОбщегоНазначения.ОбщийМодуль("ХранилищеСертификатов");
		МассивСертификатов = МодульХранилищеСертификатов.Получить("ПерсональныеСертификаты");
		
		ПараметрыДобавленияСвойств = Новый Структура("ВОблачномСервисе", Истина);
		ЭлектроннаяПодписьСлужебныйКлиентСервер.ДобавитьСвойстваСертификатов(ТаблицаСвойствСертификатов, МассивСертификатов, Истина,
			ЭлектроннаяПодписьСлужебный.ДобавкаВремени(), ТекущаяДатаСеанса(), ПараметрыДобавленияСвойств);
			
	КонецЕсли;
	
	Если ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи() Тогда
	КонецЕсли;
	
	Возврат ОбработатьЛичныеСертификаты(ТаблицаСвойствСертификатов, Отбор);
	
КонецФункции

// Только для внутреннего использования         
Функция ОбработатьЛичныеСертификаты(ТаблицаСвойствСертификатов, Отбор)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Отпечатки", ТаблицаСвойствСертификатов.Скопировать(, "Отпечаток"));
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Отпечатки.Отпечаток КАК Отпечаток
		|ПОМЕСТИТЬ Отпечатки
		|ИЗ
		|	&Отпечатки КАК Отпечатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Отпечатки.Отпечаток КАК Отпечаток,
		|	Сертификаты.Наименование КАК Наименование,
		|	Сертификаты.Организация КАК Организация,
		|	Сертификаты.Пользователь КАК Пользователь,
		|	Сертификаты.Ссылка КАК Ссылка,
		|	Сертификаты.ДанныеСертификата КАК ДанныеСертификата
		|ПОМЕСТИТЬ ВсеСертификаты
		|ИЗ
		|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК Сертификаты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Отпечатки КАК Отпечатки
		|		ПО Сертификаты.Отпечаток = Отпечатки.Отпечаток
		|ГДЕ
		|	НЕ Сертификаты.Программа = ЗНАЧЕНИЕ(Справочник.ПрограммыЭлектроннойПодписиИШифрования.ПустаяСсылка)
		|	И Сертификаты.Организация = &Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Сертификаты.Отпечаток КАК Отпечаток,
		|	Сертификаты.Наименование КАК Наименование,
		|	Сертификаты.Организация КАК Организация,
		|	Сертификаты.Ссылка КАК Ссылка,
		|	Сертификаты.ДанныеСертификата КАК ДанныеСертификата
		|ИЗ
		|	ВсеСертификаты КАК Сертификаты
		|ГДЕ
		|	Сертификаты.Ссылка В
		|			(ВЫБРАТЬ
		|				ВсеСертификаты.Ссылка КАК Ссылка
		|			ИЗ
		|				ВсеСертификаты КАК ВсеСертификаты
		|			ГДЕ
		|				ВсеСертификаты.Пользователь = &Пользователь
		|		
		|			ОБЪЕДИНИТЬ ВСЕ
		|		
		|			ВЫБРАТЬ
		|				ВсеСертификаты.Ссылка
		|			ИЗ
		|				ВсеСертификаты КАК ВсеСертификаты
		|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Пользователи КАК СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи
		|					ПО
		|						ВсеСертификаты.Ссылка = СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи.Ссылка
		|			ГДЕ
		|				СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи.Пользователь = &Пользователь)";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	
	Если Не Отбор.ТолькоСертификатыСЗаполненнойПрограммой Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "НЕ Сертификаты.Программа = ЗНАЧЕНИЕ(Справочник.ПрограммыЭлектроннойПодписиИШифрования.ПустаяСсылка)", "ИСТИНА");
	КонецЕсли;
	
	Если Отбор.ВключатьСертификатыСПустымПользователем Тогда
		
		Запрос.Текст = Запрос.Текст + "
		|ОБЪЕДИНИТЬ ВСЕ
		|" + 
		"ВЫБРАТЬ
		|	ВсеСертификаты.Отпечаток КАК Отпечаток,
		|	ВсеСертификаты.Наименование КАК Наименование,
		|	ВсеСертификаты.Организация КАК Организация,
		|	ВсеСертификаты.Ссылка КАК Ссылка,
		|	ВсеСертификаты.ДанныеСертификата КАК ДанныеСертификата
		|ИЗ
		|	ВсеСертификаты КАК ВсеСертификаты
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Пользователи КАК СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи
		|		ПО ВсеСертификаты.Ссылка = СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи.Ссылка
		|ГДЕ
		|	ВсеСертификаты.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
		|	И СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи.Ссылка ЕСТЬ NULL";
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отбор.Организация) Тогда
		Запрос.УстановитьПараметр("Организация", Отбор.Организация);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Сертификаты.Организация = &Организация", "ИСТИНА");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивЛичныхСертификатов = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		Строка = ТаблицаСвойствСертификатов.Найти(Выборка.Отпечаток, "Отпечаток");
		Если Строка <> Неопределено Тогда
			СтруктураСертификата = Новый Структура("Ссылка, Наименование, Отпечаток, Данные, Организация");
			ЗаполнитьЗначенияСвойств(СтруктураСертификата, Выборка);
			СтруктураСертификата.Данные = ПоместитьВоВременноеХранилище(Выборка.ДанныеСертификата, Неопределено);
			МассивЛичныхСертификатов.Добавить(СтруктураСертификата);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивЛичныхСертификатов;
	
КонецФункции

// Только для внутреннего использования.
Функция ПроверитьПодпись(АдресИсходныхДанных, АдресПодписи, ОписаниеОшибки) Экспорт
	
	Возврат ЭлектроннаяПодпись.ПроверитьПодпись(Неопределено, АдресИсходныхДанных, АдресПодписи, ОписаниеОшибки);
	
КонецФункции

// Только для внутреннего использования.
Функция ПроверитьСертификат(АдресСертификата, ОписаниеОшибки, НаДату, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = ЭлектроннаяПодписьСлужебный.ДополнительныеПараметрыПроверкиСертификата();
	КонецЕсли;
	
	Результат = ЭлектроннаяПодписьСлужебный.ПроверитьСертификат(Неопределено, АдресСертификата, ОписаниеОшибки, НаДату, ДополнительныеПараметры);
	
	Если Не Результат Или ДополнительныеПараметры.ДляПроверкиПодписи Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДополнительныеПараметры.Предупреждение) Тогда
		
		СсылкаНаСертификат = Неопределено;
		ПользовательОповещен = ПользовательОповещенОСертификате(АдресСертификата, СсылкаНаСертификат);
		
		Если ПользовательОповещен Или СсылкаНаСертификат = Неопределено Тогда
			ДополнительныеПараметры.Предупреждение = Неопределено;
		Иначе
			ДополнительныеПараметры.Вставить("Сертификат", СсылкаНаСертификат);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Только для внутреннего использования.
Функция СсылкаНаСертификат(Отпечаток, АдресСертификата) Экспорт
	
	Если ЗначениеЗаполнено(АдресСертификата) Тогда
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресСертификата);
		Сертификат = Новый СертификатКриптографии(ДвоичныеДанные);
		Отпечаток = Base64Строка(Сертификат.Отпечаток);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Отпечаток", Отпечаток);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сертификаты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК Сертификаты
	|ГДЕ
	|	Сертификаты.Отпечаток = &Отпечаток";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Только для внутреннего использования.
Функция СертификатыПоПорядкуДоКорневого(Сертификаты) Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебный.СертификатыПоПорядкуДоКорневого(Сертификаты);
	
КонецФункции

// Только для внутреннего использования.
Функция ПредставлениеСубъекта(АдресСертификата) Экспорт
	
	ДанныеСертификата = ПолучитьИзВременногоХранилища(АдресСертификата);
	
	СертификатКриптографии = Новый СертификатКриптографии(ДанныеСертификата);
	
	АдресСертификата = ПоместитьВоВременноеХранилище(ДанныеСертификата, АдресСертификата);
	
	Возврат ЭлектроннаяПодпись.ПредставлениеСубъекта(СертификатКриптографии);
	
КонецФункции

// Только для внутреннего использования.
Функция ВыполнитьНаСторонеСервера(Знач Параметры, АдресРезультата, ОперацияНачалась, ОшибкаНаСервере) Экспорт
	
	ПараметрыСоздания = ЭлектроннаяПодписьСлужебный.ПараметрыСозданияМенеджераКриптографии();
	ПараметрыСоздания.Программа = Параметры.СертификатПрограмма;
	ПараметрыСоздания.ОписаниеОшибки = Новый Структура;
	
	МенеджерКриптографии = ЭлектроннаяПодписьСлужебный.МенеджерКриптографии(Параметры.Операция, ПараметрыСоздания);
	
	ОшибкаНаСервере = ПараметрыСоздания.ОписаниеОшибки;
	Если МенеджерКриптографии = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Если личный сертификат шифрования не используется, тогда его не нужно искать.
	Если Параметры.Операция <> "Шифрование"
	 Или ЗначениеЗаполнено(Параметры.СертификатОтпечаток) Тогда
		
		СертификатКриптографии = ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку(
			Параметры.СертификатОтпечаток, Истина, Ложь, Параметры.СертификатПрограмма, ОшибкаНаСервере);
		
		Если СертификатКриптографии = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		Данные = ПолучитьИзВременногоХранилища(Параметры.ЭлементДанныхДляСервера.Данные);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ОшибкаНаСервере.Вставить("ОписаниеОшибки",
			ЭлектроннаяПодписьСлужебныйКлиентСервер.ЗаголовокОшибкиПолученияДанных(Параметры.Операция)
			+ Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Возврат Ложь;
	КонецПопытки;
	
	ЭтоXMLDSig = (ТипЗнч(Данные) = Тип("Структура")
	            И Данные.Свойство("ПараметрыXMLDSig"));
	
	Если ЭтоXMLDSig И Не Данные.Свойство("КонвертXML") Тогда
		Данные = Новый Структура(Новый ФиксированнаяСтруктура(Данные));
		Данные.Вставить("КонвертXML", Данные.КонвертSOAP);
	КонецЕсли;
	
	ЭтоCMS = (ТипЗнч(Данные) = Тип("Структура")
	            И Данные.Свойство("ПараметрыCMS"));
	
	Если ЭтоXMLDSig Тогда
		
		Если Параметры.Операция <> "Подписание" Тогда
			ОшибкаНаСервере.Вставить("ОписаниеОшибки", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Внешняя компонента %1 может использоваться только для подписания.'"), "ExtraCryptoAPI"));
			Возврат Ложь;
		КонецЕсли;
		
		МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = Параметры.ЗначениеПароля;
		Попытка
			ДвоичныеДанныеРезультата = ЭлектроннаяПодписьСлужебный.Подписать(
				Данные.КонвертXML,
				Данные.ПараметрыXMLDSig,
				СертификатКриптографии,
				МенеджерКриптографии);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
		КонецПопытки;
		
	ИначеЕсли ЭтоCMS Тогда
		
		Если Параметры.Операция <> "Подписание" Тогда
			ОшибкаНаСервере.Вставить("ОписаниеОшибки", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Внешняя компонента %1 может использоваться только для подписания.'"), "ExtraCryptoAPI"));
			Возврат Ложь;
		КонецЕсли;
		
		МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = Параметры.ЗначениеПароля;
		Попытка
			ДвоичныеДанныеРезультата = ЭлектроннаяПодписьСлужебный.ПодписатьCMS(
				Данные.Данные,
				Данные.ПараметрыCMS,
				СертификатКриптографии,
				МенеджерКриптографии);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
		КонецПопытки;
	
	Иначе
		
		ОписаниеОшибки = "";
		Если Параметры.Операция = "Подписание" Тогда
			МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = Параметры.ЗначениеПароля;
			Попытка
				Если ЭлектроннаяПодпись.ДоступнаУсовершенствованнаяПодпись() Тогда
					НастройкиПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.НастройкиСозданияПодписи(Параметры.ТипПодписи,
						ЭлектроннаяПодпись.ОбщиеНастройки().АдресаСерверовМетокВремени);
					Если ЗначениеЗаполнено(НастройкиПодписи.АдресаСерверовМетокВремени) Тогда
						МенеджерКриптографии.АдресаСерверовМетокВремени = НастройкиПодписи.АдресаСерверовМетокВремени;
					КонецЕсли;
					ДвоичныеДанныеРезультата = МенеджерКриптографии.Подписать(Данные, СертификатКриптографии,
						НастройкиПодписи.ТипПодписи);
				Иначе
					ДвоичныеДанныеРезультата = МенеджерКриптографии.Подписать(Данные, СертификатКриптографии);
				КонецЕсли;
				ЭлектроннаяПодписьСлужебныйКлиентСервер.ПустыеДанныеПодписи(ДвоичныеДанныеРезультата, ОписаниеОшибки);
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
			КонецПопытки;
		ИначеЕсли Параметры.Операция = "Шифрование" Тогда
			Сертификаты = СертификатыКриптографии(Параметры.АдресСертификатов);
			Попытка
				ДвоичныеДанныеРезультата = МенеджерКриптографии.Зашифровать(Данные, Сертификаты);
				ЭлектроннаяПодписьСлужебныйКлиентСервер.ПустыеЗашифрованныеДанные(ДвоичныеДанныеРезультата, ОписаниеОшибки);
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
			КонецПопытки;
		Иначе // Расшифровка.
			МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = Параметры.ЗначениеПароля;
			Попытка
				ДвоичныеДанныеРезультата = МенеджерКриптографии.Расшифровать(Данные);
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
			КонецПопытки;
		КонецЕсли;
	
	КонецЕсли;
	
	Если ИнформацияОбОшибке <> Неопределено Тогда
		ОшибкаНаСервере.Вставить("ОписаниеОшибки", КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		ОшибкаНаСервере.Вставить("Инструкция", Истина);
		Возврат Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ОшибкаНаСервере.Вставить("ОписаниеОшибки", ОписаниеОшибки);
		Возврат Ложь;
	КонецЕсли;
	
	ОперацияНачалась = Истина;
	
	Если Параметры.Операция = "Подписание" Тогда
		
		СвойстваСертификата = ЭлектроннаяПодпись.СвойстваСертификата(СертификатКриптографии);
		СвойстваСертификата.Вставить("ДвоичныеДанные", СертификатКриптографии.Выгрузить());
		
		Если ЭлектроннаяПодпись.ДоступнаУсовершенствованнаяПодпись() Тогда
			Попытка
				КонтейнерПодписи = МенеджерКриптографии.ПолучитьКонтейнерПодписейКриптографии(ДвоичныеДанныеРезультата);
				ПараметрыПодписиКриптографии = ЭлектроннаяПодписьСлужебныйКлиентСервер.ПараметрыПодписиКриптографии(КонтейнерПодписи,
					ЭлектроннаяПодписьСлужебный.ДобавкаВремени(), ТекущаяДатаСеанса());
			Исключение
				ДанныеПодписи = Base64Строка(ДвоичныеДанныеРезультата);
				ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='При чтении данных подписи после подписания: %1
					|Результат подписи: %2'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), ДанныеПодписи);
				ОшибкаНаСервере.Вставить("ОписаниеОшибки", ПредставлениеОшибки);
				ОшибкаНаСервере.Вставить("Инструкция", Истина);
				Возврат Ложь;
			КонецПопытки;
		Иначе
			ПараметрыПодписиКриптографии = Неопределено;
		КонецЕсли;
		
		СвойстваПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.СвойстваПодписи(ДвоичныеДанныеРезультата,
			СвойстваСертификата, Параметры.Комментарий, Пользователи.АвторизованныйПользователь(),,ПараметрыПодписиКриптографии);
			
		Если Параметры.СертификатВерен <> Неопределено Тогда
			СвойстваПодписи.ДатаПодписи = ТекущаяДатаСеанса();
			СвойстваПодписи.ДатаПроверкиПодписи = СвойстваПодписи.ДатаПодписи;
			СвойстваПодписи.ПодписьВерна = Параметры.СертификатВерен;
		КонецЕсли;
		
		АдресРезультата = ПоместитьВоВременноеХранилище(СвойстваПодписи, Параметры.ИдентификаторФормы);
		
		Если Параметры.ЭлементДанныхДляСервера.Свойство("Объект") Тогда
			ВерсияОбъекта = Неопределено;
			Параметры.ЭлементДанныхДляСервера.Свойство("ВерсияОбъекта", ВерсияОбъекта);
			ПредставлениеОшибки = ДобавитьПодпись(Параметры.ЭлементДанныхДляСервера.Объект,
				СвойстваПодписи, Параметры.ИдентификаторФормы, ВерсияОбъекта);
			Если ЗначениеЗаполнено(ПредставлениеОшибки) Тогда
				ОшибкаНаСервере.Вставить("ОписаниеОшибки", ПредставлениеОшибки);
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
	Иначе
		АдресРезультата = ПоместитьВоВременноеХранилище(ДвоичныеДанныеРезультата, Параметры.ИдентификаторФормы);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Только для внутреннего использования.
Функция НачатьУсовершенствованиеНаСервере(Знач Параметры) Экспорт
	
	Подпись = Параметры.ЭлементДанныхДляСервера.Подпись;
	Если ТипЗнч(Параметры.ЭлементДанныхДляСервера.Подпись) = Тип("Строка") Тогда
		Попытка
			Подпись = ПолучитьИзВременногоХранилища(Подпись);
		Исключение
			Результат = Новый Структура;
			Результат.Вставить("Успех", Ложь);
			Результат.Вставить("ТекстОшибки", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Результат.Вставить("ОшибкаПриСозданииМенеджераКриптографии", Ложь);
			Возврат Результат;
		КонецПопытки;
	КонецЕсли;
	
	Параметры.ЭлементДанныхДляСервера.Подпись = Подпись;
	Параметры.Вставить("СлужебнаяУчетнаяЗаписьDSSАдрес", Параметры.СлужебнаяУчетнаяЗаписьDSS);
	Параметры.СлужебнаяУчетнаяЗаписьDSS = ПолучитьИзВременногоХранилища(Параметры.СлужебнаяУчетнаяЗаписьDSS);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Параметры.ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Усовершенствование подписи'");
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "ЭлектроннаяПодписьСлужебный.УсовершенствоватьНаСторонеСервера", Параметры);

КонецФункции

// Только для внутреннего использования.
Функция УсовершенствоватьНаСторонеСервера(Параметры) Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебный.УсовершенствоватьНаСторонеСервера(Параметры);
	
КонецФункции

// Только для внутреннего использования.
Функция НастройкиСлужебнойУчетнойЗаписиДляУсовершенствованияПодписей(ИдентификаторФормы = Неопределено) Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебный.НастройкиСлужебнойУчетнойЗаписиДляУсовершенствованияПодписей(ИдентификаторФормы);
	
КонецФункции

// Только для внутреннего использования.
Функция ПользовательОповещенОСертификате(Сертификат, СсылкаНаСертификат) Экспорт
	
	Если ТипЗнч(Сертификат) = Тип("ДвоичныеДанные") Тогда
		СсылкаНаСертификат = СсылкаНаСертификат(Base64Строка(Сертификат), Неопределено);
	ИначеЕсли ТипЗнч(Сертификат) = Тип("Строка") Тогда
		СсылкаНаСертификат = СсылкаНаСертификат(Неопределено, Сертификат);
	Иначе
		СсылкаНаСертификат = Сертификат;
	КонецЕсли;
	
	Если СсылкаНаСертификат = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат РегистрыСведений.ОповещенияПользователейСертификатов.ПользовательОповещен(СсылкаНаСертификат);
	
КонецФункции

// См. ЭлектроннаяПодписьСлужебный.СвойстваКонвертаXML
Функция СвойстваКонвертаXML(Знач КонвертXML, Знач ПараметрыXMLDSig, Знач ПроверкаПодписи) Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебный.СвойстваКонвертаXML(КонвертXML, ПараметрыXMLDSig, ПроверкаПодписи);
	
КонецФункции

// Только для внутреннего использования.
Функция ДобавитьПодпись(СсылкаНаОбъект, СвойстваПодписи, ИдентификаторФормы, ВерсияОбъекта) Экспорт
	
	ЭлементДанных = Новый Структура;
	ЭлементДанных.Вставить("СвойстваПодписи",     СвойстваПодписи);
	ЭлементДанных.Вставить("ПредставлениеДанных", СсылкаНаОбъект);
	
	ЭлектроннаяПодписьСлужебный.ЗарегистрироватьПодписаниеДанныхВЖурнале(ЭлементДанных);
	
	ПредставлениеОшибки = "";
	Попытка
		ЭлектроннаяПодпись.ДобавитьПодпись(СсылкаНаОбъект, СвойстваПодписи, ИдентификаторФормы, ВерсияОбъекта);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПредставлениеОшибки = НСтр("ru = 'При записи подписи возникла ошибка:'")
			+ Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	КонецПопытки;
	
	Возврат ПредставлениеОшибки;
	
КонецФункции

// Только для внутреннего использования.
Функция ПреобразоватьПодписиВМассив(Подписи, ИдентификаторФормы) Экспорт
	
	Массив = Новый Массив; 
	Для Каждого ТекущийЭлемент Из Подписи Цикл
		УстановленныеПодписи = ЭлектроннаяПодпись.УстановленныеПодписи(
			ТекущийЭлемент.ПодписанныйОбъект, ТекущийЭлемент.ПорядковыйНомер);
		Для Каждого ТекущаяПодпись Из УстановленныеПодписи Цикл
			Если Не ТекущаяПодпись.ПодписьВерна Тогда
				Продолжить;
			КонецЕсли;
			Структура = Новый Структура("ПодписанныйОбъект, ПорядковыйНомер, Подпись, ТипПодписи, СрокДействияПоследнейМеткиВремени");
			Структура.ПодписанныйОбъект = ТекущийЭлемент.ПодписанныйОбъект;
			Структура.ПорядковыйНомер = ТекущаяПодпись.ПорядковыйНомер;
			Структура.Подпись = ПоместитьВоВременноеХранилище(ТекущаяПодпись.Подпись, ИдентификаторФормы);
			Массив.Добавить(Структура);
		КонецЦикла;
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

// Только для внутреннего использования.
Процедура ЗарегистрироватьПодписаниеДанныхВЖурнале(ЭлементДанных) Экспорт
	
	ЭлектроннаяПодписьСлужебный.ЗарегистрироватьПодписаниеДанныхВЖурнале(ЭлементДанных);
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ЗарегистрироватьУсовершенствованиеПодписиВЖурнале(СвойстваПодписи) Экспорт
	
	ЭлектроннаяПодписьСлужебный.ЗарегистрироватьУсовершенствованиеПодписиВЖурнале(СвойстваПодписи);
	
КонецПроцедуры

// Только для внутреннего использования.
Функция ОбновитьУсовершенствованнуюПодпись(СвойстваПодписи) Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебный.ОбновитьУсовершенствованнуюПодпись(СвойстваПодписи);
	
КонецФункции

// Для функции ВыполнитьНаСторонеСервера.
Функция СертификатыКриптографии(Знач СвойстваСертификатов)
	
	Если ТипЗнч(СвойстваСертификатов) = Тип("Строка") Тогда
		СвойстваСертификатов = ПолучитьИзВременногоХранилища(СвойстваСертификатов);
	КонецЕсли;
	
	Сертификаты = Новый Массив;
	Для каждого Свойства Из СвойстваСертификатов Цикл
		Сертификаты.Добавить(Новый СертификатКриптографии(Свойства.Сертификат));
	КонецЦикла;
	
	Возврат Сертификаты;
	
КонецФункции

Функция НайтиУстановленныеПрограммы(ОписаниеПрограмм, ПроверятьНаСервере) Экспорт
	
	Если ПроверятьНаСервере = Неопределено Тогда
		ПроверятьНаСервере = ЭлектроннаяПодпись.ПроверятьЭлектронныеПодписиНаСервере()
		                 Или ЭлектроннаяПодпись.СоздаватьЭлектронныеПодписиНаСервере();
	КонецЕсли;
	
	Программы = ЗаполнитьСписокПрограммДляПоиска(ОписаниеПрограмм);
	
	Если Не ПроверятьНаСервере Тогда
		Возврат Программы;
	КонецЕсли;
	
	Для Каждого Программа Из Программы Цикл
		ПараметрыСоздания = ЭлектроннаяПодписьСлужебный.ПараметрыСозданияМенеджераКриптографии();
		ПараметрыСоздания.Программа = Программа;
		ПараметрыСоздания.ОписаниеОшибки = Новый Структура;
		Менеджер = ЭлектроннаяПодписьСлужебный.МенеджерКриптографии("", ПараметрыСоздания);
		Если Менеджер = Неопределено Тогда
			Программа.РезультатПроверкиНаСервере =
				ЭлектроннаяПодписьСлужебныйКлиентСервер.ТекстОшибкиПоискаПрограммы(
					НСтр("ru = 'Не установлена на сервере %1.'"), ПараметрыСоздания.ОписаниеОшибки);
		Иначе
			Программа.РезультатПроверкиНаСервере = "";
			Программа.Установлена = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Программы;
	
КонецФункции

// Для процедуры НайтиУстановленныеПрограммы.
Функция ЗаполнитьСписокПрограммДляПоиска(ОписаниеПрограмм)
	
	ПоставляемыеНастройки = Справочники.ПрограммыЭлектроннойПодписиИШифрования.ПоставляемыеНастройкиПрограмм();
	
	ОбновленныеОписанияПрограмм = Новый Массив;
	
	МассивИсключений = Новый Массив;
	МассивИсключений.Добавить("Установлена");
	МассивИсключений.Добавить("Ссылка");
	МассивИсключений.Добавить("Идентификатор");
	МассивИсключений.Добавить("РезультатПроверкиНаКлиенте");
	МассивИсключений.Добавить("РезультатПроверкиНаСервере");
	
	Для Каждого ОписаниеПрограммы Из ОписаниеПрограмм Цикл
		Отбор = Новый Структура;
		Отбор.Вставить("ИмяПрограммы", ОписаниеПрограммы.ИмяПрограммы);
		Отбор.Вставить("ТипПрограммы", ОписаниеПрограммы.ТипПрограммы);
	
		Строки = ПоставляемыеНастройки.НайтиСтроки(Отбор);
		Если Строки.Количество() = 0 Тогда
			НовоеОписаниеПрограммы = РасширенноеОписаниеПрограммы();
			ЗаполнитьЗначенияСвойств(НовоеОписаниеПрограммы, ОписаниеПрограммы);
			ОбновленныеОписанияПрограмм.Добавить(НовоеОписаниеПрограммы);
		Иначе
			Для Каждого КлючИЗначение Из ОписаниеПрограммы Цикл
				Если МассивИсключений.Найти(КлючИЗначение.Ключ) <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
				Если КлючИЗначение.Значение <> Неопределено Тогда
					Строки[0][КлючИЗначение.Ключ] = КлючИЗначение.Значение;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	ОписанияНастроенныхПрограмм = ЭлектроннаяПодпись.ОбщиеНастройки().ОписанияПрограмм; // Массив из см. ЭлектроннаяПодписьСлужебныйПовтИсп.ОписаниеПрограммы
	
	Для Каждого ПоставляемаяПрограмма Из ПоставляемыеНастройки Цикл
		ОписаниеПрограммы = РасширенноеОписаниеПрограммы();
		ЗаполнитьЗначенияСвойств(ОписаниеПрограммы, ПоставляемаяПрограмма);
		
		Для Каждого ОписаниеНастроеннойПрограммы Из ОписанияНастроенныхПрограмм Цикл
			Если ОписаниеПрограммы.ИмяПрограммы = ОписаниеНастроеннойПрограммы.ИмяПрограммы
			   И ОписаниеПрограммы.ТипПрограммы = ОписаниеНастроеннойПрограммы.ТипПрограммы Тогда
				ОписаниеПрограммы.Ссылка = ОписаниеНастроеннойПрограммы.Ссылка;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		ОбновленныеОписанияПрограмм.Добавить(ОписаниеПрограммы);
	КонецЦикла;
	
	Возврат ОбновленныеОписанияПрограмм;
	
КонецФункции

// Для процедуры НайтиУстановленныеПрограммы.
Функция РасширенноеОписаниеПрограммы()
	
	ОписаниеПрограммы = ЭлектроннаяПодпись.НовоеОписаниеПрограммы();
	ОписаниеПрограммы.Вставить("Ссылка", Неопределено);
	ОписаниеПрограммы.Вставить("Идентификатор", Неопределено);
	ОписаниеПрограммы.Вставить("Установлена", Ложь);
	ОписаниеПрограммы.Вставить("РезультатПроверкиНаКлиенте", "");
	ОписаниеПрограммы.Вставить("РезультатПроверкиНаСервере", Неопределено);
	
	Возврат ОписаниеПрограммы;
	
КонецФункции

Функция ЗаписатьСертификатПослеПроверки(Контекст) Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебный.ЗаписатьСертификатПослеПроверки(Контекст);
	
КонецФункции

Функция ЗаписатьСертификатВСправочник(Знач Сертификат, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ЭлектроннаяПодпись.ЗаписатьСертификатВСправочник(Сертификат, ДополнительныеПараметры);
	
КонецФункции

Функция НастроенСервисОблачнойПодписи() Экспорт
	
	Результат = Ложь;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодписьСервисаDSS") Тогда
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ИзменитьОтметкуОНапоминании(Сертификат, Напомнить, ИдентификаторНапоминания) Экспорт
	
	ЭлектроннаяПодписьСлужебный.ИзменитьОтметкуОНапоминании(Сертификат, Напомнить, ИдентификаторНапоминания);
	
КонецПроцедуры

Функция АккредитованныеУдостоверяющиеЦентры() Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебныйПовтИсп.АккредитованныеУдостоверяющиеЦентры();
	
КонецФункции

#Область ДиагностикаЭлектроннойПодписи

Процедура ДобавитьОписаниеДополнительныхДанных(ДополнительныеДанные, ОписаниеФайлов, Сведения) Экспорт
	
	Текст = "";
	
	Сертификаты = Неопределено;
	ДополнительныеДанные.Свойство("Сертификат", Сертификаты);
	Если ТипЗнч(Сертификаты) = Тип("Массив") Тогда
		Номер = 1;
		Для Каждого Сертификат Из Сертификаты Цикл
			ДобавитьОписаниеСертификата(Сертификат, ОписаниеФайлов, Текст, Номер);
			Номер = Номер + 1;
		КонецЦикла;
	ИначеЕсли Сертификаты <> Неопределено Тогда
		ДобавитьОписаниеСертификата(Сертификаты, ОписаниеФайлов, Текст, 1);
	КонецЕсли;
	
	Подписи = Неопределено;
	ДополнительныеДанные.Свойство("Подпись", Подписи);
	Если ТипЗнч(Подписи) = Тип("Массив") Тогда
		Номер = 1;
		Для Каждого Подпись Из Подписи Цикл
			ДобавитьОписаниеПодписи(Подпись, ОписаниеФайлов, Текст, Номер);
			Номер = Номер + 1;
		КонецЦикла;
	ИначеЕсли Подписи <> Неопределено Тогда
		ДобавитьОписаниеПодписи(Подписи, ОписаниеФайлов, Текст, 1);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Текст) Тогда
		Сведения = Сведения + Текст + Символы.ПС;
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  Сертификат - ДвоичныеДанные
//             - Строка
//  ОписаниеФайлов - Массив
//  Сведения - Строка
//  Номер - Число
//
Процедура ДобавитьОписаниеСертификата(Сертификат, ОписаниеФайлов, Сведения, Номер)
	
	Если ТипЗнч(Сертификат) = Тип("СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Сертификат, "Наименование, Программа, ВводитьПарольВПрограммеЭлектроннойПодписи, ДанныеСертификата");
		
		Если ТипЗнч(ЗначенияРеквизитов.ДанныеСертификата) = Тип("ХранилищеЗначения") Тогда
			ДанныеСертификата = ЗначенияРеквизитов.ДанныеСертификата.Получить();
		Иначе
			ДанныеСертификата = Null;
		КонецЕсли;
		ПредставлениеСертификата = ЗначенияРеквизитов.Наименование;
	Иначе
		Если ТипЗнч(Сертификат) = Тип("Строка") И ЭтоАдресВременногоХранилища(Сертификат) Тогда
			ДанныеСертификата = ПолучитьИзВременногоХранилища(Сертификат);
		Иначе
			ДанныеСертификата = Сертификат;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеСертификата) = Тип("ДвоичныеДанные") Тогда
		Если Не ЗначениеЗаполнено(ПредставлениеСертификата) Тогда
			Попытка
				СертификатКриптографии = Новый СертификатКриптографии(ДанныеСертификата);
				ПредставлениеСертификата = ЭлектроннаяПодпись.ПредставлениеСертификата(СертификатКриптографии);
			Исключение
				ПредставлениеСертификата = "";
			КонецПопытки;
		КонецЕсли;
		Расширение = ".cer";
		АлгоритмПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.АлгоритмПодписиСертификата(
			ДанныеСертификата, Истина);
	Иначе
		Расширение = ".txt";
		XMLДанныеСертификата = XMLСтрока(Новый ХранилищеЗначения(ДанныеСертификата));
		ДанныеСертификата = ПолучитьДвоичныеДанныеИзСтроки(XMLДанныеСертификата, КодировкаТекста.ANSI, Ложь);
		АлгоритмПодписи = "";
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ПредставлениеСертификата) Тогда
		ПредставлениеСертификата = НСтр("ru = 'Сертификат'") + Формат(Номер, "ЧГ=");
	КонецЕсли;
	
	ИмяФайлаСертификата = ЭлектроннаяПодписьСлужебныйКлиентСервер.ПодготовитьСтрокуДляИмениФайла(
		ПредставлениеСертификата) + Расширение;
	
	ОписаниеФайла = Новый Структура;
	ОписаниеФайла.Вставить("Данные", ДанныеСертификата);
	ОписаниеФайла.Вставить("Имя",    ИмяФайлаСертификата);
	
	Сведения = Сведения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Сертификат: ""%1""'"), ИмяФайлаСертификата) + Символы.ПС;
	
	Сведения = Сведения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Символы.Таб + НСтр("ru = 'Алгоритм подписи: %1'"), АлгоритмПодписи) + Символы.ПС;
	
	Если ТипЗнч(Сертификат) = Тип("СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
		Сведения = Сведения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Символы.Таб + НСтр("ru = 'Программа: %1'"), Строка(ЗначенияРеквизитов.Программа)) + Символы.ПС;
		
		Сведения = Сведения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Символы.Таб + НСтр("ru = 'Вводить пароль в программе электронной подписи: %1'"),
			?(ЗначенияРеквизитов.ВводитьПарольВПрограммеЭлектроннойПодписи = Истина, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"))) + Символы.ПС;
	КонецЕсли;
	
	ОписаниеФайлов.Добавить(ОписаниеФайла);
	
КонецПроцедуры

// Параметры:
//  Подпись - ДвоичныеДанные
//          - Строка
//  ОписаниеФайлов - Массив
//  Номер - Число
//
Процедура ДобавитьОписаниеПодписи(Подпись, ОписаниеФайлов, Сведения, Номер)
	
	Если ТипЗнч(Подпись) = Тип("Строка") И ЭтоАдресВременногоХранилища(Подпись) Тогда
		ДанныеПодписи = ПолучитьИзВременногоХранилища(Подпись);
	Иначе
		ДанныеПодписи = Подпись;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеПодписи) = Тип("ДвоичныеДанные") Тогда
		Расширение = ".p7s";
		АлгоритмПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.АлгоритмСформированнойПодписи(
			ДанныеПодписи, Истина);
		АлгоритмХеширования = ЭлектроннаяПодписьСлужебныйКлиентСервер.АлгоритмХеширования(
			ДанныеПодписи, Истина);
	Иначе
		Расширение = ".txt";
		XMLДанныеПодписи = XMLСтрока(Новый ХранилищеЗначения(ДанныеПодписи));
		ДанныеПодписи = ПолучитьДвоичныеДанныеИзСтроки(XMLДанныеПодписи, КодировкаТекста.ANSI, Ложь);
		АлгоритмПодписи = "";
		АлгоритмХеширования = "";
	КонецЕсли;
	
	ИмяФайлаПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.ПодготовитьСтрокуДляИмениФайла(
		НСтр("ru = 'Подпись'") + Формат(Номер, "ЧГ=")) + Расширение;
	
	ОписаниеФайла = Новый Структура;
	ОписаниеФайла.Вставить("Данные", ДанныеПодписи);
	ОписаниеФайла.Вставить("Имя",    ИмяФайлаПодписи);
	
	Сведения = Сведения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Подпись: ""%1""'"), ИмяФайлаПодписи) + Символы.ПС;
	
	Сведения = Сведения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Символы.Таб + НСтр("ru = 'Алгоритм подписи: %1'"), АлгоритмПодписи) + Символы.ПС;
	
	Сведения = Сведения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Символы.Таб + НСтр("ru = 'Алгоритм хеширования: %1'"), АлгоритмХеширования) + Символы.ПС;
	
	ОписаниеФайлов.Добавить(ОписаниеФайла);
	
КонецПроцедуры

// Возвращаемое значение:
//   Массив из Структура:
//   * Ссылка - СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования
//   * Представление - Строка
//
Функция ИспользуемыеПрограммы() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрограммыЭлектроннойПодписиИШифрования.Ссылка КАК Ссылка,
	|	ПрограммыЭлектроннойПодписиИШифрования.Представление КАК Представление,
	|	ПрограммыЭлектроннойПодписиИШифрования.ИмяПрограммы КАК ИмяПрограммы,
	|	ПрограммыЭлектроннойПодписиИШифрования.ТипПрограммы КАК ТипПрограммы,
	|	ПрограммыЭлектроннойПодписиИШифрования.АлгоритмПодписи КАК АлгоритмПодписи,
	|	ПрограммыЭлектроннойПодписиИШифрования.АлгоритмХеширования КАК АлгоритмХеширования,
	|	ПрограммыЭлектроннойПодписиИШифрования.АлгоритмШифрования КАК АлгоритмШифрования
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК ПрограммыЭлектроннойПодписиИШифрования
	|ГДЕ
	|	НЕ ПрограммыЭлектроннойПодписиИШифрования.ПометкаУдаления
	|	И НЕ ПрограммыЭлектроннойПодписиИШифрования.ЭтоВстроенныйКриптопровайдер";
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(Запрос.Выполнить().Выгрузить());
	
КонецФункции

Функция АдресАрхиваТехническойИнформации(Знач СопроводительныйТекст,
			Знач ДополнительныеФайлы, Знач ПроверенныеПутиКМодулямПрограммНаКлиенте) Экспорт
	
	ЭлектроннаяПодписьСлужебный.ДополнитьТехническойИнформациейОСервере(СопроводительныйТекст,
		ПроверенныеПутиКМодулямПрограммНаКлиенте);
	
	АрхивИнформации = Новый ЗаписьZipФайла();
	
	ВременныеФайлы = Новый Массив;
	ВременныеФайлы.Добавить(ПолучитьИмяВременногоФайла("txt"));
	
	ТекстСостояния = Новый ТекстовыйДокумент;
	ТекстСостояния.УстановитьТекст(СопроводительныйТекст);
	
	ВременныйКаталог = ФайловаяСистема.СоздатьВременныйКаталог();
	Если ДополнительныеФайлы <> Неопределено Тогда
		
		Если ТипЗнч(ДополнительныеФайлы) = Тип("Массив") Тогда
			Для Каждого ДополнительныйФайл Из ДополнительныеФайлы Цикл
				ДобавитьФайлВАрхив(АрхивИнформации, ДополнительныйФайл,
					ТекстСостояния, ВременныйКаталог, ВременныеФайлы);
			КонецЦикла;
		Иначе
			ДобавитьФайлВАрхив(АрхивИнформации, ДополнительныеФайлы,
				ТекстСостояния, ВременныйКаталог, ВременныеФайлы);
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстСостояния.Записать(ВременныеФайлы[0]);
	АрхивИнформации.Добавить(ВременныеФайлы[0]);
	
	АдресАрхива = ПоместитьВоВременноеХранилище(АрхивИнформации.ПолучитьДвоичныеДанные(),
		Новый УникальныйИдентификатор);
	
	Для Каждого ВременныйФайл Из ВременныеФайлы Цикл
		ФайловаяСистема.УдалитьВременныйФайл(ВременныйФайл);
	КонецЦикла;
	
	ФайловаяСистема.УдалитьВременныйКаталог(ВременныйКаталог);
	
	Возврат АдресАрхива;
	
КонецФункции

Процедура ДобавитьФайлВАрхив(Архив, ИнформацияОФайле, ТекстСостояния, ВременныйКаталог, ВременныеФайлы)
	
	Разделитель = ПолучитьРазделительПути();
	ВременныйФайл = ВременныйКаталог
		+ ?(СтрЗаканчиваетсяНа(ВременныйКаталог, Разделитель), "", Разделитель)
		+ ИнформацияОФайле.Имя;
	
	Если ТипЗнч(ИнформацияОФайле.Данные) = Тип("Строка") Тогда
		
		Если ЭтоАдресВременногоХранилища(ИнформацияОФайле.Данные) Тогда
			ДанныеФайла = ПолучитьИзВременногоХранилища(ИнформацияОФайле.Данные);
		Иначе
			ТекстСостояния.ДобавитьСтроку(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось добавить %1. Данные файла не являются двоичными данными или адресом во временном хранилище.'"),
				ИнформацияОФайле.Имя));
		КонецЕсли;
		
	Иначе
		ДанныеФайла = ИнформацияОФайле.Данные;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеФайла) = Тип("ДвоичныеДанные") Тогда
		ВременныеФайлы.Добавить(ВременныйФайл);
		ДанныеФайла.Записать(ВременныйФайл);
		Архив.Добавить(ВременныйФайл);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти