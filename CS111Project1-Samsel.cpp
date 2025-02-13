/*Isaac Samsel
CS-111
Dr.Birmingham
2-20-2024*/

#include <iostream>
#include <fstream>

using namespace std;

#define NOT_FOUND -1
const int SIZE = 50000;	//Changed to 50000 because it would not run with 500000. C6262 error
typedef int Data[SIZE];
//postcondition: each element is initialized with its index
void initializeArraySorted(Data array, int size);
int binarySearch(Data& array, int size, int target);
int linearSearch(Data array, int size, int target);
// insert function signatures for linear and binary search 

int gCOUNT_LINEAR = 0;
int gCOUNT_BINARY = 0;

int main(void) {
	srand(time(NULL));// initialize srand 
	Data a;
	initializeArraySorted(a, SIZE);
	int target = 0;
	ofstream data;

	//declare open, check a data file, called runData.txt
	data.open("runData.txt");
	if (data.fail()) {
		cout << "File could not open" << endl;
		exit(0);
	}

	int workingArraySize = 10;
	for (; workingArraySize <= SIZE; workingArraySize += 10) {
		gCOUNT_LINEAR = 0;
		gCOUNT_BINARY = 0;
		target = rand() % workingArraySize;
		cout << "Target " << target << " ";
		//each search function increments the proper global to keep track of the 
		//number of comparisons 
		int b = linearSearch(a, workingArraySize, target);
		b = binarySearch(a, workingArraySize, target);
		//output to file workingArraySize, gCOUNT_LINEAR, and gCOUNT_BINARY 
		data << workingArraySize << " " << gCOUNT_LINEAR << " " << gCOUNT_BINARY << endl;
	}
	data.close();
	//other statements for proper execution as needed 
	return 0;
}

void initializeArraySorted(Data array, int size) {
	for (int i = 0; i < size; i++) {
		array[i] = i;
	}
}

int linearSearch(Data array, int size, int target) {
	for (int i = 0; i < size; i++) {
		gCOUNT_LINEAR++;
		if (array[i]== target) {
			return i;
		}
		//return NOT_FOUND;
	}
	return NOT_FOUND;
}

int binarySearch(Data& array, int size, int target) {
	int left = 0;
	int right = size - 1;
	while (right >= left) {
		gCOUNT_BINARY++;
		int middle = (left + right) / 2;
		if (array[middle] == target)
			return middle;
		if (target < array[middle])
			right = middle - 1;
		else
			left = middle + 1;
	}
	return NOT_FOUND;
}