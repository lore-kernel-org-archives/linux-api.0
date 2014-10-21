From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: preadv2/pwritev2 rename
Date: Tue, 21 Oct 2014 08:42:41 +0200
Message-ID: <CAKgNAkjwJ6SH_j_Op+u+p4-0mN-cBVE24Wrt4SyhAiG1MMF9tA@mail.gmail.com>
References: <CANP1eJFfGE53PTGR4XYGmr=HBLLdOByJj+GbkQB6+JSdrgtvFw@mail.gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANP1eJFfGE53PTGR4XYGmr=HBLLdOByJj+GbkQB6+JSdrgtvFw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Milosz,

On Mon, Oct 20, 2014 at 11:52 PM, Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org> wrote:
> Christoph and/or Jeff,
>
> I updated the patch for 3.18-rc1 and I'm going to resend it as non-RFC
> as I didn't get comments last time.
>
> I only have one stupid question... I'm going to rename the calls to
> preadv6 and pwritev6 (so it's more like the other syscalls: dup3,
> accept4, eventfd2) but I'm not sure if i should call it preadv5 or
> pwritev6 since the offset argument is split into two different
> arguments (upper and lower part).

It's points like this that show exactly why naming system calls after
the number of their arguments is a very bad idea[1]. Please don't do
it. pwritev2() and preadv2() are not pretty either, but are marginally
better. pwritev_fl() and preadv_fl() (or simialr) might also be okay,
I guess.

> Also, In our application we were able to get about 20%-30% reduction
> in response time when using this before queuing in a IO thread pool on
> the read path. It's a pretty nice win in the real world.

Cheers,

Michael

http://blog.man7.org/2014/02/system-call-naming-and-numbering.html
