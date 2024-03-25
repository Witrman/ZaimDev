﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТекПользователь = Пользователи.ТекущийПользователь();
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Запись.Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
		СтруктурноеПодразделение = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновноеСтруктурноеПодразделениеОрганизации");
		Если СтруктурноеПодразделение = Неопределено Тогда
			Запись.СтруктурноеПодразделение = Запись.Организация;
		ИначеЕсли ТипЗнч(СтруктурноеПодразделение) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
			Запись.СтруктурноеПодразделение = СтруктурноеПодразделение;
		Иначе
			Запись.СтруктурноеПодразделение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли
