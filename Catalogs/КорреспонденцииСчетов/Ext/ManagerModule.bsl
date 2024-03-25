﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
		
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Подготовка табличных печатных документов.


////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления ИБ

// Обработка обновления на версию 3.0.14
//
Процедура ОбновитьОперацииКорреспонденцииСчетов() Экспорт
	
	Макет = Справочники.КорреспонденцииСчетов.ПолучитьМакет("Макет");
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	КорреспонденцииСчетов.Код
	               |ИЗ
	               |	Справочник.КорреспонденцииСчетов КАК КорреспонденцииСчетов";
	ВсеКорреспонденции = Запрос.Выполнить().Выгрузить();
	
	НомерСтроки=1;
	
	Пока Истина Цикл
		
		Номер = Макет.область(НомерСтроки,1).Текст;
		Если НЕ ЗначениеЗаполнено(Номер) Тогда
			//Т.е. если прочли весь макет
			Прервать;
		КонецЕсли;
			
		НайденСуществующий = ВсеКорреспонденции.Найти(формат(Число(Номер),"ЧЦ=9; ЧВН=; ЧГ="));
		Если Не ЗначениеЗаполнено(НайденСуществующий) Тогда
			НовыйСпр = Справочники.КорреспонденцииСчетов.СоздатьЭлемент();
			НовыйСпр.СчетДт 			  = ПланыСчетов.Типовой.НайтиПоКоду(Макет.область(НомерСтроки,3).Текст);
			НовыйСпр.СчетКт 			  = ПланыСчетов.Типовой.НайтиПоКоду(Макет.область(НомерСтроки,4).Текст);
			НовыйСпр.Содержание 		  = Макет.область(НомерСтроки,2).Текст;
			НовыйСпр.ТипДокумента 		  = Макет.область(НомерСтроки,5).Текст;
			НовыйСпр.ВидОперацииДокумента = Макет.область(НомерСтроки,6).Текст;
			НовыйСпр.ЗакладкаДокумента 	  = Макет.область(НомерСтроки,7).Текст;
			НовыйСпр.Меню 				  = Макет.область(НомерСтроки,8).Текст;
			НовыйСпр.Код 				  = формат(Число(Номер),"ЧЦ=9; ЧВН=; ЧГ=");
			НовыйСпр.Записать();
		Иначе
			СуществующийЭлемент = Справочники.КорреспонденцииСчетов.НайтиПоКоду(НайденСуществующий.Код);
			Если ЗначениеЗаполнено(СуществующийЭлемент)
				И (СуществующийЭлемент.Содержание <> Макет.область(НомерСтроки,2).Текст
				ИЛИ СуществующийЭлемент.СчетДт <> ПланыСчетов.Типовой.НайтиПоКоду(Макет.область(НомерСтроки,3).Текст) 
				ИЛИ СуществующийЭлемент.СчетКт <> ПланыСчетов.Типовой.НайтиПоКоду(Макет.область(НомерСтроки,4).Текст) 
				ИЛИ СуществующийЭлемент.ТипДокумента <> Макет.область(НомерСтроки,5).Текст 
				ИЛИ СуществующийЭлемент.ВидОперацииДокумента <> Макет.область(НомерСтроки,6).Текст
				ИЛИ СуществующийЭлемент.ЗакладкаДокумента <> Макет.область(НомерСтроки,7).Текст
				ИЛИ СуществующийЭлемент.Меню <> Макет.область(НомерСтроки,8).Текст) Тогда
				Попытка
					СуществующийОбъект = СуществующийЭлемент.ПолучитьОбъект();
					СуществующийОбъект.Содержание           = Макет.область(НомерСтроки,2).Текст;
					СуществующийОбъект.СчетДт               = ПланыСчетов.Типовой.НайтиПоКоду(Макет.область(НомерСтроки,3).Текст);
					СуществующийОбъект.СчетКт               = ПланыСчетов.Типовой.НайтиПоКоду(Макет.область(НомерСтроки,4).Текст);
					СуществующийОбъект.ТипДокумента         = Макет.область(НомерСтроки,5).Текст;
					СуществующийОбъект.ВидОперацииДокумента = Макет.область(НомерСтроки,6).Текст;
					СуществующийОбъект.ЗакладкаДокумента    = Макет.область(НомерСтроки,7).Текст;
					СуществующийОбъект.Меню                 = Макет.область(НомерСтроки,8).Текст;
					СуществующийОбъект.Записать();
				Исключение
					ТекстСообщения = НСтр("ru = 'Не удалось обновить ""Справочник ""Корреспонденции счетов"""".'");
					ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,, СуществующийОбъект.Содержание, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
		НомерСтроки = НомерСтроки+1;
		
	КонецЦикла;
	
КонецПроцедуры


#КонецЕсли
 