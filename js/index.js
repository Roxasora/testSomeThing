(function() {
  var bindEvent, calculateResult, checkIfScoreArrayItemNotSame, choiceArray, h, loadCurrentQuestion, m, p, questionIndex, r, showEnterBtnAnim;

  questionIndex = 0;

  choiceArray = [];

  p = [[["B", "D"], ["G", "E", "C"], ["F", "A"]], [["A", "G"], ["F", "C"], ["E", "B", "D"]], [["D", "B", "G"], ["C", "F"], ["E", "A"]], [["E", "C"], ["G", "B", "D"], ["F", "A"]], [["D", "G", "E"], ["A", "C"], ["B", "F"]], [["E", "G", "C"], ["A", "D"], ["B", "F"]], [["D", "G"], ["C", "F"], ["E", "B", "A"]], [["G", "C", "D", "E"], ["A", "B", "F"]]];

  h = ["D", "C", "E", "G", "A", "B", "F"];

  m = [["F", "B"], ["B", "C"], ["F", "G"], ["B", "A"], ["B", "G"], ["C", "F"], ["A", "F"], ["B", "D"], ["C", "D"]];

  r = ["A", "B", "C", "D", "E", "F", "G", "BA", "BC", "BD", "CF", "AF", "FB", "FG", "CD", "BG"];

  checkIfScoreArrayItemNotSame = function(array) {
    var item, j, len, map;
    map = {};
    for (j = 0, len = array.length; j < len; j++) {
      item = array[j];
      if (map[item]) {
        return false;
      } else {
        map[item] = "1";
      }
    }
    return true;
  };

  calculateResult = function() {
    var choice, eighthItem, finalChoice, finalResult, hItem, highestHItem, highestMItemIndex, highestMScore, highestScore, i, item, itemScoreDic, j, k, l, len, len1, len2, len3, len4, m0, m1, mItem, mScoreArray, n, o, ref, resultItem, score, scoreArray, useDouble;
    console.log("cal result");
    itemScoreDic = {};
    for (i = j = 0, len = choiceArray.length; j < len; i = ++j) {
      choice = choiceArray[i];
      scoreArray = [];
      if (i === 7 && choice === 2) {
        scoreArray = p[i][1];
      } else {
        scoreArray = p[i][Number(choice)];
      }
      console.log(scoreArray);
      for (k = 0, len1 = scoreArray.length; k < len1; k++) {
        item = scoreArray[k];
        if (!itemScoreDic[item]) {
          itemScoreDic[item] = 0;
        }
        itemScoreDic[item] = itemScoreDic[item] + 1;
      }
    }
    console.log("itemScoreDic before check " + itemScoreDic);
    if (!checkIfScoreArrayItemNotSame(Object.values(itemScoreDic))) {
      eighthItem = p[7];
      finalChoice = choiceArray[6];
      if (finalChoice > 1) {
        finalChoice = 1;
      }
      ref = eighthItem[finalChoice];
      for (l = 0, len2 = ref.length; l < len2; l++) {
        item = ref[l];
        itemScoreDic[item] += 1;
      }
    }
    console.log("itemScoreDic", itemScoreDic);
    useDouble = false;
    if (choiceArray[6] === 0) {
      useDouble = true;
    }
    finalResult = null;
    if (useDouble) {
      console.log("use double");
      mScoreArray = [];
      highestMItemIndex = 0;
      highestMScore = 0;
      for (i = n = 0, len3 = m.length; n < len3; i = ++n) {
        mItem = m[i];
        m0 = mItem[0];
        m1 = mItem[1];
        if (!itemScoreDic[m0] || !itemScoreDic[m1]) {
          mScoreArray.push(0);
          continue;
        } else {
          score = itemScoreDic[m0] + itemScoreDic[m1];
          mScoreArray.push(score);
          if (score > highestMScore) {
            highestMScore = score;
            highestMItemIndex = i;
          }
        }
      }
      console.log("m score " + mScoreArray);
      console.log("max m " + highestMItemIndex);
      finalResult = m[highestMItemIndex][0] + m[highestMItemIndex][1];
      console.log("double result " + finalResult);
    } else {
      console.log("use single");
      highestHItem = null;
      highestScore = 0;
      for (o = 0, len4 = h.length; o < len4; o++) {
        hItem = h[o];
        if (!itemScoreDic[hItem]) {
          continue;
        }
        if (itemScoreDic[hItem] > highestScore) {
          highestHItem = hItem;
          highestScore = itemScoreDic[hItem];
        }
      }
      if (highestHItem === h[0]) {
        if (Math.random() > 0.5) {
          highestHItem = h[4];
        }
      }
      finalResult = highestHItem;
      console.log("single result " + highestHItem + " score " + highestScore);
    }
    resultItem = window.result[finalResult];
    console.log("final result", resultItem);
    jQuery(".card-title").html(finalResult);
    jQuery(".card-subtitle").html("晴十九，你是<br/>" + resultItem.oneWord);
    jQuery(".card-text").html("外在<br/>" + resultItem.otherPeopleText + "<br/><br/>内在<br/>" + resultItem.infactText);
    jQuery("#questionCard").hide();
    return jQuery("#resultCard").show();
  };

  loadCurrentQuestion = function() {
    var choice, currentQuestion, i, j, len, liHtml, ref;
    jQuery("#video").get(0).pause();
    console.log("load current question " + questionIndex);
    currentQuestion = window.data.data[questionIndex];
    jQuery("#qIndex").html((questionIndex + 1) + "/8");
    jQuery("#qTitle").html(currentQuestion.question);
    liHtml = "";
    ref = currentQuestion.choices;
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
      choice = ref[i];
      liHtml += "<div><li class='list-group-item choiceItem' data-index=" + i + ">" + choice + "</li></div>";
    }
    jQuery("#listGroup").html(liHtml);
    $("#questionBgImg").attr("src", currentQuestion.img);
    jQuery("#img").attr("src", currentQuestion.img);
    jQuery("#video").attr("src", "videos/" + currentQuestion.video + "?playsinline=1");
    jQuery("#video").get(0).play();
    return bindEvent();
  };

  bindEvent = function() {
    return jQuery(".choiceItem").click(function() {
      var index;
      index = jQuery(this).attr("data-index");
      console.log("choice selected " + index);
      choiceArray.push(Number(index));
      questionIndex++;
      if (questionIndex >= window.data.data.length) {
        return calculateResult();
      } else {
        return loadCurrentQuestion();
      }
    });
  };

  showEnterBtnAnim = function() {
    return console.log("h");
  };

  jQuery(document).ready(function() {
    var $enterBtn, $firstPage, $secondPage;
    $enterBtn = $("#enterBtn");
    $firstPage = $("#firstPage");
    $secondPage = $("#secondPage");
    $enterBtn.click(function() {
      console.log("enter");
      $secondPage.addClass("active");
      return loadCurrentQuestion();
    });
    showEnterBtnAnim();
    return jQuery("#redo").click(function() {
      questionIndex = 0;
      choiceArray = [];
      loadCurrentQuestion();
      jQuery("#questionCard").show();
      return jQuery("#resultCard").hide();
    });
  });

}).call(this);
