﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если Значение Тогда
		
		РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
		Константы.ИспользоватьСинхронизациюДанныхВЛокальномРежиме.Установить(Не РазделениеВключено);
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса") Тогда
			МенеджерКонстанты = ОбщегоНазначения.ОбщийМодуль("Константы.ИспользоватьСинхронизациюДанныхВМоделиСервиса");
			МенеджерКонстанты.Установить(РазделениеВключено);
		КонецЕсли;
		
	Иначе
		
		Константы.ИспользоватьСинхронизациюДанныхВЛокальномРежиме.Установить(Ложь);
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса") Тогда
			МенеджерКонстанты = ОбщегоНазначения.ОбщийМодуль("Константы.ИспользоватьСинхронизациюДанныхВМоделиСервиса");
			МенеджерКонстанты.Установить(Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Значение
	   И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса") Тогда
		
		МодульОбменДаннымиВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиВМоделиСервиса");
		МодульОбменДаннымиВМоделиСервиса.ПриОтключенииСинхронизацииДанных(Отказ);
	КонецЕсли;
	Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(
			Метаданные.РегламентныеЗадания.УдалениеНеактуальнойИнформацииСинхронизации);
	Если Задание.Использование <> Значение Тогда
		Задание.Использование = Значение;
		Задание.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли