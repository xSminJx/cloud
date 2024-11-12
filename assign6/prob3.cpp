#include <bits/stdc++.h>
using namespace std;
#define MAX 1001

int cnt = 0;
void get_cnt(int data[], int s, int e, int k) {
	if (s >= e) return;
	if (data[s] + data[e]) get_cnt(data,)
}

int main() {
	int data[MAX];
	int N, K;
	cin >> N;
	for (int i = 0; i < N; i++) cin >> data[i];
	cin >> K;

	get_cnt(data, 0, N - 1, K);
	cout << cnt << endl;
}