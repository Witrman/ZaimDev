﻿// Функция получает элемент справочника - ключ аналитики учета.
//
// Параметры:
//	ПараметрыАналитики - Выборка или Структура  с полями "Номенклатура, Характеристика, Склад".
//
// Возвращаемое значение:
//	СправочникСсылка.КлючиАналитикиУчетаНоменклатуры - Созданный элемент справочника
//
Функция СоздатьКлючАналитики(ПараметрыАналитики) Экспорт
	
	Результат = Неопределено;
	
	Если ЗначениеЗаполнено(ПараметрыАналитики.ТоварНаименование) 
		ИЛИ ЗначениеЗаполнено(ПараметрыАналитики.ЕдиницаИзмеренияКод) Тогда
		
		МенеджерЗаписи = ПолучитьМенеджерЗаписи(ПараметрыАналитики);
		
		Если МенеджерЗаписи <> Неопределено Тогда

			// Создание нового ключа аналитики.
			СправочникОбъект = Справочники.КлючиАналитикиУчетаСоответствий.СоздатьЭлемент();
			СправочникОбъект.Наименование = ПолучитьПолноеНаименованиеКлючаАналитики(МенеджерЗаписи);
			ЗаполнитьЗначенияСвойств(СправочникОбъект, ПараметрыАналитики, "ТоварНаименование, ЕдиницаИзмеренияКод");
			СправочникОбъект.Записать();

			Результат = СправочникОбъект.Ссылка;

			МенеджерЗаписи.КлючАналитики = Результат;
			МенеджерЗаписи.Записать(Истина);			
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьМенеджерЗаписи(ПараметрыАналитики)
	
	// В параметрах аналитики могут быть не все свойства
	СтруктураАналитики = Новый Структура("ТоварНаименование, ЕдиницаИзмеренияКод");
	ЗаполнитьЗначенияСвойств(СтруктураАналитики, ПараметрыАналитики);
	Если НЕ ЗначениеЗаполнено(СтруктураАналитики.ТоварНаименование)
		И НЕ ЗначениеЗаполнено(СтруктураАналитики.ЕдиницаИзмеренияКод) Тогда
		Возврат Неопределено
	Иначе
		
		МенеджерЗаписи = РегистрыСведений.АналитикаУчетаСоответствий.СоздатьМенеджерЗаписи();
		
		//обрезаем из-за записи на СУБД, когда 450 символов будет ошибка по превышению индекса
		МенеджерЗаписи.ТоварНаименование = Лев(СтруктураАналитики.ТоварНаименование,400);

		МенеджерЗаписи.ЕдиницаИзмеренияКод = ЭСФКлиентСервер.ПреобразованноеНаименование(СтруктураАналитики.ЕдиницаИзмеренияКод);
		
		Возврат МенеджерЗаписи;
	КонецЕсли;
	
КонецФункции


Функция ПолучитьПолноеНаименованиеКлючаАналитики(МенеджерЗаписи)

	Возврат СокрЛП(МенеджерЗаписи.ТоварНаименование) + "; " 
		+ ?(ЗначениеЗаполнено(МенеджерЗаписи.ЕдиницаИзмеренияКод), СокрЛП(МенеджерЗаписи.ЕдиницаИзмеренияКод), "");

КонецФункции
