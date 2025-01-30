#include <iostream>
#include <chrono>
#include <cstdlib> // For rand() and srand()
#include <ctime>   // For time()
using namespace std;

// Custom swap function
void swap(int& a, int& b) {
    int temp = a;
    a = b;
    b = temp;
}

// Partition function
int partition(int arr[], int low, int high) {
    int pivot = arr[high]; // Choose the last element as pivot
    int i = low - 1;       // Index of the smaller element

    for (int j = low; j < high; ++j) {
        if (arr[j] <= pivot) {
            ++i; // Increment index of the smaller element
            swap(arr[i], arr[j]);
        }
    }
    swap(arr[i + 1], arr[high]); // Place the pivot in its correct position
    return i + 1;
}

// QuickSort function
void quickSort(int arr[], int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high); // Partition index

        // Recursively sort elements before and after partition
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}

int main() {

	for (int i = 1000; i <= 10000; i += 1000) {
		int arr[i] = {0};
		for (int j = 1; j <= i; j++) {
			arr[j - 1] = j;
		}
		int n = sizeof(arr) / sizeof(arr[0]);
		auto start = chrono::high_resolution_clock::now();
        	quickSort(arr, 0, n - 1);
        	auto end = chrono::high_resolution_clock::now();
        	chrono::duration<double, milli> duration = end - start;
        	cout << "Elapsed Time (" << i << " elements): " << duration.count() << " ms" << endl;
	}

/*	for (int i = 1000; i <= 10000; i += 1000) {
                int arr[i] = {0};
                for (int j = 1; j <= i; j++) {
			srand(time(0));
                	int randomNum = (rand() % i) + 1;
                        arr[j - 1] = randomNum;
                }
                int n = sizeof(arr) / sizeof(arr[0]);
                auto start = chrono::high_resolution_clock::now();
                quickSort(arr, 0, n - 1);
                auto end = chrono::high_resolution_clock::now();
                chrono::duration<double, milli> duration = end - start;
                cout << "Elapsed Time (" << i << " elements): " << duration.count() << " ms" << endl;
        }
*/

	int arr[10] = {1, 5, 8, 2, 9, 7, 10, -1, 23, 6};
        int n = sizeof(arr) / sizeof(arr[0]);
	cout << "Array Before: ";
	for (int i = 0; i < n; i++) {
		cout << " " << arr[i] << " ";
	}
	quickSort(arr, 0, n - 1);
	cout << endl;
	cout << "Array After: ";
	for (int i = 0; i < n; i++) {
		cout << " " << arr[i] << " ";
	}
	cout << endl;

    return 0;
}
