From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: preadv2/pwritev2 rename
Date: Tue, 21 Oct 2014 13:07:39 -0700
Message-ID: <5446BD0B.6040009@zytor.com>
References: <CANP1eJFfGE53PTGR4XYGmr=HBLLdOByJj+GbkQB6+JSdrgtvFw@mail.gmail.com> <CAKgNAkjwJ6SH_j_Op+u+p4-0mN-cBVE24Wrt4SyhAiG1MMF9tA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkjwJ6SH_j_Op+u+p4-0mN-cBVE24Wrt4SyhAiG1MMF9tA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/20/2014 11:42 PM, Michael Kerrisk (man-pages) wrote:
> Hello Milosz,
> 
> On Mon, Oct 20, 2014 at 11:52 PM, Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org> wrote:
>> Christoph and/or Jeff,
>>
>> I updated the patch for 3.18-rc1 and I'm going to resend it as non-RFC
>> as I didn't get comments last time.
>>
>> I only have one stupid question... I'm going to rename the calls to
>> preadv6 and pwritev6 (so it's more like the other syscalls: dup3,
>> accept4, eventfd2) but I'm not sure if i should call it preadv5 or
>> pwritev6 since the offset argument is split into two different
>> arguments (upper and lower part).
> 
> It's points like this that show exactly why naming system calls after
> the number of their arguments is a very bad idea[1]. Please don't do
> it. pwritev2() and preadv2() are not pretty either, but are marginally
> better. pwritev_fl() and preadv_fl() (or simialr) might also be okay,
> I guess.
> 

The splitting of the argument is a calling convention thing (and a
rather stupid one at that... we shouldn't do these kinds of things
manually.)  As such, it is not visible to the user and should not be
counted.

	-hpa
