From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Wed, 12 Jul 2017 23:33:09 +0200
Message-ID: <20170712213309.GW21846@wotan.suse.de>
References: <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
 <20170629174046.GC3954@linux-80c1.suse>
 <CA+55aFz=6XmH5MfwKLN6MZSyG8fAk-aD67mbDc1ZaKySzsq8aw@mail.gmail.com>
 <20170629183339.GD3954@linux-80c1.suse>
 <CA+55aFz8Mhx+A-g-5yOG-O1ZLRUR_fpeeA4iBNGH8EnDBZEdpA@mail.gmail.com>
 <20170629194015.GQ21846@wotan.suse.de>
 <20170629194455.GR21846@wotan.suse.de>
 <20170629135822.366fd67a@cakuba.netronome.com>
 <20170629225003.GU21846@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170629225003.GU21846-B4tOwbsTzaBolqkO4TVVkw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jakub Kicinski <jakub.kicinski-wFxRvT7yatFl57MIdRCFDg@public.gmane.org>, nbroeking-BUHhN+a2lJ4@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Emmanuel Grumbach <emmanuel.grumbach-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 30, 2017 at 12:50:03AM +0200, Luis R. Rodriguez wrote:
> ie, I expect the combination of both to fix your issues, not just the last
> series I just posted [0]. If you want this in git form you can find all of
> the patches bundled on the 20170629-fw-fixes-wait-v4 branch [1]. I just
> wrote this patch it but it seems to have not broken the tests
> 
> From cb7fee12c6d539405793e883dfd79e0b21c2baad Mon Sep 17 00:00:00 2001
> From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Thu, 29 Jun 2017 15:19:04 -0700
> Subject: [RFT] firmware: send wake up on failure for batched requests
> 
> Fix batched requests from waiting forever on failure.
> 
> The firmware API supports "batched requests" which means requests with
> the same name share the same lookup effort. They wait for the first
> request to complete, however they are set to always wait for what seem
> to be forever (MAX_SCHEDULE_TIMEOUT).
> 
> We currently handle informing waited batched requests on success but we
> never seem to have sent smoke signals of any kind on failure! This
> should mean secondary requests batched in seem to just wait forever when
> the request fails.
> 
> For device drivers with optional firmware schemes (Intel, or Netronome),
> this could mean that when you boot a system with multiple cards the
> firmware will seem to never load on the system, or that the card is just
> not responsive even the driver initialized. Due to differences in scheduling
> possible this should not always trigger, so triggering batched requests
> actually needs to be triggered for this to be an issue.
> 
> Its reported that at least with the Intel WiFi cards on one system this
> issue was creeping up 50% of the boots [0].
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=195477
> 
> Reported-by: Nicolas <nbroeking-BUHhN+a2lJ4@public.gmane.org>
> Reported-by: John Ewalt  <jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org>
> Reported-by: Jakub Kicinski <jakub.kicinski-wFxRvT7yatFl57MIdRCFDg@public.gmane.org>
> Signed-off-by: Luis R. Rodriguez <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---

FWIW I wrote a test case for this and indeed as I expected, it fixed the last
remaining issue I was aware of with using multiple cards and the firmware API.

Determining the first affected kernel was rather hard, but it would seem to be
that this became an issue once we started supporting making the fallback
mechanism optional via commit bba3a87e982ad5 ("firmware: Introduce
request_firmware_direct()", merged via v3.14.

Will follow up with patches.

  Luis
