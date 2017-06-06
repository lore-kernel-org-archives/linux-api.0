From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on
 fallback
Date: Tue, 6 Jun 2017 19:54:13 +0200
Message-ID: <20170606175413.GF27288@wotan.suse.de>
References: <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
 <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
 <87fufr3mdy.fsf@xmission.com>
 <20170526194640.GS8951@wotan.suse.de>
 <CAKdAkRTrcTVOAP5GK-R=Au_tL5WqSn5UkQEzNe5NcCWXS8mbtA@mail.gmail.com>
 <CAB=NE6Wh9inuA-R9-zegnvJV=s_6o_doMNDOhBVhYn4ZQ_Ku5Q@mail.gmail.com>
 <20170526215518.GB40877@dtor-ws>
 <20170605202410.GQ8951@wotan.suse.de>
 <1496760796.5682.48.camel@linux.intel.com>
 <20170606164734.GB27288@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170606164734.GB27288-B4tOwbsTzaBolqkO4TVVkw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stephen Boyd <stephen.boyd-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Fuzzey, Martin" <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>a
List-Id: linux-api@vger.kernel.org

Using the right linux-fsdevel this time also, this was the second reply.

  Luis

On Tue, Jun 06, 2017 at 06:47:34PM +0200, Luis R. Rodriguez wrote:
> Adding fsdevel folks.
> 
> On Tue, Jun 06, 2017 at 03:53:16PM +0100, Alan Cox wrote:
> > > "Unix tradition (and thus almost all applications) believe file store
> > > writes to
> > > be non signal interruptible. It would not be safe or practical to
> > > change that
> > > guarantee."
> > 
> > Yep everyone codes
> > 
> > 	write(disk_file, "foo", 3);
> > 
> > not while(..) blah around it.
> 
> Thanks for the confirmation! That's a simple enough explanation.
> 
> > > For these two reasons then it would seem best we do two things
> > > actually:
> > > 
> > > 1) return -EINTR instead of -EAGAIN when we detect
> > > swait_event_interruptible_timeout()
> > > got interrupted by a signal (it returns -ERESTARTSYS)
> > > 2) Do as you note below and add wait_event_killable_timeout()
> > 
> > Pedantic detail that I don't think affects you
> > 
> > If you have completed a part of the I/O then you should return the byte
> > processed count not EINTR, but -1,EINTR if no progress was made.
> 
> You are right with some new exceptions and with regards to the future:
> 
> The syfs loading interface for firmware currently goes through the
> data file exposed on syfs, the respective write op firmware_data_write()
> only checks for signals at the beginning. After that its a full one
> swoop try to write if you are following the old tradition and are using
> a buffer allocated by the firmware API.
> 
> If you are using the relatively new request_firmware_into_buf() added
> by Stephen Boyd which lets the driver provide the allocated buffer then
> we have a loop in firmware_rw() which should be fixed to:
> 
> 1) Check for signals
> 2) Do what you noted above.
> 
> Furthermore Yi Li over at Intel is adding some new API calls which would
> re-use some of this for FPGA firmwares which are also very large, that
> work should consider the above and fix appropriately as well.
> 
>   Luis
> 

-- 
Luis Rodriguez, SUSE LINUX GmbH
Maxfeldstrasse 5; D-90409 Nuernberg
