#include <bits/stdc++.h>
using namespace std;

class node {
public:
	int wall = 0, visit = 0, path = 0;
};
using matrix = vector<vector<node>>;

int dx[] = { 1,0,-1,0 };
int dy[] = { 0,-1,0,1 };

bool inrange(matrix& v, int x, int y) {
	return 0 <= x && x < v.size() && 0 <= y && y < v.size();
}

void dfs(matrix& v, int x, int y) {
	v[x][y].visit = 1;
	/*cout << endl;
	for (auto i : v) {
		for (auto j : i) cout << j.path << " ";
		cout << endl;
	}*/
	for (int i = 0; i < 4; i++) {
		int dxx = x + dx[i], dyy = y + dy[i];

	}
}

int main() {
	int n;
	cin >> n;
	matrix v(n, vector<node>(n));
	for (auto& i : v) {
		for (auto& j : i) cin >> j.wall;
	}

	v[0][0].path = 1;
	dfs(v, 0, 0);
	cout << v[n - 1][n - 1].path;
	return 0;
}