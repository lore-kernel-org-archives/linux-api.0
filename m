From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] ipc: Modify message queue accounting to not take
 kernel data structures into account
Date: Tue, 7 Jul 2015 15:01:17 +0200
Message-ID: <CAKgNAkjy-+2TkN=0Fe11bVea4q6uLcUx=++Mf1eFxhmPmZoc9w@mail.gmail.com>
References: <20150622222546.GA32432@ramsey.localdomain> <1435211229.11852.23.camel@stgolabs.net>
 <CAKgNAkieR5zdpKm=P2dcTDJ_3X4HMRoeOQ2D8yghYVKOjDsYAg@mail.gmail.com>
 <1435256484.11852.30.camel@stgolabs.net> <20150706154928.GA19828@ramsey.localdomain>
 <1436246210.12255.71.camel@stgolabs.net>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436246210.12255.71.camel-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: Marcus Gelderie <redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, John Duffy <jb_duffy-FhtRXb7CoQBt1OO0OYaSVA@public.gmane.org>, Arto Bendiken <arto-TQ6thHYR8Svk1uMJSBkQmQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi David,

On 7 July 2015 at 07:16, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org> wrote:
> On Mon, 2015-07-06 at 17:49 +0200, Marcus Gelderie wrote:
>> A while back, the message queue implementation in the kernel was
>> improved to use btrees to speed up retrieval of messages (commit
>> d6629859b36). The patch introducing the improved kernel handling of
>> message queues (using btrees) has, as a by-product, changed the
>> meaning of the QSIZE field in the pseudo-file created for the queue.
>> Before, this field reflected the size of the user-data in the queue.
>> Since, it also takes kernel data structures into account. For
>> example, if 13 bytes of user data are in the queue, on my machine the
>> file reports a size of 61 bytes.
>>
>> There was some discussion on this topic before (for example
>> https://lkml.org/lkml/2014/10/1/115). Commenting on a th lkml, Michael
>> Kerrisk gave the following background (https://lkml.org/lkml/2015/6/16/74):
>>
>>     The pseudofiles in the mqueue filesystem (usually mounted at
>>     /dev/mqueue) expose fields with metadata describing a message
>>     queue. One of these fields, QSIZE, as originally implemented,
>>     showed the total number of bytes of user data in all messages in
>>     the message queue, and this feature was documented from the
>>     beginning in the mq_overview(7) page. In 3.5, some other (useful)
>>     work happened to break the user-space API in a couple of places,
>>     including the value exposed via QSIZE, which now includes a measure
>>     of kernel overhead bytes for the queue, a figure that renders QSIZE
>>     useless for its original purpose, since there's no way to deduce
>>     the number of overhead bytes consumed by the implementation.
>>     (The other user-space breakage was subsequently fixed.)
>
> Michael, this breakage was never finally documented in the manpage,
> right?

Right.

> I took a look and there is no mention, but it was a quick look.
> It's just that if this patch goes in, I'd hate ending up with something
> like this in the manpage:
>
> as of 3.5
>   <accounts for kernel overhead>
>
> as of 4.3
>   <behavior reverted back to not include kernel overhead... *sigh*>
>
> If there are changes to be made to the manpage, it should probably be
> posted with this patch, methinks.

I think something like the above will have to end up in the man page.
The only thing I'd add is that the fix also has gone to -stable
kernels. At least: I think this patch should also be marked for
-stable. I'll take care of the man page updates as the patch goes
through.

>> This patch removes the accounting of kernel data structures in the
>> queue. Reporting the size of these data-structures in the QSIZE field
>> was a breaking change (see Michael's comment above). Without the QSIZE
>> field reporting the total size of user-data in the queue, there is no
>> way to deduce this number.
>>
>> It should be noted that the resource limit RLIMIT_MSGQUEUE is counted
>> against the worst-case size of the queue (in both the old and the new
>> implementation). Therefore, the kernel overhead accounting in QSIZE is
>> not necessary to help the user understand the limitations RLIMIT imposes
>> on the processes.
>
> Also, I would suggest adding some comment in struct mqueue_inode_info
> for future reference, ie:
>
> -       unsigned long qsize; /* size of queue in memory (sum of all msgs) */
> +       /*
> +        * Size of queue in memory (sum of all msgs). Accounts for
> +        * only userspace overhead; ignoring any in-kernel rbtree nodes.
> +        */
> +       unsigned long qsize;
>
> But no big deal in any case.
>
> I think this is the right approach,

Me too.

> but would still like to know if Doug
> has any concerns about it.

Looking on gmane, Doug does not appear to have been active on any
lists since late May! Not sure why.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
