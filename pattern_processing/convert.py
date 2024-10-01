import csv
for i in range(100):
    with open(f"./actstart/input_no_combine{i}.csv", mode="w", newline="") as file:
        with open(f"./activations/img{i}/conv1/input.csv", mode="r", newline="") as csvfile:
            reader = csv.reader(csvfile)
            writer = csv.writer(file)
            for row in reader:
                result = list(map(float, row))
                writer.writerow(result)

    with open(f"./actstart/conv1_no_combine{i}.csv", mode="w", newline="") as file:
        with open(f"./activations/img{i}/conv3/input.csv", mode="r", newline="") as csvfile:
            reader = csv.reader(csvfile)
            writer = csv.writer(file)
            for row in reader:
                result = list(map(float, row))
                writer.writerow(result)
                
                
    with open(f"./actstart/conv2_no_combine{i}.csv", mode="w", newline="") as file:
        with open(f"./activations/img{i}/conv5/input.csv", mode="r", newline="") as csvfile:
            reader = csv.reader(csvfile)
            writer = csv.writer(file)
            for row in reader:
                result = list(map(float, row))
                writer.writerow(result)

    with open(f"./actstart/conv3_no_combine{i}.csv", mode="w", newline="") as file:
        with open(f"./activations/img{i}/fc6/input.csv", mode="r", newline="") as csvfile:
            reader = csv.reader(csvfile)
            writer = csv.writer(file)
            for row in reader:
                result = list(map(float, row))
                writer.writerow(result)
                
    with open(f"./actstart/fc1_no_combine{i}.csv", mode="w", newline="") as file:
        with open(f"./activations/img{i}/output/input.csv", mode="r", newline="") as csvfile:
            reader = csv.reader(csvfile)
            writer = csv.writer(file)
            for row in reader:
                result = list(map(float, row))
                writer.writerow(result)  
                
    with open(f"./actstart/output_no_combine{i}.csv", mode="w", newline="") as file:
        with open(f"./activations/img{i}/output/output.csv", mode="r", newline="") as csvfile:
            reader = csv.reader(csvfile)
            writer = csv.writer(file)
            for row in reader:
                result = list(map(float, row))
                writer.writerow(result)




## weights
with open("./weightstart/conv1_weight_no_combine.csv", mode="w", newline="") as file:
    with open("./weights/conv1.conv.weight.csv", mode="r", newline="") as csvfile:
        reader = csv.reader(csvfile)
        writer = csv.writer(file)
        for row in reader:
            result = list(map(float, row))
            writer.writerow(result)
            
with open("./weightstart/conv2_weight_no_combine.csv", mode="w", newline="") as file:
    with open("./weights/conv3.conv.weight.csv", mode="r", newline="") as csvfile:
        reader = csv.reader(csvfile)
        writer = csv.writer(file)
        for row in reader:
            result = list(map(float, row))
            writer.writerow(result)

with open("./weightstart/conv3_weight_no_combine.csv", mode="w", newline="") as file:
    with open("./weights/conv5.conv.weight.csv", mode="r", newline="") as csvfile:
        reader = csv.reader(csvfile)
        writer = csv.writer(file)
        for row in reader:
            result = list(map(float, row))
            writer.writerow(result)

with open("./weightstart/fc1_weight_no_combine.csv", mode="w", newline="") as file:
    with open("./weights/fc6.fc.weight.csv", mode="r", newline="") as csvfile:
        reader = csv.reader(csvfile)
        writer = csv.writer(file)
        for row in reader:
            result = list(map(float, row))
            writer.writerow(result)
            
with open("./weightstart/fc2_weight_no_combine.csv", mode="w", newline="") as file:
    with open("./weights/output.fc.weight.csv", mode="r", newline="") as csvfile:
        reader = csv.reader(csvfile)
        writer = csv.writer(file)
        for row in reader:
            result = list(map(float, row))
            writer.writerow(result)
      
with open("./weightstart/fc2_bias_no_combine.csv", mode="w", newline="") as file:
    writer = csv.writer(file)
    with open("./weights/output.fc.bias.csv", mode="r", newline="") as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            for item in row:
                float_item = float(item)
                writer.writerow([float_item])







file.close
csvfile.close
        


