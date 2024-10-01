# Training LeNet model
* 要注意的是，如果電腦cpu為intel，則不支援qnnpack，此時就需要用colab 去模擬，如何看自己cpu是否有支援:
   ``` python
  #check if qnnpack is supported
  print(torch.backends.quantized.supported_engines)
  ```
  請依照自己是否有支援來決定要在哪裡模擬
* Step 1 Open your Colab
* 
  此給不支援qnnpack者使用，如果有支援則跳過此步驟，到自己電腦鍵虛擬環境
  
  由於Colab package 沒有torchinfo，所以在一開始要先執行:
  ``` python
  !pip install torchinfo 
  ```
* Step 1 Create a Conda virtual environment
  ``` python
  conda create --name Lenet
  conda activate Lenet
  conda install -c conda-forge matplotlib
  conda install -c anaconda jupyter
  conda install -c conda-forge torchinfo
  ```
* Step 2 Autoreload

  由於有其他py檔，為了使更改py檔時，ipynb檔能夠自動讀到更改好的檔案，要加:
  ``` python
  %load_ext autoreload
  %autoreload 2
  ```
# Pattern processing
 在 Pattern processing folder中，會發現有  **all.py**、**convert.py**、**convert_h.py**、**golden.py**、**input.py**、**weight.py**

 這些為賺換成SRAM想要格式的python，只需運行**all.py** 就行，自動就會把後面所有程式執行完，就會產生符合的pattern

# Hardware
 只要有看到.sh 的檔案，需打以下指令
  ``` makefile
  sh *.sh
  ```
* spy.sh
 
  此為運行spyglass.tcl，裡面有下spyglass constrain ，去分析我們的RTL code 有甚麼問題
  
* ./sim/test.sh
  
  此為simulation 所有的pattern，去看demo是否成功，可以在rtl_sim_log去看所有的模擬結果

  注意: 如果要做gate_level 模擬，則要去test.sh裡，改:
  ``` makefile
  log_file="./gate_sim_log/gate_img${img}.log"
  vcs -full64 -R -debug_access+all +v2k +neg_tchk -f ${SYN_SRC}  +define+img=$img > $log_file 2>&1
  ```
  不過注意的是，跑gate_level 模擬，跑完所有pattern 會非常久，所以建議只跑一個側資就行，此時要執行
  ``` makefile
  make syn 
  ```
*./syn/syn.sh

  此為跑合成所需的指令，要改clock period 要在synthesis.tcl 去修改，其他constrain 則在compile.tcl 去做修改
