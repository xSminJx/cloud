#include <bits/stdc++.h>
using namespace std;

int get_odd(int n) {
	int res = 0;
	while (n) {
		if ((n % 10) % 2) res++;
		n /= 10;
	}
	return res;
}

int getlen(int n) {
	int res = 1;
	while (n /= 10) res++;
	return res;
}

pair<int, int> divide(int n) {
	cout << n << endl;
	pair<int, int> res(0, 0);
	res.first = res.second = get_odd(n);
	int len = getlen(n);

	if (len <= 1) return{ n % 2,n % 2 };
	else if (len == 2) {
		auto [x, y] = divide(n % 10 + (n / 10));
		return { res.first + x, res.second + y };
	}
	else {
		int a = 0, b = 0, c = 0, mx = 0, mn = 100000;
		for (int i = 1; i <= len - 2; i++) {
			for (int j = 1; j <= len - i - 1; j++) {
				int k = len - i - j, ti = i, tj = j, tn = n, p0 = 1, p1 = 1, p2 = 1;

				while (len--) {
					if (k) c += pow(tn % 10, p0++), k--;
					else if (tj) b += pow(tn % 10, p1++), tj--;
					else if (ti) a += pow(tn % 10, p2++), ti--;
					tn /= 10;
				}
				auto [x, y] = divide(a + b + c);
				mx = max(mx, y);
				mn = min(mn, x);
			}
		}
		return { res.first + mn,res.second + mx };
	}
}

int main() {
	int n;
	cin >> n;
	auto [x, y] = divide(n);
	cout << x << " " << y;
	return 0;
}
