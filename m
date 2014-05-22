From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [patch 3/3] timerfd: Implement write method
Date: Thu, 22 May 2014 08:32:45 +0200
Message-ID: <CAHO5Pa3NFndwZUKGdEt8AYnYLXvd4aJB1RdWOQ-Kcht+Y0WEyA@mail.gmail.com>
References: <20140428212517.200264067@openvz.org> <20140428213301.507657833@openvz.org>
 <alpine.DEB.2.02.1405220642100.9695@ionos.tec.linutronix.de>
 <20140521215707.GH12819@moon> <alpine.DEB.2.02.1405220658530.9695@ionos.tec.linutronix.de>
 <20140521223511.GI12819@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140521223511.GI12819@moon>
Sender: linux-kernel-owner@vger.kernel.org
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Linux Kernel <linux-kernel@vger.kernel.org>, shawn@churchofgit.com, Andrew Morton <akpm@linux-foundation.org>, Andrey Vagin <avagin@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, vdavydov@parallels.com, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

[Thomas, thanks for pinging me on this.]

Hi Cyril

Please CC linux-api on changes that affect kernel-user-space ABI/API.

On Thu, May 22, 2014 at 12:35 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Thu, May 22, 2014 at 07:12:30AM +0900, Thomas Gleixner wrote:
>>
>> There is a world outside of checkpoint/restore, really.
>
> Yes, I simply don't know who else might use this write()
> functionality for other purpose, I mean i don't see a
> point to use it for anything else.

Nevertheless, when making API changes like this, we should be thinking
as generally as possible, rather than looking from the perspective of
a single use case.

>> So what's the semantics of that write function? We really want to have
>> that agreed on and documented in the man page.
>
> The idea was to provide a way to setup @ticks into (nonzero) value
> which we get from show_fdinfo output. Then when we restore it
> we setup the timer and set @ticks to the value it had at dump
> moment.
>
>> Right now the write will just update the ticks and nothing else. So
>> what if there is a waiter already? What if there is a timer armed?
>>
>> Can you please describe how checkpoint/restore is going to use all of
>> this. How is the timer restored and how/when is the reader which was
>> waiting in read/poll at the time of suspend reattached to it.
>
> Thomas, I see what you mean. Need to think (I must admit I forgot about
> polling of timerfds :( I were to restore timerfds like this
>
>  - fetch data from fdinfo
>  - use timer_create/settime to arm it
>  - write @ticks then
>
> but i didn't try restore polling waiters, my bad. Letme rework this
> trying addressing your comments.

Great. Please CC me and linux-api@ on the next round.

Cheers,

Michael

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
