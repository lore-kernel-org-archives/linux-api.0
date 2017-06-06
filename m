From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on
 fallback
Date: Tue, 6 Jun 2017 18:34:01 +0200
Message-ID: <20170606163401.GA27288@wotan.suse.de>
References: <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
 <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
 <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
 <87fufr3mdy.fsf@xmission.com>
 <20170526194640.GS8951@wotan.suse.de>
 <CAKdAkRTrcTVOAP5GK-R=Au_tL5WqSn5UkQEzNe5NcCWXS8mbtA@mail.gmail.com>
 <CAB=NE6Wh9inuA-R9-zegnvJV=s_6o_doMNDOhBVhYn4ZQ_Ku5Q@mail.gmail.com>
 <20170526215518.GB40877@dtor-ws>
 <20170605202410.GQ8951@wotan.suse.de>
 <59367025.3020901@parkeon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <59367025.3020901-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Fuzzey <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, atull-yzvPICuk2ABMcg4IHK0kFoH6Mc4MB0Vx@public.gmane.org, Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Emmanuel Grumbach <emmanuel.grumbach-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Luca Coelho <luciano.coelho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Adding fsdevel for review on the correct semantics of handling signals on
write(), in this case a sysfs write which triggered a sync request firmware
call and what the firmware API should return in such case of a signal (I gather
this should be -EINTR and not -ERESTARTSYS). Also whether or not SIGINT should
be followed or if only allowing SIGKILL is fine (fine by me, but it would
change old behaviour).

Hoping between fsdevel and linux-api folks we can hash this out.

On Tue, Jun 06, 2017 at 11:04:37AM +0200, Martin Fuzzey wrote:
> On 05/06/17 22:24, Luis R. Rodriguez wrote:
> > 
> > 
> > For these two reasons then it would seem best we do two things actually:
> > 
> > 1) return -EINTR instead of -EAGAIN when we detect swait_event_interruptible_timeout()
> > got interrupted by a signal (it returns -ERESTARTSYS)
> 
> 
> I disagree. That would force userspace to handle the signal rather than
> having the kernel retry.
> 
> From Documentation/DocBook/kernel-hacking.tmpl:
> 
>    After you slept you should check if a signal occurred: the
>    Unix/Linux way of handling signals is to temporarily exit the
>    system call with the <constant>-ERESTARTSYS</constant> error.  The
>    system call entry code will switch back to user context, process
>    the signal handler and then your system call will be restarted
>    (unless the user disabled that).  So you should be prepared to
>    process the restart, e.g. if you're in the middle of manipulating
>    some data structure.

This applies but you are missing my point that the LWN article [0] I referred
to also stated "Kernel code which uses interruptible sleeps must always check
to see whether it woke up as a result of a signal, and, if so, clean up
whatever it was doing and return -EINTR back to user space." -- I realize there
may be contradiction with above documentation -- this perhaps can be clarified
with fsdevel folks *but* regardless of that the same article notes Alan Cox
explains that "Unix tradition (and thus almost all applications) believe file
store writes to be non signal interruptible. It would not be safe or practical
to change that guarantee." So for this reason alone there does seem to be an
exemption to the above documentation worth noting for file store writes, and
the patch which you tested below *moves* the sysfs write op for firmware in
that direction by adding a new killable swait.

[0] https://lwn.net/Articles/288056/                                                                                                                                          
                                                                                                                                                                                
> > 2) Do as you note below and add wait_event_killable_timeout()
> 
> Hum,  I do think that would be better but, (please correct me if I'm wrong)
> the _killable_ variants only allow SIGKILL  (and not SIGINT).

That seems correct given a TASK_KILLABLE is also TASK_UNINTERRUPTIBLE.

> 0cb64249ca "firmware_loader: abort request if wait_for_completion is
> interrupted"
> 
> specifically mentrions ctrl-c (SIGINT) in the commit message so that would
> no longer work.

Great point, but it *also* allowed SIGKILL, so I do feel the goal was also to
allow it to be killable. I'm afraid that patch probably did not get proper
review from sufficient folks and its worth now asking ourselves what we'd like
to do.  I'm fine with letting go of SIGINT for firmware sysfs calls for the
sake of keeping with the long standing unix tradition on write, given we *still
have SIGKILL*.

> Myself I think having to use kill -9 to interrupt firmware loading by a
> usespace helper is OK but others may disagree.

Its why I added fsdevel as well. This is really a semantics and uapi question.
Between fsdevel and linux-api folks I would hope we can come to a sensible
resolution.

> > I do not see why we could not introduce wait_event_killable_timeout()
> > and swait_event_killable_timeout() into -stables.
> > After seeing how simple it is to do so I tend to agree. Greg, Peter,
> > what are your thoughts ?
> > 
> > Martin Fuzzey can you test this patch as an alternative to your issue ?
> > 
> > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> > index b9f907eedbf7..70fc42e5e0da 100644
> > --- a/drivers/base/firmware_class.c
> > +++ b/drivers/base/firmware_class.c
> > @@ -131,7 +131,7 @@ static int __fw_state_wait_common(struct fw_state *fw_st, long timeout)
> >   {
> >   	long ret;
> > -	ret = swait_event_interruptible_timeout(fw_st->wq,
> > +	ret = swait_event_killable_timeout(fw_st->wq,
> >   				__fw_state_is_done(READ_ONCE(fw_st->status)),
> >   				timeout);
> >   	if (ret != 0 && fw_st->status == FW_STATUS_ABORTED)
> > diff --git a/include/linux/swait.h b/include/linux/swait.h
> > index c1f9c62a8a50..9c5ca2898b2f 100644
> > --- a/include/linux/swait.h
> > +++ b/include/linux/swait.h
> > @@ -169,4 +169,29 @@ do {									\
> >   	__ret;								\
> >   })
> > +#define __swait_event_killable(wq, condition)				\
> > +	(void)___swait_event(wq, condition, TASK_KILLABLE, 0, schedule())
> > +
> > +#define swait_event_killable(wq, condition)				\
> > +({									\
> > +	int __ret = 0;							\
> > +	if (!(condition))						\
> > +		__ret = __swait_event_killable(wq, condition);		\
> > +	__ret;								\
> > +})
> > +
> > +#define __swait_event_killable_timeout(wq, condition, timeout)		\
> > +	___swait_event(wq, ___wait_cond_timeout(condition),		\
> > +		      TASK_INTERRUPTIBLE, timeout,			\
> > +		      __ret = schedule_timeout(__ret))
> > +
> 
> Should be TASK_KILLABLE above

Oops yes sorry.

> > +#define swait_event_killable_timeout(wq, condition, timeout)		\
> > +({									\
> > +	long __ret = timeout;						\
> > +	if (!___wait_cond_timeout(condition))				\
> > +		__ret = __swait_event_killable_timeout(wq,		\
> > +						condition, timeout);	\
> > +	__ret;								\
> > +})
> > +
> >   #endif /* _LINUX_SWAIT_H */
> > 
> >    Luis
> 
> After replacing TASK_INTERRUPTIBLE with TASK_KILLABLE above it works for me.

Great, thanks for testing.

  Luis
