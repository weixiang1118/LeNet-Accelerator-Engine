import csv
for i in range(100):
    with open(f"./activations/img{i}/image.csv", mode="w", newline="") as file:
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


file.close
csvfile.close

        
