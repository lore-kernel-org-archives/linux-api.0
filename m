From: Martin Fuzzey <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on
 fallback
Date: Tue, 6 Jun 2017 11:04:37 +0200
Message-ID: <59367025.3020901@parkeon.com>
References: <20170524214027.7775-1-mcgrof@kernel.org>
 <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
 <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
 <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
 <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
 <87fufr3mdy.fsf@xmission.com> <20170526194640.GS8951@wotan.suse.de>
 <CAKdAkRTrcTVOAP5GK-R=Au_tL5WqSn5UkQEzNe5NcCWXS8mbtA@mail.gmail.com>
 <CAB=NE6Wh9inuA-R9-zegnvJV=s_6o_doMNDOhBVhYn4ZQ_Ku5Q@mail.gmail.com>
 <20170526215518.GB40877@dtor-ws> <20170605202410.GQ8951@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605202410.GQ8951-B4tOwbsTzaBolqkO4TVVkw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, atull-yzvPICuk2ABMcg4IHK0kFoH6Mc4MB0Vx@public.gmane.org, Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Emmanuel Grumbach <emmanuel.grumbach-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Luca Coelho <luciano.coelho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hans
List-Id: linux-api@vger.kernel.org

On 05/06/17 22:24, Luis R. Rodriguez wrote:
>
>
> For these two reasons then it would seem best we do two things actually:
>
> 1) return -EINTR instead of -EAGAIN when we detect swait_event_interruptible_timeout()
> got interrupted by a signal (it returns -ERESTARTSYS)


I disagree. That would force userspace to handle the signal rather than 
having the kernel retry.

 From Documentation/DocBook/kernel-hacking.tmpl:

    After you slept you should check if a signal occurred: the
    Unix/Linux way of handling signals is to temporarily exit the
    system call with the <constant>-ERESTARTSYS</constant> error.  The
    system call entry code will switch back to user context, process
    the signal handler and then your system call will be restarted
    (unless the user disabled that).  So you should be prepared to
    process the restart, e.g. if you're in the middle of manipulating
    some data structure.



> 2) Do as you note below and add wait_event_killable_timeout()

Hum,
I do think that would be better but, (please correct me if I'm wrong) 
the _killable_ variants only allow
SIGKILL  (and not SIGINT).

0cb64249ca "firmware_loader: abort request if wait_for_completion is 
interrupted"

specifically mentrions ctrl-c (SIGINT) in the commit message so that 
would no longer work.

Myself I think having to use kill -9 to interrupt firmware loading by a 
usespace helper is OK but others may disagree.

> I do not see why we could not introduce wait_event_killable_timeout()
> and swait_event_killable_timeout() into -stables.
> After seeing how simple it is to do so I tend to agree. Greg, Peter,
> what are your thoughts ?
>
> Martin Fuzzey can you test this patch as an alternative to your issue ?
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index b9f907eedbf7..70fc42e5e0da 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -131,7 +131,7 @@ static int __fw_state_wait_common(struct fw_state *fw_st, long timeout)
>   {
>   	long ret;
>   
> -	ret = swait_event_interruptible_timeout(fw_st->wq,
> +	ret = swait_event_killable_timeout(fw_st->wq,
>   				__fw_state_is_done(READ_ONCE(fw_st->status)),
>   				timeout);
>   	if (ret != 0 && fw_st->status == FW_STATUS_ABORTED)
> diff --git a/include/linux/swait.h b/include/linux/swait.h
> index c1f9c62a8a50..9c5ca2898b2f 100644
> --- a/include/linux/swait.h
> +++ b/include/linux/swait.h
> @@ -169,4 +169,29 @@ do {									\
>   	__ret;								\
>   })
>   
> +#define __swait_event_killable(wq, condition)				\
> +	(void)___swait_event(wq, condition, TASK_KILLABLE, 0, schedule())
> +
> +#define swait_event_killable(wq, condition)				\
> +({									\
> +	int __ret = 0;							\
> +	if (!(condition))						\
> +		__ret = __swait_event_killable(wq, condition);		\
> +	__ret;								\
> +})
> +
> +#define __swait_event_killable_timeout(wq, condition, timeout)		\
> +	___swait_event(wq, ___wait_cond_timeout(condition),		\
> +		      TASK_INTERRUPTIBLE, timeout,			\
> +		      __ret = schedule_timeout(__ret))
> +

Should be TASK_KILLABLE above

> +#define swait_event_killable_timeout(wq, condition, timeout)		\
> +({									\
> +	long __ret = timeout;						\
> +	if (!___wait_cond_timeout(condition))				\
> +		__ret = __swait_event_killable_timeout(wq,		\
> +						condition, timeout);	\
> +	__ret;								\
> +})
> +
>   #endif /* _LINUX_SWAIT_H */
>
>    Luis

After replacing TASK_INTERRUPTIBLE with TASK_KILLABLE above it works for me.


Regards,

Martin
