﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запись.Период = Дата("01.01.1900 0:00:00");

	ЭТДСервер.ПриСозданииНаСервереСопоставлениеПрофилейНавыковЭТД(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПрофиляНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокТипов = ЭТДВызовСервера.ПолучитьМассивВыбораВладельцыПрофиля();
	
	Оповещение = Новый ОписаниеОповещения("ОткрытиеФормыВыбораВладельцаПрофиля", ЭтотОбъект);
	
	СписокТипов.ПоказатьВыборЭлемента(Оповещение, "Выбор типа данных");
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЭТДСервер.ПриЧтенииНаСервереРегистраСведений(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЭТДСервер.ПослеЗаписиНаСервереРегистраСведений(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытиеФормыВыбораВладельцаПрофиля(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	ЭТДКлиент.ОткрытиеФормыВыбораВладельцаПрофиля(ВыбранныйЭлемент, Запись.Организация, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораВладельцаПрофиля(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Запись.ВладелецПрофиля = РезультатЗакрытия;
	
КонецПроцедуры

#КонецОбласти

