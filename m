From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on
 fallback
Date: Mon, 5 Jun 2017 22:24:10 +0200
Message-ID: <20170605202410.GQ8951@wotan.suse.de>
References: <20170524214027.7775-1-mcgrof@kernel.org>
 <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
 <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
 <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
 <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
 <87fufr3mdy.fsf@xmission.com>
 <20170526194640.GS8951@wotan.suse.de>
 <CAKdAkRTrcTVOAP5GK-R=Au_tL5WqSn5UkQEzNe5NcCWXS8mbtA@mail.gmail.com>
 <CAB=NE6Wh9inuA-R9-zegnvJV=s_6o_doMNDOhBVhYn4ZQ_Ku5Q@mail.gmail.com>
 <20170526215518.GB40877@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170526215518.GB40877@dtor-ws>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Fuzzey, Martin" <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, atull-yzvPICuk2ABMcg4IHK0kFoH6Mc4MB0Vx@public.gmane.org, Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Emmanuel Grumbach <emmanuel.grumbach-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Luca Coelho <luciano.coelho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, May 26, 2017 at 02:55:18PM -0700, Dmitry Torokhov wrote:
> On Fri, May 26, 2017 at 02:32:31PM -0700, Luis R. Rodriguez wrote:
> > On Fri, May 26, 2017 at 2:26 PM, Dmitry Torokhov
> > <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > On Fri, May 26, 2017 at 12:46 PM, Luis R. Rodriguez <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >> On Fri, May 26, 2017 at 06:09:29AM -0500, Eric W. Biederman wrote:
> > >>> "Fuzzey, Martin" <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org> writes:
> > >>> >>>> Maybe SIGCHLD shouldn't interrupt firmware loading?
> > >>> >
> > >>> > I don't think there's a way of doing that without disabling all
> > >>> > signals (ie using the non interruptible wait variants).
> > >>> > It used to be that way (which is why I only ran into this after
> > >>> > updating from an ancient 3.16 kernel to a slightly less ancient 4.4)
> > >>> > But there are valid reasons for wanting to be able to interrupt
> > >>> > firmware loading (like being able to kill the userspace helper)
> > >>>
> > >>> Perhaps simply using a killable wait and not a fully interruptible
> > >>> wait would be better?
> > >>
> > >> What do you mean by a killable wait BTW?
> > >
> > > https://lwn.net/Articles/288056/

Read it thanks ! As per this it states, "Kernel code which uses interruptible
sleeps must always check to see whether it woke up as a result of a signal,
and, if so, clean up whatever it was doing and return -EINTR back to user
space." -- but also on the same article it quotes Alan Cox as having noted
"Unix tradition (and thus almost all applications) believe file store writes to
be non signal interruptible. It would not be safe or practical to change that
guarantee."

For these two reasons then it would seem best we do two things actually:

1) return -EINTR instead of -EAGAIN when we detect swait_event_interruptible_timeout()
got interrupted by a signal (it returns -ERESTARTSYS)
2) Do as you note below and add wait_event_killable_timeout()

> > > I think only interrupting firmware loading with fatal signals would
> > > make a lot of sense.
> > >
> > >>
> > >> ret = swait_event_interruptible_timeout() is being used right now.
> > >
> > > It looks like we are missing swait_event_killable*(), but I do not
> > > think it would be hard to add.
> > 
> > What should we do for stable ? Is this a *stable* issue ?
> 
> I think it is, as you have users complaining about behavior. I do not
> think we need to make their lives harder than needed by requiring
> handling signals.

Makes sense, specially given the long tradition, it would breaking a long
tradition. Even though in this case we are dealing with sysfs files it
should be no different.

> I do not see why we could not introduce wait_event_killable_timeout()
> and swait_event_killable_timeout() into -stables.

After seeing how simple it is to do so I tend to agree. Greg, Peter,
what are your thoughts ?

Martin Fuzzey can you test this patch as an alternative to your issue ?

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index b9f907eedbf7..70fc42e5e0da 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -131,7 +131,7 @@ static int __fw_state_wait_common(struct fw_state *fw_st, long timeout)
 {
 	long ret;
 
-	ret = swait_event_interruptible_timeout(fw_st->wq,
+	ret = swait_event_killable_timeout(fw_st->wq,
 				__fw_state_is_done(READ_ONCE(fw_st->status)),
 				timeout);
 	if (ret != 0 && fw_st->status == FW_STATUS_ABORTED)
diff --git a/include/linux/swait.h b/include/linux/swait.h
index c1f9c62a8a50..9c5ca2898b2f 100644
--- a/include/linux/swait.h
+++ b/include/linux/swait.h
@@ -169,4 +169,29 @@ do {									\
 	__ret;								\
 })
 
+#define __swait_event_killable(wq, condition)				\
+	(void)___swait_event(wq, condition, TASK_KILLABLE, 0, schedule())
+
+#define swait_event_killable(wq, condition)				\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__ret = __swait_event_killable(wq, condition);		\
+	__ret;								\
+})
+
+#define __swait_event_killable_timeout(wq, condition, timeout)		\
+	___swait_event(wq, ___wait_cond_timeout(condition),		\
+		      TASK_INTERRUPTIBLE, timeout,			\
+		      __ret = schedule_timeout(__ret))
+
+#define swait_event_killable_timeout(wq, condition, timeout)		\
+({									\
+	long __ret = timeout;						\
+	if (!___wait_cond_timeout(condition))				\
+		__ret = __swait_event_killable_timeout(wq,		\
+						condition, timeout);	\
+	__ret;								\
+})
+
 #endif /* _LINUX_SWAIT_H */

  Luis
