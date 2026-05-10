import tkinter as tk
from tkinter import ttk, scrolledtext
import sys
import io
import math
import random

# --- Все задачи Раздела 2 (1-62) и Раздела 3 (1-7) ---

tasks = {}

# ==================== РАЗДЕЛ 2: Задачи на составление блок-схем (1-11) ====================

tasks["2.1"] = {
    "title": "Задача 1. Площадь треугольника по формуле Герона",
    "code": '''import math

a = float(input("Введите сторону a: "))
b = float(input("Введите сторону b: "))
c = float(input("Введите сторону c: "))

p = (a + b + c) / 2
S = math.sqrt(p * (p - a) * (p - b) * (p - c))
print("Периметр P =", a + b + c)
print("Площадь S =", round(S, 2))
''',
    "default_input": "3\n4\n5"
}

tasks["2.2"] = {
    "title": "Задача 2. Функция y = ax + b",
    "code": '''a = float(input("Введите a: "))
x = float(input("Введите x: "))
b = float(input("Введите b: "))

y = a * x + b
print("y =", y)
''',
    "default_input": "2\n3\n1"
}

tasks["2.3"] = {
    "title": "Задача 3. Периметр прямоугольного треугольника по катетам",
    "code": '''import math

a = float(input("Введите катет a: "))
b = float(input("Введите катет b: "))

c = math.sqrt(a**2 + b**2)
P = a + b + c
print("Гипотенуза c =", round(c, 2))
print("Периметр P =", round(P, 2))
''',
    "default_input": "3\n4"
}

tasks["2.4"] = {
    "title": "Задача 4. Площадь квадрата со стороной a",
    "code": '''a = float(input("Введите сторону квадрата a: "))

S = a * a
print("Площадь квадрата S =", S)
''',
    "default_input": "5"
}

tasks["2.5"] = {
    "title": "Задача 5. Вычислить a/b - c/d (b>0, d>0)",
    "code": '''a = float(input("Введите a: "))
b = float(input("Введите b: "))
c = float(input("Введите c: "))
d = float(input("Введите d: "))

if b > 0 and d > 0:
    result = a / b - c / d
    print("Результат a/b - c/d =", round(result, 4))
else:
    print("Ошибка: b и d должны быть больше 0")
''',
    "default_input": "10\n2\n6\n3"
}

tasks["2.6"] = {
    "title": "Задача 6. Увеличить/уменьшить число X на 10",
    "code": '''x = float(input("Введите число X: "))

if x > 0:
    x = x + 10
    print("Число положительное, увеличено на 10:", x)
else:
    x = x - 10
    print("Число не положительное, уменьшено на 10:", x)
''',
    "default_input": "5"
}

tasks["2.7"] = {
    "title": "Задача 7. Разделить на 2 или умножить на 5",
    "code": '''x = float(input("Введите число: "))

if x > 20:
    result = x / 2
    print("Число больше 20, делим на 2:", result)
else:
    result = x * 5
    print("Число <= 20, умножаем на 5:", result)
''',
    "default_input": "25"
}

tasks["2.8"] = {
    "title": "Задача 8. Кусочная функция (3 условия)",
    "code": '''import math

x = float(input("Введите x: "))

if x > 0:
    y = math.sqrt(x)
elif x == 0:
    y = 0
else:
    y = x ** 2

print("y =", round(y, 4))
''',
    "default_input": "4"
}

tasks["2.9"] = {
    "title": "Задача 9. Сумма чисел до ввода 0",
    "code": '''summa = 0
print("Вводите числа (0 для завершения):")

while True:
    n = int(input("Число: "))
    if n == 0:
        break
    summa += n

print("Сумма =", summa)
''',
    "default_input": "5\n3\n7\n0"
}

tasks["2.10"] = {
    "title": "Задача 10. Сумма четных, произведение нечетных",
    "code": '''N = int(input("Сколько чисел ввести: "))

sum_even = 0
prod_odd = 1
has_odd = False

for i in range(N):
    num = int(input(f"Число {i+1}: "))
    if num % 2 == 0:
        sum_even += num
    else:
        prod_odd *= num
        has_odd = True

print("Сумма четных:", sum_even)
if has_odd:
    print("Произведение нечетных:", prod_odd)
else:
    print("Нечетных чисел не было")
''',
    "default_input": "5\n2\n3\n4\n5\n6"
}

tasks["2.11"] = {
    "title": "Задача 11. P = x^y + sqrt(2xy) + 4rt(4xy) + ... + 10rt(10xy)",
    "code": '''import math

x = float(input("Введите x: "))
y = float(input("Введите y: "))

P = x ** y
for n in range(2, 11, 2):
    val = n * x * y
    if val >= 0:
        P += val ** (1 / n)
    else:
        print(f"Внимание: {n}*x*y < 0, пропускаем корень степени {n}")

print("P =", round(P, 4))
''',
    "default_input": "2\n3"
}

# ==================== РАЗДЕЛ 2: Задачи на Python (12-62) ====================

tasks["2.12"] = {
    "title": "Задача 12. Животные в зоопарке",
    "code": '''monkeys = 5
lions = 3
bears = 2

animals = monkeys + lions + bears
print(animals, "животных живёт в зоопарке")
''',
    "default_input": ""
}

tasks["2.13"] = {
    "title": "Задача 13. Имя и возраст",
    "code": '''name = input("Как вас зовут? ")
age = input("Сколько вам лет? ")

print("Меня зовут", name + ", мне", age, "лет.")
''',
    "default_input": "Иван\n18"
}

tasks["2.14"] = {
    "title": "Задача 14. Пират и монеты",
    "code": '''total = 300
dolgi = total * 0.3
vorony = 4 * 10

coins = total - dolgi - vorony
print("Ответ: у пирата осталось", int(coins), "монет")
''',
    "default_input": ""
}

tasks["2.15"] = {
    "title": "Задача 15. Текущая дата",
    "code": '''day = 25
month = "января"
year = 2021

print("Сегодня", day, month, year, "года")
''',
    "default_input": ""
}

tasks["2.16"] = {
    "title": "Задача 16. 4 переменные в одном print",
    "code": '''name = "Иван"
age = 18
city = "Москва"
hobby = "программирование"

print("Меня зовут", name + ", мне", age, "лет, я живу в", city + ", увлекаюсь", hobby)
''',
    "default_input": ""
}

tasks["2.17"] = {
    "title": "Задача 17. Пингвин из символов",
    "code": '''a1 = '   _~_   '
a2 = '  (o o)  '
a3 = '  /( )\\  '
a4 = ' _/ " \\_ '
a5 = '(___/\\___)' 

print(a1)
print(a2)
print(a3)
print(a4)
print(a5)
''',
    "default_input": ""
}

tasks["2.18"] = {
    "title": "Задача 18. Свой рисунок",
    "code": '''a1 = '  /\\_/\\  '
a2 = ' ( o.o ) '
a3 = '  > ^ <  '
a4 = ' /|   |\\  '
a5 = '(_|   |_)'

print(a1)
print(a2)
print(a3)
print(a4)
print(a5)
''',
    "default_input": ""
}

tasks["2.19"] = {
    "title": "Задача 19. Площадь треугольника (формула Герона)",
    "code": '''import math

a = float(input("Введите сторону a: "))
b = float(input("Введите сторону b: "))
c = float(input("Введите сторону c: "))

p = (a + b + c) / 2
S = math.sqrt(p * (p - a) * (p - b) * (p - c))
print("Площадь треугольника S =", round(S, 2))
''',
    "default_input": "3\n4\n5"
}

tasks["2.20"] = {
    "title": "Задача 20. Решите пример 4 * 100 - 54",
    "code": '''print("Решите пример: 4 * 100 - 54")
a = int(input("Введите ваш ответ: "))
b = 4 * 100 - 54

if a == b:
    print("Все верно!", a)
else:
    print("Не верно.", "Прав. ответ:", b, "Ваш ответ:", a)
''',
    "default_input": "346"
}

tasks["2.21"] = {
    "title": "Задача 21. Четыре числа, деление сумм",
    "code": '''a = float(input("Первое число: "))
b = float(input("Второе число: "))
c = float(input("Третье число: "))
d = float(input("Четвертое число: "))

sum1 = a + b
sum2 = c + d

if sum2 != 0:
    result = sum1 / sum2
    print("Результат: {:.2f}".format(result))
else:
    print("Деление на ноль!")
''',
    "default_input": "10\n20\n5\n5"
}

tasks["2.22"] = {
    "title": "Задача 22. Сумма трех целых чисел",
    "code": '''a = int(input("Первое число: "))
b = int(input("Второе число: "))
c = int(input("Третье число: "))

print("Сумма:", a + b + c)
''',
    "default_input": "10\n20\n30"
}

tasks["2.23"] = {
    "title": "Задача 23. Площадь круга",
    "code": '''import math

r = float(input("Введите радиус круга: "))
S = math.pi * r ** 2
print("Площадь круга S =", round(S, 2))
''',
    "default_input": "5"
}

tasks["2.24"] = {
    "title": "Задача 24. Сумма трех дробных чисел",
    "code": '''a = float(input("Первое дробное число: "))
b = float(input("Второе дробное число: "))
c = float(input("Третье дробное число: "))

print("Сумма:", round(a + b + c, 4))
''',
    "default_input": "1.5\n2.3\n3.7"
}

tasks["2.25"] = {
    "title": "Задача 25. Школьники и яблоки",
    "code": '''n = int(input("Кол-во школьников: "))
k = int(input("Кол-во яблок: "))

each = k // n
left = k % n

print("Каждому школьнику достанется:", each, "яблок")
print("В корзинке останется:", left, "яблок")
''',
    "default_input": "3\n10"
}

tasks["2.26"] = {
    "title": "Задача 26. Следующее и предыдущее число",
    "code": '''n = int(input("Введите целое число: "))

print("Предыдущее число:", n - 1)
print("Введенное число:", n)
print("Следующее число:", n + 1)
''',
    "default_input": "10"
}

tasks["2.27"] = {
    "title": "Задача 27. Три строки через разделитель",
    "code": '''sep = input("Введите разделитель: ")
s1 = input("Первая строка: ")
s2 = input("Вторая строка: ")
s3 = input("Третья строка: ")

print(s1 + sep + s2 + sep + s3)
''',
    "default_input": " - \nПривет\nмир\nPython"
}

tasks["2.28"] = {
    "title": "Задача 28. Последовательность x, 2x, 3x, 4x, 5x",
    "code": '''x = int(input("Введите число x: "))

print(x, "---", 2*x, "---", 3*x, "---", 4*x, "---", 5*x)
''',
    "default_input": "3"
}

tasks["2.29"] = {
    "title": "Задача 29. Полное число метров из сантиметров",
    "code": '''cm = int(input("Введите число сантиметров: "))

meters = cm // 100
print("Полных метров:", meters)
''',
    "default_input": "354"
}

tasks["2.30"] = {
    "title": "Задача 30. Сумма и произведение цифр трехзначного числа",
    "code": '''n = int(input("Введите трехзначное число: "))

d1 = n // 100
d2 = (n // 10) % 10
d3 = n % 10

print("Цифры:", d1, d2, d3)
print("Сумма цифр:", d1 + d2 + d3)
print("Произведение цифр:", d1 * d2 * d3)
''',
    "default_input": "123"
}

tasks["2.31"] = {
    "title": "Задача 31. Сумма и произведение цифр четырехзначного числа",
    "code": '''n = int(input("Введите четырехзначное число: "))

d1 = n // 1000
d2 = (n // 100) % 10
d3 = (n // 10) % 10
d4 = n % 10

print("Цифры:", d1, d2, d3, d4)
print("Сумма цифр:", d1 + d2 + d3 + d4)
print("Произведение цифр:", d1 * d2 * d3 * d4)
''',
    "default_input": "1234"
}

tasks["2.32"] = {
    "title": "Задача 32. Цифры трехзначного числа",
    "code": '''n = int(input("Введите трехзначное число: "))

d1 = n // 100
d2 = (n // 10) % 10
d3 = n % 10

print("Сотни:", d1)
print("Десятки:", d2)
print("Единицы:", d3)
''',
    "default_input": "456"
}

tasks["2.33"] = {
    "title": "Задача 33. Цифры четырехзначного числа",
    "code": '''n = int(input("Введите четырехзначное число: "))

d1 = n // 1000
d2 = (n // 100) % 10
d3 = (n // 10) % 10
d4 = n % 10

print("Тысячи:", d1)
print("Сотни:", d2)
print("Десятки:", d3)
print("Единицы:", d4)
''',
    "default_input": "5678"
}

tasks["2.34"] = {
    "title": "Задача 34. Ввод данных или пустой Enter",
    "code": '''data = input("Введите что-нибудь: ")

if data:
    print("ОК")
''',
    "default_input": "привет"
}

tasks["2.35"] = {
    "title": "Задача 35. Число больше нуля: 1 или -1",
    "code": '''n = float(input("Введите число: "))

if n > 0:
    print(1)
else:
    print(-1)
''',
    "default_input": "5"
}

tasks["2.36"] = {
    "title": "Задача 36. Прибавить 24 и проверить > 40",
    "code": '''x = float(input("Введите число: "))
result = x + 24

if result > 40:
    print("Число", result, "соответствует заданным критериям")
else:
    print("Ошибка: число", result, "не соответствует критериям")
''',
    "default_input": "20"
}

tasks["2.37"] = {
    "title": "Задача 37. Максимум из двух чисел",
    "code": '''a = float(input("Первое число: "))
b = float(input("Второе число: "))

if a > b:
    print("Максимальное:", a)
elif b > a:
    print("Максимальное:", b)
else:
    print("Числа равны:", a)
''',
    "default_input": "7\n12"
}

tasks["2.38"] = {
    "title": "Задача 38. Степени числа 2 от 0 до 20 (while)",
    "code": '''i = 0
while i <= 20:
    print("2 ^", i, "=", 2 ** i)
    i += 1
''',
    "default_input": ""
}

tasks["2.39"] = {
    "title": "Задача 39. y = 5x² - 2x + 1 на [-5;5] с шагом 2",
    "code": '''x = -5
while x <= 5:
    y = 5 * x**2 - 2 * x + 1
    print("x =", x, " y =", y)
    x += 2
''',
    "default_input": ""
}

tasks["2.40"] = {
    "title": "Задача 40. Больше положительных или отрицательных",
    "code": '''pos = 0
neg = 0

print("Вводите числа (5 для завершения):")
while True:
    n = float(input("Число: "))
    if n == 5:
        break
    if n > 0:
        pos += 1
    elif n < 0:
        neg += 1

if pos > neg:
    print("Положительных больше:", pos, ">", neg)
elif neg > pos:
    print("Отрицательных больше:", neg, ">", pos)
else:
    print("Поровну:", pos, "=", neg)
''',
    "default_input": "3\n-1\n7\n-2\n5"
}

tasks["2.41"] = {
    "title": "Задача 41. Среднее арифметическое до ввода 0",
    "code": '''summa = 0
count = 0

print("Вводите числа (0 для завершения):")
while True:
    n = int(input("Число: "))
    if n == 0:
        break
    summa += n
    count += 1

if count > 0:
    print("Среднее арифметическое:", summa / count)
else:
    print("Вы не ввели ни одного числа")
''',
    "default_input": "10\n20\n30\n0"
}

tasks["2.42"] = {
    "title": "Задача 42. Числа от 0 до N (while)",
    "code": '''N = int(input("Введите N: "))

i = 0
while i <= N:
    print(i, end=" ")
    i += 1
print()
''',
    "default_input": "10"
}

tasks["2.43"] = {
    "title": "Задача 43. Сумма нечетных от K до N (while)",
    "code": '''K = int(input("Введите K: "))
N = int(input("Введите N: "))

summa = 0
i = K
while i <= N:
    if i % 2 != 0:
        summa += i
    i += 1

print("Сумма нечетных от", K, "до", N, "=", summa)
''',
    "default_input": "1\n10"
}

tasks["2.44"] = {
    "title": "Задача 44. Факториал числа N",
    "code": '''N = int(input("Введите N: "))

factorial = 1
for i in range(1, N + 1):
    factorial *= i

print(str(N) + "! =", factorial)
''',
    "default_input": "5"
}

tasks["2.45"] = {
    "title": "Задача 45. Числа от 0 до N (for)",
    "code": '''N = int(input("Введите N: "))

for i in range(N + 1):
    print(i, end=" ")
print()
''',
    "default_input": "10"
}

tasks["2.46"] = {
    "title": "Задача 46. Числа от K до N (for)",
    "code": '''K = int(input("Введите K: "))
N = int(input("Введите N: "))

for i in range(K, N + 1):
    print(i, end=" ")
print()
''',
    "default_input": "3\n10"
}

tasks["2.47"] = {
    "title": "Задача 47. Сумма четных от K до N (for)",
    "code": '''K = int(input("Введите K: "))
N = int(input("Введите N: "))

summa = 0
for i in range(K, N + 1):
    if i % 2 == 0:
        summa += i

print("Сумма четных от", K, "до", N, "=", summa)
''',
    "default_input": "1\n10"
}

tasks["2.48"] = {
    "title": "Задача 48. Сумма 1 + 1/2 + 1/3 + ... + 1/N",
    "code": '''N = int(input("Введите N: "))

summa = 0
for i in range(1, N + 1):
    summa += 1 / i

print("Сумма = {:.4f}".format(summa))
''',
    "default_input": "10"
}

tasks["2.49"] = {
    "title": "Задача 49. Список из 10 четных чисел (for)",
    "code": '''lst = [i * 2 for i in range(1, 11)]

for num in lst:
    print(num, end=" ")
print()
''',
    "default_input": ""
}

tasks["2.50"] = {
    "title": "Задача 50. Срез списка [2:4]",
    "code": '''lst = [10, 20, 30, 40, 50]
print("Исходный список:", lst)

srez = lst[2:5]
print("Срез от индекса 2 до 4:", srez)
''',
    "default_input": ""
}

tasks["2.51"] = {
    "title": "Задача 51. Список из 10 случайных чисел",
    "code": '''import random

lst = []
for i in range(10):
    lst.append(random.randint(1, 100))

print("Список:", lst)
''',
    "default_input": ""
}

tasks["2.52"] = {
    "title": "Задача 52. Удалить символы a, e, o из строки",
    "code": '''s = input("Введите строку: ")
lst = list(s)

for ch in ['a', 'e', 'o']:
    while ch in lst:
        lst.remove(ch)

print("Результат:", ''.join(lst))
''',
    "default_input": "hello world"
}

tasks["2.53"] = {
    "title": "Задача 53. Удалить элементы первого списка из второго",
    "code": '''lst1 = [1, 2, 3]
lst2 = [1, 4, 2, 5, 3, 6]

print("Список 1:", lst1)
print("Список 2:", lst2)

for el in lst1:
    while el in lst2:
        lst2.remove(el)

print("Результат:", lst2)
''',
    "default_input": ""
}

tasks["2.54"] = {
    "title": "Задача 54. Наибольший элемент в списке",
    "code": '''import random

lst = [random.randint(1, 100) for _ in range(10)]
print("Список:", lst)

max_val = lst[0]
for el in lst:
    if el > max_val:
        max_val = el

print("Максимум:", max_val)
''',
    "default_input": ""
}

tasks["2.55"] = {
    "title": "Задача 55. Наименьший элемент в списке",
    "code": '''import random

lst = [random.randint(1, 100) for _ in range(10)]
print("Список:", lst)

min_val = lst[0]
for el in lst:
    if el < min_val:
        min_val = el

print("Минимум:", min_val)
''',
    "default_input": ""
}

tasks["2.56"] = {
    "title": "Задача 56. Сумма элементов списка",
    "code": '''lst = [10, 20, 30, 40, 50]
print("Список:", lst)

summa = 0
for el in lst:
    summa += el

print("Сумма:", summa)
''',
    "default_input": ""
}

tasks["2.57"] = {
    "title": "Задача 57. Среднее арифметическое элементов списка",
    "code": '''lst = [10, 20, 30, 40, 50]
print("Список:", lst)

summa = 0
for el in lst:
    summa += el

avg = summa / len(lst)
print("Среднее арифметическое:", avg)
''',
    "default_input": ""
}

tasks["2.58"] = {
    "title": "Задача 58. Функция: площадь круга",
    "code": '''import math

def area_circle(radius):
    return math.pi * radius ** 2

r = float(input("Введите радиус: "))
print("Площадь круга:", round(area_circle(r), 2))
''',
    "default_input": "5"
}

tasks["2.59"] = {
    "title": "Задача 59. Функция: делится ли на 3",
    "code": '''def divisible_by_3(n):
    return n % 3 == 0

num = int(input("Введите число: "))
result = divisible_by_3(num)
print("Делится на 3:", result)
''',
    "default_input": "9"
}

tasks["2.60"] = {
    "title": "Задача 60. Функция: максимум в списке",
    "code": '''def find_max(lst):
    max_val = lst[0]
    for el in lst:
        if el > max_val:
            max_val = el
    return max_val

lst = [34, 12, 78, 5, 99, 23]
print("Список:", lst)
print("Максимум:", find_max(lst))
''',
    "default_input": ""
}

tasks["2.61"] = {
    "title": "Задача 61. Функция: количество четных",
    "code": '''def count_even(lst):
    count = 0
    for el in lst:
        if el % 2 == 0:
            count += 1
    return count

lst = [1, 2, 3, 4, 5, 6, 7, 8]
print("Список:", lst)
print("Четных элементов:", count_even(lst))
''',
    "default_input": ""
}

tasks["2.62"] = {
    "title": "Задача 62. Функция: уникальные элементы",
    "code": '''def unique(lst):
    result = []
    for el in lst:
        if el not in result:
            result.append(el)
    return result

lst = [1, 2, 3, 2, 1, 4, 5, 3, 6]
print("Исходный список:", lst)
print("Уникальные:", unique(lst))
''',
    "default_input": ""
}

# ==================== РАЗДЕЛ 3: ООП задачи (1-7) ====================

tasks["3.1"] = {
    "title": "Задача 1. Классы фигур (прямоугольник, круг, треугольник)",
    "code": '''import math

class Figura:
    def area(self):
        return 0
    def perimeter(self):
        return 0
    def info(self):
        print("Фигура:", self.__class__.__name__)
        print("  Площадь:", round(self.area(), 2))
        print("  Периметр:", round(self.perimeter(), 2))

class Pryamougolnik(Figura):
    def __init__(self, a, b):
        self.a = a
        self.b = b
    def area(self):
        return self.a * self.b
    def perimeter(self):
        return 2 * (self.a + self.b)

class Krug(Figura):
    def __init__(self, r):
        self.r = r
    def area(self):
        return math.pi * self.r ** 2
    def perimeter(self):
        return 2 * math.pi * self.r

class Treugolnik(Figura):
    def __init__(self, a, b, c):
        self.a = a
        self.b = b
        self.c = c
    def area(self):
        p = (self.a + self.b + self.c) / 2
        return math.sqrt(p * (p - self.a) * (p - self.b) * (p - self.c))
    def perimeter(self):
        return self.a + self.b + self.c

figures = [
    Pryamougolnik(5, 3),
    Krug(4),
    Treugolnik(3, 4, 5)
]

for fig in figures:
    fig.info()
    print()
''',
    "default_input": ""
}

tasks["3.2"] = {
    "title": "Задача 2. Классы изданий (книга, статья, эл. ресурс)",
    "code": '''class Izdanie:
    def __init__(self, name, author):
        self.name = name
        self.author = author
    def info(self):
        print("Название:", self.name, "| Автор:", self.author)
    def is_match(self, author):
        return self.author.lower() == author.lower()

class Kniga(Izdanie):
    def __init__(self, name, author, year, publisher):
        super().__init__(name, author)
        self.year = year
        self.publisher = publisher
    def info(self):
        print("[Книга]", self.name, "|", self.author, "|", self.year, "|", self.publisher)

class Statya(Izdanie):
    def __init__(self, name, author, journal, number, year):
        super().__init__(name, author)
        self.journal = journal
        self.number = number
        self.year = year
    def info(self):
        print("[Статья]", self.name, "|", self.author, "|", self.journal, "№" + str(self.number), "|", self.year)

class ElResurs(Izdanie):
    def __init__(self, name, author, url, annotation):
        super().__init__(name, author)
        self.url = url
        self.annotation = annotation
    def info(self):
        print("[Эл. ресурс]", self.name, "|", self.author, "|", self.url)
        print("  Аннотация:", self.annotation)

editions = [
    Kniga("Python для начинающих", "Иванов", 2022, "Питер"),
    Statya("ООП в Python", "Петров", "Программист", 5, 2023),
    ElResurs("Курс Python", "Иванов", "https://example.com", "Онлайн-курс по Python")
]

print("=== Все издания ===")
for ed in editions:
    ed.info()
    print()

search = input("Поиск по фамилии автора: ")
print("\\n=== Результаты поиска ===")
found = False
for ed in editions:
    if ed.is_match(search):
        ed.info()
        found = True
if not found:
    print("Ничего не найдено")
''',
    "default_input": "Иванов"
}

tasks["3.3"] = {
    "title": "Задача 3. Классы треугольников",
    "code": '''import math

class Treugolnik:
    def __init__(self, a, b, angle):
        self.a = a
        self.b = b
        self.angle = angle
    def third_side(self):
        rad = math.radians(self.angle)
        return math.sqrt(self.a**2 + self.b**2 - 2*self.a*self.b*math.cos(rad))
    def area(self):
        rad = math.radians(self.angle)
        return 0.5 * self.a * self.b * math.sin(rad)
    def perimeter(self):
        return self.a + self.b + self.third_side()
    def info(self):
        print("Тип:", self.__class__.__name__)
        print("  Стороны:", round(self.a, 2), round(self.b, 2), round(self.third_side(), 2))
        print("  Площадь:", round(self.area(), 2))
        print("  Периметр:", round(self.perimeter(), 2))

class Pryamougolny(Treugolnik):
    def __init__(self, a, b):
        super().__init__(a, b, 90)

class Ravnobedren(Treugolnik):
    def __init__(self, a, angle):
        super().__init__(a, a, angle)

class Ravnostoron(Treugolnik):
    def __init__(self, a):
        super().__init__(a, a, 60)

triangles = [
    Pryamougolny(3, 4),
    Ravnobedren(5, 40),
    Ravnostoron(6)
]

for t in triangles:
    t.info()
    print()
''',
    "default_input": ""
}

tasks["3.4"] = {
    "title": "Задача 4. Классы тел (параллелепипед, шар, пирамида)",
    "code": '''import math

class Telo:
    def surface_area(self):
        return 0
    def volume(self):
        return 0
    def info(self):
        print("Тело:", self.__class__.__name__)
        print("  Площадь поверхности:", round(self.surface_area(), 2))
        print("  Объем:", round(self.volume(), 2))

class Parallelepiped(Telo):
    def __init__(self, a, b, c):
        self.a = a
        self.b = b
        self.c = c
    def surface_area(self):
        return 2 * (self.a*self.b + self.b*self.c + self.a*self.c)
    def volume(self):
        return self.a * self.b * self.c

class Shar(Telo):
    def __init__(self, r):
        self.r = r
    def surface_area(self):
        return 4 * math.pi * self.r ** 2
    def volume(self):
        return (4/3) * math.pi * self.r ** 3

class Piramida(Telo):
    def __init__(self, a, h):
        self.a = a
        self.h = h
    def surface_area(self):
        l = math.sqrt((self.a/2)**2 + self.h**2)
        return self.a**2 + 2 * self.a * l
    def volume(self):
        return (1/3) * self.a**2 * self.h

bodies = [
    Parallelepiped(3, 4, 5),
    Shar(3),
    Piramida(4, 6)
]

for body in bodies:
    body.info()
    print()
''',
    "default_input": ""
}

tasks["3.5"] = {
    "title": "Задача 5. Классы уравнений (линейное, квадратное)",
    "code": '''import math

class Uravnenie:
    def solve(self):
        return []
    def info(self):
        print("Тип:", self.__class__.__name__)

class Lineynoe(Uravnenie):
    def __init__(self, a, b):
        self.a = a
        self.b = b
    def solve(self):
        if self.a == 0:
            return []
        return [-self.b / self.a]
    def info(self):
        print(f"Линейное: {self.a}x + {self.b} = 0")
        roots = self.solve()
        if roots:
            print("  Корень: x =", round(roots[0], 4))
        else:
            print("  Нет корней")

class Kvadratnoe(Uravnenie):
    def __init__(self, a, b, c):
        self.a = a
        self.b = b
        self.c = c
    def solve(self):
        D = self.b**2 - 4*self.a*self.c
        if D < 0:
            return []
        elif D == 0:
            return [-self.b / (2*self.a)]
        else:
            x1 = (-self.b + math.sqrt(D)) / (2*self.a)
            x2 = (-self.b - math.sqrt(D)) / (2*self.a)
            return [x1, x2]
    def info(self):
        print(f"Квадратное: {self.a}x² + {self.b}x + {self.c} = 0")
        roots = self.solve()
        if len(roots) == 2:
            print(f"  x1 = {round(roots[0], 4)}, x2 = {round(roots[1], 4)}")
        elif len(roots) == 1:
            print(f"  x = {round(roots[0], 4)}")
        else:
            print("  Нет действительных корней")

equations = [
    Lineynoe(2, -6),
    Lineynoe(0, 5),
    Kvadratnoe(1, -5, 6),
    Kvadratnoe(1, 2, 5)
]

for eq in equations:
    eq.info()
    print()
''',
    "default_input": ""
}

tasks["3.6"] = {
    "title": "Задача 6. Классы валют (доллар, евро)",
    "code": '''class Valuta:
    def __init__(self, amount, rate):
        self.amount = amount
        self.rate = rate
    def to_rubles(self):
        return self.amount * self.rate
    def info(self):
        print(self.__class__.__name__ + ":", self.amount, "-> в рублях:", round(self.to_rubles(), 2))

class Dollar(Valuta):
    def __init__(self, amount):
        super().__init__(amount, 92.5)

class Euro(Valuta):
    def __init__(self, amount):
        super().__init__(amount, 100.2)

currencies = [
    Dollar(100),
    Euro(50),
    Dollar(250),
    Euro(75)
]

for cur in currencies:
    cur.info()

total = sum(c.to_rubles() for c in currencies)
print("\\nОбщая сумма в рублях:", round(total, 2))
''',
    "default_input": ""
}

tasks["3.7"] = {
    "title": "Задача 7. Классы прогрессий (арифметическая, геометрическая)",
    "code": '''class Progressiya:
    def __init__(self, a1, n):
        self.a1 = a1
        self.n = n
    def element(self, j):
        return 0
    def summa(self):
        return 0
    def info(self):
        print(self.__class__.__name__)
        print("  Сумма первых", self.n, "членов:", round(self.summa(), 4))

class Arifmeticheskaya(Progressiya):
    def __init__(self, a1, d, n):
        super().__init__(a1, n)
        self.d = d
    def element(self, j):
        return self.a1 + (j - 1) * self.d
    def summa(self):
        return (self.n / 2) * (2 * self.a1 + (self.n - 1) * self.d)
    def info(self):
        print(f"Арифметическая прогрессия: a1={self.a1}, d={self.d}, n={self.n}")
        print("  Сумма:", round(self.summa(), 4))

class Geometricheskaya(Progressiya):
    def __init__(self, a1, q, n):
        super().__init__(a1, n)
        self.q = q
    def element(self, j):
        return self.a1 * self.q ** (j - 1)
    def summa(self):
        if self.q == 1:
            return self.a1 * self.n
        return self.a1 * (self.q ** self.n - 1) / (self.q - 1)
    def info(self):
        print(f"Геометрическая прогрессия: a1={self.a1}, q={self.q}, n={self.n}")
        print("  Сумма:", round(self.summa(), 4))

progressions = [
    Arifmeticheskaya(1, 2, 10),
    Geometricheskaya(1, 2, 10),
    Arifmeticheskaya(3, 5, 8),
    Geometricheskaya(2, 3, 5)
]

for prog in progressions:
    prog.info()
    print()
''',
    "default_input": ""
}


# ==================== TKINTER ПРИЛОЖЕНИЕ ====================

class App:
    def __init__(self, root):
        self.root = root
        self.root.title("Лабораторные работы - Python")
        self.root.geometry("1200x700")

        top_frame = tk.Frame(root)
        top_frame.pack(fill=tk.X, padx=5, pady=5)

        tk.Label(top_frame, text="Выберите раздел:").pack(side=tk.LEFT)

        self.section_var = tk.StringVar(value="Раздел 2")
        sections = ["Раздел 2", "Раздел 3"]
        self.section_combo = ttk.Combobox(top_frame, textvariable=self.section_var, values=sections, state="readonly", width=15)
        self.section_combo.pack(side=tk.LEFT, padx=5)
        self.section_combo.bind("<<ComboboxSelected>>", self.update_task_list)

        tk.Label(top_frame, text="Задача:").pack(side=tk.LEFT, padx=(15, 0))

        self.task_var = tk.StringVar()
        self.task_combo = ttk.Combobox(top_frame, textvariable=self.task_var, state="readonly", width=60)
        self.task_combo.pack(side=tk.LEFT, padx=5)
        self.task_combo.bind("<<ComboboxSelected>>", self.show_task)

        self.run_btn = tk.Button(top_frame, text="Запустить", command=self.run_task, bg="#4CAF50", fg="white", padx=10)
        self.run_btn.pack(side=tk.LEFT, padx=10)

        main_frame = tk.Frame(root)
        main_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        left_frame = tk.LabelFrame(main_frame, text="Код")
        left_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=(0, 2))

        self.code_text = scrolledtext.ScrolledText(left_frame, wrap=tk.WORD, font=("Courier", 11))
        self.code_text.pack(fill=tk.BOTH, expand=True, padx=3, pady=3)

        right_frame = tk.LabelFrame(main_frame, text="Результат")
        right_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True, padx=(2, 0))

        self.input_label = tk.Label(right_frame, text="Входные данные (каждый ввод на новой строке):")
        self.input_label.pack(anchor=tk.W, padx=3)

        self.input_text = scrolledtext.ScrolledText(right_frame, wrap=tk.WORD, height=4, font=("Courier", 11))
        self.input_text.pack(fill=tk.X, padx=3, pady=2)

        tk.Label(right_frame, text="Вывод:").pack(anchor=tk.W, padx=3)

        self.output_text = scrolledtext.ScrolledText(right_frame, wrap=tk.WORD, font=("Courier", 11), bg="#1e1e1e", fg="#00ff00")
        self.output_text.pack(fill=tk.BOTH, expand=True, padx=3, pady=3)

        self.update_task_list()

    def update_task_list(self, event=None):
        section = self.section_var.get()
        prefix = "2." if section == "Раздел 2" else "3."

        filtered = {}
        for key, val in tasks.items():
            if key.startswith(prefix):
                filtered[key] = val

        sorted_keys = sorted(filtered.keys(), key=lambda k: int(k.split(".")[1]))
        self.current_keys = sorted_keys
        display = [f"{k}: {filtered[k]['title']}" for k in sorted_keys]
        self.task_combo['values'] = display
        if display:
            self.task_combo.current(0)
            self.show_task()

    def show_task(self, event=None):
        idx = self.task_combo.current()
        if idx < 0:
            return
        key = self.current_keys[idx]
        task = tasks[key]

        self.code_text.delete(1.0, tk.END)
        self.code_text.insert(tk.END, task["code"])

        self.input_text.delete(1.0, tk.END)
        self.input_text.insert(tk.END, task.get("default_input", ""))

        self.output_text.delete(1.0, tk.END)

    def run_task(self):
        idx = self.task_combo.current()
        if idx < 0:
            return
        key = self.current_keys[idx]
        task = tasks[key]
        code = task["code"]

        input_data = self.input_text.get(1.0, tk.END).strip()
        input_lines = input_data.split("\n") if input_data else []
        input_iter = iter(input_lines)

        old_stdin = sys.stdin
        old_stdout = sys.stdout

        output_buffer = io.StringIO()
        sys.stdout = output_buffer

        def mock_input(prompt=""):
            output_buffer.write(prompt)
            try:
                val = next(input_iter)
                output_buffer.write(val + "\n")
                return val
            except StopIteration:
                output_buffer.write("[нет данных]\n")
                return ""

        try:
            exec(code, {"__builtins__": __builtins__, "input": mock_input, "print": print})
        except Exception as e:
            output_buffer.write(f"\nОшибка: {e}\n")

        sys.stdout = old_stdout
        sys.stdin = old_stdin

        result = output_buffer.getvalue()
        self.output_text.delete(1.0, tk.END)
        self.output_text.insert(tk.END, result)


if __name__ == "__main__":
    root = tk.Tk()
    app = App(root)
    root.mainloop()
