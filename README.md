# LeNet Accelerator Engine
![image](https://production-media.paperswithcode.com/methods/LeNet_Original_Image_48T74Lc.jpg)

Ref.: LeCun et al., Gradient-Based Learning Applied to Document Recognition, 1998a
* Software simulation
   <img src="https://github.com/user-attachments/assets/ad0d2a52-3099-4488-958f-46ca55a08412" div align =center />
  
   <div align="center">
   <img src="https://github.com/user-attachments/assets/bf557c8b-06c6-45da-8a75-a68cbf854c04" alt="Image" />
   </div>
   
  使用homework1.ipynb、quantutils.py 來 training LeNet model，使用 MNIST 資料集來訓練，並且使用 Quantization Aware Trainging (QAT) 應用到電路上面，因為在電路中如果有浮點數四則運算，會大幅降低電路效能，所以選擇量化，雖然降低一定的
  準確度，但可以大幅提升電路效能

  <div align="center">
  <img src="https://github.com/user-attachments/assets/43a3dcd9-e2bf-4eda-ad6f-8b57b95ba3a4" width="400" height="250" style="display: inline-block; margin-right: 10px;" />
  <img src="https://github.com/user-attachments/assets/416bd201-6ae4-4d0d-8340-f9064cee8ca9" width="400" height="250" style="display: inline-block;" />
</div>
  在pattern_processing 中，由於模擬生成的pattern 沒有符合電路SRAM 擺放的設定，必須要把原有的pattern 轉成相對應的格式
  
* Hardware

  ![image](https://github.com/user-attachments/assets/647fee80-cd94-44cb-ac6b-d956b9eb5bf6)

  電路採用8個pe 來達到 data reuse ，在每6個 cycle 中，會完成8個矩陣運算，經過兩次maxpool，產生兩個output

  ![image](https://github.com/user-attachments/assets/75153f78-8083-4d02-9fce-1f864a61c473)

  其中pe 採用pipeline 來減少critial path
  
  ![image](https://github.com/user-attachments/assets/174c8385-8aef-4ade-ae33-a402d2179d36)
  
  在sim 中 使用test.sh 來測試99個個img，搭配lenet_tb.sv來完成 vcs模擬

  |  Performance   |   | Unit |   
  |  :----:  | :----:  |   :----:  |
  | Gate-level simulation clock period  | 1.66  |ns|
  | Gate-level simulation latency | 25187  |cycles|
  | Total cell area | 44856.1396 | $um^2$|
  | Rank | 5/48 | 人|

  
