From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
Date: Fri, 04 Apr 2014 08:54:20 +0200
Message-ID: <533E571C.4080902@gmail.com>
References: <533B04A9.6090405@bbn.com> <20140402111032.GA27551@infradead.org> <1396439119.2726.29.camel@menhir> <533CA0F6.2070100@bbn.com> <CAKgNAki8U+j0mvYCg99j7wJ2Z7ve-gxusVbM3zdog=hKGPdidQ@mail.gmail.com> <533D4B42.4040600@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <533D4B42.4040600@codeaurora.org>
Sender: owner-linux-mm@kvack.org
To: Christopher Covington <cov@codeaurora.org>
Cc: mtk.manpages@gmail.com, Richard Hansen <rhansen@bbn.com>, Steven Whitehouse <swhiteho@redhat.com>, Christoph Hellwig <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Troxel <gdt@ir.bbn.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On 04/03/2014 01:51 PM, Christopher Covington wrote:
> On 04/03/2014 04:25 AM, Michael Kerrisk (man-pages) wrote:
>=20
>> I think the only reasonable solution is to better document existing
>> behavior and what the programmer should do. With that in mind, I've
>> drafted the following text for the msync(2) man page:
>>
>>     NOTES
>>        According to POSIX, exactly one of MS_SYNC and MS_ASYNC  must  =
be
>>        specified  in  flags.   However,  Linux permits a call to msync=
()
>>        that specifies neither of these flags, with  semantics  that  a=
re
>>        (currently)  equivalent  to  specifying  MS_ASYNC.   (Since Lin=
ux
>>        2.6.19, MS_ASYNC is in fact a no-op, since  the  kernel  proper=
ly
>>        tracks  dirty  pages  and  flushes them to storage as necessary=
.)
>>        Notwithstanding the Linux behavior, portable, future-proof appl=
i=E2=80=90
>>        cations  should  ensure  that they specify exactly one of MS_SY=
NC
>>        and MS_ASYNC in flags.
>=20
> Nit: MS_SYNC or MS_ASYNC

Thanks. Reworded.

Cheers,

Michael

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
