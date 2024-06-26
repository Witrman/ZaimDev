﻿
// Получает данные для печати и открывает форму обработки печати этикеток и ценников.
//
// Параметры:
//  ОбъектыПечати        - Структура        - структура с описанием данных печати:
//   * ОбъектыПечати - Массив из ПечатьКодовМаркировкиИСМПКлиентСервер.СтурктураПечатиЭтикеткиОбувь - строки описания товаров
//     и кодов для печати
//   * Документ - ДокументСсылка.ЗаказНаЭмиссиюКодовМаркировкиСУЗ,
//     ОпределеямыйТип.ОснованиеЗаказНаЭмиссиюКодовМаркировкиИСМП - Документ, в рамках которого выполняется печать.
//   * КаждаяЭтикеткаНаНовомЛисте - Булево - Выводить разрыв страницы после каждой этикетки (для термопечати этикетки).
//  Форма                - УправляемаяФорма - форма-владелец из которой выполняется печать.
//  СтандартнаяОбработка - Булево           - Отключает печать встроенными средставами библиотеки.
Процедура ПечатьЭтикеткиИСМП(ДанныеПечати, Форма, СтандартнаяОбработка) Экспорт

	СтандартнаяОбработка = Ложь;
	
	ОписаниеКоманды = Новый Структура;
	ОписаниеКоманды.Вставить("Вид",             "Печать");
	ОписаниеКоманды.Вставить("Идентификатор",   "ЭтикеткаПоПереданнымДаннымОбувь");
	ОписаниеКоманды.Вставить("СтруктураДанных", ДанныеПечати);
	ОписаниеКоманды.Вставить("Представление",   НСтр("ru = 'Печать: Этикетки ИС МПТ';
													 |en = 'Печать: Этикетки ИС МПТ'"));
	ОписаниеКоманды.Вставить("Форма",           Форма);
	
	ПечатьКодовМаркировкиИСМПТККлиент.ПечатьЭтикетокОбувь(ОписаниеКоманды, "Обработка.ПечатьКодовМаркировкиИСМПТК");
	
	Возврат;
	
КонецПроцедуры

#Область ПечатьИСМПТ

Процедура ПечатьSSCC(ДанныеПечати, Форма, СтандартнаяОбработка) Экспорт

	СтандартнаяОбработка = Ложь;
	
	ОписаниеКоманды = Новый Структура;
	ОписаниеКоманды.Вставить("Вид",             "Печать");
	ОписаниеКоманды.Вставить("Идентификатор",   "ЭтикеткаSSCC");
	ОписаниеКоманды.Вставить("СтруктураДанных", ДанныеПечати);
	ОписаниеКоманды.Вставить("Представление",   НСтр("ru = 'Печать: код SSCC';
													 |en = 'Печать: код SSCC'"));
	ОписаниеКоманды.Вставить("Форма",           Форма);
	
	ПечатьКодовМаркировкиИСМПТККлиент.ПечатьКодSSCC(ОписаниеКоманды, "Обработка.ПечатьКодовМаркировкиИСМПТК");
	
	Возврат;
	
КонецПроцедуры

Процедура ПечатьАгрегацияКМ(ДанныеПечати, Форма, СтандартнаяОбработка) Экспорт

	СтандартнаяОбработка = Ложь;
	
	ОписаниеКоманды = Новый Структура;
	ОписаниеКоманды.Вставить("Вид",             "Печать");
	ОписаниеКоманды.Вставить("Идентификатор",   "АгрегацияКМ");
	ОписаниеКоманды.Вставить("СтруктураДанных", ДанныеПечати);
	ОписаниеКоманды.Вставить("Представление",   НСтр("ru = 'Печать: Агрегация кодов маркировки';
													 |en = 'Печать: Агрегация кодов маркировки'"));
	ОписаниеКоманды.Вставить("Форма",           Форма);
	
	ПечатьКодовМаркировкиИСМПТККлиент.ПечатьАгрегацияКМ(ОписаниеКоманды, "Документ.АгрегацияКодовМаркировкиСУЗИСМПТК");
	
	Возврат;
	
КонецПроцедуры

Процедура ВыполнитьКомандуПечати(ИмяМенеджераПечати, ИмяОбъектаПечати, МассивОбъектов, ВладелецФормы = Неопределено, ПараметрыПечати = Неопределено) Экспорт
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(ИмяМенеджераПечати, ИмяОбъектаПечати, МассивОбъектов, ВладелецФормы, ПараметрыПечати);

КонецПроцедуры

#КонецОбласти