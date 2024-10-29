#include <iostream>
#include <vector>
using namespace std;

int main() {
	char c;
	int i = 1, topidx = -1;
	vector<int> stc(100);
	vector<int> res;
	while (cin >> c) {
		if (c == '(') {
			stc[++topidx] = i;
			res.push_back(i++);
		}
		else if (c == ')' && topidx != -1) {
			res.push_back(stc[topidx--]);
		}
	}
	for (auto i : res) cout << i << " ";
	return 0;
}
