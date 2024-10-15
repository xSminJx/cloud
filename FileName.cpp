#include <iostream>
#include <list>
#include <fstream>
#include <string>
#include <vector>
#include <cassert>
#include <sstream>
using namespace std;

int id_counter = 0;
struct Song;
struct Artist {
	string name;
	list<Song*> songs;
	Artist() {}
	Artist(string name) : name(name) {}
};
struct Song {
	int index;
	string title, album, mv_url;
	Artist* artist;
	Song() {}
	Song(string ti, Artist* art, string alb, string mv) :
		title(ti), artist(art), album(alb), mv_url(mv) {
		index = id_counter++;
	}
};

list<Artist*> artist_directory[256];
const int SONG_DIRECTORY_SIZE = 10;
list<Song*> song_directory[SONG_DIRECTORY_SIZE];
const string datafilename = "songs.csv";

// ��Ƽ��Ʈ ���丮���� ã���ڿ� ������ 0, ������ ��Ƽ��Ʈ ��ȯ
Artist* find_artist(string name) {
	list<Artist*> artist_list = artist_directory[(unsigned char)name[0]];
	for (auto it = artist_list.begin(); it != artist_list.end(); it++) {
		if ((*it)->name == name)
			return *it;
	}
	return nullptr;
}

// ��µ�
void print_artist(Artist* p) {
	cout << p->name << ":" << endl;
	for (auto s : p->songs) {
		cout << " " << s->index << ":" << s->title << ", " << s->album <<
			", " << s->mv_url << endl;
	}
}
void print_artist_directory() {
	for (int i = 0; i < 256; i++) {
		list<Artist*>& artist_list = artist_directory[i];
		for (auto ptr : artist_list) {
			print_artist(ptr);
		}
	}
}

// ���丮�� ��Ƽ��Ʈ ����
Artist* add_artist(string name) {
	Artist* ptr_artist = new Artist(name);
	list<Artist*>& artist_list = artist_directory[(unsigned char)name[0]];
	artist_list.push_back(ptr_artist);
	return ptr_artist;
}
// �뷡 ����
void add_song(string title, string artist, string album = ""
	, string mv_url = "") {
	Artist* artist_ptr = find_artist(artist);
	if (artist_ptr == nullptr) {
		artist_ptr = add_artist(artist);
	}
	Song* song_ptr = new Song(title, artist_ptr, album, mv_url);
	artist_ptr->songs.push_back(song_ptr);
	list<Song*>& song_list = song_directory[song_ptr->index % SONG_DIRECTORY_SIZE];
	song_list.push_back(song_ptr);
}
void add() {
	vector<string> out{ "Title: ","Artist: ","Album: ","MV url: " };
	for (int i = 0; i < 4; i++) {
		cout << out[i];
		getline(cin, out[i]);
	}
	add_song(out[0], out[1], out[2], out[3]);
}

// load_songs�� ���� �Լ���
string cutting(string str) {
	while (str.front() == ' ') str.erase(str.begin());
	while (str.back() == ' ') str.erase(str.end() - 1);
	return str;
}
vector<string> split_line(string line, char deli) {
	vector<string> res;
	string buf;
	stringstream ssm(line);
	while (getline(ssm, buf, deli)) {
		res.push_back(cutting(buf));
	}
	return res;
}
void load_songs(string filename) {
	string line;
	ifstream songfile(filename);
	while (getline(songfile, line)) {
		vector<string> tokens = split_line(line, ',');
		assert(tokens.size() == 4 || tokens.size() == 3);
		if (tokens.size() == 4)
			add_song(tokens[0], tokens[1], tokens[2], tokens[3]);
		else
			add_song(tokens[0], tokens[1], tokens[2]);
	}
	songfile.close();
}

void print_song_directory() {
	for (int i = 0; i < SONG_DIRECTORY_SIZE; i++) {
		list<Song*>& song_list = song_directory[i];
		for (auto s : song_list) {
			cout << " " << s->index << ":" << s->title << ", "
				<< s->artist->name << ", " << s->album << ", " << s->mv_url << endl;
		}
	}
}

void cmd() {
	while (1) {
		vector<string> com;
		string buf;
		cout << "$ ";
		getline(cin, buf);
		com = split_line(buf, ' ');
		com.push_back(""); // �Է¹޴� �κ� ��ġ��

		if (com[0] == "list") {
			if (com[1] == "") print_song_directory();
			else print_artist_directory();
		}
		else if (com[0] == "add") add();
		else if (com[0] == "find") {
			if (com[1] == "") {
				cin >> buf;
				cout << "Found:\n";

			}
			else {
				cin >> buf;
				if (find_artist(com[0])) {
					cout << "Found:\n";
					print_artist(find_artist(com[0]));
				}
				else cout << "not exist artist.";
			}
		}
		else if (com[0] == "remove") {
			if (com[1] == "") {

			}
			else {

			}
		}
		else if (com[0] == "save");//
		else if (com[0] == "clear") system("cls");
		else if (com[0] == "exit") break;
	}
}
int main() {
	load_songs(datafilename);
	cmd();
	return 0;
}