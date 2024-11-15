#include <bits/stdc++.h>
using namespace std;

string reverse_bit(char a) {
	if (a == '1') return "0";
	return "1";
}

void cout_dif(string prev, string str, int k) {
	if (k == 0) {
		cout << prev + str << endl;
	}
	else {
		string next_str = str.substr(1, str.size() - 1); // str에서 맨앞 비트 뗀 문자열
		if (str.size() > k) cout_dif(prev + str[0], next_str, k);
		cout_dif(prev + reverse_bit(str[0]), next_str, k - 1);
	}
}

int main() {
	string str;
	int k;
	cin >> str >> k;
	cout_dif("", str, k);
}