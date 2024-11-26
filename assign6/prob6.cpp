#include <bits/stdc++.h>
using namespace std;

void printv(vector<bool>& v) {
	for (auto i : v) cout << i;
	cout << endl;
}

void cout_dif(vector<bool>& v, int n, int k) { // n: 현재 가리키는 v의 인덱스, k: 남은 변경 횟수
	if (k == 0) printv(v);
	else {
		if (v.size() - n > k) { // 지금부터 전부 뒤집지 않아도 될 때
			cout_dif(v, n + 1, k); // n번 요소를 뒤집지 않고 진행
		}
		v[n] = !v[n];
		cout_dif(v, n + 1, k - 1); // n번 요소를 뒤집고 진행
		v[n] = !v[n];
	}
}

int main() {
	string str;
	int k;
	cin >> str >> k;
	vector<bool> v;
	for (auto i : str) v.push_back(i - '0');

	cout_dif(v, 0, k);
	return 0;
}
