import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch
import os

OUT_DIR = os.path.join(os.path.dirname(__file__), "block_schemes")
os.makedirs(OUT_DIR, exist_ok=True)

def new_fig(title, h=12, w=6):
    fig, ax = plt.subplots(figsize=(w, h))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, h)
    ax.set_aspect('equal')
    ax.axis('off')
    ax.set_title(title, fontsize=13, fontweight='bold', pad=10)
    return fig, ax

def oval(ax, cx, cy, text, w=2.4, h=0.6):
    e = patches.Ellipse((cx, cy), w, h, facecolor='#e8f5e9', edgecolor='black', lw=1.5)
    ax.add_patch(e)
    ax.text(cx, cy, text, ha='center', va='center', fontsize=10, fontweight='bold')
    return cy

def rect(ax, cx, cy, text, w=3.2, h=0.7):
    r = FancyBboxPatch((cx - w/2, cy - h/2), w, h, boxstyle="round,pad=0.05",
                        facecolor='#e3f2fd', edgecolor='black', lw=1.5)
    ax.add_patch(r)
    ax.text(cx, cy, text, ha='center', va='center', fontsize=9)
    return cy

def para(ax, cx, cy, text, w=3.2, h=0.7):
    dx = 0.3
    xs = [cx - w/2 + dx, cx + w/2 + dx, cx + w/2 - dx, cx - w/2 - dx]
    ys = [cy - h/2, cy - h/2, cy + h/2, cy + h/2]
    ax.fill(xs, ys, facecolor='#fff9c4', edgecolor='black', lw=1.5)
    ax.text(cx, cy, text, ha='center', va='center', fontsize=9)
    return cy

def diamond(ax, cx, cy, text, w=3.0, h=1.0):
    xs = [cx, cx + w/2, cx, cx - w/2]
    ys = [cy + h/2, cy, cy - h/2, cy]
    ax.fill(xs, ys, facecolor='#fce4ec', edgecolor='black', lw=1.5)
    ax.text(cx, cy, text, ha='center', va='center', fontsize=8)
    return cy

def arrow(ax, x1, y1, x2, y2, label=""):
    ax.annotate("", xy=(x2, y2), xytext=(x1, y1),
                arrowprops=dict(arrowstyle='->', lw=1.2, color='black'))
    if label:
        mx, my = (x1+x2)/2, (y1+y2)/2
        ax.text(mx + 0.15, my, label, fontsize=8, color='red')

def save(fig, name):
    fig.savefig(os.path.join(OUT_DIR, name), dpi=150, bbox_inches='tight', facecolor='white')
    plt.close(fig)
    print(f"  Saved: {name}")


# Задача 4 (Рисунок 1): Линейный алгоритм — перестановка значений D:=C, C:=B, B:=A
def r1_z4():
    fig, ax = new_fig("Раздел 1. Задача 4\nПерестановка значений (Рисунок 1)", h=12)
    cx = 5
    oval(ax, cx, 11, "Начало")
    arrow(ax, cx, 10.7, cx, 10.1)
    para(ax, cx, 9.8, "Ввод: A, B, C, D")
    arrow(ax, cx, 9.45, cx, 8.55)
    rect(ax, cx, 8.2, "D := C")
    arrow(ax, cx, 7.85, cx, 7.25)
    rect(ax, cx, 6.9, "C := B")
    arrow(ax, cx, 6.55, cx, 5.95)
    rect(ax, cx, 5.6, "B := A")
    arrow(ax, cx, 5.25, cx, 4.65)
    para(ax, cx, 4.3, "Вывод: A, B, C, D")
    arrow(ax, cx, 3.95, cx, 3.35)
    oval(ax, cx, 3.1, "Конец")
    save(fig, "r1_z4.png")


# Задача 12 (Рисунок 2): x > 0 → y=2x, иначе y=-2x
def r1_z12():
    fig, ax = new_fig("Раздел 1. Задача 12\nВетвление (Рисунок 2)", h=13)
    cx = 5
    oval(ax, cx, 12, "Начало")
    arrow(ax, cx, 11.7, cx, 11.1)
    para(ax, cx, 10.8, "Ввод: x")
    arrow(ax, cx, 10.45, cx, 9.55)
    diamond(ax, cx, 9.0, "x > 0 ?")
    arrow(ax, 3.5, 9.0, 2.5, 8.0, "Да")
    arrow(ax, 6.5, 9.0, 7.5, 8.0, "Нет")
    rect(ax, 2.5, 7.6, "y = 2x", w=2.2)
    rect(ax, 7.5, 7.6, "y = -2x", w=2.2)
    arrow(ax, 2.5, 7.25, cx, 6.3)
    arrow(ax, 7.5, 7.25, cx, 6.3)
    para(ax, cx, 5.9, "Вывод: y")
    arrow(ax, cx, 5.55, cx, 4.95)
    oval(ax, cx, 4.7, "Конец")
    save(fig, "r1_z12.png")


# Задача 13 (Рисунок 3): n>0 → "n-полож.", n<0 → "n-отриц.", n=0 → "n=0"
def r1_z13():
    fig, ax = new_fig("Раздел 1. Задача 13\nОпределение знака числа (Рисунок 3)", h=14)
    cx = 5
    oval(ax, cx, 13, "Начало")
    arrow(ax, cx, 12.7, cx, 12.1)
    para(ax, cx, 11.8, "Ввод: n")
    arrow(ax, cx, 11.45, cx, 10.55)
    diamond(ax, cx, 10.0, "n > 0 ?")
    arrow(ax, 3.5, 10.0, 2, 9.0, "Да")
    arrow(ax, 6.5, 10.0, 7.5, 9.0, "Нет")
    para(ax, 2, 8.6, "\"n-полож.\"", w=2.5)
    diamond(ax, 7.5, 8.5, "n < 0 ?", w=2.5, h=0.8)
    arrow(ax, 6.25, 8.5, 5, 7.5, "Да")
    arrow(ax, 8.75, 8.5, 9, 7.5, "Нет")
    para(ax, 5, 7.1, "\"n-отриц.\"", w=2.5)
    para(ax, 9, 7.1, "\"n=0\"", w=1.8)
    arrow(ax, 2, 8.25, cx, 6.0)
    arrow(ax, 5, 6.75, cx, 6.0)
    arrow(ax, 9, 6.75, cx, 6.0)
    oval(ax, cx, 5.6, "Конец")
    save(fig, "r1_z13.png")


# Задача 17 (Рисунок 4): Ввод x,y → x=0? → Да: Ошибка, Нет: z=y/x → Вывод
def r1_z17():
    fig, ax = new_fig("Раздел 1. Задача 17\nДеление y/x (Рисунок 4)", h=13)
    cx = 5
    oval(ax, cx, 12, "Начало")
    arrow(ax, cx, 11.7, cx, 11.1)
    para(ax, cx, 10.8, "Ввод: x, y")
    arrow(ax, cx, 10.45, cx, 9.55)
    diamond(ax, cx, 9.0, "x = 0 ?")
    arrow(ax, 3.5, 9.0, 2.5, 8.0, "Да")
    arrow(ax, 6.5, 9.0, 7.5, 8.0, "Нет")
    para(ax, 2.5, 7.6, "Ошибка!", w=2.2)
    rect(ax, 7.5, 7.6, "z = y / x", w=2.2)
    arrow(ax, 7.5, 7.25, cx, 6.3)
    arrow(ax, 2.5, 7.25, cx, 6.3)
    para(ax, cx, 5.9, "Вывод: x, y, z")
    arrow(ax, cx, 5.55, cx, 4.95)
    oval(ax, cx, 4.7, "Конец")
    save(fig, "r1_z17.png")


# Задача 18 (Рисунок 5): A=B → C=A+B, F=B+C | иначе B>C → A=A+B, F=A+C | иначе B=C+B, F=A+B
def r1_z18():
    fig, ax = new_fig("Раздел 1. Задача 18\nАлгоритм с A, B, C (Рисунок 5)", h=16, w=8)
    ax.set_xlim(0, 14)
    cx = 7
    oval(ax, cx, 15, "Начало")
    arrow(ax, cx, 14.7, cx, 14.1)
    para(ax, cx, 13.8, "Ввод: A, B, C")
    arrow(ax, cx, 13.45, cx, 12.55)
    diamond(ax, cx, 12.0, "A = B ?")
    arrow(ax, 5.5, 12.0, 3, 11.0, "+")
    arrow(ax, 8.5, 12.0, 10.5, 11.0, "-")
    rect(ax, 2.2, 10.6, "C = A + B", w=2.2)
    rect(ax, 4.2, 10.6, "F = B + C", w=2.2)
    diamond(ax, 10.5, 10.5, "B > C ?", w=2.5, h=0.9)
    arrow(ax, 9.25, 10.5, 7.5, 9.3, "+")
    arrow(ax, 11.75, 10.5, 13, 9.3, "-")
    rect(ax, 6.7, 8.9, "A = A + B", w=2.2)
    rect(ax, 8.9, 8.9, "F = A + C", w=2.2)
    rect(ax, 12.2, 8.9, "B = C + B", w=2.2)
    rect(ax, 14.2, 8.9, "F = A + B", w=2.2)
    # merge arrows
    arrow(ax, 3, 10.25, cx, 7.5)
    arrow(ax, 7.8, 8.55, cx, 7.5)
    arrow(ax, 13, 8.55, cx, 7.5)
    para(ax, cx, 7.1, "Вывод: F")
    arrow(ax, cx, 6.75, cx, 6.15)
    oval(ax, cx, 5.9, "Конец")
    save(fig, "r1_z18.png")


# Задача 19: y = (2x - 1) / (3x), если x > 0
def r1_z19():
    fig, ax = new_fig("Раздел 1. Задача 19\ny = (2x-1) / (3x), если x > 0", h=14)
    cx = 5
    oval(ax, cx, 13, "Начало")
    arrow(ax, cx, 12.7, cx, 12.1)
    para(ax, cx, 11.8, "Ввод: x")
    arrow(ax, cx, 11.45, cx, 10.55)
    diamond(ax, cx, 10.0, "x > 0 ?")
    arrow(ax, 3.5, 10.0, 2.5, 9.0, "Да")
    arrow(ax, 6.5, 10.0, 7.5, 9.0, "Нет")
    rect(ax, 2.5, 8.6, "y = (2x-1)/(3x)", w=3.0)
    para(ax, 7.5, 8.6, "Ошибка: x <= 0", w=2.8)
    arrow(ax, 2.5, 8.25, 2.5, 7.55)
    para(ax, 2.5, 7.2, "Вывод: y", w=2)
    arrow(ax, 2.5, 6.85, cx, 5.9)
    arrow(ax, 7.5, 8.25, cx, 5.9)
    oval(ax, cx, 5.5, "Конец")
    save(fig, "r1_z19.png")


# Задача 20: R = a/b - c/d, если b > 0 и d > 0
def r1_z20():
    fig, ax = new_fig("Раздел 1. Задача 20\nR = a/b - c/d (b>0, d>0)", h=14)
    cx = 5
    oval(ax, cx, 13, "Начало")
    arrow(ax, cx, 12.7, cx, 12.1)
    para(ax, cx, 11.8, "Ввод: a, b, c, d")
    arrow(ax, cx, 11.45, cx, 10.55)
    diamond(ax, cx, 10.0, "b > 0 и d > 0 ?")
    arrow(ax, 3.5, 10.0, 2.5, 9.0, "Да")
    arrow(ax, 6.5, 10.0, 7.5, 9.0, "Нет")
    rect(ax, 2.5, 8.6, "R = a/b - c/d", w=2.8)
    para(ax, 7.5, 8.6, "Ошибка!", w=2)
    arrow(ax, 2.5, 8.25, 2.5, 7.55)
    para(ax, 2.5, 7.2, "Вывод: R", w=2)
    arrow(ax, 2.5, 6.85, cx, 5.9)
    arrow(ax, 7.5, 8.25, cx, 5.9)
    oval(ax, cx, 5.5, "Конец")
    save(fig, "r1_z20.png")


# Задача 21 (Рисунок 6): Цикл — S=0, k=n, while k>2: S=S+k, k=k-1
def r1_z21():
    fig, ax = new_fig("Раздел 1. Задача 21\nЦикл: сумма от 3 до n (Рисунок 6)", h=15)
    cx = 5
    oval(ax, cx, 14, "Начало")
    arrow(ax, cx, 13.7, cx, 13.1)
    para(ax, cx, 12.8, "Ввод: n")
    arrow(ax, cx, 12.45, cx, 11.85)
    rect(ax, cx, 11.5, "S = 0")
    arrow(ax, cx, 11.15, cx, 10.55)
    rect(ax, cx, 10.2, "k = n")
    arrow(ax, cx, 9.85, cx, 9.2)
    diamond(ax, cx, 8.7, "k > 2 ?")
    arrow(ax, 6.5, 8.7, 8, 8.7, "Нет")
    arrow(ax, cx, 8.2, cx, 7.55)
    ax.text(cx + 0.2, 8.0, "Да", fontsize=8, color='red')
    rect(ax, cx, 7.2, "S = S + k")
    arrow(ax, cx, 6.85, cx, 6.25)
    rect(ax, cx, 5.9, "k = k - 1")
    # loop back
    arrow(ax, cx, 5.55, 2.5, 5.55)
    ax.annotate("", xy=(2.5, 8.7), xytext=(2.5, 5.55),
                arrowprops=dict(arrowstyle='->', lw=1.2, color='black'))
    ax.annotate("", xy=(3.5, 8.7), xytext=(2.5, 8.7),
                arrowprops=dict(arrowstyle='->', lw=1.2, color='black'))
    # "Нет" branch
    para(ax, 8, 8.3, "Вывод: S", w=2.2)
    arrow(ax, 8, 7.95, 8, 7.35)
    oval(ax, 8, 7.1, "Конец")
    save(fig, "r1_z21.png")


# Задача 22 (Рисунок 7): Ввод a,b → a>b? → +: Y:=b, -: Y:=a → Вывод (нахождение min)
def r1_z22():
    fig, ax = new_fig("Раздел 1. Задача 22\nНахождение min(a,b) (Рисунок 7)", h=13)
    cx = 5
    oval(ax, cx, 12, "Начало")
    arrow(ax, cx, 11.7, cx, 11.1)
    para(ax, cx, 10.8, "Ввод: a, b")
    arrow(ax, cx, 10.45, cx, 9.55)
    diamond(ax, cx, 9.0, "a > b ?")
    arrow(ax, 3.5, 9.0, 2.5, 8.0, "+")
    arrow(ax, 6.5, 9.0, 7.5, 8.0, "-")
    rect(ax, 2.5, 7.6, "Y := b", w=2.2)
    rect(ax, 7.5, 7.6, "Y := a", w=2.2)
    arrow(ax, 2.5, 7.25, cx, 6.3)
    arrow(ax, 7.5, 7.25, cx, 6.3)
    para(ax, cx, 5.9, "Вывод: Y")
    arrow(ax, cx, 5.55, cx, 4.95)
    oval(ax, cx, 4.7, "Конец")
    save(fig, "r1_z22.png")


print("=== Генерация исправленных блок-схем (раздел 1) ===")
r1_z4()
r1_z12()
r1_z13()
r1_z17()
r1_z18()
r1_z19()
r1_z20()
r1_z21()
r1_z22()
print("\nГотово! Обновлено 9 блок-схем.")
