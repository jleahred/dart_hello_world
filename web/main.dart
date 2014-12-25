// Copyright (c) 2014, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:hello_world/nav_menu.dart';
import 'package:route_hierarchical/client.dart';
import 'package:hello_world/painter.dart';
import 'package:markdown/markdown.dart' show markdownToHtml;


void main() {
  initNavMenu();
  initPainter();
  initReadme();

  // Webapps need routing to listen for changes to the URL.
  var router = new Router();
  router.root
      ..addRoute(name: 'about', path: '/about', enter: showAbout)
      ..addRoute(name: 'home', defaultRoute: true, path: '/', enter: showHome)
      ..addRoute(name: 'readme', path: '/readme', enter: showReadme);
  router.listen();
}


void updateHeaderCaption(String context) {
  querySelector("#header_caption").text = "Hello World";
  if (context.isEmpty == false) querySelector("#header_caption").text += "  > $context";
}
void showAbout(RouteEvent e) {
  // Extremely simple and non-scalable way to show different views.
  querySelector('#home').style.display = 'none';
  querySelector('#about').style.display = '';
  querySelector('#readme').style.display = 'none';
  updateHeaderCaption("About...");
}

void showHome(RouteEvent e) {
  querySelector('#home').style.display = '';
  querySelector('#about').style.display = 'none';
  querySelector('#readme').style.display = 'none';
  updateHeaderCaption("");
}

void showReadme(RouteEvent e) {
  // Extremely simple and non-scalable way to show different views.
  querySelector('#home').style.display = 'none';
  querySelector('#about').style.display = 'none';
  querySelector('#readme').style.display = '';
  updateHeaderCaption("Readme");
}

void initReadme() {
  var readmeText = new ParagraphElement();

  querySelector("#readme").children.add(readmeText);
  HttpRequest.getString("README.md")
      .then((text) => readmeText.appendHtml(markdownToHtml(text)));
}

