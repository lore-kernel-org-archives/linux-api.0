From: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [CRIU] [PATCH 2/3] signalfd: add ability to return siginfo in a
 raw format (v2)
Date: Mon, 21 Jan 2013 21:57:24 +0400
Message-ID: <CANaxB-zR1daDmu3wxKMfw70Fv63=bSqUfjvibRG98RECKJQndw@mail.gmail.com>
References: <1358182435-19245-1-git-send-email-avagin@openvz.org>
	<1358182435-19245-3-git-send-email-avagin@openvz.org>
	<20130116123502.70af6b85.akpm@linux-foundation.org>
	<CAKgNAkgHVB3=k_XOevobcMWuEqy2r75tdTc85ZYiD8rkn5OZKA@mail.gmail.com>
	<CANaxB-wXdPZFzD3BhkD6niDA6M1NiNrc5coKf9bSx+ar_fZecg@mail.gmail.com>
	<CAKgNAkjK9iWh_PuJ92A-MKW6Q6_B8DvTL5-fkxyULqx9ZoDPfg@mail.gmail.com>
	<20130120174153.GA5675@paralelels.com>
	<20130120195555.GA14177@redhat.com>
	<CAKgNAkhcha9CkYHESqx72LyFB_xw7du=OU566Nk1LzHw+EnQQA@mail.gmail.com>
	<20130121154444.GA10849@paralelels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130121154444.GA10849-yYYamFZzV1regbzhZkK2zA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2013/1/21 Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>:
> On Sun, Jan 20, 2013 at 09:33:41PM +0100, Michael Kerrisk (man-pages) wrote:
>> Hi Oleg,
>>
>> On Sun, Jan 20, 2013 at 8:55 PM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > On 01/20, Andrew Vagin wrote:
>> >>
>> >> > SFD_RAW
>> >> > SFD_SHARED_QUEUE -- reads will be from process-wide shared signal queue
>> >> > SFD_PER_THREAD_QUEUE --reads will be from per-thread signal queue
>> >>
>> >> I suggested this variant in the initial series, but then we decided to
>> >> avoid adding new flags.
>> >
>> > Yes, because SFD_SHARED/PRIVATE will add even more complications into this
>> > code. And outside of signalfd.c too. And nobody except c/r will ever use
>> > these features I guess.
>>
>> So, I must admit that I don't understand why adding SFD_SHARED and
>> SFD_PER_THREAD in signalfd() makes things more complicated than adding
>> the equivalents in pread(). But, I'll take your word for that, if
>> that's what you meant.
>
> You could look at the initial series.
> http://thread.gmane.org/gmane.linux.file-systems/70327
>
> In this case dequeue_signal should be changed for specifying a queue.
> signalfd_poll() should be fixed too. All this changes are not a big
> deal, but...
>
> If we want to have two flags for specifying queues, we will need one
> more flag SFD_PEEK, which will say, that signals should not be dequeued.
> Currently we get this information from offset too. If offset isn't zero,
> signals are not dequeued. With flags this sentence will look ugly.

I'm going to prepare a series with flags tomorrow.

Thanks.

>
>>
>> However, note that I did suggest that in the initial implementation
>> you might require that if SFD_SHARED_QUEUE or SFD_PER_THREAD_QUEUE is
>> specified in signalfd(), then SFD_RAW could be required as well.
>> Later, if someone wants to do the work, they could relax the
>> constraint, so as to allow signalfd() to be used to do per-queue
>> select even when reading siginfo (i.e., SFD_SHARED_QUEUE or
>> SFD_PER_THREAD_QUEUE specified but not SFD_RAW). Surely that is not
>> more complicated than the current implementation. And it allows for an
>> orthogonal expansion of the design that seems more natural and may one
>> day be useful.
>>
>> Cheers,
>>
>> Michael
