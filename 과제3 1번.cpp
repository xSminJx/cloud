#include <iostream>
#include <fstream>
using namespace std;

struct Node {
	int x, y, w, h;
	Node* next;
};
Node* head = nullptr;

void addlist(int x, int y, int w, int h) {
	Node* temp = new Node;
	temp->x = x, temp->y = y, temp->w = w, temp->h = h, temp->next = nullptr;

	if (head == nullptr) {
		head = temp;
	}
	else {
		Node* p = head;
		while (p->next != nullptr) p = p->next;
		p->next = temp;
	}
}


void print_list() {
	Node* p = head;
	while (p != nullptr) {
		cout << p->x << " " << p->y << " " << p->w << " " << p->h << endl;
		p = p->next;
	}
}

void read_file() {
	ifstream file("rects.txt");
	int n, x, y, w, h;
	file >> n;
	while (n--) {
		file >> x >> y >> w >> h;
		addlist(x, y, w, h);
	}
}

bool sizecom(Node* b, Node* c) {
	return b->w * b->h < c->w * c->h;
}

void sort_by_area() {
	bool ischange = 1;
	while (ischange) {
		ischange = 0;
		Node* a = nullptr;
		Node* b = head;
		Node* c = head->next;

		while (c != nullptr) {
			if (!sizecom(b, c)) {
				if (a == nullptr) {
					b->next = c->next;
					c->next = b;
					head = c;
				}
				else if (c->next == nullptr) {
					a->next = c;
					c->next = b;
					b->next = nullptr;
				}
				else {
					Node* d = c->next;
					a->next = c;
					c->next = b;
					b->next = d;
				}
				ischange = 1;
			}
			a = b;
			b = c;
			c = c->next;
		}
	}
}

void remove_rects(int mw, int mh) {

}

int main()
{
	// (1)
	read_file(); // 파일을 읽어서 파일에 저장된 순서대로 저장된 연결리스트를 구성한다.
	print_list(); // 파일에 저장된 순서대로 출력된다.
	cout << endl; // 한 줄을 띄운다.
	// (2)
	sort_by_area(); // 연결리스트의 노드들을 면적순으로 정렬한다.
	print_list(); // 정렬된 순서대로 출력한다
	cout << endl; // 한 줄을 띄운다.
	//// (3)
	//int min_w, min_h;
	//cin >> min_w >> min_h;
	//remove_rects(min_w, min_h);
	//print_list();
	return 0;
}
