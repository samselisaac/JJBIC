#include <iostream>

using namespace std;

#define SIZE 10
#define UPPERBOUND_ON_RANDOM_INTS 1000
typedef int theData[10];

void bubbleSort(theData &data, int size);
void swap(int& a, int& b);
void initRandom(theData& v, int size);
void print(theData v, int size);
int binarySearch(theData& data, int size);

int main(void){
	int target = 0;
	theData data;
	initRandom(data, SIZE);
	print(data, SIZE);
	bubbleSort(data, SIZE);
	print(data, SIZE);
	return 0;
}

int binarySearch(theData& data, int size, int target) {
	int left = 0;
	int right = size - 1;
	while (right >= left) {
		int mid = (left + right) / 2;
		if (data[mid] == target)
			return mid;
		if (target < data[mid])
			right = mid - 1;
		else
			left = mid + 1;
	}
	return -1;
}
void swap(int& a, int& b) {
	cout << "A " << a << " B " << b << endl;
	int t = a;
	a = b;
	b = t;
}

void bubbleSort(theData &data, int size) {
	int top = size - 1;
	bool done = false;
	int k = 0;

		while (!done && top > 0) {
			done = true;
			for (k = 0; k < top; k++) {
				if (data[k] < data[k + 1]) {
					done = false;
					swap(data[k], data[k + 1]);
				}
			}
			top--;
		}
}

void print(theData v, int size) {
	for (int i = 0; i < size; i++) {
		cout << " " << v[i];

	}
	cout << endl;
}

void initRandom(theData& v, int size) {
	for (int i = 0; i < size; i++) {
		int temp = rand() % UPPERBOUND_ON_RANDOM_INTS;
		v[i] = temp;
	}
}
