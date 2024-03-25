﻿
// УстановитьФлажки()
//
&НаКлиенте
Процедура УстановитьФлажки(Команда)
			
	УстановитьПометкуСтрокДерева(1, Элементы.Дерево.ТекущийЭлемент.Имя); 
	
КонецПроцедуры // УстановитьФлажки()

// УстановитьПометкуСтрокДерева()
//
&НаКлиенте
Процедура УстановитьПометкуСтрокДерева(Пометка, Знач ТекКолонка)
	
	ТекКолонка = СтрЗаменить(ТекКолонка, "Дерево", "");

	ДанныеСписка = Дерево.ПолучитьЭлементы();
	
	Если ТекКолонка = "Представление" Тогда
		
		ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Для установки или снятия меток по требуемой колонке%1предварительно активизируйте колонку.'"), Символы.ПС));
	Иначе
		
	Для Каждого СтрокаУровня1 Из ДанныеСписка Цикл
		
		Если (ТекКолонка = "ПоказатьСтраницу" ИЛИ ТекКолонка = "Выгружать" ИЛИ ТекКолонка = "АвтоЗаполнение") 
			И СтрокаУровня1 = ДанныеСписка[0] И Пометка = 0 Тогда					
				СтрокаУровня1[ТекКолонка] = 1;
			Иначе
				СтрокаУровня1[ТекКолонка] = Пометка;
			КонецЕсли;
			
			ДанныеСпискаУровня1 = СтрокаУровня1.ПолучитьЭлементы();
			
			Если ДанныеСпискаУровня1.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого СтрокаУровня2 Из ДанныеСпискаУровня1 Цикл				
				СтрокаУровня2[ТекКолонка] = Пометка;
			КонецЦикла;                                          			
			
			ДанныеСпискаУровня2 = СтрокаУровня2.ПолучитьЭлементы();
			
			Если ДанныеСпискаУровня2.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;

			Для Каждого СтрокаУровня3 Из ДанныеСпискаУровня2 Цикл				
				СтрокаУровня3[ТекКолонка] = Пометка;
			КонецЦикла;  
		КонецЦикла;        		
		
	КонецЕсли;	
			


КонецПроцедуры // УстановитьПометкуСтрокДерева()

// СнятьФлажки()
//
&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьПометкуСтрокДерева(0, Элементы.Дерево.ТекущийЭлемент.Имя);
	
КонецПроцедуры // СнятьФлажки()

// ПриСозданииНаСервере()
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("СписокФормДерева") Тогда		
		КопироватьДанныеФормы(Параметры.СписокФормДерева, Дерево);
	КонецЕсли;
	
	мСпрашиватьОСохранении = Истина;
	мПрограммноеЗакрытие   = Ложь;
		
КонецПроцедуры // ПриСозданииНаСервере()

// ПриОткрытии()
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностьюПолученияАвтоИтоговФормы(Дерево.ПолучитьЭлементы());	
	
	Элементы.Дерево.ТолькоПросмотр = (Дерево.ПолучитьЭлементы().Количество() = 0);
	Элементы.УстановитьСнятьФлажки.Доступность = (Дерево.ПолучитьЭлементы().Количество() > 0);
	
КонецПроцедуры // ПриОткрытии()

// Сохранить()
//
&НаКлиенте
Процедура Сохранить(Команда)
	
	мСпрашиватьОСохранении = Ложь;
	Закрыть(Дерево);
	
КонецПроцедуры // Сохранить()

// ДеревоПередНачаломДобавления()
//
&НаКлиенте
Процедура ДеревоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры // ДеревоПередНачаломДобавления()

// ДеревоПередУдалением()
//
&НаКлиенте
Процедура ДеревоПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры // ДеревоПередУдалением()

// ПриИзмененииФлажка()
//
&НаКлиенте
Процедура ПриИзмененииФлажка(Элемент)
	
	ТекЭлемент = СтрЗаменить(Элемент.ТекущийЭлемент.Имя, "Дерево", "");
	
	ВерхнийУровень = Дерево.ПолучитьЭлементы()[0]; 
	
	Если Элемент.ТекущиеДанные = ВерхнийУровень И (ТекЭлемент = "Выгружать" 
		ИЛИ ТекЭлемент = "ПоказатьСтраницу" ИЛИ ТекЭлемент = "АвтоЗаполнение") Тогда
		Элемент.ТекущиеДанные.Выгружать        = 1;
		Элемент.ТекущиеДанные.ПоказатьСтраницу = 1; 			
		Элемент.ТекущиеДанные.АвтоЗаполнение   = 1; 			
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя исключать основную форму отчета!!!'"));
		Возврат;
	КонецЕсли;    	
	
	НоваяПометка = Элемент.ТекущиеДанные[ТекЭлемент];

	Элемент.ТекущиеДанные[ТекЭлемент] = НоваяПометка;
	
КонецПроцедуры // ПриИзмененииФлажка()

// ДеревоПриИзменении()
//
&НаКлиенте
Процедура ДеревоПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ПриИзмененииФлажка(Элемент);
	
КонецПроцедуры // ДеревоПриИзменении()

// ПередЗакрытием()
//
&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Если мПрограммноеЗакрытие = Истина Тогда
		Возврат;
	КонецЕсли;
			
	Если мСпрашиватьОСохранении <> Ложь И Модифицированность Тогда
		
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Настройки были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
		
	ИначеЕсли мСпрашиватьОСохранении <> Ложь И НЕ Модифицированность Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры // ПередЗакрытием()

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		мПрограммноеЗакрытие = Истина;		
		Закрыть(Дерево);  		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеДоступностьюПолученияАвтоИтоговФормы(ДанныеЭлемента)

	Для Каждого СтрокаУровень Из  ДанныеЭлемента Цикл
		ДанныеЭлемента = СтрокаУровень.ПолучитьЭлементы();
		Если Не ДанныеЭлемента.Количество() = 0 Тогда			
			СтрокаУровень.ДоступностьИзмененияАвтополученияИтогов = Истина;
			УправлениеДоступностьюПолученияАвтоИтоговФормы(ДанныеЭлемента);					
		КонецЕсли;		
	КонецЦикла
КонецПроцедуры

