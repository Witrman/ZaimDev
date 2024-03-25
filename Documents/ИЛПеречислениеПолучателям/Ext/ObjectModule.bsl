﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
    
    Запрос = Новый Запрос;
    Запрос.УстановитьПараметр("ИсполнительныеЛисты", ЭтотОбъект.ИсполнительныеЛисты.Выгрузить());
    
    Запрос.Текст = 
    "ВЫБРАТЬ *
    |ПОМЕСТИТЬ ВТ_ИсполнительныеЛисты
    |ИЗ 
    |   &ИсполнительныеЛисты КАК ИсполнительныеЛисты
    |
    |;
    |
    |ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
    |	Док.ДокументОснование.СозданПриОбмене КАК ДокументОснованиеСозданПриОбмене
    |ИЗ
    |	Документ.ИЛПеречислениеПолучателям.ИсполнительныеЛисты КАК Док
    |
    |ГДЕ
    |	Док.ДокументОснование В (ВЫБРАТЬ
    |						        ИсполнительныеЛисты.ДокументОснование
    |					         ИЗ
    |						        ВТ_ИсполнительныеЛисты КАК ИсполнительныеЛисты)
    |";
    
    Выборка = Запрос.Выполнить().Выбрать();
    
    Если Выборка.Количество() > 1 Тогда
        
        ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'В документе выбраны исполнительные листы, созданные при обмене и созданные вручную. 
                                                    |Ведомость может содержать исполнительные листы, созданные только при обмене или созданные только пользователем вручную.'"), ЭтотОбъект,,, Отказ);
        
    КонецЕсли; 

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;

	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	КраткийСоставДокумента = "";
	ВрмСуммаДокумента = 0;
	
	Для Каждого СтрокаТЧ Из ИсполнительныеЛисты Цикл
			
		НаименованиеПолучателя = СокрЛП(СтрокаТЧ.Получатель.Наименование);
		
		Если Найти(КраткийСоставДокумента, НаименованиеПолучателя) = 0 Тогда
			
			Если СтрДлина(КраткийСоставДокумента) < 100 Тогда
				КраткийСоставДокумента = КраткийСоставДокумента + ", " + НаименованиеПолучателя;
			Иначе
				КраткийСоставДокумента = Сред(КраткийСоставДокумента,3,95) + "...";
			КонецЕсли;
			
		КонецЕсли; 
		
		ВрмСуммаДокумента = ВрмСуммаДокумента + СтрокаТЧ.СуммаПлатежа;
	
	КонецЦикла;
	
	Если Лев(КраткийСоставДокумента,2) = ", " Тогда
		ДлинаСтроки = СтрДлина(КраткийСоставДокумента);
		Если ДлинаСтроки < 100 Тогда
			КраткийСоставДокумента = Сред(КраткийСоставДокумента,3)
		Иначе
			КраткийСоставДокумента = Сред(КраткийСоставДокумента,3,95) + "...";
		КонецЕсли; 
		
	КонецЕсли;

	СуммаДокумента = ВрмСуммаДокумента;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#КонецЕсли
