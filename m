From: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Subject: preadv2/pwritev2 rename
Date: Mon, 20 Oct 2014 17:52:58 -0400
Message-ID: <CANP1eJFfGE53PTGR4XYGmr=HBLLdOByJj+GbkQB6+JSdrgtvFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Christoph and/or Jeff,

I updated the patch for 3.18-rc1 and I'm going to resend it as non-RFC
as I didn't get comments last time.

I only have one stupid question... I'm going to rename the calls to
preadv6 and pwritev6 (so it's more like the other syscalls: dup3,
accept4, eventfd2) but I'm not sure if i should call it preadv5 or
pwritev6 since the offset argument is split into two different
arguments (upper and lower part).

Also, In our application we were able to get about 20%-30% reduction
in response time when using this before queuing in a IO thread pool on
the read path. It's a pretty nice win in the real world.

Best,
- Milosz

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org
