#include <bits/stdc++.h>
using namespace std;

class node {
public:
	bool val = 0;
	int visit = 0;
};
using matrix = vector<vector<node>>;

int dx[] = { 0,1,0,-1 };
int dy[] = { 1,0,-1,0 };

bool inrange(int n, int x, int y) {
	return 0 <= x && x < n && 0 <= y && y < n;
}

int bfs(matrix& v, int a, int b, int k) {
	int cnt = 0;
	queue<pair<int, int>> qu;
	qu.push({ a,b });
	v[a][b].visit = 1;
	cnt++;

	while (!qu.empty()) {
		int x = qu.front().first, y = qu.front().second;
		qu.pop();

		for (int i = 0; i < 4; i++) {
			int dxx = x + dx[i], dyy = y + dy[i];
			if (inrange(v[0].size(), dxx, dyy) && v[dxx][dyy].val == 0 && v[dxx][dyy].visit == 0 && v[x][y].visit <= k) {
				v[dxx][dyy].visit = v[x][y].visit + 1;
				qu.push({ dxx,dyy });
				cnt++;
			}
		}
	}
	return cnt;
}

void clean(matrix& v) {
	for (auto& i : v) {
		for (auto& j : i) j.visit = 0;
	}
}

int main() {
	ifstream file("input1.txt");
	int n, k, mx = 0, mi = 0, mj = 0;
	file >> n;
	matrix v(n, vector<node>(n));

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) file >> v[i][j].val;
	}
	file >> k;

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			if (v[i][j].val == 0) {
				int p = bfs(v, i, j, k);

				if (mx < p) {
					mx = p;
					mi = i, mj = j;
				}
				clean(v);
			}
		}
	}
	cout << mi << " " << mj << endl << mx;
	return 0;
}