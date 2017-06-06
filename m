From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on
 fallback
Date: Tue, 6 Jun 2017 18:11:51 -0400
Message-ID: <20170606221151.ygoxqkwhhjsqw632@thunk.org>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170606164734.GB27288@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Alan Cox <alan@linux.intel.com>, linux-fsdevel@vger.kernel.org, Stephen Boyd <stephen.boyd@linaro.org>, "Li, Yi" <yi1.li@linux.intel.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andy Lutomirski <luto@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, "Fuzzey, Martin" <mfuzzey@parkeon.com>, Linux API <linux-api@vger.kernel.org>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, atull@opensource.altera.com, Moritz
List-Id: linux-api@vger.kernel.org

On Tue, Jun 06, 2017 at 06:47:34PM +0200, Luis R. Rodriguez wrote:
> On Tue, Jun 06, 2017 at 03:53:16PM +0100, Alan Cox wrote:
> > Yep everyone codes
> > 
> > 	write(disk_file, "foo", 3);
> > 
> > not while(..) blah around it.

In general I/O to tty devices and other character mode devices was
where you definitely needed to check for EINTR/EAGAIN because that was
the place where historically Unix systems would interrupt system calls
--- e.g., a user typing control-Z, for example.

And in general writes to file systems and block devices in *general*
were never interrupted by signals, although that was always a
non-portable assumption.

So I've always subscribed to the "be liberal in what you accept,
conservative in what you send" rule of thumb.  Which is to say, any
programs *I* write I'll in general always check for EINTR/EAGAIN and
check for partial writes, but in general, as a kernel program I try to
adhere to the long-standing Unix trandition for disk based files.

This does beg the question about whether firmware devices are more
like tty devices or block devices or files, though.  If before signals
never caused them to return EINTR/EAGAIN, then it's probably best to
not break backwards compatbility.

That being said, not that you also have the option of using
-ERESTARTNOINTR (always restart the system call, regardless of how the
sighandle flags were set), and -ERESTARTNOHAND (restart the system
call always if there was no signal handler and the process was not
killed), in addition to -ERESTARTSYS.  So that might be another option
that's fairly easy to implement or experiment with.

       	      	      		   - Ted
