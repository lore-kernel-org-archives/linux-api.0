From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on
 fallback
Date: Wed, 7 Jun 2017 02:22:37 +0200
Message-ID: <20170607002237.GJ27288@wotan.suse.de>
References: <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
 <87fufr3mdy.fsf@xmission.com>
 <20170526194640.GS8951@wotan.suse.de>
 <CAKdAkRTrcTVOAP5GK-R=Au_tL5WqSn5UkQEzNe5NcCWXS8mbtA@mail.gmail.com>
 <CAB=NE6Wh9inuA-R9-zegnvJV=s_6o_doMNDOhBVhYn4ZQ_Ku5Q@mail.gmail.com>
 <20170526215518.GB40877@dtor-ws>
 <20170605202410.GQ8951@wotan.suse.de>
 <1496760796.5682.48.camel@linux.intel.com>
 <20170606164734.GB27288@wotan.suse.de>
 <20170606221151.ygoxqkwhhjsqw632@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170606221151.ygoxqkwhhjsqw632-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Boyd <stephen.boyd-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Fuzzey, Martin" <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Rafa
List-Id: linux-api@vger.kernel.org

On Tue, Jun 06, 2017 at 06:11:51PM -0400, Theodore Ts'o wrote:
> On Tue, Jun 06, 2017 at 06:47:34PM +0200, Luis R. Rodriguez wrote:
> > On Tue, Jun 06, 2017 at 03:53:16PM +0100, Alan Cox wrote:
> > > Yep everyone codes
> > > 
> > > 	write(disk_file, "foo", 3);
> > > 
> > > not while(..) blah around it.
> 
> In general I/O to tty devices and other character mode devices was
> where you definitely needed to check for EINTR/EAGAIN because that was
> the place where historically Unix systems would interrupt system calls
> --- e.g., a user typing control-Z, for example.
> 
> And in general writes to file systems and block devices in *general*
> were never interrupted by signals, although that was always a
> non-portable assumption.
> 
> So I've always subscribed to the "be liberal in what you accept,
> conservative in what you send" rule of thumb.  Which is to say, any
> programs *I* write I'll in general always check for EINTR/EAGAIN and
> check for partial writes, but in general, as a kernel program I try to
> adhere to the long-standing Unix trandition for disk based files.

OK so userspace should consider checking for EINTR/EAGAIN.  On the kernel front
though we we do *strive* to go by the old unix tradition -- there are
exceptions though, of course.

> This does beg the question about whether firmware devices are more
> like tty devices or block devices or files, though.

And here you raise the analogy to see if its *worthy* to break the old unix
tradition, the tty example is a case that we seem to accept as reasonable
for an exception, clearly.

This help, thanks!

So, "firmware devices" is a misnomer, the firmware API does direct FS lookup
and only if that fails and the distribution enabled the fallback mechanism will
it be used if the file was not found on /lib/firmware/ paths. So the syfs
interface we are evaluating here is this fallback mechanism. The "firmware
device" then is really more a user of the firmware API, and these do vary
widely. In fact it recent developments with the "driver data API" generalize
the interface given things outside our typical device drivers for what we know
as old "firmware" are looking to use the firmware API for looking for files
from userspace. This in fact already has happened, it was just subtle: we look
for default EEPROMs, configururation files, microcode updates, and soon we'll
want to replace the userspace wireless CRDA tool for the regulatory database
with a simple file lookup once we get firmware signing upstream. So -- more and
more the API is being used for general file lookups.

Which type of drivers request these files ? It all varies across the board,
and we have really early things like CPU microcode files (so we enable built-in
files), regular old firmware files for things like networking drivers,
subsystem configuration stuff (for the wireless regulatory database), and it
seems now *huge* (100s of MiBs I'm told) for remote-proc and FPGAs. The FPGA
use case is one use case where having the uploader use a while loop makes more
sense. Drivers may also want to have more fine control to the buffer where the
"driver data" gets stashed into, so the API request_firmware_into_buf() was
added for this purpose. The FPGA devices seem to want to use this breakdown
mechanism as well. Although the remote-proc folks seem to be relying on the
sysfs interface as a default mechanism.

So it would seem to make sense to support the loop thing since some
files these days *can* be really big. I think we can easily address
this by relying on the killable signal (SIGKILL), rather than capturing
SIGINT (CTRL-C).

One problem is we had supported SIGINT before, it was reported however we
never gave back to userspace the fact that a signal was captured, we always
returned EAGAIN, so usersace did not know WTF was going on. The reporter wanted
to detect this and wanted to get us to return the same value the wait call
passed to the firmware API, -ERESTARTSYS. Hence this patch, however since
-ERESTARTSYS is special and folks may just restart the syscall always when this
happens, one question is if we should return EINTR instead of today's EAGAIN.

> If before signals
> never caused them to return EINTR/EAGAIN, then it's probably best to
> not break backwards compatbility.

There was a time where did not have signal, and always just used to return
-ENOMEM on failure. After signals support was added we still were
returning -ENOMEM for a while. It was only later that we started capturing
the actual signal, however this was masked as EAGAIN, for no precise good
reason, I suppose just lack of review.

The patch in question wants us to return -ERESTARTSYS so that userspace
can restart the upload. But the issue was that the sysfs firmware loader
was killed by a signal as well, so this is why Dmitry noted that we can
just fix this issue by just making the wait killable with SIGKILL only.
The swait killable patch I supplied upon Dmitry's suggestion as a replacement
would do away with capturing SIGINT but allow SIGKILL then.

Since EAGAIN was always returned even if a signal was captured I'm
inclined to take the position we really never gave userspace a proper
clue about the signal. Additionally I cannot see why userspace would
rely on SIGINT working *only* but not *SIGKILL*.

The risk here I think is if userspace ever *did* rely on SIGINT for the sysfs
interface as userspace functional API. If this is not worth breaking
then I suppose we are stuck with the current wait. If we do that I'd
say we return EINTR, based on what I have read so far.

If doing away with SIGINT but keeping SIGKILL is rather sane then I'd go
with the approach of the new swait killable + returning -EINTR.

> That being said, note that you also have the option of using
> -ERESTARTNOINTR (always restart the system call, regardless of how the
> sighandle flags were set), and -ERESTARTNOHAND (restart the system
> call always if there was no signal handler and the process was not
> killed), in addition to -ERESTARTSYS.

We rely on swait, and swait right now only uses -ERESTARTSYS. Are
you saying we could mask out -ERESTARTSYS and map it to -ERESTARTNOINTR
or -ERESTARTNOHAND if we see fit for some future functionality / need ?

> So that might be another option
> that's fairly easy to implement or experiment with.

Thanks!

  Luis
