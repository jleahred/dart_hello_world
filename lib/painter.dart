library painter;

import 'dart:html';
import 'dart:math';

import 'package:color_picker/color_picker.dart';


Painter _painter;

void initPainter() {
  _painter = new Painter();
}

class Config {
  bool colorRandom = true;
  ColorValue color = new ColorValue.fromRGB(100, 100, 100);
  bool incrementalRadius = true;
  int radius = 20;
  bool fillShape = true;

  ConfigWidgets widgets = new ConfigWidgets();
}

class ConfigWidgets {
  RadioButtonInputElement random_color = querySelector("#random_color");
  RadioButtonInputElement custom_color = querySelector("#custom_color");

  RadioButtonInputElement incremental_radius = querySelector("#incremental_radius");
  RadioButtonInputElement custom_radius = querySelector("#custom_radius");
  RangeInputElement rage_radius = querySelector("#rage_radius");

  CheckboxInputElement filled = querySelector("#filled");
  ColorPicker colorPicker = new ColorPicker(128, showInfoBox: false);
}

class Painter {
  bool initializing = true;
  Random rgn = new Random();
  bool mouseDown = false;
  CanvasElement canvas;
  CanvasRenderingContext2D context;

  bool showSetup = false;
  Config config = new Config();

  Painter() {
    canvas = querySelector("#canvas");
    context = canvas.context2D;

    canvas
        ..onMouseMove.listen((mouseEvent) => onMouseMove(mouseEvent))
        ..onMouseDown.listen((_) => mouseDown = true)
        ..onMouseUp.listen((_) => mouseDown = false)
        ..onMouseLeave.listen((_) => mouseDown = false);

    prepareConfig();

    initButtons();
    clear();
    initializing = false;
  }

  void paintCircle(x, y) {
    ColorValue color = config.color;
    if (config.colorRandom) {
      color
          ..r += rgn.nextInt(30)
          ..g += rgn.nextInt(30)
          ..b += rgn.nextInt(30)
          ..r %= 255
          ..g %= 255
          ..b %= 255;
    }
    var stringColor = "rgb(${color.toRgbString()})";
    var radius = config.radius;
    if (config.incrementalRadius) {
      config.radius = config.radius > 30 ? 2 : config.radius + 1;
    }
    if (config.fillShape == false) {
      context
          ..beginPath()
          ..arc(x, y, config.radius, 0, 2 * PI)
          ..strokeStyle = stringColor
          ..stroke()
          ..closePath();
    } else {
      context
          ..beginPath()
          ..arc(x, y, config.radius, 0, 2 * PI)
          ..fillStyle = stringColor
          ..fill();
    }
  }

  void onMouseMove(MouseEvent event) {
    if (mouseDown) {
      var x = event.client.x - canvas.getBoundingClientRect().left;
      var y = event.client.y - canvas.getBoundingClientRect().top;

      paintCircle(x, y);
    }
  }
  void clear() {
    var lineWidth = 1;
    context
        ..fillStyle = "rgba(255, 255, 255, 1)"
        ..fillRect(0, 0, canvas.width, canvas.height);
    context
        ..beginPath()
        ..lineJoin = "round"
        ..lineWidth = lineWidth
        ..strokeStyle = "rgba(100, 100, 100, 1)"
        ..rect(lineWidth, lineWidth, canvas.width - lineWidth * 2, canvas.height - lineWidth * 2)
        ..stroke()
        ..closePath();
  }

  void initButtons() {
    querySelector("#clear").onClick.listen((_) => clear());
    querySelector("#setup_button").onClick.listen((_) => showHideSetup());
  }

  void showHideSetup() {
    if (showSetup) {
      querySelector("#setup_div").style.display = "none";
      showSetup = false;
    } else {
      querySelector("#setup_div").style.display = "";
      showSetup = true;
      updateUIConfig();
    }
  }
  void updateUIConfig() {
    if (config.colorRandom) {
      config.widgets
          ..random_color.checked = true
          ..custom_color.checked = false
          ..colorPicker.element.hidden = true;
    } else {
      config.widgets
          ..random_color.checked = false
          ..custom_color.checked = true
          ..colorPicker.element.hidden = false
          ..colorPicker.currentColor = config.color;
    }

    if (config.incrementalRadius) {
      config.widgets
          ..incremental_radius.checked = true
          ..custom_radius.checked = false
          ..rage_radius.hidden = true;
    } else {
      config.widgets
          ..incremental_radius.checked = false
          ..custom_radius.checked = true
          ..rage_radius.hidden = false
          ..custom_radius.value = config.radius.toString();
    }

    CheckboxInputElement cbf = querySelector("#filled");
    if (config.fillShape) {
      config.widgets..filled.checked = true;
    } else {
      config.widgets..filled.checked = false;
    }
  }

  void prepareConfig() {
    querySelector("#color_setup").nodes.add(config.widgets.colorPicker.element);
    updateUIConfig();
    config.widgets
        ..custom_color.onChange.listen((_) => updateConfigFromUI())
        ..custom_radius.onChange.listen((_) => updateConfigFromUI())
        ..filled.onChange.listen((_) => updateConfigFromUI())
        ..incremental_radius.onChange.listen((_) => updateConfigFromUI())
        ..rage_radius.onChange.listen((_) => updateConfigFromUI())
        ..random_color.onChange.listen((_) => updateConfigFromUI())
        ..colorPicker.colorChangeListener = ((_a, _b, _c, _d) => updateConfigFromUI());
  }
  void updateConfigFromUI() {
    if (!initializing) {
      config
          ..colorRandom = config.widgets.random_color.checked
          ..color = config.widgets.colorPicker.currentColor
          ..fillShape = config.widgets.filled.checked
          ..incrementalRadius = config.widgets.incremental_radius.checked
          ..radius = int.parse(config.widgets.rage_radius.value);

      updateUIConfig();
    }
  }
}
