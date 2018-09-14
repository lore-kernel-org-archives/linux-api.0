From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/5] y2038: Make ppoll, io_pgetevents and pselect y2038 safe
Date: Fri, 14 Sep 2018 18:06:42 +0200
Message-ID: <CAK8P3a3KLVEcCpPXWdEoOWgmP8zcDvLyj2LUn0Nw0+0yGO_MmA@mail.gmail.com>
References: <20180901204721.13117-1-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180901204721.13117-1-deepa.kernel@gmail.com>
Sender: owner-linux-aio@kvack.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-aio <linux-aio@kvack.org>
List-Id: linux-api@vger.kernel.org

On Sat, Sep 1, 2018 at 10:48 PM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>
> The series transitions the ppoll, io_getevents, and pselect syscalls
> to be y2038 safe.
>
> This is part of the work proceeding for syscalls for y2038.
> It is based on the series [1] from Arnd Bergmann.
>
> The overview of the series is as below:
> 1. Refactor sigmask handling logic for the above syscalls.
> 2. Provide y2038 safe versions of syscalls for all ABIs.
>
> [1] https://lkml.org/lkml/2018/8/27/651

Hi Deepa,

This is a very nice series, sorry for taking way too long before
I had a good look at it.

The first two patches in particular are great. The third patch
looks like it has a small bug that I commented on, but given
how much more thought you have put into this than I did, it's
just as possible that I misunderstood it.

I've applied you series locally now, but have not pushed it out
yet for linux-next because of that one issue. I'll send a pull
request to Thomas for my other patches for now, and a
follow-up with these once we have clarified it.

        Arnd

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
