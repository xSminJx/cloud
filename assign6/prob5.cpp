#include <bits/stdc++.h>
using namespace std;

class node {
public:
	int wall = 0, visit = 0, path = 0;
};
using matrix = vector<vector<node>>;

int dx[] = { 1,0,-1,0 };
int dy[] = { 0,-1,0,1 };
int ex, ey;

bool inrange(matrix& v, int x, int y) {
	return 0 <= x && x < v.size() && 0 <= y && y < v.size();
}

int dfs(matrix& v, int x, int y) {
	if (x == ex && y == ey) return 1;
	v[x][y].visit = 1;
	for (int i = 0; i < 4; i++) {
		int dxx = x + dx[i], dyy = y + dy[i];
		if (inrange(v, dxx, dyy) && !v[dxx][dyy].wall && !v[dxx][dyy].visit) v[x][y].path += dfs(v, dxx, dyy);
	}
	v[x][y].visit = 0;
	int res = v[x][y].path;
	v[x][y].path = 0;
	return res;
}

int main() {
	int n;
	cin >> n;
	ex = ey = n - 1;
	matrix v(n, vector<node>(n));
	for (auto& i : v) {
		for (auto& j : i) cin >> j.wall;
	}

	cout << dfs(v, 0, 0);
	return 0;
}
