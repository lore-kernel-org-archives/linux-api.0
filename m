From: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] signalfd: add ability to return siginfo in a raw
 format (v2)
Date: Sat, 19 Jan 2013 14:50:12 +0400
Message-ID: <CANaxB-wXdPZFzD3BhkD6niDA6M1NiNrc5coKf9bSx+ar_fZecg@mail.gmail.com>
References: <1358182435-19245-1-git-send-email-avagin@openvz.org>
	<1358182435-19245-3-git-send-email-avagin@openvz.org>
	<20130116123502.70af6b85.akpm@linux-foundation.org>
	<CAKgNAkgHVB3=k_XOevobcMWuEqy2r75tdTc85ZYiD8rkn5OZKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkgHVB3=k_XOevobcMWuEqy2r75tdTc85ZYiD8rkn5OZKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2013/1/19 Michael Kerrisk (man-pages) <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> As SFD_RAW is being added to the kernel API we should document it.
>> Please keep Michael cc'ed and work with him on getting the manpages
>> updated.
>
> The API is certainly no thing of beauty, as I already remarked here:
> http://thread.gmane.org/gmane.linux.file-systems/70420/focus=1420228

All of us have similar thoughts, but we don't know a better solution.

Here is an example of usage signalfd and pread:
http://lists.openvz.org/pipermail/criu/2013-January/007040.html

>
> A description of the API can be found here:
> https://lwn.net/Articles/531939/

Thanks you for the attempt to involve more people to this discussion.

>
> The main problem is the ugliness of changing the meaning of pread()'s
> 'offset' argument to be a multiplexed [signal queue selector + queue
> position].
>
> I do wonder if we can do better, though I have no particular solution
> to offer beyond the sledgehammer of adding a new system call.

If we are choosing between this interface or a new syscall, I would
prefer this interface. signalfd is a special descriptor, so I think it
is not a big deal, that it works a bit strange. If all other would
decides, that a new syscall is better, I will not ague.

Michael, thank you for the comments.

>
> Cheers,
>
> Michael
>
>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Author of "The Linux Programming Interface"; http://man7.org/tlpi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
