# WEB FUN

A single website written with flutter with two Crud models connected with an Spring DB in order to have fun with a Fullstack challenge.

#### Features
* *View* Home page.
* *View* Orders page.
* *View* Products page.

* *Get* Paginated Orders.
* *Post* Create Orders.
* *Patch* Update Orders.
* *Get* Paginated Products.
* *Post* Create Products.
* *Patch* Update Products.
* *Delete* Delete Products.

#### Technical Features
* *MVProvider pattern*.
* Flutter 3.0.3.
* Dart 2.10.2.
* Tested on Chrome Only
* Pseudo Responsive

## Running
0. Prerequisites - Technical
```
Be aware on having above versions
```
0. Prerequisites - Backend
```
Go to clone and run using README on the following repo:
https://github.com/zphoenixz/spring-fun
```
1. Get the repo
```
git clone git@github.com:zphoenixz/web-fun.git
```
2. Go to the repo folder
```
cd web-fun
```
3. Install flutter libs
```
flutter pub get
```
4. Start Flutter Application
```
flutter run -d chrome
```
5. Test WEB on CHROME
```
localhost/{{randomPort}}
```

#### Screenshots
<p align="center">
<img src="https://github.com/zphoenixz/web-fun/blob/master/screenshots/order.png" width="500" height="400">
</p>
<p align="center">
<img src="https://github.com/zphoenixz/web-fun/blob/master/screenshots/create-order.png" width="500" height="400">
</p>
<p align="center">
<img src="https://github.com/zphoenixz/web-fun/blob/master/screenshots/product.png" width="500" height="400">
</p>
<p align="center">
<img src="https://github.com/zphoenixz/web-fun/blob/master/screenshots/create-product.png" width="500" height="400">
</p>

## My comments
It is simple enough to fullfill the challenge, some improvements that needs to be done see are:
* Decouple multiple some widgets that are 
* Work in cleanning some constants.
* Improve the UI responsiveness
* more....