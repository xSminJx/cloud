#include <bits/stdc++.h>
using namespace std;

void printv(vector<bool>& v) {
	for (auto i : v) cout << i;
	cout << endl;
}

void cout_dif(vector<bool>& v, int n, int k) { // n: ���� ����Ű�� v�� �ε���, k: ���� ���� Ƚ��
	if (k == 0) printv(v);
	else {
		if (v.size() - n > k) { // ���ݺ��� ���� ������ �ʾƵ� �� ��
			cout_dif(v, n + 1, k); // n�� ��Ҹ� ������ �ʰ� ����
		}
		v[n] = !v[n];
		cout_dif(v, n + 1, k - 1); // n�� ��Ҹ� ������ ����
		v[n] = !v[n];
	}
}

int main() {
	string str;
	int k;
	cin >> str >> k;
	stringstream ss(str);
	vector<bool> v;

	char c;
	while (ss >> c) v.push_back(c - '0');

	cout_dif(v, 0, k);
	return 0;
}