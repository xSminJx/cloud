#include <iostream>
using namespace std;

struct Node {
	string data;
	Node* prev = 0, * next = 0;
	Node() {};
	Node(string s, Node* p, Node* n) : data(s), prev(p), next(n) {};
};
void ordered_insert(string item);
void remove_dup();
void print_list_twice();
Node* head = nullptr, * tail = nullptr; /* 2�� ���Ḯ��Ʈ�� ó���� ������ ��� */

int main() {
	int n;
	string word;
	cin >> n;
	for (int i = 0; i < n; i++) {
		cin >> word;
		ordered_insert(word);
	}
	print_list_twice();
	remove_dup();
	print_list_twice();
	return 0;
}
void ordered_insert(string item) {
	if (!head) { // ����Ʈ�� ����� ��
		tail = head = new Node(item, 0, 0);
		return;
	}
	Node* p = head;
	while (p) {
		if (item < p->data) { // p���� item�� ������ �տ� ��� ����
			if (p == head) head = head->prev = new Node(item, 0, head); // item�� �� ���� �� ��� ����
			else p->prev = p->prev->next = new Node(item, p->prev, p); // ���� ���
			return;
		}
		p = p->next;
	}
	tail = tail->next = new Node(item, tail, 0); // item�� ���� Ŭ �� tail ����
}
void remove_dup() {
	Node* p = head;
	while (p->next) {
		if (p->data == p->next->data) {
			if (p == head) { // ��尡 �ߺ��� ��
				head = p->next;
				head->prev = 0;
			}
			else { // ���� ���
				p->prev->next = p->next;
				p->next->prev = p->prev;
			}
		}
		p = p->next;
	}
}
void print_list_twice() {
	Node* p = head;
	while (p != nullptr) {
		cout << p->data << " ";
		p = p->next;
	}
	cout << endl;
	Node* q = tail;
	while (q != nullptr) {
		cout << q->data << " ";
		q = q->prev;
	}
	cout << endl;
}
