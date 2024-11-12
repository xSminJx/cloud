#include <bits/stdc++.h>
using namespace std;

class node {
public:
	bool val = 0;
	int visit = INT_MAX; // ²ªÀÎ È½¼ö
};
using matrix = vector<vector<node>>;

int dx[] = { 0,1,0,-1 };
int dy[] = { 1,0,-1,0 };

bool inrange(int n, int x, int y) {
	return 0 <= x && x < n && 0 <= y && y < n;
}

void dfs(matrix& v, int x, int y, int k) {
	for (int i = 0; i < 4; i++) {
		int dxx = x + dx[i], dyy = y + dy[i];
		if (inrange(v[0].size(), dxx, dyy) && v[dxx][dyy].val == 0) {
			bool offset = i != k;
			if (v[dxx][dyy].visit > v[x][y].visit + offset) {
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

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) file >> v[i][j].val;
	}

	v[0][0].visit = 0;
	dfs(v, 0, 0, -1);
	cout << v[n - 1][n - 1].visit - 1;
	return 0;
}