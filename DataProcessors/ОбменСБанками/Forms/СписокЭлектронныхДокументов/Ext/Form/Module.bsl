﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для Каждого СообщениеОбмена Из Параметры.МассивСообщенийОбмена Цикл
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.СообщениеОбмена = СообщениеОбмена;
		НоваяСтрока.ПредставлениеЭД = Строка(СообщениеОбмена);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаДанных

&НаКлиенте
Процедура ТаблицаДанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбменСБанкамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(ТаблицаДанных[ВыбраннаяСтрока].СообщениеОбмена, , , Истина);
	
КонецПроцедуры


#КонецОбласти