import os
from torch.utils.data import DataLoader, Dataset
import torchvision.transforms as transforms
from PIL import Image
import numpy as np
import pandas as pd
from torchvision import models
import torch.nn as nn
from pathlib import Path
import torch
from torch.autograd import Variable
import torch.nn.functional as F

NUMBER = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
ALPHABET = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u',
            'v', 'w', 'x', 'y', 'z']
ALL_CHAR_SET = NUMBER + ALPHABET
ALL_CHAR_SET_LEN = len(ALL_CHAR_SET)
MAX_CAPTCHA = 5



def encode(a):
    onehot = [0] * ALL_CHAR_SET_LEN
    index = ALL_CHAR_SET.index(a)
    onehot[index] += 1
    return onehot


class DataSet(Dataset):
    def __init__(self, path, is_train=True, transform=None):
        self.path = path
        if is_train:
            self.img = os.listdir(self.path)[:250]
        else:
            self.img = os.listdir(self.path)[251:]
        self.transform = transform

    def __getitem__(self, index):
        img_path = self.img[index]
        img = Image.open(self.path / img_path)
        img = img.convert('L')
        label = Path(self.path / img_path).name[:-4]
        label_oh = []
        for i in label:
            label_oh += encode(i)
        if self.transform is not None:
            img = self.transform(img)
        return img, np.array(label_oh), label

    def __len__(self):
        return len(self.img)


transform = transforms.Compose([
    transforms.Resize([224, 224]),
    transforms.ToTensor(),
])

train_dataset = DataSet(Path('samples'), transform=transform)
test_dataset = DataSet(Path('samples'), False, transform)
train_dataloader = DataLoader(train_dataset, batch_size=64, num_workers=0, shuffle=True)
test_dataloader = DataLoader(test_dataset, batch_size=1, num_workers=0, shuffle=True)

if os.path.isfile('model/model.pth'):
    model = torch.load('model/model.pth')
else:
    model = models.resnet18(pretrained=False)
    model.conv1 = nn.Conv2d(1, 64, kernel_size=(7, 7), stride=(2, 2), padding=(3, 3), bias=False)
    model.fc = nn.Linear(in_features=512, out_features=ALL_CHAR_SET_LEN * MAX_CAPTCHA, bias=True)

train = False
test = True

loss_function = nn.MultiLabelSoftMarginLoss()
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

if train == True:
    for epoch in range(20): #epochs amount
        print('epoch:', epoch + 1)
        print('----------------')
        for step, i in enumerate(train_dataloader):
            img, label_oh, label = i
            img = Variable(img)
            label_oh = Variable(label_oh.float())
            prediction = model(img)
            loss = loss_function(prediction, label_oh)
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()
            print('step:', step+1)
            print('loss:', loss.item())
            print('accuracy:', round(100-(loss.item()*100), 2), '%')

        print('----------------')
        PATH = 'model/model.pth'
        torch.save(model, PATH)

model.eval()

if test == True:
    for step, (img, label_oh, label) in enumerate(test_dataloader):
        img = Variable(img)
        prediction = model(img)

        c0 = ALL_CHAR_SET[np.argmax(prediction.squeeze().cpu().tolist()[0:ALL_CHAR_SET_LEN])]
        c1 = ALL_CHAR_SET[np.argmax(prediction.squeeze().cpu().tolist()[ALL_CHAR_SET_LEN:ALL_CHAR_SET_LEN*2])]
        c2 = ALL_CHAR_SET[np.argmax(prediction.squeeze().cpu().tolist()[ALL_CHAR_SET_LEN*2:ALL_CHAR_SET_LEN*3])]
        c3 = ALL_CHAR_SET[np.argmax(prediction.squeeze().cpu().tolist()[ALL_CHAR_SET_LEN*3:ALL_CHAR_SET_LEN*4])]
        c4 = ALL_CHAR_SET[np.argmax(prediction.squeeze().cpu().tolist()[ALL_CHAR_SET_LEN*4:ALL_CHAR_SET_LEN*5])]
        c = '%s%s%s%s%s' % (c0, c1, c2, c3, c4)

        print('label:', label[0], 'pred:', c)