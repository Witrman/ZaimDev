﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуДанныеЭЦП();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьТаблицуДанныеЭЦПСеансовымиДанными();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КлючИмяНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбработкаВыбораКлючаЗавершение = Новый ОписаниеОповещения("ОбработкаВыбораКлючаЗавершение", ЭтаФорма);
	НачатьПомещениеФайла(ОбработкаВыбораКлючаЗавершение,,,, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораКлючаЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		
		ИнформацияПоФайлу = ЭТДКлиент.ИнформацияПоФайлу(ВыбранноеИмяФайла);
		
		Если ВРег(ИнформацияПоФайлу.Расширение) <> ".P12" Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Файл должен иметь расширение ""*.p12"".'"));
			Возврат;
		КонецЕсли;
		
		Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
			СтрокаДанных.КлючИмя = ИнформацияПоФайлу.Имя;
			СтрокаДанных.КлючПолноеИмя = ВыбранноеИмяФайла;
			СтрокаДанных.КлючBase64 = КлючBase64(Адрес);
			
			КлючИмя = ИнформацияПоФайлу.Имя;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьНаВремяСеансаПриИзменении(Элемент)
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
		СтрокаДанных.ЗапомнитьНаВремяСеанса = ЗапомнитьНаВремяСеанса;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
		СтрокаДанных.Пароль = Пароль;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СчетчикСтруктурныхЕдиниц = 0;
	
	ЕстьОшибки = Ложь;
	
	СоответствиеОрганизацийИНастроек = Новый Соответствие;
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
		
		СтруктурнаяЕдиницаТекст = "(" + Строка(СтрокаДанных.СтруктурнаяЕдиница) + ")";
		
		Если ПустаяСтрока(СтрокаДанных.КлючBase64) Тогда
			ТекстСообщения = НСтр("ru = 'Выберите файл сертификата %1'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", СтруктурнаяЕдиницаТекст);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "КлючИмя");
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		Если ПустаяСтрока(СтрокаДанных.Пароль) Тогда
			ТекстСообщения = НСтр("ru = 'Укажите пароль сертификата %1'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", СтруктурнаяЕдиницаТекст);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Пароль");
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		СчетчикСтруктурныхЕдиниц = СчетчикСтруктурныхЕдиниц + 1;
		
	КонецЦикла;
	
	Если ЕстьОшибки Тогда
		
		Возврат;
		
	Иначе
		
		Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
			
			Результат = Новый Структура;
			
			Результат.Вставить("Пароль", СтрокаДанных.Пароль);
			Результат.Вставить("КлючBase64", СтрокаДанных.КлючBase64);
			
			СоответствиеОрганизацийИНастроек.Вставить(СтрокаДанных.СтруктурнаяЕдиница, Результат);
			
		КонецЦикла;
		
		// Запомнить введенные данные.
		СохранитьРасположениеКлючевогоКонтейнера();
		ЗапомнитьПарольКлючевогоКонтейнераНаВремяСеанса();
		ЗапомнитьКлючBase64НаВремяСеанса();
		
		Закрыть(СоответствиеОрганизацийИНастроек);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуДанныеЭЦП()
	
	Если Параметры.Свойство("СтруктурнаяЕдиница") Тогда
		СтрокаДанных = ДанныеЭЦП.Добавить();
		СтрокаДанных.СтруктурнаяЕдиница = Параметры.СтруктурнаяЕдиница;
		
		КлючПолноеИмя = СохраненноеРасположениеКлючевогоКонтейнера(Параметры.СтруктурнаяЕдиница);
		Если ЗначениеЗаполнено(КлючПолноеИмя) Тогда
			СтрокаДанных.КлючПолноеИмя = КлючПолноеИмя;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуДанныеЭЦПСеансовымиДанными()
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
		
		ДанныеКлюча = КлючBase64ЗапомненныйНаВремяСеанса(СтрокаДанных.СтруктурнаяЕдиница);
		СтрокаДанных.КлючИмя = ДанныеКлюча.КлючИмя;
		СтрокаДанных.КлючBase64 = ДанныеКлюча.КлючBase64;
		
		СтрокаДанных.Пароль = ПарольКлючевогоКонтейнераЗапомненныйНаВремяСеанса(СтрокаДанных.КлючИмя);
		
		Если НЕ ПустаяСтрока(СтрокаДанных.Пароль) Тогда
			СтрокаДанных.ЗапомнитьНаВремяСеанса = Истина;
			
			ЗапомнитьНаВремяСеанса = Истина;
		КонецЕсли;
		
	КонецЦикла
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КлючBase64(Адрес)
	
	КлючДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	КлючBase64 = Base64Строка(КлючДвоичныеДанные);
	
	Возврат КлючBase64;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сохранение и загрузка расположения ключевого контейнера

&НаСервере
Процедура СохранитьРасположениеКлючевогоКонтейнера()
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
	
		СоответствиеРасположений = ХранилищеОбщихНастроек.Загрузить(ИмяНастройкиРасположенияКлючевыхКонтейнеров());
		СоответствиеРасположений = ?(СоответствиеРасположений = Неопределено, Новый Соответствие(), СоответствиеРасположений); 
		
		СоответствиеРасположений.Вставить(СтрокаДанных.СтруктурнаяЕдиница, СтрокаДанных.КлючПолноеИмя);
		
		ХранилищеОбщихНастроек.Сохранить(ИмяНастройкиРасположенияКлючевыхКонтейнеров(), , СоответствиеРасположений);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СохраненноеРасположениеКлючевогоКонтейнера(Знач Организация)
	
	СоответствиеРасположений = ХранилищеОбщихНастроек.Загрузить(ИмяНастройкиРасположенияКлючевыхКонтейнеров());
	
	Если СоответствиеРасположений <> Неопределено Тогда
		Расположение = СоответствиеРасположений.Получить(Организация);
	КонецЕсли;
	
	Расположение = ?(Расположение = Неопределено, "", Расположение);
	
	Возврат Расположение;
	
КонецФункции

&НаСервере
Функция ИмяНастройкиРасположенияКлючевыхКонтейнеров()
	
	Возврат "РасположенияКлючевыхКонтейнеровДляЭТД";
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Сохранение и загрузка пароля ключевого контейнера.

&НаКлиенте
Процедура ЗапомнитьПарольКлючевогоКонтейнераНаВремяСеанса()
	
	ИмяСеансовыхДанных = ЭТДКлиент.ИмяСеансовыхДанныхПарольКлючевогоКонтейнераЭЦП();
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
		
		Если СтрокаДанных.ЗапомнитьНаВремяСеанса Тогда
			ЭТДКлиент.СохранитьСеансовыеДанные(ИмяСеансовыхДанных, СтрокаДанных.КлючИмя, СтрокаДанных.Пароль);
		Иначе
			ЭТДКлиент.УдалитьСеансовыеДанные(ИмяСеансовыхДанных, СтрокаДанных.КлючИмя);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПарольКлючевогоКонтейнераЗапомненныйНаВремяСеанса(Знач КлючИмя)
	
	ИмяСеансовыхДанных = ЭТДКлиент.ИмяСеансовыхДанныхПарольКлючевогоКонтейнераЭЦП();
	
	Пароль = ЭТДКлиент.ПолучитьСеансовыеДанные(ИмяСеансовыхДанных, КлючИмя, "");
	
	Возврат Пароль;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Сохранение и загрузка ключевого контейнера в формате Base64.
// Ключевой контейнер сохраняется в переменной сеанса пользователя.

&НаКлиенте
Процедура ЗапомнитьКлючBase64НаВремяСеанса()
	
	ИмяСеансовыхДанных = ЭТДКлиент.ИмяСеансовыхДанныхКлючBase64();
	
	Для Каждого СтрокаДанных Из ДанныеЭЦП Цикл
		
		ДанныеКлюча = Новый Структура;
		ДанныеКлюча.Вставить("КлючИмя", СтрокаДанных.КлючИмя);
		ДанныеКлюча.Вставить("КлючBase64", СтрокаДанных.КлючBase64);
		
		Если СтрокаДанных.ЗапомнитьНаВремяСеанса Тогда
			ЭТДКлиент.СохранитьСеансовыеДанные(ИмяСеансовыхДанных, СтрокаДанных.СтруктурнаяЕдиница, ДанныеКлюча); 
		Иначе
			ЭТДКлиент.УдалитьСеансовыеДанные(ИмяСеансовыхДанных, СтрокаДанных.СтруктурнаяЕдиница);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция КлючBase64ЗапомненныйНаВремяСеанса(Знач Организация)
	
	ИмяСеансовыхДанных = ЭТДКлиент.ИмяСеансовыхДанныхКлючBase64();
	
	ПустыеДанныеКлюча = Новый Структура;
	ПустыеДанныеКлюча.Вставить("КлючИмя", НСтр("ru = 'Выбрать сертификат...'"));
	ПустыеДанныеКлюча.Вставить("КлючBase64", "");
	
	ДанныеКлюча = ЭТДКлиент.ПолучитьСеансовыеДанные(ИмяСеансовыхДанных, Организация, ПустыеДанныеКлюча);
	
	КлючИмя = ДанныеКлюча.КлючИмя;
	
	Возврат ДанныеКлюча;
	
КонецФункции

#КонецОбласти
