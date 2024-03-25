﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)

	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьКорректностьНазначенияГруппПользователям();
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПроверитьКорректностьНазначенияГруппПользователям() Экспорт
		
	ГруппыВНаборе = ЭтотОбъект.ВыгрузитьКолонку("Пользователь");
	Если ГруппыВНаборе.Найти(Справочники.ГруппыПользователей.ВсеПользователи) <> Неопределено Тогда		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1 1 ИЗ Справочник.ГруппыПользователей ГДЕ Ссылка <> ЗНАЧЕНИЕ(Справочник.ГруппыПользователей.ВсеПользователи)";
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для корректного функционирования механизма ограничения прав доступа на уровне записей необходимо создать группы 
							|пользователей, для которых следует определить виды объектов доступа, по которым они ограничиваются. Настройки 
							|одной лишь группы ""Все пользователи» недостаточно"". Подробнее см. в документации.'"));
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
