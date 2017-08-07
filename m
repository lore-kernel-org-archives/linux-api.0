From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v06 33/36] uapi linux/fsmap.h: use __kernel_size_t instead
 of size_t
Date: Mon, 7 Aug 2017 22:20:58 +0200
Message-ID: <CAK8P3a25BVQpqcB5c7nMHHaw383WVhir3rb+QovNeyaZtqmiug@mail.gmail.com>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi> <20170806164428.2273-34-mikko.rapeli@iki.fi>
 <20170807155445.GA4074@magnolia> <CAK8P3a3sVWu9wiqct4h9njZC53qUOrLbM_wXL7XXZ8hfiuK7Lg@mail.gmail.com>
 <20170807164505.GC4474@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170807164505.GC4474@magnolia>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 7, 2017 at 6:45 PM, Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, Aug 07, 2017 at 06:01:43PM +0200, Arnd Bergmann wrote:
>> On Mon, Aug 7, 2017 at 5:54 PM, Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Sun, Aug 06, 2017 at 06:44:24PM +0200, Mikko Rapeli wrote:
>>
>> Either way works, but including a system header from a kernel header
>> requires an additional "#ifndef __KERNEL__" check, so I think Miko's
>> variant is a little nicer.
>>
>> Generally speaking, you also want to avoid including system headers
>> indirectly from kernel headers, as POSIX requires that including one
>> system header should not indirectly make symbols from other system
>> headers visible. I think this is not a problem here though, as no system
>> header should include linux/fsmap.h.
>
> Sorry, I guess I was a little unclear about what I was asking -- I was
> wondering why can't the userspace program include sys/types.h prior to
> linux/fsmap.h?  I wasn't proposing including C library headers in kernel
> headers.
>
> I think the patch author is pushing towards kernel headers never relying
> on /anything/ in the system headers.

Right, and I think that is a good thing to have, because it allows us to
do better compile-time testing of the exported kernel headers.

> For data structures being
> exchanged with the kernel I agree, but the fsmap_sizeof result is never
> passed to or received from the kernel; it exists purely for malloc
> convenience.

Would you prefer making fsmap_sizeof a macro? That would also
make it possible to do static checking on the header without having
to resort to odd types.

      Arnd
