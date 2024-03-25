﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = Тип("ФормаКлиентскогоПриложения") Тогда
			
		Если Источник.ИмяФормы = "Документ.УведомлениеОВвозеИзЕАЭСИСМПТК.Форма.ФормаДокумента" Тогда
			
			ИнтеграцияИСМПТККлиент.ОбновитьДокументыИзИСМПТ(ПараметрКоманды, Новый Структура("ЗапускатьФоновоеЗадание, ТолькоОбновитьСтатус", Ложь, Истина));
			
		//БМ_ИСМПТ ТРЕБУЕТСЯ_РАССМОТРЕНИЕ	Фоновая отправка данных Ввоз в ИС МПТ
		Иначе
			
			ИспользоватьФоновуюОтправкуДокументИСМПТ = ИнтеграцияИСМПТККлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуДокументовИСМПТ();
			
			ДополнительныеПараметры = Новый Структура("ЗапускатьФоновоеЗадание, КлючФормы, ТолькоОбновитьСтатус", ИспользоватьФоновуюОтправкуДокументИСМПТ, Источник.КлючУникальности, Истина);
			
			ИнтеграцияИСМПТККлиент.ОбновитьДокументыИзИСМПТ(ПараметрКоманды, ДополнительныеПараметры);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
