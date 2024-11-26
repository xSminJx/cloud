#include <bits/stdc++.h>
using namespace std;

class node {
public:
	bool wall = 0;
	int visit = INT_MAX; // 꺾은 횟수 기록
};
using matrix = vector<vector<node>>;

int dx[] = { 0,1,0,-1 };
int dy[] = { 1,0,-1,0 };

bool inrange(int n, int x, int y) {
	return 0 <= x && x < n && 0 <= y && y < n;
}

void dfs(matrix& v, int x, int y, int k) { // x, y = 현재 좌표, k = 방향 값
	for (int i = 0; i < 4; i++) {
		int dxx = x + dx[i], dyy = y + dy[i];
		if (inrange(v[0].size(), dxx, dyy) && v[dxx][dyy].wall == 0) {
			bool offset = i != k; // 방향이 변하면 1, 아니면 0
			if (v[dxx][dyy].visit > v[x][y].visit + offset) { // 기존 값보다 현재 값이 더 작으면 갱신
				v[dxx][dyy].visit = v[x][y].visit + offset;
				dfs(v, dxx, dyy, i);
			}
		}
	}
}

int main() {
	ifstream file("input2.txt");
	int n;
	file >> n;
	matrix v(n, vector<node>(n));

	for (auto& i : v) {
		for (auto& j : i) file >> j.wall;
	}

	v[0][0].visit = 0;
	dfs(v, 0, 0, -1);
	cout << v[n - 1][n - 1].visit - 1;
	return 0;
}
