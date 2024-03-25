﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастроитьЭлементыФормы(ЭтаФорма);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	НастроитьЭлементыФормы(ЭтаФорма);
	
КонецПроцедуры

	
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЭлементыФормы(Форма)
	
	Запись = Форма.Запись;
	Элементы = Форма.Элементы;

	Если ЗначениеЗаполнено(Запись.Период) И Запись.Период < Дата(2022, 1, 1) Тогда
		
		Элементы.РазмерМРП.Заголовок = НСтр("ru = 'МРП'");
		Элементы.РазмерМРПДляПособийИныхСоциальныхВыплат.Видимость = Ложь;
		
	Иначе
		
		Элементы.РазмерМРП.Заголовок = НСтр("ru = 'МРП для налогов, штрафных санкций и других платежей'");
		Элементы.РазмерМРПДляПособийИныхСоциальныхВыплат.Видимость = Истина;
		
	КонецЕсли
	
КонецПроцедуры
