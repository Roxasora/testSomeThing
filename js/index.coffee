questionIndex = 0

choiceArray = []

p = [
  [["B", "D"], ["G", "E", "C"], ["F", "A"]],  #1
  [["A", "G"], ["F", "C"], ["E", "B", "D"]],  #2
  [["D", "B", "G"], ["C", "F"], ["E", "A"]],  #7
  [["E", "C"], ["G", "B", "D"], ["F", "A"]],  #4
  [["D", "G", "E"], ["A", "C"], ["B", "F"]],  #6
  [["E", "G", "C"], ["A", "D"], ["B", "F"]],  #3
  [["D", "G"], ["C", "F"], ["E", "B", "A"]],  #5
  [["G", "C", "D", "E"], ["A", "B", "F"]],    #8
  ]
h = ["D", "C", "E", "G", "A", "B", "F"]
m = [
  ["F", "B"], 
  ["B", "C"], 
  ["F", "G"], 
  ["B", "A"], 
  ["B", "G"], 
  ["C", "F"], 
  ["A", "F"], 
  ["B", "D"], 
  ["C", "D"]]

r = [ "A", "B", "C", "D", "E", "F", "G", "BA", "BC", "BD", "CF", "AF", "FB", "FG", "CD", "BG" ]

# p = [
#   [["金", "绿"], ["紫", "银", "橙"], ["粉", "蓝"]],   #1
#   [["蓝", "紫"], ["粉", "橙"], ["银", "金", "绿"]],   #2
#   [["绿", "金", "紫"], ["橙", "粉"], ["银", "蓝"]],   #7
#   [["银", "橙"], ["紫", "金", "绿"], ["粉", "蓝"]],   #4
#   [["绿", "紫", "银"], ["蓝", "橙"], ["金", "粉"]],   #6
#   [["银", "紫", "橙"], ["蓝", "绿"], ["金", "粉"]],   #3
#   [["绿", "紫"], ["橙", "粉"], ["银", "金", "蓝"]],   #5
#   [["紫", "橙", "绿", "银"], ["蓝", "金", "粉"]],     #8
#   ]
# h = ["绿", "橙", "银", "紫", "蓝", "金", "粉"]
# m = [
#     ["粉", "金"], 
#     ["金", "橙"], 
#     ["粉", "紫"], 
#     ["金", "蓝"], 
#     ["金", "紫"], 
#     ["橙", "粉"], 
#     ["蓝", "粉"], 
#     ["金", "绿"], 
#     ["橙", "绿"]]

checkIfScoreArrayItemNotSame =(array) ->
  map = {}
  for item in array
    if  map[item]
      return false
    else
      map[item] = "1"

  return true

calculateResult = ->
  console.log("cal result")

  itemScoreDic = {}

  for choice, i in choiceArray
    scoreArray = []
    if i == 7 && choice == 2
      scoreArray = p[i][1]
    else
      scoreArray = p[i][Number(choice)]
    console.log(scoreArray)
    for item in scoreArray
      if !itemScoreDic[item]
        itemScoreDic[item] = 0

      itemScoreDic[item] = (itemScoreDic[item] + 1)

  console.log("itemScoreDic before check #{itemScoreDic}")

  #check if there is same score
  if ! checkIfScoreArrayItemNotSame(Object.values(itemScoreDic))
    eighthItem = p[7]
    finalChoice = choiceArray[6]
    if finalChoice > 1
      finalChoice = 1
    for item in eighthItem[finalChoice]
      itemScoreDic[item] += 1

  console.log("itemScoreDic", itemScoreDic)

  #check if double
  useDouble = false
  if choiceArray[6] == 0
    useDouble = true

  finalResult = null

  if useDouble
    #calcu score for m
    console.log("use double")

    mScoreArray = []
    highestMItemIndex = 0
    highestMScore = 0
    for mItem, i in m
      m0 = mItem[0]
      m1 = mItem[1]
      if !itemScoreDic[m0] || !itemScoreDic[m1]
        mScoreArray.push(0)
        continue
      else
        score = itemScoreDic[m0] + itemScoreDic[m1]
        mScoreArray.push(score)
        if score > highestMScore
          highestMScore = score
          highestMItemIndex = i

    console.log("m score #{mScoreArray}")
    console.log("max m #{highestMItemIndex}")

    finalResult = m[highestMItemIndex][0] + m[highestMItemIndex][1]
    console.log("double result #{finalResult}")
  else
    console.log("use single")
    highestHItem = null
    highestScore = 0
    for hItem in h
      if !itemScoreDic[hItem]
        continue
      if itemScoreDic[hItem] > highestScore
        highestHItem = hItem
        highestScore = itemScoreDic[hItem]

    if highestHItem == h[0]
      if Math.random() > 0.5
        highestHItem = h[4]
      
    finalResult = highestHItem
    console.log("single result #{highestHItem} score #{highestScore}")

  #get result
  resultItem = window.result[finalResult]
  console.log("final result", resultItem)

  jQuery(".card-title").html finalResult
  jQuery(".card-subtitle").html "晴十九，你是<br/>" + resultItem.oneWord
  jQuery(".card-text").html "外在<br/>#{resultItem.otherPeopleText}<br/><br/>内在<br/>#{resultItem.infactText}"
        
  jQuery("#questionCard").hide()
  jQuery("#resultCard").show()

loadCurrentQuestion = ->
  $video.get(0).pause()
  $audio.get(0).pause()
  console.log("load current question #{questionIndex}")
  currentQuestion = window.data.data[questionIndex]
  jQuery("#qIndex").html "#{questionIndex+1}/8"
  jQuery("#qTitle").html(currentQuestion.question)

  liHtml = ""
  for choice, i in currentQuestion.choices
    liHtml += "<div><li class='list-group-item choiceItem' data-index=#{i}>#{choice}</li></div>"

  jQuery("#listGroup").html(liHtml)

  # $("#questionBgImg").attr "src", currentQuestion.img
  # jQuery("#img").attr("src", currentQuestion.img)
  
  $video.attr "src", currentQuestion.video
  $audio.attr "src", currentQuestion.audio
  $video.get(0).play()
  $audio.get(0).play()
  bindEvent()

bindEvent = ->
  jQuery(".choiceItem").click ->
    index = jQuery(this).attr("data-index")
    console.log("choice selected #{index}")
    choiceArray.push(Number(index))
    questionIndex++
    if questionIndex >= window.data.data.length
      calculateResult()
    else
      loadCurrentQuestion()

showEnterBtnAnim = ->
  console.log "h"

$video = null
$audio = null

loadResources = ->
  resources = []
  for item in window.data.data
    if item.video
      resources.push item.video
    if item.audio
      resources.push item.audio

  preloader = new createjs.LoadQueue()
  # preloader.addFiles resources
  preloader.installPlugin(createjs.Sound);  

  preloader.on "progress", (e)->
  # preloader.addProgressListener (loaded, length)->
  # preloader.progressCallback = (progress)->
    # console.log('loading ', loaded, length, loaded / length)
    # progress = loaded / length
    progress = preloader.progress
    jQuery("#loadingLabel").html "#{parseInt(progress * 100)}%"
    jQuery("#loadingBar").css "width", "#{progress * 100}%"
  
  # preloader.addCompletionListener ()->
  preloader.on 'complete', ()->
    console.log('load completed')

    jQuery("#enterBtn").show()
    jQuery("#loadingHolder").hide()

  preloader.loadManifest resources


  showEnterBtnAnim()


jQuery(document).ready ->
  $enterBtn = $("#enterBtn")
  $firstPage = $("#firstPage")
  $secondPage = $("#secondPage")
  $video = $("#video")
  $audio = $("#audio")
  $enterBtn.click ->
    console.log("enter")
    # $firstPage.removeClass "active"
    $secondPage.addClass "active"
    loadCurrentQuestion()

  # $enterBtn.click()

  loadResources()

  jQuery("#redo").click ->
    questionIndex = 0
    choiceArray = []
    loadCurrentQuestion()
    jQuery("#questionCard").show()
    jQuery("#resultCard").hide()
  



