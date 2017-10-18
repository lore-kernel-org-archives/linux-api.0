From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [1/2,v2] fdmap(2)
Date: Wed, 18 Oct 2017 13:35:00 +0200
Message-ID: <CACVxJT_ZP=VAJQ_=D1JV0yt3bT_RZjtWTW61KcV5gCbhF8ixBw@mail.gmail.com>
References: <20170924200620.GA24368@avx2> <20171010220804.GA30735@outlook.office365.com>
 <20171011181234.GB2119@avx2> <20171012080608.GA23077@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171012080608.GA23077-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/12/17, Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:

> I'm agree with your points, but I think you choose a wrong set of data
> to make an example of a new approach.
>
> You are talking a lot about statx, but for me it is unclear how fdmap
> follows the idea of statx. Let's imagine that I want to extend fdmap to
> return mnt_id for each file descriptor?

fdmap() is standalone thing.

Next step is to design fdinfo(2) (?) which uses descriptors from fdmap(2).
Extending structures is done as usual: but version, add new fields to the end.

> Or it may be more complex case, when we decided to provide all data
> from /proc/pid/fdinfo/X for each descriptor. A set of fields in fdinfo
> depends on a type of a file descriptor, it is different for epoll,
> signalfd, inotify, sockets, etc.
>
> For inotify file descriptors, there are information about all watches,
> so it is not possible to use a fixed size struture to present this data.

Now I didn't look closely at inotify watches but this is done with unions,
zero-length trailing arrays, and other usual stuff. If OpenVZ/Virtuozzo is
doing C/R of inotify then you already have all serializing code.
