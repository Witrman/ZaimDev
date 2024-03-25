﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ТекстОбращения", ТекстОбращения) Тогда
		Элементы.ТекстОбращения.Видимость = Ложь;
		Элементы.ТекстОбращенияНадпись.Видимость = Ложь;
		Элементы.ТекстОбращенияНадписьНеизвестнаяОшибка.Видимость = Истина;
	КонецЕсли;
	
	Параметры.Свойство("КонтекстДиагностики", КонтекстДиагностики);
	Параметры.Свойство("АдресФайлаДляТехПоддержки", АдресФайлаДляТехПоддержки);
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВызовОнлайнПоддержки") Тогда
		Элементы.Группа1СКоннект.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбработкаНеисправностейБЭДКлиент.ЗаполнитьДанныеСлужбыПоддержки(ТелефонСлужбыПоддержки,
		АдресЭлектроннойПочтыСлужбыПоддержки);
	Элементы.Техподдержка.Заголовок =
		ОбработкаНеисправностейБЭДКлиент.СформироватьГиперссылкуДляОбращенияВСлужбуПоддержки(
			НСтр("ru = 'Вопросы и ответы'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресЭлектроннойПочтыСлужбыПоддержкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("mailto://" + АдресЭлектроннойПочтыСлужбыПоддержки);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстОбращенияНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияБЭДКлиент.СкопироватьВБуферОбмена(ТекстОбращения, 
		НСтр("ru = 'Текст обращения скопирован в буфер обмена'"));
	
КонецПроцедуры

&НаКлиенте
Процедура АрхивСТехИнформациейНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохранения.Диалог.Фильтр = НСтр("ru = 'Архивы zip(*.zip)|*.zip'");
	ФайловаяСистемаКлиент.СохранитьФайл(Неопределено, АдресФайлаДляТехПоддержки, НСтр("ru = 'Отчет об ошибках.zip'"),
		ПараметрыСохранения);
	
КонецПроцедуры

#КонецОбласти
