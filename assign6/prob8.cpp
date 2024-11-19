#include <bits/stdc++.h>
using namespace std;

class node {
public:
	int wall = 0;
	int visit = 0;
};
using matrix = vector<vector<node>>;

int dx[] = { 1,0,-1,0 };
int dy[] = { 0,1,0,-1 };

bool inrange(matrix& v, int x, int y) {
	return 0 <= x && x < v.size() && 0 <= y && y < v.size();
}

void bfs(matrix& v, int a, int b) {
	queue<pair<int, int>> qu;
	qu.push({ a,b });
	v[a][b].visit = 1;

	while (!qu.empty()) {
		int x = qu.front().first, y = qu.front().second;
		qu.pop();

		for (int i = 0; i < 4; i++) {
			int dxx = x + dx[i], dyy = y + dy[i];
			bool iswallfind = 0;
			while (1) {
				if (inrange(v, dxx, dyy)) {
					if (!iswallfind && v[dxx][dyy].wall) {
						iswallfind = 1;
					}
					else if (iswallfind) {
						if (v[dxx][dyy].wall) break;
						else if (!v[dxx][dyy].visit) {
							qu.push({ dxx,dyy });
							v[dxx][dyy].visit = 1;
						}
					}
					dxx += dx[i], dyy += dy[i];
				}
				else break;
			}
		}
	}
}

int main() {
	int n;
	ifstream file("input8.txt");
	file >> n;
	matrix v(n, vector<node>(n));
	for (auto& i : v) {
		for (auto& j : i) file >> j.wall;
	}

	int x, y, ex, ey;
	file >> x >> y >> ex >> ey;
	bfs(v, x, y);

	cout << (v[ex][ey].visit ? "Yes" : "No");
	return 0;
}