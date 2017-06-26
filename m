From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] firmware: fix fallback mechanism by ignoring SIGCHLD
Date: Mon, 26 Jun 2017 23:19:04 +0200
Message-ID: <20170626211904.GD21846@wotan.suse.de>
References: <20170614222017.14653-1-mcgrof@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170614222017.14653-1-mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org, pmladek-IBi9RG/b67k@public.gmane.org, johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, emmanuel.grumbach-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, luciano.coelho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel
List-Id: linux-api@vger.kernel.org

On Wed, Jun 14, 2017 at 03:20:13PM -0700, Luis R. Rodriguez wrote:
> Martin reported an issue with Android where if sysfs is used to trigger a sync
> fw load which *relies* on the fallback mechanism and a background job completes
> while the trigger is ongoing in the foreground it will immediately fail the fw
> request.  The issue can be observed in this simple test script using the
> test_firmware driver:
> 
> 	set -e
> 	/etc/init.d/udev stop
> 	modprobe test_firmware
> 	DIR=/sys/devices/virtual/misc/test_firmware
> 	echo 10 >/sys/class/firmware/timeout
> 	sleep 2 &
> 	echo -n "does-not-exist-file.bin" > "$DIR"/trigger_request
> 
> The background sleep triggers the SIGCHLD signal and we fail the firmware
> request on the fallback mechanism. This was due to the type of wait used which
> captures all signals, but we currently lack the killable swaits which would
> only allow killing the fallback wait on SIGKILL. This adds the missing killable
> swaits and fixes the firmware API to use it. This goes along with a test case to
> demo the issue clearly and how its fixed afterwards.  Lastly, ensure to use
> -EINTR when interrupted so callers can distinguish between an interrupted
> failure and other types of failure.
> 
> As suggested I've tagged the addition of the killable swaits and the firmware
> fix as stable. Between v4.0 and v4.10 the stable fix is to instead change
> the firmware to use wait_for_completion_killable_timeout() as the firmware
> API was only converted to swait as of v4.10.
> 
> The last patch must be applied only after the killable wait is applied to
> ensure only SIGKILL triggers an interruption. Otherwise it has been observed
> using -EINTR on other signals like SIGCHLD will trigger a restart of the call,
> if a sysfs write() is used to trigger the sync firmware request. This might be
> due what signal(7) says about using the SA_RESTART flag when write() is called,
> in such cases the call will be automatically restarted after the signal handler
> returns. The excemption here naturally seems to be on SIGKILL.
> 
> Note that although I *feared* this might implicate any use of non-killable waits
> on other system calls, such as finit_module(), initial testing confirms this to
> not be the case.  For instance replacing the echo with modprobe on a module
> which does the same on init does not present the same issues. This could be due
> to the special SA_RESTART flag case on write() as noted above and sysfs...
> however, its not perfectly clear yet to me.
> 
> As usual these patches are on my linux-next git tree, they are on the
> 20170614-fw-fixes branch based on linux-next 20170614 [0].
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20170614-fw-fixes

Greg, *poke*

  Luis
