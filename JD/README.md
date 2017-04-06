## JingDong Data Competition

According to the scoring standard, it is reasonable to seperate our task into two parts: 

- Prediction about who would buy any products in the period. 

- For those who would buy any products, what would they buy. 


### Scoring

参赛者提交的结果文件中包含对所有用户购买意向的预测结果。对每一个用户的预测结果包括两方面：

- 1、该用户2016-04-16到2016-04-20是否下单P中的商品，提交的结果文件中仅包含预测为下单的用户，预测为未下单的用户，无须在结果中出现。若预测正确，则评测算法中置label=1，不正确label=0；
- 2、如果下单，下单的sku_id （只需提交一个sku_id），若sku_id预测正确，则评测算法中置pred=1，不正确pred=0。

对于参赛者提交的结果文件，按如下公式计算得分：

$$Score=0.4*F11 + 0.6* F12$$

此处的F1值定义为：

$$F11=6*Recall*Precise/(5*Recall+Precise)$$
$$F12=5*Recall*Precise/(2*Recall+3*Precise)$$

其中，Precise为准确率，Recall为召回率.

F11是label=1或0的F1值，F12是pred=1或0的F1值.
