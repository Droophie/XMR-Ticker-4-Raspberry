
// Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com



// Application version
var app_version = '3.07.3';  // 2022/FEBUARY/4TH


// BLANK var inits
var api = [];
var sockets = [];
var rest_ids = [];
var rest_other = [];
var markets = [];
var parsed_markets = [];
var subscribe_msg = [];
var trade_side_price = [];
var trade_side_arrow = [];
var markets_length = 0;
var reload_queued = false;
var reload_countdown = -1;
// BELOW MUST at least be set as 'undefined' here
var api_alert; 
var kucoin_alert; 
var loopring_alert; 
var is_online;
// END BLANK var inits

// Save what time the app started running (works fine with refresh)
var runtime_start = new Date().getTime(); 

// Minimum-allowed error refresh time (if significant error requires refresh, to try auto-fixing it)
var min_error_refresh_time = Number(auto_error_fix_min * 60000); // (in milliseconds)

// REST API REFRESH TIME
var rest_api_refresh_milliseconds = Number(rest_api_refresh * 60000); // (in milliseconds)

//////////////////////////////////////////////////////////////////////////////////////

// Load external google font CSS file if required
var google_font_css = load_google_font();

//////////////////////////////////////////////////////////////////////////////////////


// Initiate once page is fully loaded...
$(document).ready(function() {

is_online = navigator.onLine; 


    window.addEventListener("offline", function() {
    console.log('Internet is offline.');
    is_online = false;
    reload_queued = true;
    $("#internet_alert").css({ "display": "block" });
    $("#internet_alert").text("Internet offline!").css("color", "#fc4e4e"); 
    });
    

    window.addEventListener("online", function() {
        
        // Only run logic if we were offline LAST CHECK
        if ( is_online == false ) {
        
        is_online = true;   
            
        console.log('Internet is back online.');
        
        $("#internet_alert").css({ "display": "block" });
        $("#internet_alert").html("Internet back online, reloading...<br />(in " + app_reload_wait + " seconds)").css("color", "#FFFF00");        
        
        reload_check();
            
        }
        
    });


	// Custom google font
	if ( google_font_css == false ) {
	console.log('Skipping custom google font rendering (no value set).');
	}
	else {
	console.log('Enabling custom google font rendering.');
	$("body, html").css({ "font-family": google_font_css });
	}


	// If monospace emulation is properly enabled, set the CSS attributes
	if ( monospace_check() == true ) {
	console.log('Enabling monospace emulation rendering.');
	$(".ticker .monospace").css({ "width": Math.round(ticker_size * monospace_width) + "px" });
	$(".volume .monospace").css({ "width": Math.round(volume_size * monospace_width) + "px" });
	}
	else {
	console.log('Skipping monospace emulation rendering (no proper decimal value of 1.00 or less detected).');
	}
	

	// Screen orientation
	if ( orient_screen > 0 ) {
	$("#ticker_window").addClass("orient_" + orient_screen);
	}



// Background color
$("body, html").css({ "background": background_color });

// Text color
$("body, html").css({ "color": text_color });


// Connect to exchange APIs for market data, run checks, and load the interface
init_interface();


});


//////////////////////////////////////////////////////////////////////////////////////



