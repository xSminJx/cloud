#include <bits/stdc++.h>
using namespace std;

void remove_unlucky(queue<int>& qu, int n) {
	int qsize = qu.size();
	if (n > qsize) return;
	for (int i = 1; i < qsize + 1; i++) {
		if (i % n) qu.push(qu.front());
		qu.pop();
	}
	remove_unlucky(qu, n + 1);
}

int main() {
	int target;
	cin >> target;
	queue<int> qu;
	for (int i = 0; i < target; i++) qu.push(i + 1);

	remove_unlucky(qu, 2);
	while (!qu.empty()) {
		if (qu.front() == target) {
			cout << "yes";
			return 0;
		}
		qu.pop();
	}
	cout << "no";
	return 0;
}