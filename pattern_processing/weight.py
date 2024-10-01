import csv

weight = []

with open("./weightend/conv1_weight.csv", mode="w", newline="") as file:
    with open("./weightstart/conv1_weight_no_combine.csv", mode="r", newline="") as csvfile:
        reader = csv.reader(csvfile)
        writer = csv.writer(file)
        string = ""
        x=0
        for row in reader:
            if(x<4):
                row1 = float(row[0])
                row1 = int(row1)
                row1 = format(row1 & 0xff , "02x")
                string = row1  + string
                x=x+1
                if(x==4):
                    #print(string)
                    write_weight = []
                    write_weight.append(string)
                    writer.writerow(write_weight)
            else: #if x ==4
                row1 = float(row[0])
                row1 = int(row1)
                row1 = format(row1 & 0xff , "02x")
                string = "000000" + row1
                x=0
                #print(string)
                write_weight = []
                weight.append(string)
                write_weight.append(string)
                writer.writerow(write_weight)
                string = ""

with open("./weightend/conv2_weight.csv", mode="w", newline="") as file:
    with open("./weightstart/conv2_weight_no_combine.csv", mode="r", newline="") as csvfile:
        reader = csv.reader(csvfile)
        writer = csv.writer(file)
        string = ""
        x=0
        for row in reader:
            if(x<4):
                row1 = float(row[0])
                row1 = int(row1)
                row1 = format(row1 & 0xff, "02x")
                string = row1  + string
                x=x+1
                if(x==4):
                    #print(string)
                    write_weight = []
                    weight.append(string)
                    write_weight.append(string)
                    writer.writerow(write_weight)
            else:
                row1 = float(row[0])
                row1 = int(row1)
                row1 = format(row1 & 0xff , "02x")
                string = "000000" + row1
                x=0
                #print(string)
                write_weight = []
                write_weight.append(string)
                weight.append(string)
                writer.writerow(write_weight)
                string = ""

with open("./weightend/conv3_weight.csv", mode="w", newline="") as file:
    with open("./weightstart/conv3_weight_no_combine.csv", mode="r", newline="") as csvfile:
        reader = csv.reader(csvfile)
        writer = csv.writer(file)
        string = ""
        x=0
        for row in reader:
            if(x<4):
                row1 = float(row[0])
                row1 = int(row1)
                row1 = format(row1 & 0xff , "02x")
                string = row1  + string
                x=x+1
                if(x==4):
                    #print(string)
                    write_weight = []
                    write_weight.append(string)
                    weight.append(string)
                    writer.writerow(write_weight)
                    x=0
                    string = ""
                    
with open("./weightend/fc1_weight.csv", mode="w", newline="") as file:
    with open("./weightstart/fc1_weight_no_combine.csv", mode="r", newline="") as csvfile:
        reader = csv.reader(csvfile)
        writer = csv.writer(file)
        string = ""
        x=0
        for row in reader:
            if(x<4):
                row1 = float(row[0])
                row1 = int(row1)
                row1 = format(row1 & 0xff, "02x")
                string = row1  + string
                x=x+1
                if(x==4):
                    #print(string)
                    write_weight = []
                    write_weight.append(string)
                    weight.append(string)
                    writer.writerow(write_weight)
                    x=0
                    string = ""

with open("./weightend/fc2_weight.csv", mode="w", newline="") as file:
    with open("./weightstart/fc2_weight_no_combine.csv", mode="r", newline="") as csvfile:
        reader = csv.reader(csvfile)
        writer = csv.writer(file)
        string = ""
        x=0
        for row in reader:
            if(x<4):
                row1 = float(row[0])
                row1 = int(row1)
                row1 = format(row1 & 0xff, "02x")
                string = row1  + string
                x=x+1
                if(x==4):
                    #print(string)
                    write_weight = []
                    write_weight.append(string)
                    weight.append(string)
                    writer.writerow(write_weight)
                    x=0
                    string = ""
                    
                    
with open("./weightend/fc2_bias.csv", mode="w", newline="") as file:
    with open("./weightstart/fc2_bias_no_combine.csv", mode="r", newline="") as csvfile:
        reader = csv.reader(csvfile)
        writer = csv.writer(file)
        string = ""
        for row in reader:
            row1 = float(row[0])
            row1 = int(row1)
            row1 = format(row1 & 0xffffffff , "08x")
            string = row1  + string
            #print(string)
            write_weight = []
            write_weight.append(string)
            weight.append(string)
            writer.writerow(write_weight)
            string = ""
      


input_files = [
    "./weightend/conv1_weight.csv",
    "./weightend/conv2_weight.csv",
    "./weightend/conv3_weight.csv",
    "./weightend/fc1_weight.csv",
    "./weightend/fc2_weight.csv",
    "./weightend/fc2_bias.csv"
]


output_file = "./weights/weights.csv"


with open(output_file, mode="w", newline="") as output_csv:
    writer = csv.writer(output_csv)
    for file in input_files:
        with open(file, mode="r", newline="") as input_csv:
            reader = csv.reader(input_csv)
            for row in reader:
                writer.writerow(row)

      


