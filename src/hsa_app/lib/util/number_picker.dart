import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:infinite_listview/infinite_listview.dart';

/// Created by Marcin Szałek

///Define a text mapper to transform the text displayed by the picker
typedef String TextMapper(String numberText);

///NumberPicker is a widget designed to pick a number between #minValue and #maxValue
class NumberPicker extends StatelessWidget {
  ///height of every list element for normal number picker
  ///width of every list element for horizontal number picker
  static const double kDefaultItemExtent = 50.0;

  ///width of list view for normal number picker
  ///height of list view for horizontal number picker
  static const double kDefaultListViewCrossAxisSize = 100.0;

  //整数
  NumberPicker.integer({
    Key key,
    @required int initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    this.textMapper,
    this.itemExtent = kDefaultItemExtent,
    this.listViewWidth = kDefaultListViewCrossAxisSize,
    this.step = 1,
    this.scrollDirection = Axis.vertical,
    this.infiniteLoop = false,
    this.zeroPad = false,
    this.highlightSelectedValue = true,
    this.decoration,
    this.defaultStyle,
    this.selectedStyle,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue >= minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        assert(scrollDirection != null),
        selectedIntValue = initialValue,
        selectedDecimalValue = -1,
        decimalPlaces = 0,
        intScrollController = infiniteLoop
            ? new InfiniteScrollController(
                initialScrollOffset:
                    (initialValue - minValue) ~/ step * itemExtent,
              )
            : new ScrollController(
                initialScrollOffset:
                    (initialValue - minValue) ~/ step * itemExtent,
              ),
        decimalScrollController = null,
        listViewHeight = 3 * itemExtent,
        integerItemCount = (maxValue - minValue) ~/ step + 1,
        super(key: key);

  //当选择的值改变时调用
  final ValueChanged<num> onChanged;

  //最小值
  final int minValue;

  //最大值
  final int maxValue;
  
  //在选择器上构建每个项目的文本
  final TextMapper textMapper;

  ///inidcates how many decimal places to show
  /// e.g. 0=>[1,2,3...], 1=>[1.0, 1.1, 1.2...]  2=>[1.00, 1.01, 1.02...]
  final int decimalPlaces;

  //每个列表元素的高度
  final double itemExtent;

  //列表视图的高度
  final double listViewHeight;

  //列表视图的宽度
  final double listViewWidth;

  ///ScrollController used for integer list
  final ScrollController intScrollController;

  ///ScrollController used for decimal list
  final ScrollController decimalScrollController;

  //当前选择的整数值
  final int selectedIntValue;

  //当前选择的小数值
  final int selectedDecimalValue;

  ///If currently selected value should be highlighted
  final bool highlightSelectedValue;

  //应用于放置所选值的中央框
  final Decoration decoration;

  ///Step between elements. Only for integer datePicker
  ///Examples:
  /// if step is 100 the following elements may be 100, 200, 300...
  /// if min=0, max=6, step=3, then items will be 0, 3 and 6
  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final int step;

  /// Direction of scrolling
  final Axis scrollDirection;

  ///Repeat values infinitely
  final bool infiniteLoop;

  ///Pads displayed integer values up to the length of maxValue
  final bool zeroPad;

  ///Amount of items
  final int integerItemCount;

  //未选中
  final TextStyle defaultStyle;

  //选中
  final TextStyle selectedStyle;

  //
  //----------------------------- PUBLIC ------------------------------
  //

  /// Used to animate integer number picker to new selected value
  void animateInt(int valueToSelect) {
    int diff = valueToSelect - minValue;
    int index = diff ~/ step;
    animateIntToIndex(index);
  }

  /// Used to animate integer number picker to new selected index
  void animateIntToIndex(int index) {
    _animate(intScrollController, index * itemExtent);
  }

  //
  //----------------------------- VIEWS -----------------------------
  //

  ///main widget
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    if (infiniteLoop) {
      return _integerInfiniteListView(themeData);
    }
    if (decimalPlaces == 0) {
      return _integerListView(themeData);
    } else {
      return new Row(
        children: <Widget>[
          _integerListView(themeData),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
  }

  Widget _integerListView(ThemeData themeData) {
    TextStyle defaultStyle = this.defaultStyle ?? themeData.textTheme.body1;
    TextStyle selectedStyle = this.selectedStyle
       ?? themeData.textTheme.headline.copyWith(color: themeData.accentColor);

    var listItemCount = integerItemCount + 2;

    return Listener(
      onPointerUp: (ev) {
        ///used to detect that user stopped scrolling
        if (intScrollController.position.activity is HoldScrollActivity) {
          animateInt(selectedIntValue);
        }
      },
      child: new NotificationListener(
        child: new Container(
          height: listViewHeight,
          width: listViewWidth,
          child: Stack(
            children: <Widget>[
              new ListView.builder(
                scrollDirection: scrollDirection,
                controller: intScrollController,
                itemExtent: itemExtent,
                itemCount: listItemCount,
                cacheExtent: _calculateCacheExtent(listItemCount),
                itemBuilder: (BuildContext context, int index) {
                  final int value = _intValueFromIndex(index);

                  //define special style for selected (middle) element
                  final TextStyle itemStyle =
                      value == selectedIntValue && highlightSelectedValue
                          ? selectedStyle
                          : defaultStyle;

                  bool isExtra = index == 0 || index == listItemCount - 1;

                  return isExtra
                      ? new Container() //empty first and last element
                      : new Center(
                          child: new Text(
                            getDisplayedValue(value),
                            style: itemStyle,
                          ),
                        );
                },
              ),
              _NumberPickerSelectedItemDecoration(
                axis: scrollDirection,
                itemExtent: itemExtent,
                decoration: decoration,
              ),
            ],
          ),
        ),
        onNotification: _onIntegerNotification,
      ),
    );
  }

  

  Widget _integerInfiniteListView(ThemeData themeData) {
    TextStyle defaultStyle = this.defaultStyle ?? themeData.textTheme.body1;
    TextStyle selectedStyle = this.selectedStyle 
       ??  themeData.textTheme.headline.copyWith(color: themeData.accentColor);

    return Listener(
      onPointerUp: (ev) {
        ///used to detect that user stopped scrolling
        if (intScrollController.position.activity is HoldScrollActivity) {
          _animateIntWhenUserStoppedScrolling(selectedIntValue);
        }
      },
      child: new NotificationListener(
        child: new Container(
          height: listViewHeight,
          width: listViewWidth,
          child: Stack(
            children: <Widget>[
              InfiniteListView.builder(
                controller: intScrollController,
                itemExtent: itemExtent,
                itemBuilder: (BuildContext context, int index) {
                  final int value = _intValueFromIndex(index);

                  //define special style for selected (middle) element
                  final TextStyle itemStyle =
                      value == selectedIntValue && highlightSelectedValue
                          ? selectedStyle
                          : defaultStyle;

                  return new Center(
                    child: new Text(
                      getDisplayedValue(value),
                      style: itemStyle,
                    ),
                  );
                },
              ),
              _NumberPickerSelectedItemDecoration(
                axis: scrollDirection,
                itemExtent: itemExtent,
                decoration: decoration,
              ),
            ],
          ),
        ),
        onNotification: _onIntegerNotification,
      ),
    );
  }

  String getDisplayedValue(int value) {
    final text = zeroPad
        ? value.toString().padLeft(maxValue.toString().length, '0')
        : value.toString();
    return textMapper != null ? textMapper(text) : text;
  }

  //
  // ----------------------------- LOGIC -----------------------------
  //

  int _intValueFromIndex(int index) {
    index--;
    index %= integerItemCount;
    return minValue + index * step;
  }

  bool _onIntegerNotification(Notification notification) {
    if (notification is ScrollNotification) {
      //calculate
      int intIndexOfMiddleElement =
          (notification.metrics.pixels / itemExtent).round();
      if (!infiniteLoop) {
        intIndexOfMiddleElement =
            intIndexOfMiddleElement.clamp(0, integerItemCount - 1);
      }
      int intValueInTheMiddle = _intValueFromIndex(intIndexOfMiddleElement + 1);
      intValueInTheMiddle = _normalizeIntegerMiddleValue(intValueInTheMiddle);

      if (_userStoppedScrolling(notification, intScrollController)) {
        //center selected value
        animateIntToIndex(intIndexOfMiddleElement);
      }

      //update selection
      if (intValueInTheMiddle != selectedIntValue) {
        num newValue;
        if (decimalPlaces == 0) {
          //return integer value
          newValue = (intValueInTheMiddle);
        } else {
          if (intValueInTheMiddle == maxValue) {
            //if new value is maxValue, then return that value and ignore decimal
            newValue = (intValueInTheMiddle.toDouble());
            //animateDecimal(0);
          } else {
            //return integer+decimal
            double decimalPart = _toDecimal(selectedDecimalValue);
            newValue = ((intValueInTheMiddle + decimalPart).toDouble());
          }
        }
        onChanged(newValue);
      }
    }
    return true;
  }

  

  ///There was a bug, when if there was small integer range, e.g. from 1 to 5,
  ///When user scrolled to the top, whole listview got displayed.
  ///To prevent this we are calculating cacheExtent by our own so it gets smaller if number of items is smaller
  double _calculateCacheExtent(int itemCount) {
    double cacheExtent = 250.0; //default cache extent
    if ((itemCount - 2) * kDefaultItemExtent <= cacheExtent) {
      cacheExtent = ((itemCount - 3) * kDefaultItemExtent);
    }
    return cacheExtent;
  }

  ///When overscroll occurs on iOS,
  ///we can end up with value not in the range between [minValue] and [maxValue]
  ///To avoid going out of range, we change values out of range to border values.
  int _normalizeMiddleValue(int valueInTheMiddle, int min, int max) {
    return math.max(math.min(valueInTheMiddle, max), min);
  }

  int _normalizeIntegerMiddleValue(int integerValueInTheMiddle) {
    //make sure that max is a multiple of step
    int max = (maxValue ~/ step) * step;
    return _normalizeMiddleValue(integerValueInTheMiddle, minValue, max);
  }

  

  ///indicates if user has stopped scrolling so we can center value in the middle
  bool _userStoppedScrolling(
    Notification notification,
    ScrollController scrollController,
  ) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  /// Allows to find currently selected element index and animate this element
  /// Use it only when user manually stops scrolling in infinite loop
  void _animateIntWhenUserStoppedScrolling(int valueToSelect) {
    // estimated index of currently selected element based on offset and item extent
    int currentlySelectedElementIndex = intScrollController.offset ~/ itemExtent;

    // when more(less) than half of the top(bottom) element is hidden
    // then we should increment(decrement) index in case of positive(negative) offset
    if (intScrollController.offset > 0 &&
        intScrollController.offset % itemExtent > itemExtent / 2) {
      currentlySelectedElementIndex++;
    } else if (intScrollController.offset < 0 &&
        intScrollController.offset % itemExtent < itemExtent / 2) {
      currentlySelectedElementIndex--;
    }

    animateIntToIndex(currentlySelectedElementIndex);
  }

  ///converts integer indicator of decimal value to double
  ///e.g. decimalPlaces = 1, value = 4  >>> result = 0.4
  ///     decimalPlaces = 2, value = 12 >>> result = 0.12
  double _toDecimal(int decimalValueAsInteger) {
    return double.parse((decimalValueAsInteger * math.pow(10, -decimalPlaces))
        .toStringAsFixed(decimalPlaces));
  }

  ///scroll to selected value
  _animate(ScrollController scrollController, double value) {
    if(!scrollController.positions.isNotEmpty) return;
    scrollController.animateTo(value,
        duration: new Duration(seconds: 1), curve: new ElasticOutCurve());
      
  }
}

class _NumberPickerSelectedItemDecoration extends StatelessWidget {
  final Axis axis;
  final double itemExtent;
  final Decoration decoration;

  const _NumberPickerSelectedItemDecoration(
      {Key key,
      @required this.axis,
      @required this.itemExtent,
      @required this.decoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new IgnorePointer(
        child: new Container(
          width: isVertical ? double.infinity : itemExtent,
          height: isVertical ? itemExtent : double.infinity,
          decoration: decoration,
        ),
      ),
    );
  }

  bool get isVertical => axis == Axis.vertical;
}


//4位数滚轮
class NumberPickerRow extends StatefulWidget {

  //0-9999 最大值
  final int max;

  //小数位数 0-3
  final int decimal;

  //当前值
  final int current;

  //当选择的值改变时调用
  final ValueChanged<num> onChanged;
  
  //每个列表元素的高度
  final double itemExtent;

  //列表视图的宽度
  final double listViewWidth;

  //应用于放置所选值的中央框
  final Decoration decoration;

  //未选中
  final TextStyle defaultStyle;

  //选中
  final TextStyle selectedStyle;
  

  ///constructor for integer values
  NumberPickerRow.integer({
    @required this.onChanged,
    @required this.max,
    @required this.current,
    this.decimal = 0,
    this.decoration,
    this.listViewWidth = 50,
    this.itemExtent = 50,
    this.defaultStyle,
    this.selectedStyle,
  }): assert(decimal >=0 && decimal <= 3 ),
      assert(max >=0 && max <= 9999 ),
      assert(max >=0 && max <= 9999 );

  @override
  State<NumberPickerRow> createState() =>
    new _NumberPickerRowControllerState(
      max: max,
      current:current,
      decimal:decimal,
      decoration:decoration,
      listViewWidth:listViewWidth,
      onChanged:onChanged,
      itemExtent: itemExtent,
      defaultStyle: defaultStyle,
      selectedStyle: selectedStyle
    );
}

class _NumberPickerRowControllerState extends State<NumberPickerRow> {
  
  _NumberPickerRowControllerState({
    this.max,
    this.current,
    this.decimal,
    this.decoration,
    this.onChanged,
    this.listViewWidth,
    this.itemExtent,
    this.defaultStyle,
    this.selectedStyle
  });

  
  int max;
  int decimal;
  int current;
  double itemExtent;
  double listViewWidth;
  Decoration decoration;
  TextStyle defaultStyle;
  TextStyle selectedStyle;
  ValueChanged<num> onChanged;
  
  NumberPicker oneNumberPicker;
  NumberPicker twoNumberPicker;
  NumberPicker threeNumberPicker;
  NumberPicker fourNumberPicker;

  //当前值
  int _currentOneValue = 0;
  int _currentTwoValue = 0;
  int _currentThreeValue = 0;
  int _currentFourValue = 0;

  //数字长度
  int size = 0;

  //最大值
  int oneMax = 0;
  int twoMax = 0;
  int threeMax = 0;
  int fourMax = 0;

  @override
  void initState() {
    mathData(max,current);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //整理数据
  void mathData(int max ,int current){
    
    if(max >= 1000){
      oneMax = max~/1000%10 ;
      _currentOneValue = current~/1000%10;
      twoMax = 9;
      _currentTwoValue = current~/100%10;
      threeMax = 9;
      _currentThreeValue = current~/10%10;
      fourMax = 9;
      _currentFourValue = current%10;
      size = 4;
    }else if(max >= 100 && max < 1000){
      twoMax = max~/100%10;
      _currentTwoValue = current~/100%10;
      threeMax = 9;
      _currentThreeValue = current~/10%10;
      fourMax = 9;
      _currentFourValue = current%10;
      size = 3;
    }else if(max >= 10 && max < 100){
      threeMax = max~/10%10 ;
      _currentThreeValue = current~/10%10;
      fourMax = 9;
      _currentFourValue = current%10;
      size = 2;
    }else if(max >= 0 && max < 10){
      fourMax = max%10;
      _currentFourValue = current%10;
      size = 1;
    }

    onChanged(mathOnChanged());
  }

  //刷新数据
  void reflashData(){
    if(_currentOneValue != oneMax){
      twoMax = 9;
      threeMax = 9;
      fourMax = 9;
    }else {
      twoMax = max~/100%10;
      if(_currentTwoValue != twoMax){
        threeMax = 9;
        fourMax = 9;
      }else{
        threeMax =  max~/10%10;
        if(_currentThreeValue != threeMax){
          fourMax = 9;
        }else{
          fourMax =  max%10;
        }
      }
    }
    //刷新picker
    _initializeNumberPickers();
    onChanged(mathOnChanged());
  }

  //计算回传数值
  num mathOnChanged(){

    if(size == 4){
      return (_currentOneValue*1000+_currentTwoValue*100+_currentThreeValue*10+_currentFourValue)/(decimal > 0 ?  pow(10, decimal): 1);
    }else if(size == 3){
      return (_currentTwoValue*100+_currentThreeValue*10+_currentFourValue)/(decimal > 0 ?  pow(10, decimal) : 1);
    }else if(size == 2){
      return (_currentThreeValue*10+_currentFourValue)/(decimal > 0 ? pow(10, decimal) : 1);
    }else if(size == 1){
      return _currentFourValue;
    }else{
      return 0;
    }
  }

  //初始化picker
  void _initializeNumberPickers() {
      

    oneNumberPicker = new NumberPicker.integer(
      initialValue: _currentOneValue >= oneMax ? oneMax : _currentOneValue,
      minValue: 0,
      maxValue: oneMax,
      infiniteLoop: oneMax != 0,
      listViewWidth: listViewWidth,
      itemExtent:itemExtent,
      decoration: decoration,
      defaultStyle: defaultStyle,
      selectedStyle: selectedStyle,
      onChanged: (value) => setState(() {
        _currentOneValue = value;
        twoNumberPicker.animateIntToIndex(0);
        _currentTwoValue = 0;
        threeNumberPicker.animateIntToIndex(0);
        _currentThreeValue = 0;
        fourNumberPicker.animateIntToIndex(0);
        _currentFourValue = 0;
        reflashData();
      }),
    );
    twoNumberPicker = new NumberPicker.integer(
      initialValue: _currentTwoValue >= twoMax ? twoMax : _currentTwoValue,
      minValue: 0,
      maxValue: twoMax,
      infiniteLoop: twoMax != 0,
      listViewWidth: listViewWidth,
      itemExtent:itemExtent,
      decoration: decoration,
      defaultStyle: defaultStyle,
      selectedStyle: selectedStyle,
      onChanged: (value) => setState(() {
        _currentTwoValue = value;
        threeNumberPicker.animateIntToIndex(0);
        _currentThreeValue = 0;
        fourNumberPicker.animateIntToIndex(0);
        _currentFourValue = 0;
        reflashData();
      }),
    );
    threeNumberPicker = new NumberPicker.integer(
      initialValue: _currentThreeValue >= threeMax ? threeMax : _currentThreeValue,
      minValue: 0,
      maxValue: threeMax,
      infiniteLoop: threeMax != 0,
      listViewWidth: listViewWidth,
      itemExtent:itemExtent,
      decoration: decoration,
      defaultStyle: defaultStyle,
      selectedStyle: selectedStyle,
      onChanged: (value) => setState(() {
        _currentThreeValue = value;
        fourNumberPicker.animateIntToIndex(0);
        _currentFourValue = 0;
        reflashData();
      }),
    );
    fourNumberPicker = new NumberPicker.integer(
      initialValue: _currentFourValue >= fourMax ? fourMax : _currentFourValue,
      minValue: 0,
      maxValue: fourMax,
      infiniteLoop: fourMax != 0,
      listViewWidth: listViewWidth,
      itemExtent:itemExtent,
      decoration: decoration,
      defaultStyle: defaultStyle,
      selectedStyle: selectedStyle,
      onChanged: (value) => setState(() {
        _currentFourValue = value;
        reflashData();
      }),
    );
  }

  //根据数据长度显示滚轮
  List<Widget> numberPickerWidget(int size,int decimal){
    List<Widget> list = [];

    if(size == 4){
      list.add(oneNumberPicker);
      list.add(twoNumberPicker);
      list.add(threeNumberPicker);
      list.add(fourNumberPicker);
    }else if(size == 3){
      list.add(twoNumberPicker);
      list.add(threeNumberPicker);
      list.add(fourNumberPicker);
    }else if(size == 2){
      list.add(threeNumberPicker);
      list.add(fourNumberPicker);
    }else if(size == 1){
      list.add(fourNumberPicker);
    }
    
    if(decimal > 0){
      
      list.insert(list.length-decimal, decimalWidget());
    }
    
    return list;
  }

  Widget decimalWidget(){
    return Text('.',style:selectedStyle ?? TextStyle(fontSize: 24,),);
  }
  
  
  @override
  Widget build(BuildContext context) {
    
    _initializeNumberPickers();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: numberPickerWidget(size,decimal),
    );
    
  }

  
}