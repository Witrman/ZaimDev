﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокИсключений = Новый Массив;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДепонированиеЗаработнойПлаты") Тогда
		СписокИсключений.Добавить(Перечисления.СпособыРасчетаСуммКВыплате.ДепонированнаяЗарплатаЗаМесяц);
		СписокИсключений.Добавить(Перечисления.СпособыРасчетаСуммКВыплате.ЗарплатаИДепонированнаяЗарплата);
		СписокИсключений.Добавить(Перечисления.СпособыРасчетаСуммКВыплате.ЗарплатаИОстаткиПоДепонированнойЗарплате);
		СписокИсключений.Добавить(Перечисления.СпособыРасчетаСуммКВыплате.ОстаткиПоДепонированнойЗарплатеНаКонецМесяца);
	КонецЕсли;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Для Каждого ЗначениеПеречисления Из Перечисления.СпособыРасчетаСуммКВыплате Цикл
		Если СписокИсключений.Найти(ЗначениеПеречисления) = Неопределено Тогда
			ДанныеВыбора.Добавить(ЗначениеПеречисления);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли