#include <stdio.h>

int main() {
int age;
age = 25;
if ((age < 18)) {
printf("Mineur\n");
} else {
if (((age >= 18) && (age < 65))) {
printf("Adulte\n");
} else {
printf("Senior\n");
}
}
return 0;
}
