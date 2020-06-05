# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'driver.ui'
#
# Created by: PyQt5 UI code generator 5.13.0
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


registered_users = []


def load_registered_users():
    with open('authorized_users.txt') as f:
        registered_users = f.read().splitlines()


def print_registered_users():
    with open('authorized_users.txt') as f:
        registered_users = f.read().splitlines()
    print("\nRegistered users: ")
    for user in registered_users:
        print(user)
    print('---' * 3)


def write_users():
    driver = ui.textEdit.toPlainText().strip().lower()
    file = open('authorized_users.txt', 'a+')
    if driver in registered_users:
        print('User \'{}\'  already registered.'.format(driver))
    else:
        file.write(driver + '\n')
        print(driver, 'is added..')
        ui.label_4.setText('{} added'.format(driver))
        ui.textEdit.setText('')
        file.close()
        load_registered_users()


def on_click_add_user(checked):
    write_users()
    print_registered_users()



def on_click_remove_user(checked):
    driver = ui.textEdit.toPlainText().strip()
    with open("authorized_users.txt", "r") as f:
        lines = f.readlines()
    if driver in lines:
        print('user does not exists')
    else:
        with open("authorized_users.txt", "w") as f:
            for line in lines:
                if line.strip("\n") != driver:
                    f.write(line)
        print('User \'{}\' is removed..'.format(driver))
        print_registered_users()


class Ui_Dialog(object):
    def setupUi(self, Dialog):
        Dialog.setObjectName("Dialog")
        Dialog.resize(308, 288)
        self.buttonBox = QtWidgets.QDialogButtonBox(Dialog)
        self.buttonBox.setGeometry(QtCore.QRect(10, 240, 281, 32))
        self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
        self.buttonBox.setStandardButtons(QtWidgets.QDialogButtonBox.Cancel|QtWidgets.QDialogButtonBox.Ok)
        self.buttonBox.setObjectName("buttonBox")
        self.pushButton = QtWidgets.QPushButton(Dialog)
        self.pushButton.setGeometry(QtCore.QRect(10, 201, 131, 23))
        self.pushButton.setObjectName("pushButton")
        self.pushButton.clicked.connect(on_click_add_user)
        self.pushButton_2 = QtWidgets.QPushButton(Dialog)
        self.pushButton_2.setGeometry(QtCore.QRect(160, 201, 131, 23))
        self.pushButton_2.setObjectName("pushButton_2")
        self.pushButton_2.clicked.connect(on_click_remove_user)
        self.label = QtWidgets.QLabel(Dialog)
        self.label.setGeometry(QtCore.QRect(20, 150, 71, 31))
        self.label.setObjectName("label")
        self.label_2 = QtWidgets.QLabel(Dialog)
        self.label_2.setGeometry(QtCore.QRect(20, 0, 261, 101))
        self.label_2.setObjectName("label_2")
        self.textEdit = QtWidgets.QTextEdit(Dialog)
        self.textEdit.setGeometry(QtCore.QRect(100, 151, 191, 31))
        self.textEdit.setObjectName("textEdit")
        self.label_3 = QtWidgets.QLabel(Dialog)
        self.label_3.setGeometry(QtCore.QRect(20, 90, 261, 31))
        font = QtGui.QFont()
        font.setPointSize(10)
        font.setBold(True)
        font.setWeight(75)
        self.label_3.setFont(font)
        self.label_3.setAlignment(QtCore.Qt.AlignCenter)
        self.label_3.setObjectName("label_3")
        self.label_4 = QtWidgets.QLabel(Dialog)
        self.label_4.setGeometry(QtCore.QRect(20, 250, 47, 13))
        self.label_4.setObjectName("label_4")

        self.retranslateUi(Dialog)
        self.buttonBox.accepted.connect(Dialog.accept)
        self.buttonBox.rejected.connect(Dialog.reject)
        QtCore.QMetaObject.connectSlotsByName(Dialog)

    def retranslateUi(self, Dialog):
        _translate = QtCore.QCoreApplication.translate
        Dialog.setWindowTitle(_translate("Dialog", "Dialog"))
        self.pushButton.setText(_translate("Dialog", "Add user"))
        self.pushButton_2.setText(_translate("Dialog", "Remove User"))
        self.label.setText(_translate("Dialog", "Driver Name"))
        self.label_2.setText(_translate("Dialog", "<html><head/><body><p><img src=\":/newPrefix/assets/ABU.png\"/></p></body></html>"))
        self.label_3.setText(_translate("Dialog", "CS491/2 Driver name registration"))
        self.label_4.setText(_translate("Dialog", ""))
import resource_rc


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    Dialog = QtWidgets.QDialog()
    ui = Ui_Dialog()
    ui.setupUi(Dialog)
    Dialog.show()

    with open('authorized_users.txt') as f:
        registered_users = f.read().splitlines()

    # print(registered_users)

    sys.exit(app.exec_())
