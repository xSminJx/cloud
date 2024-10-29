#include <iostream>
#include <vector>
#include <stack>
#include <fstream>
using namespace std;

int dx[] = { -1,-1,0,1,1,1,0,-1 };
int dy[] = { 0,1,1,1,0,-1,-1,-1 };

class node {
public:
	bool val = 0, visit = 0;
};
using matrix = vector<vector<node>>;

bool inrange(int x, int y, int n) {
	return 0 <= x && x < n && 0 <= y && y < n;
}

int dfs(matrix& v, int a, int b, int n) {
	stack < pair<int, int>> stc;
	int res = 0;
	res++;
	v[a][b].visit = 1;
	stc.push({ a,b });
	while (!stc.empty()) {
		int x = stc.top().first, y = stc.top().second;
		stc.pop();

		for (int i = 0; i < 8; i++) {
			int dxx = x + dx[i], dyy = y + dy[i];
			if (inrange(dxx, dyy, n) && v[dxx][dyy].val == 1 && v[dxx][dyy].visit == 0) {
				v[dxx][dyy].visit = 1;
				stc.push({ dxx,dyy });
				res++;
			}
		}
	}
	return res;
}

int main() {
	int t, n;
	ifstream file("input.txt");
	file >> t;
	while (t--) {
		file >> n;
		matrix v(n, vector<node>(n));
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++) file >> v[i][j].val;
		}

		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++) {
				if (v[i][j].val == 1 && v[i][j].visit == 0) {
					cout << dfs(v, i, j, n) << " ";
				}
			}
		}
		cout << endl;
	}
	return 0;
}
