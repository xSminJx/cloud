#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <algorithm>
using namespace std;

class man {
public:
	string name, address, phone, email, web;
	void print() {
		cout << name << ":\n";
		cout << "\tAddress: " << address << endl;
		cout << "\tPhone: " << phone << endl;
		cout << "\tEmail: " << email << endl;
		cout << "\tWeb: " << web << endl;
	}
};

class book {
public:
	vector<man> v;

	static bool compare(man& a, man& b) {
		return a.name < b.name;
	}

	void readlist() {
		ifstream file("address.tsv");
		string str, buf;
		while (file >> str) {
			file >> buf;
			str += " " + buf;

			man temp;
			temp.name = str;
			getline(file, buf, '\t');
			getline(file, buf, '\t');
			temp.address = buf;
			getline(file, buf, '\t');
			temp.phone = buf;
			getline(file, buf, '\t');
			temp.email = buf;
			getline(file, buf);
			temp.web = buf;
			v.push_back(temp);
		}
	}

	void namefind() {
		string str;
		cin >> str;
		for (auto i : v) {
			string comp = i.name.substr(0, str.size());
			if (comp == str) i.print();
		}
	}

	void add() {
		man temp;
		getline(cin, temp.name);
		temp.name.erase(temp.name.begin());
		cout << "\tAddress: ";
		getline(cin, temp.address);
		cout << "\tPhone: ";
		getline(cin, temp.phone);
		cout << "\tEmail: ";
		getline(cin, temp.email);
		cout << "\tWeb: ";
		getline(cin, temp.web);
		v.push_back(temp);
		sort(v.begin(), v.end(), compare);
	}

	void cmd() {
		readlist();
		sort(v.begin(), v.end(), compare);
		string com;
		while (1) {
			cout << "$ ";
			cin >> com;

			if (com == "list") {
				for (auto i : v) i.print();
			}
			else if (com == "find") namefind();
			else if (com == "search");
			else if (com == "add") add();
			else if (com == "delete");
			else if (com == "save");
			else if (com == "exit") break;
			else cout << "\nerror\n";
		}
	}
};

int main() {
	book a;
	a.cmd();
	return 0;
}
