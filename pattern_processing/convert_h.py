import csv
for i in range(100):
    input_file = f'./activations/img{i}/image.csv'
    output_file = f'./activations/img{i}/hw5_image.csv'
    with open(input_file, 'r') as csvfile:
        reader = csv.reader(csvfile)
        numbers = [row[0] for row in reader]

    processed_numbers = [f"0x{number.strip()}," for number in numbers[:-1]]
    processed_numbers.append(f"0x{numbers[-1].strip()}")


    with open(output_file, 'w', newline='') as csvfile:
        csvfile.write("int32_t image[] = {\n")
        for number in processed_numbers:
            csvfile.write(number + '\n')
        csvfile.write("};\n")
            
            
    input_file = f'./activations/img{i}/golden.csv'
    output_file = f'./activations/img{i}/hw5_golden.csv'
    with open(input_file, 'r') as csvfile:
        reader = csv.reader(csvfile)
        numbers = [row[0] for row in reader]

    processed_numbers = [f"0x{number.strip()}," for number in numbers[:-1]]
    processed_numbers.append(f"0x{numbers[-1].strip()}")


    with open(output_file, 'w', newline='') as csvfile:
        csvfile.write("int32_t golden[] = {\n")
        for number in processed_numbers:
            csvfile.write(number + '\n')
        csvfile.write("};\n")



input_file = './weights/weights.csv'
output_file = './weights/hw5_weights.csv'
with open(input_file, 'r') as csvfile:
    reader = csv.reader(csvfile)
    numbers = [row[0] for row in reader]

processed_numbers = [f"0x{number.strip()}," for number in numbers[:-1]]
processed_numbers.append(f"0x{numbers[-1].strip()}")


with open(output_file, 'w', newline='') as csvfile:
    csvfile.write("int32_t weight[] = {\n")
    for number in processed_numbers:
        csvfile.write(number + '\n')
    csvfile.write("};\n")
        
