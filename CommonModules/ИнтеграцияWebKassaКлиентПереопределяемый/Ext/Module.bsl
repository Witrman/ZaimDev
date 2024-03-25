﻿#Область ПрограммныйИнтерфейс

Функция ВыбиратьКассыККМ() Экспорт
	
	Возврат Ложь;
	
КонецФункции

Функция ПолучитьСерийныйНомер(Команда, Параметры, ВходныеПараметры) Экспорт
	
	СерийныйНомер = "";
	Если Команда = "PrintReceipt" Тогда
		СерийныйНомер = ИнтеграцияWebKassaВызовСервераПереопределяемый.ПолучитьСерийныйНомерУстройства(Параметры.Идентификатор);
	ИначеЕсли Команда = "OpenCheck" Тогда
		СерийныйНомер = ИнтеграцияWebKassaВызовСервераПереопределяемый.ПолучитьСерийныйНомерУстройства(Параметры.Идентификатор);
	ИначеЕсли Команда = "PrintZReport" ИЛИ Команда = "PrintXReport" Тогда
		СерийныйНомер = ИнтеграцияWebKassaВызовСервераПереопределяемый.ПолучитьСерийныйНомерУстройства(Параметры.Идентификатор);
	ИначеЕсли Команда = "Encash" Тогда
		СерийныйНомер = ИнтеграцияWebKassaВызовСервераПереопределяемый.ПолучитьСерийныйНомерУстройства(Параметры.Идентификатор);
	КонецЕсли;
	Возврат СерийныйНомер;
	
КонецФункции

Функция ПолучитьСведенияОбОрганизации(ОбщиеПараметры) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Организация", ОбщиеПараметры.ОрганизацияНазвание);
	Результат.Вставить("ИИН", ОбщиеПараметры.ОрганизацияИНН);
	Результат.Вставить("СерияСвидетельстваПоНДС", ОбщиеПараметры.СерияСвидетельстваПоНДС);
	Результат.Вставить("НомерСвидетельстваПоНДС", ОбщиеПараметры.НомерСвидетельстваПоНДС);
	Результат.Вставить("Кассир", ОбщиеПараметры.Кассир);
	
	Возврат Результат;
	
КонецФункции

// Возвращает текущую дату, приведенную к часовому поясу сеанса.
Функция ДатаСеанса() Экспорт
	
	Возврат МенеджерОборудованияКлиентПереопределяемый.ДатаСеанса();
	
КонецФункции

// Значение реквизита, прочитанного из информационной базы по ссылке на объект.
//
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита) Экспорт
	
	Возврат ОбщегоНазначенияБКВызовСервера.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
	
КонецФункции

// Подставляет параметры в строку.
//
Функция ПодставитьПараметрыВСтроку(ШаблонСообщения, Параметр1 = Неопределено, Параметр2 = Неопределено) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Параметр1, Параметр2);
	
КонецФункции

//Выводит сообщение пользователю
//
Процедура СообщитьПользователю(ТекстСообщения, Знач КлючДанных = Неопределено, Знач Поле = "", Знач ПутьКДанным = "") Экспорт
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,
		КлючДанных,
		Поле,
		ПутьКДанным);
	
КонецПроцедуры

//
//
Функция КодТипаРасчета(ТипРасчета) Экспорт
	
	Возврат МенеджерОборудованияКлиентСервер.КодРасчетаДенежнымиСредствами(ТипРасчета);
	
КонецФункции

//
//
Функция ПолучитьПараметрыПриложения(ИмяПараметра) Экспорт
	
	Возврат ПараметрыПриложения[ИмяПараметра];
	
КонецФункции

//
//
Процедура ДобавитьВПараметрыПриложения(ИмяПараметра, Значение) Экспорт
	
	ПараметрыПриложения.Вставить(ИмяПараметра, Значение);
	
КонецПроцедуры

// Выполняет печать текста на подключаемом оборудовании
//
Процедура НачатьПечатьТекста(ОповещениеЗавершения, УникальныйИдентификатор, ТекстЧека, ПринтерЧеков) Экспорт
	
	МенеджерОборудованияКлиент.НачатьПечатьТекста(
			ОповещениеЗавершения,
			УникальныйИдентификатор,
			ТекстЧека,
			ПринтерЧеков);
	
КонецПроцедуры

Процедура НачатьВыполнениеДополнительнойКоманды(ОповещениеПриЗавершении, Команда, ВходныеПараметры, Идентификатор, Параметры) Экспорт
	
	МенеджерОборудованияКлиент.НачатьВыполнениеДополнительнойКоманды(ОповещениеПриЗавершении, Команда, ВходныеПараметры, Идентификатор, Параметры);
	
КонецПроцедуры


Процедура ПоказатьВопросОбУстановкеРасширения(ОповещениеЗавершения, ТекстСообщения, ПродолжитьБезУстановки) Экспорт
	
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОповещениеЗавершения, ТекстСообщения, ПродолжитьБезУстановки);
	
КонецПроцедуры

Функция СкопироватьМассив(МассивИсточник) Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.СкопироватьМассив(МассивИсточник);
	
КонецФункции

#КонецОбласти

