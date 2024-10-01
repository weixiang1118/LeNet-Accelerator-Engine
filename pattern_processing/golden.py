import csv

for i in range(100):
    with open(f"./actend/input_feature_map{i}.csv", mode="w", newline="") as file:
        with open(f"./actstart/input_no_combine{i}.csv", mode="r", newline="") as csvfile:
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
                        x=0
                        string = ""

    with open(f"./actend/conv1_activation{i}.csv", mode="w", newline="") as file:
        with open(f"./actstart/conv1_no_combine{i}.csv", mode="r", newline="") as csvfile:
            reader = csv.reader(csvfile)
            writer = csv.writer(file)
            string = ""
            x=0
            y=0
            for row in reader:
                if(y<3):    
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
                            writer.writerow(write_weight)
                            string = ""
                            x=0
                            y=y+1
                else: #if y ==3          
                    if(x<2):
                        row1 = float(row[0])
                        row1 = int(row1)
                        row1 = format(row1 & 0xff , "02x")
                        string = row1  + string
                        x=x+1
                        if(x==2):
                            string = "0000" + string
                            write_weight = []
                            write_weight.append(string)
                            writer.writerow(write_weight)
                            x = 0
                            y = 0
                            string = ""
                        
                        
    with open(f"./actend/conv2_activation{i}.csv", mode="w", newline="") as file:
        with open(f"./actstart/conv2_no_combine{i}.csv", mode="r", newline="") as csvfile:
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
                        x=0
                        string = ""
        
    with open(f"./actend/conv3_activation{i}.csv", mode="w", newline="") as file:
        with open(f"./actstart/conv3_no_combine{i}.csv", mode="r", newline="") as csvfile:
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
                        x=0
                        string = ""
            
    with open(f"./actend/fc1_activation{i}.csv", mode="w", newline="") as file:
        with open(f"./actstart/fc1_no_combine{i}.csv", mode="r", newline="") as csvfile:
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
                        writer.writerow(write_weight)
                        x=0
                        string = ""

    with open(f"./actend/fc2_activation{i}.csv", mode="w", newline="") as file:
        with open(f"./actstart/output_no_combine{i}.csv", mode="r", newline="") as csvfile:
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
                writer.writerow(write_weight)
                string = ""
                
                
                
    input_files = [
        f"./actend/input_feature_map{i}.csv",
        f"./actend/conv1_activation{i}.csv",
        f"./actend/conv2_activation{i}.csv",
        f"./actend/conv3_activation{i}.csv",
        f"./actend/fc1_activation{i}.csv",
        f"./actend/fc2_activation{i}.csv"
    ]


    output_file = f"./activations/img{i}/golden.csv"


    with open(output_file, mode="w", newline="") as output_csv:
        writer = csv.writer(output_csv)
        for file in input_files:
            with open(file, mode="r", newline="") as input_csv:
                reader = csv.reader(input_csv)
                for row in reader:
                    writer.writerow(row)
            

               

#file.close
csvfile.close

