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
	void sprint() {
		cout << index << ":" << title << ", " << album <<
			", " << mv_url << endl;
	}
};

list<Artist*> artist_directory[256];
const int SONG_DIRECTORY_SIZE = 10;
list<Song*> song_directory[SONG_DIRECTORY_SIZE];
const string datafilename = "songs.csv";

// 아티스트 디렉토리에서 찾은뒤에 없으면 0, 있으면 아티스트 반환
Artist* find_artist(string name) {
	list<Artist*> artist_list = artist_directory[(unsigned char)name[0]];
	for (auto it = artist_list.begin(); it != artist_list.end(); it++) {
		if ((*it)->name == name)
			return *it;
	}
	return nullptr;
}
Artist* find_artist2(string name) { // 부분 문자열 포함하는지
	list<Artist*> artist_list = artist_directory[(unsigned char)name[0]];
	for (auto it = artist_list.begin(); it != artist_list.end(); it++) {
		if ((*it)->name.substr(0, name.size()) == name)
			return *it;
	}
	return nullptr;
}
void find_song_bykeyword(string str) { // song_directory에 가서 전수조사
	for (int i = 0; i < SONG_DIRECTORY_SIZE; i++) {
		auto cur = song_directory[i].begin();
		while (cur != song_directory[i].end()) {
			if ((*cur)->title.find(str) != string::npos) {
				cout << " ";
				(*cur)->sprint();
			}
			cur++;
		}
	}
}

// 출력들
void print_artist(Artist* p) {
	cout << p->name << ":" << endl;
	for (auto s : p->songs) {
		cout << " ";
		s->sprint();
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

// 디렉토리에 아티스트 삽입
Artist* add_artist(string name) {
	Artist* ptr_artist = new Artist(name);
	list<Artist*>& artist_list = artist_directory[(unsigned char)name[0]];
	artist_list.push_back(ptr_artist);
	return ptr_artist;
}
// 노래 삽입
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

// load_songs에 쓰는 함수들
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

void remove_by_idx(int idx) {
	int i = idx % 10;
	for (auto it = song_directory[i].begin(); it != song_directory[i].end(); it++) {
		if ((*it)->index == idx) {
			auto artsong = (*it)->artist->songs;
			for (auto it2 = artsong.begin(); it2 != artsong.end(); it2++) {
				if ((*it2)->index == idx) {
					artsong.erase(it2); // 이거 왜 안지워짐??
					break;
				}
			}
			song_directory[i].erase(it);
			return;
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
		com.push_back(""); // 입력받는 부분 고치셈

		if (com[0] == "list") {
			if (com[1] == "") print_song_directory();
			else print_artist_directory();
		}
		else if (com[0] == "add") add();
		else if (com[0] == "find") {
			if (com[1] != "-a") {
				cout << "Found:\n";
				find_song_bykeyword(com[1]);
			}
			else {
				if (find_artist2(com[2])) {
					cout << "Found:\n";
					print_artist(find_artist2(com[2]));
				}
				else cout << "not exist artist.\n";
			}
		}
		else if (com[0] == "remove") {
			if (com[1] != "-a") {
				remove_by_idx(stoi(com[1]));
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
