#include <iostream>
#include <string>
#include <stack>
#include <sstream>
using namespace std;

const string OPERATORS = "+-*/()";
const int PRECEDENCE[] = { 1, 1, 2, 2, -1, -1 };
stack<char> operator_stack; // 연산자 담아두는 스택

string::size_type is_operator(char ch) {
	return OPERATORS.find(ch);
}

int precedence(char op) {
	return PRECEDENCE[is_operator(op)];
}

void process_op(char op, stack<string> postfix) {
	if (operator_stack.empty() || op == '(') {
		operator_stack.push(op);
	}
	else {
		char top_op = operator_stack.top();
		if (precedence(op) > precedence(top_op)) {
			operator_stack.push(op);
		}
		else {
			while (!operator_stack.empty() && precedence(op) <= precedence(top_op)) {
				operator_stack.pop();
				if (top_op == '(')
					break;
				postfix.push(to_string(top_op));
				if (!operator_stack.empty())
					top_op = operator_stack.top();
			}
			if (op != ')')
				operator_stack.push(op);
		}
	}
}
bool is_blank(string& infix, int i) { // 이 칸이 공백일까?
	return i >= 0 && infix[i] == ' ';
}
void insert_blank(string& infix) { // 입력에 공백 삽입해서 토큰화하기 쉽게 하는 함수
	bool iscuroper = 0; // 연산자 차례인지 피연산자 차례인지
	for (int i = 0; i < infix.size(); i++) {
		if (infix[i] == '(' || infix[i] == ')') {
			if (!is_blank(infix, i - 1)) {
				infix.insert(infix.begin() + i, ' ');
				i++;
			}
		}
		else if (iscuroper && is_operator(infix[i]) != string::npos) {
			if (!is_blank(infix, i - 1)) {
				infix.insert(infix.begin() + i, ' ');
				iscuroper = 0;
				i++;
			}

		}
		else if (!iscuroper) {
			if (!is_blank(infix, i - 1)) {
				infix.insert(infix.begin() + i, ' ');
				iscuroper = 1;
				i++;
			}
		}
	}
	infix.erase(infix.begin());
}

double cal(double a, double b, char c) {
	if (c == '+') return a + b;
	if (c == '-') return a - b;
	if (c == '*') return a * b;
	if (c == '/') return a / b;
}
double cal_postfix(stack<string>& infix) {
	double a, b;
	char c;
	if (is_operator(infix.top()[0]) != string::npos) {
		c = infix.top()[0];
		infix.pop();
		b = stod(infix.top());
		infix.pop();
		a = stod(infix.top());
		infix.pop();
		return cal(a, b, c);
	}
}

double convert(string infix) { // 중위 -> 후위 표기식, 계산
	insert_blank(infix);
	cout << infix << endl;
	stack<string> postfix; // 후위 표기식 스택
	stringstream infixstream(infix); // 입력 스트림
	string token;

	double res = 0;

	while (getline(infixstream, token, ' ')) {
		if (isdigit(token[0]) || (token.size() > 1 && isdigit(token[1]))) { // 숫자면 그냥 스택에 집어넣음
			postfix.push(token);
		}
		else if (is_operator(token[0]) != string::npos) { // operator
			process_op(token[0], postfix);
		}
		else {
			throw runtime_error("Syntax Error: invalid character encountered.");
		}


	}
	while (!operator_stack.empty()) {
		char op = operator_stack.top();
		if (op == '(')
			throw runtime_error("Unmatched parenthesis.");
		postfix.push(to_string(op));
		operator_stack.pop();
	}
	return res;
}

int main() {
	string expr;
	cout << "Enter an infix expression: ";
	getline(cin, expr);
	cout << convert(expr) << endl;
	return 0;
}