﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	

	
КонецПроцедуры

Функция ВариантыНастроек() Экспорт
	
    Результат = Новый Массив;
    Результат.Добавить(Новый Структура("Имя, Представление", "Основной", НСтр("ru = 'Анализ остатков товаров на виртуальном складе с учетом резервов'")));
	
    Возврат Результат;
	
КонецФункции

#КонецЕсли
