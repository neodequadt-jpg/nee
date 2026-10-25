# Телефон Recovery — состояние сессии

## Дата: 2026-10-14

## Устройство
- Бренд: **Realme**
- Платформа: **Spreadtrum / Unisoc** (USB vendor `1782`, product `4d00`)
- Режим USB: **SPD Download Mode** ("Sprd Gadget Serial")
- bcdDevice: 24.16
- Точная модель: **НЕ ОПРЕДЕЛЕНА** (возможно C21 / C25s / C30 / C33 / Narzo 50A Prime)

## Симптомы
- Bootloop: грузится до 2-й заставки **REALME UI** → зависает → перезагрузка
- Бутлоадер жив, ядро живает, падает на этапе system_server / dex cache
- Предположительная причина: кривое обновление ОС

## Что пробовали
- ❌ Power 20 сек — не вырубает
- ❌ Volume Down при перезагрузке — не входит в Recovery
- ❌ Volume Up — не проверяли (следующий шаг)

## Что НЕ пробовали (продолжить отсюда)
1. **Volume Up** при перезагрузке → Fastboot Mode
2. **Volume Up + Volume Down** → Firmware Upgrade Mode
3. **Power 40–60 сек** — принудительное выключение
4. **Дать разрядиться** → после вырубки зажать Volume Down + подключить кабель
5. **SPD Research Tool** прошивка — телефон уже в Download Mode по USB

## Если Recovery/Fastboot войдёт
- Wipe cache partition → Reboot (данные сохраняются)
- Если нет → Wipe data / factory reset (данные потеряются)

## Если кнопки не работают — SPD Tool
1. Скачать SPD Research Tool: https://spdflashtool.com/
2. Прошивка Realme: https://www.realme.com/support/software-update
3. udev-правила: `SUBSYSTEM=="usb", ATTR{idVendor}=="1782", MODE="0666"`
4. Режим: Download Only (НЕ Format All!)
5. .pac файл из распакованной прошивки

## Риски
- Неверная прошивка = кирпич (нужна точная модель!)
- Format All убьёт IMEI/NVRAM
- Wipe data = потеря всех данных

## Нужно от пользователя
- [ ] Точная модель (под батареей)
- [ ] Что случилось до bootloop (обновление? установка? падение?)
- [ ] Результат попытки Volume Up / Volume Up+Down
