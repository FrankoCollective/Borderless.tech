	/*---------------------
		Video button 
      --------------------- */
	var vid = document.getElementById("video-bg");
	var pauseButton = document.querySelector("#polina button");

	function vidFade() {
	    vid.classList.add("stopfade");
	}
	vid.addEventListener('ended', function () {
	    // only functional if "loop" is removed 
	    vid.pause();
	    // to capture IE10
	    vidFade();
	});
	pauseButton.addEventListener("click", function () {
	    vid.classList.toggle("stopfade");
	    if (vid.paused) {
	        vid.play();
	        pauseButton.innerHTML = [
	"<i class='fa fa-pause'></i>"
	]
            $(".video-overlay").css("display","none");
	    } else {
	        vid.pause();
	        pauseButton.innerHTML = [
	"<i class='fa fa-play'></i>"
	]
            $(".video-overlay").css("display","block");
	    }

	});
	