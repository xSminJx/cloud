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
	queue<pair<int, int>> qu; // bfs에 사용할 큐(좌표 저장함)
	qu.push({ a,b });
	v[a][b].visit = 1;

	while (!qu.empty()) {
		int x = qu.front().first, y = qu.front().second; // 큐에서 뽑아낸 값 x, y에 저장
		qu.pop();

		for (int i = 0; i < 4; i++) {
			int dxx = x + dx[i], dyy = y + dy[i]; // dxx, dyy = 현재 칸(x, y)에서 갈 수 있는 칸
			bool iswallfind = 0; // 벽을 뛰어넘었는지
			while (1) {
				if (inrange(v, dxx, dyy)) {
					if (!iswallfind && v[dxx][dyy].wall) { // 아직 벽을 넘지 않았을 때 벽을 만났으면
						iswallfind = 1;
					}
					else if (iswallfind) { // 벽을 넘었으면
						if (v[dxx][dyy].wall) break; // 벽을 넘었는데 또 벽을 만난 경우
						else if (!v[dxx][dyy].visit) {
							qu.push({ dxx,dyy }); // 갈 수 있는 칸이므로 큐에 좌표를 집어넣음
							v[dxx][dyy].visit = 1;
						}
					}
					dxx += dx[i], dyy += dy[i]; // 그 다음칸으로 이동
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
