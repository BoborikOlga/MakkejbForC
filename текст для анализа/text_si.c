#include "stdio.h"
#include "StdAfx.h"
#include <Windows.h> 

struct hardware_info    // ������ ���������

{
    char cpu_type[20];
    int year;
    int mem;
    int hdd;
    struct hardware_info *next;
};
typedef struct hardware_info item; // ����������� �������� � ������ ���������


int cmp(item *a, item *b, int field) // �-� ���������� ����� �������� �����������

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
item* sort_list(item *list, int field) // �-� ����������

{
    item *p, *q, *e, *tail;
    int insize, nmerges, psize, qsize, i;
    insize = 1;
    while (1)
    {
        p = list;
        list = NULL; // �������� ������

        tail = NULL; // ������������ ������


        nmerges = 0; //������� ����� �������

        while (p) // ��������� ���� p ����������

        {
            nmerges++; // ������� �������

            q = p;
            psize = 0;
            for (i = 0; i < insize; i++)
            {
                psize++;
                q = q->next;
                if (!q) break; // ���� ���� q  ���������� �������

            }

            qsize = insize;
            while (psize > 0 || (qsize > 0 && q)) // ���� ���������� 2 ������ ���������� ��

            {
                if (psize == 0) // ���� p ���� �� � ����� �� q

                {
                    e = q;
                    q = q->next;
                    qsize--;
                }
                else if (qsize == 0 || !q) // ���� q ���� �� � ����� �� p

                {
                    e = p;
                    p = p->next;
                    psize--;
                }
                else if (cmp(p, q, field) <= 0) // ������� ���� ������� �� ������� ����� �����������, � ������ ����� ���� ���� �������� (����� ���� ������)

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
                if (tail) // ��������� ���� ������ � ����� ������ ���� �� ����

                {
                    tail->next = e;
                }
                else
                {
                    list = e; //���� ��� �� ��������� ������� � �������� ������

                }
                tail = e;
            }
            p = q;
        }
        tail->next = NULL;
        if (nmerges <= 1) return list; // ���� ������� ���� ������ ���� �� ����������� ����������

        insize = 2*insize; // ���� �� ����������� �� ����������� 2 ����

    }
}
void print_sorted_items(item *head, int sort_field, int max_year)   // �-� ������ ������

{
    FILE *o = NULL;
    item *t = sort_list(head, sort_field);
    o = fopen("print.txt","w");
    while(t)
    {
        if (t->year >= max_year)    // ��������� �� ������ ���� �������� ��������� ���

        {
            fprintf(o,"��� ����������: %s\n", t->cpu_type);
            fprintf(o,"���: %d\n", t->year);
            fprintf(o,"������ ������: %d\n", t->mem);
            fprintf(o,"������ HDD: %d\n\n", t->hdd);
        }
        t = t->next ; //�������� ����������� t

    }
}
void my_sorty(item *head) // ����� ���� ����������, � �������� ��� ���������� ����������

{
    char tmp[128];
    int year = 0;
    printf("������� ��� ����������: ������(m)/������ �������� �����(h)/���(y)");

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
            printf("������� ������������ ���: ");
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
    item *head = NULL; // ��������� �� ������ ������� ������

    FILE *f = NULL;
    int items = 0;
    char tmp[128];

    if(!(f = fopen("base.bd","a+")))
        printf("������ �������� �����\n");
    else if(!( t = (item *)malloc(sizeof(item)))) //�������� ������ ��� _����_ ������� ���������

        printf("������ ��������� ������\n");
    else
    {
        while(fread(t, (sizeof(item)-sizeof(item *)), 1, f)) //������ ���� � ������, �� ������ ��������, � ������������ ��� � t

        { 
	    // ���� ������ �� ��������� ������ ��������� ���
            // ����� ���� ���������� ���������
	    t->next  = head; // ���������� ���������� ������� � ���������

            head = t;
//          t = (item *)malloc(sizeof(item)); // �������� ������ ��� ����� �������

            if (!(t = (item *)malloc(sizeof(item))))
            {
                printf("������ ��������� ������\n");
                break;
            }
        }
        if (items == 0) // ���� ��������� �� ������� �� ����������� t

        {
            free(t);
        }
        else
        {
            printf("��������� %d �������.\n", items); // �������� ������� ��������� ������� �� �����

            printf("�������� ���� (d). ������������� (s) ��� �������� (a) ��������?");

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
                printf("���� �������.");
                free(t);
                items = 0;
            }
            else if (tmp[0]!='a')
            {
                printf("������ ����� ������\n");
                return 0;
            }
        }
        while(1)
        {
            printf("������� ����� ��������.\n");
            if (!(t = (item *)malloc(sizeof(item))))
            {
                printf("������ ��������� ������\n");
                return -1;
            }
            printf("������� ��� ����������: ");
            scanf("%s", t->cpu_type);
            printf("������� ���� ������������: ");
            scanf("%d", &t->year);
            printf("������� ������ ������: ");
            scanf("%d", &t->mem);
            printf("������� ������ HDD: ");
            scanf("%d", &t->hdd);
            printf("��� ��������� ����� ������� (f), ��� ����������� (a): ");
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
                printf("\n\n������ ����� ������, ��������� ���� ��������� ������.\n\n");
                free(t);
                continue;
            }
        }
        my_sorty(head);
        printf("%d ������� ���������.\n", items);
        printf("������ ��������� ��������.\n");
        fclose(f);
    }
    return 0;
}
