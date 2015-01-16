
function loadData() {

    var $body = $('body');
    var $wikiElem = $('#wikipedia-links');
    var $nytHeaderElem = $('#nytimes-header');
    var $nytElem = $('#nytimes-articles');
    var $greeting = $('#greeting');

    // clear out old data before new request
    $wikiElem.text("");
    $nytElem.text("");

    var streetValue = $('#street').val();
    var cityValue = $('#city').val();
    var address = streetValue + ', ' + cityValue;

    $greeting.text('So, you want to live at ' + address + '?');

    var streetviewUrl = 'http://maps.googleapis.com/maps/api/streetview?size=600x400&location=' + address + '';

    $body.append('<img class="bgimg" src="' + streetviewUrl + '">');
    //console.log(streetValue + cityValue);

    var articleURI = 'http://api.nytimes.com/svc/search/v2/articlesearch.json?q=%searchterms%&sort=newest&page=0&api-key=a06ac179be4caf630a2910e21b16e286:14:69863843';
    var cityArray = cityValue.split(" ");
    var cityQuery = cityArray.join('+');
    articleURI = articleURI.replace('%searchterms%', cityQuery);
    $.getJSON(articleURI, function (data) {
        $nytHeaderElem.text('New York Times Articles about ' + cityValue);
        console.log(data);
        //var articles = [];
        $.each(data.response.docs, function(key, value) {
            $nytElem.append("<a href='" + value.web_url + "'>" + value.headline.main + "</a>");
            $nytElem.append("<p>" + value.snippet + "</p>");
        });
        //console.log(articles);
    }).error(function(e) {
        $nytHeaderElem.text('New York Times Articles Could Not Be Loaded');
    });

    var wikiUrl = 'http://en.wikipedia.org/w/api.php?action=opensearch&search=' + cityValue + '&format=json&callback=?';
    $.getJSON(wikiUrl, function(data) {
        console.log(data);
        var articleList = data[1];

        for (entry in articleList) {
            articleStr = articleList[entry];
            var url = 'http://en.wikipedia.org/wiki' + articleStr;
            $wikiElem.append('<li><a href="' + url + '">' + articleStr + '</a></li>');
        };
    });

    return false;
};

$('#form-container').submit(loadData);

// loadData();
