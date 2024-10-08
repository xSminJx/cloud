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
Node* head = nullptr, * tail = nullptr; /* 2중 연결리스트의 처음과 마지막 노드 */

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
	if (!head) { // 리스트가 비었을 때
		tail = head = new Node(item, 0, 0);
		return;
	}
	Node* p = head;
	while (p) {
		if (item < p->data) { // p보다 item이 작으면 앞에 노드 삽입
			if (p == head) head = head->prev = new Node(item, 0, head); // item이 젤 작을 때 헤드 갱신
			else p->prev = p->prev->next = new Node(item, p->prev, p); // 보통 경우
			return;
		}
		p = p->next;
	}
	tail = tail->next = new Node(item, tail, 0); // item이 제일 클 때 tail 갱신
}
void remove_dup() {
	Node* p = head;
	while (p->next) {
		if (p->data == p->next->data) {
			if (p == head) { // 헤드가 중복일 때
				head = p->next;
				head->prev = 0;
			}
			else { // 보통 경우
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
