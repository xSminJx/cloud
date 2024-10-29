#include <iostream>
#include <vector>
using namespace std;

vector<int> erase(vector<int> v, int k) {
	vector<int> rv;
	for (auto i : v) {
		if (i > k) rv.push_back(i);
	}
	return rv;
}

int main() {
	int n, k;
	cin >> n;
	vector<int> v;
	vector<int> res;
	while (n--) {
		cin >> k;
		v = erase(v, k);
		v.push_back(k);
		res.push_back(v.size());
	}
	for (auto i : res) cout << i << " ";
	return 0;
}