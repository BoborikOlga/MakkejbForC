#include "stdio.h"
#include "StdAfx.h"
#include <Windows.h> 

struct hardware_info    // Опишем структуру

{
    char cpu_type[20];
    int year;
    int mem;
    int hdd;
    struct hardware_info *next;
};
typedef struct hardware_info item; // Возможность работать с именем структуры


int cmp(item *a, item *b, int field) // ф-я сообщающая какие элементы сортировать

{
    if (field == 1)
    {
        return a->mem - b->mem;
    }
    else if (field == 2)
    {
        return a->hdd - b->hdd;
    }
    else
    {
        return a->year - b->year;
    }
}
item* sort_list(item *list, int field) // ф-я сортировки

{
    item *p, *q, *e, *tail;
    int insize, nmerges, psize, qsize, i;
    insize = 1;
    while (1)
    {
        p = list;
        list = NULL; // конечный список

        tail = NULL; // объединенный список


        nmerges = 0; //подсчет числа слияний

        while (p) // Исполняем пока p существует

        {
            nmerges++; // считаем слияния

            q = p;
            psize = 0;
            for (i = 0; i < insize; i++)
            {
                psize++;
                q = q->next;
                if (!q) break; // пока есть q  производим слияние

            }

            qsize = insize;
            while (psize > 0 || (qsize > 0 && q)) // пока существуют 2 списка объединяем их

            {
                if (psize == 0) // если p пуст то е берем из q

                {
                    e = q;
                    q = q->next;
                    qsize--;
                }
                else if (qsize == 0 || !q) // если q пуст то е берем из p

                {
                    e = p;
                    p = p->next;
                    psize--;
                }
                else if (cmp(p, q, field) <= 0) // предаем поля которые по которым будем сортировать, и узнаем какое поле куда сдвигать (какое поле меньше)

                {
                    e = p;
                    p = p->next;
                    psize--;
                }
                else
                {
                    e = q;
                    q = q->next;
                    qsize--;
                }
                if (tail) // добавляем след элемет в общий список если он есть

                {
                    tail->next = e;
                }
                else
                {
                    list = e; //если нет то добавляем элемент в конечный список

                }
                tail = e;
            }
            p = q;
        }
        tail->next = NULL;
        if (nmerges <= 1) return list; // если слияние было только одно то заканчиваем сортировку

        insize = 2*insize; // если не выполняется то сортировать 2 раза

    }
}
void print_sorted_items(item *head, int sort_field, int max_year)   // Ф-я Вывода данных

{
    FILE *o = NULL;
    item *t = sort_list(head, sort_field);
    o = fopen("print.txt","w");
    while(t)
    {
        if (t->year >= max_year)    // проверяем до какого года печатать сравнивая год

        {
            fprintf(o,"Тип процессора: %s\n", t->cpu_type);
            fprintf(o,"Год: %d\n", t->year);
            fprintf(o,"Размер памяти: %d\n", t->mem);
            fprintf(o,"Размер HDD: %d\n\n", t->hdd);
        }
        t = t->next ; //сдвигаем считываемое t

    }
}
void my_sorty(item *head) // Выбор типа сортировки, и передача для дальнейшей сортировки

{
    char tmp[128];
    int year = 0;
    printf("Введите тип сортировки: память(m)/размер жесткого диска(h)/год(y)");

    if (scanf("%s", tmp))
    {
        if (tmp[0] == 'm')
        {
            print_sorted_items(head, 1, 0);
        }
        else if (tmp[0] == 'h')
        {
            print_sorted_items(head, 2, 0);
        }
        else
        {
            printf("Введите максимальный год: ");
            if (scanf("%d", &year))
            {
                print_sorted_items(head, 3, year);
            }
        }
    }
}

main()
{
    SetConsoleOutputCP(1251);
    SetConsoleCP(1251);
    item *t;
    item *head = NULL; // указатель на первый элемент списка

    FILE *f = NULL;
    int items = 0;
    char tmp[128];

    if(!(f = fopen("base.bd","a+")))
        printf("Ошибка открытия файла\n");
    else if(!( t = (item *)malloc(sizeof(item)))) //выделяем память под _один_ элемент структуры

        printf("Ошибка выделения памяти\n");
    else
    {
        while(fread(t, (sizeof(item)-sizeof(item *)), 1, f)) //Читаем файл в память, по одному элементу, и расспологаем его в t

        { 
	    // Если чтение не выполнено значит элементов нет
            // ведем счет прочитаных элементов
	    t->next  = head; // записываем прочитаный элемент в структуру

            head = t;
//          t = (item *)malloc(sizeof(item)); // выделяем память под новый элемент

            if (!(t = (item *)malloc(sizeof(item))))
            {
                printf("Ошибка выделения памяти\n");
                break;
            }
        }
        if (items == 0) // если элементов не найдено то освобаждаем t

        {
            free(t);
        }
        else
        {
            printf("Прочитано %d записей.\n", items); // Печатаем сколько прочитано записей из файла

            printf("Очистить базу (d). Отсортировать (s) или добавить (a) элементы?");

            scanf("%s", tmp);
            if (tmp[0]=='s')
            {
                my_sorty(head);
                fclose(f);
                return 0;
            }
            else if (tmp[0]=='d')
            {
                f = fopen("base.bd","w");
                printf("База очищена.");
                free(t);
                items = 0;
            }
            else if (tmp[0]!='a')
            {
                printf("Ошибка ввода данных\n");
                return 0;
            }
        }
        while(1)
        {
            printf("Добавте новые значения.\n");
            if (!(t = (item *)malloc(sizeof(item))))
            {
                printf("Ошибка выделения памяти\n");
                return -1;
            }
            printf("Введите тип Процессора: ");
            scanf("%s", t->cpu_type);
            printf("Введите дату производства: ");
            scanf("%d", &t->year);
            printf("Введите размер памяти: ");
            scanf("%d", &t->mem);
            printf("Введите размер HDD: ");
            scanf("%d", &t->hdd);
            printf("Для окончания ввода нажмите (f), для продолжения (a): ");
            scanf("%s", tmp);
            if (tmp[0] == 'f')
            {
                fwrite(t, (sizeof(item)-sizeof(item *)), 1, f);
                t->next  = head;
                head = t;
                items += 1;
                break;
            }
            else if (tmp[0]== 'a')
            {
                fwrite(t, (sizeof(item)-sizeof(item *)), 1, f);
                t->next  = head;
                head = t;
                items += 1;
            }
            else
            {
                printf("\n\nОшибка ввода данных, повторите ввод последник данных.\n\n");
                free(t);
                continue;
            }
        }
        my_sorty(head);
        printf("%d записей сохранено.\n", items);
        printf("Работа программы окончена.\n");
        fclose(f);
    }
    return 0;
}
