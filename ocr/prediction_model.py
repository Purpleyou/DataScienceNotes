#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 4/1/2017
# @Author  : Ewen
# @Link    : http://example.org
# @Version : $1$

import pickle
import pandas as pd

if __name__ == '__main__':
    # load the model from disk
    filename = 'D:/finalized_model.sav'
    loaded_model = pickle.load(open(filename, 'rb'))

    # load the test data
    test = pd.read_csv("D:/test_no_label.csv")

    # print the results
    print(loaded_model.predict(test))