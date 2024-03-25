﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗаполнитьРегистрАдресныхДанных(СсылкаНаВладельца, Данные)Экспорт
	
	Для Каждого ДанныеКИ Из Данные Цикл
		
		НаборЗаписей = РегистрыСведений.КонтактнаяИнформация.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.Объект.Установить(СсылкаНаВладельца);
		НаборЗаписей.Отбор.Тип.Установить(ДанныеКИ.Тип);
		НаборЗаписей.Отбор.Вид.Установить(ДанныеКИ.Вид);
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество()>0 Тогда
			
			НоваяЗапись = НаборЗаписей[0];
			
		Иначе
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Объект = СсылкаНаВладельца;
			НоваяЗапись.Тип = ДанныеКИ.Тип;
			НоваяЗапись.Вид = ДанныеКИ.Вид;
			НоваяЗапись.ЗначениеПоУмолчанию = Истина;
			
		КонецЕсли;
		
		НоваяЗапись.Представление = ДанныеКИ.Представление;
		
		НаборЗаписей.Записать();
		
	КонецЦикла;

КонецПроцедуры

#КонецЕсли
