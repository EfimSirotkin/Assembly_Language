
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <math.h>
#include <exception>
#include <time.h>
#include <Windows.h>
#define ARRAY_SIZE 10
//#define RAND_MAX 5.5f
#define NULL_POINTER_EXCEPTION 1
#define FAILED 0

void assign_default_values(float* array, int size) {
	if (size && array)
		for (int i = 0; i < size; ++i)
			array[i] = 1;
	else throw NULL_POINTER_EXCEPTION;
}
void assign_random_values(float* array, int size) {
	if (size && array)
		for (int i = 0; i < size; ++i)
			array[i] = static_cast <float> (rand()) / static_cast <float> (RAND_MAX/100);
	else throw NULL_POINTER_EXCEPTION;
}
void print_array_values(float* array, int size) {
	if (size && array) {
		for (int i = 0; i < size; ++i)
			printf("%f ", array[i]);
		printf("\n");
	}

	else throw NULL_POINTER_EXCEPTION;
}
void get_array_by_input(float* array, int size) {
	if (size && array)
		for (int i = 0; i < size; ++i) {
			printf("%d) ", i);
			do {
				rewind(stdin);
			} while (!scanf("%lf", &array[i]));
		}
	else throw NULL_POINTER_EXCEPTION;
}

int main() {
	srand(static_cast <unsigned> (time(0)));

	int arraySize = ARRAY_SIZE;

	float* myArray = (float*)malloc(ARRAY_SIZE * sizeof(float));
	if (!myArray)
		return FAILED;
	try {
		assign_random_values(myArray, ARRAY_SIZE);
		print_array_values(myArray, ARRAY_SIZE);
	}
	catch (int exNum) {
		printf("NULL POINTER EXCEPTION DETECTED\n");
	}

	float* result = (float*)malloc(ARRAY_SIZE * sizeof(float));
	if (!result)
		return FAILED;
	try {
		assign_default_values(result, ARRAY_SIZE);
	}
	catch (int exNum) {
		printf("NULL POINTER EXCEPTON DETECTED");
		free(myArray);
	}
	_asm {
		xor ecx, ecx
		mov ebx, result
		mov ecx, ARRAY_SIZE
		finit
		mov eax, myArray
		start :
		fld[eax]
			push ecx
			xor ecx, ecx
			mov ecx, ARRAY_SIZE
			multiplication :
		fmul[eax]
			loop multiplication
			pop ecx
			add eax, 4
			fstp[ebx]
			add ebx, 4
			dec ecx
			jnz start
			fwait
	}
	print_array_values(myArray, ARRAY_SIZE);
	print_array_values(result, ARRAY_SIZE);
	free(myArray);
	free(result);
	system("pause>nul");
	return 0;
}


