'use strict'

// module Test.Phantomjs.Webpage.PaperSizeUtil

// exports.exampleHeaderCallback = function (pageNum, numPages) {
//   return "<h1>Header <span style='float:right'>" + pageNum + " / " + numPages + "</span></h1>"
// }

// exports.exampleFooterCallback = function (pageNum, numPages) {
//   return "<h1>Footer <span style='float:right'>" + pageNum + " / " + numPages + "</span></h1>";
// }

// exports.phantomCallback2 = function (fn2) {
//   phantom.callback(fn)
// }

exports._getPaperSize = function (page) {
  return function () {
    return page.paperSize
  }
}

exports._setPaperSize = function (page) {
  return function (opts) {
    return function () {
      return page.paperSize = opts
    }
  }
}

exports._setPaperSizeLW = function (page) {
  return function (opts) {
    return function () {
      return page.paperSize = opts
    }
  }
}
