#include <iostream>
using namespace std;

void remove_minimum(string& str) {
	for (int i = 0; i < str.size() - 1; i++) {
		if (str[i] < str[i + 1]) {
			str.erase(str.begin() + i);
			return;
		}
	}
	str.erase(str.end() - 1);
}

int main() {
	string n;
	int k;
	cin >> n >> k;
	while (k--) remove_minimum(n);
	for (auto i : n) {
		if (i != ' ')cout << i;
	}
	return 0;
}