From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
Date: Thu, 03 Apr 2014 07:51:30 -0400
Message-ID: <533D4B42.4040600@codeaurora.org>
References: <533B04A9.6090405@bbn.com> <20140402111032.GA27551@infradead.org> <1396439119.2726.29.camel@menhir> <533CA0F6.2070100@bbn.com> <CAKgNAki8U+j0mvYCg99j7wJ2Z7ve-gxusVbM3zdog=hKGPdidQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgNAki8U+j0mvYCg99j7wJ2Z7ve-gxusVbM3zdog=hKGPdidQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mtk.manpages@gmail.com
Cc: Richard Hansen <rhansen@bbn.com>, Steven Whitehouse <swhiteho@redhat.com>, Christoph Hellwig <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Troxel <gdt@ir.bbn.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On 04/03/2014 04:25 AM, Michael Kerrisk (man-pages) wrote:

> I think the only reasonable solution is to better document existing
> behavior and what the programmer should do. With that in mind, I've
> drafted the following text for the msync(2) man page:
>=20
>     NOTES
>        According to POSIX, exactly one of MS_SYNC and MS_ASYNC  must =
 be
>        specified  in  flags.   However,  Linux permits a call to msyn=
c()
>        that specifies neither of these flags, with  semantics  that  =
are
>        (currently)  equivalent  to  specifying  MS_ASYNC.   (Since Li=
nux
>        2.6.19, MS_ASYNC is in fact a no-op, since  the  kernel  prope=
rly
>        tracks  dirty  pages  and  flushes them to storage as necessar=
y.)
>        Notwithstanding the Linux behavior, portable, future-proof app=
li=E2=80=90
>        cations  should  ensure  that they specify exactly one of MS_S=
YNC
>        and MS_ASYNC in flags.

Nit: MS_SYNC or MS_ASYNC

Christopher

--=20
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
