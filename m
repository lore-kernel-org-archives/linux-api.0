From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] ipc: Modify message queue accounting to reflect both
 total user data and auxiliary kernel data
Date: Thu, 25 Jun 2015 09:23:33 +0200
Message-ID: <CAKgNAkieR5zdpKm=P2dcTDJ_3X4HMRoeOQ2D8yghYVKOjDsYAg@mail.gmail.com>
References: <20150622222546.GA32432@ramsey.localdomain> <1435211229.11852.23.camel@stgolabs.net>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435211229.11852.23.camel-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Marcus Gelderie <marcus.gelderie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, John Duffy <jb_duffy-FhtRXb7CoQBt1OO0OYaSVA@public.gmane.org>, Arto Bendiken <arto-TQ6thHYR8Svk1uMJSBkQmQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Marcus Gelderie <redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 25 June 2015 at 07:47, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org> wrote:
> On Tue, 2015-06-23 at 00:25 +0200, Marcus Gelderie wrote:
>> A while back, the message queue implementation in the kernel was
>> improved to use btrees to speed up retrieval of messages (commit
>> d6629859b36). The patch introducing the improved kernel handling of
>> message queues (using btrees) has, as a by-product, changed the
>> meaning of the QSIZE field in the pseudo-file created for the queue.
>> Before, this field reflected the size of the user-data in the queue.
>> Since, it also takes kernel data structures into account. For
>> example, if 13 bytes of user data are in the queue, on my machine the
>> file reports a size of 61 bytes.
>
> Good catch, and a nice opportunity to make the mq manpage more specific
> wrt to queue sizes.
>
> [...]
>
>> Reporting the size of the message queue in kernel has its merits, but
>> doing so in the QSIZE field of the pseudo file corresponding to the
>> queue is a breaking change, as mentioned above. This patch therefore
>> returns the QSIZE  field to its original meaning. At the same time,
>> it introduces a new field QKERSIZE that reflects the size of the queue
>> in kernel (user data + kernel data).
>
> Hmmm I'm not sure about this. What are the specific benefits of having
> QKERSIZE? We don't export in-kernel data like this in any other ipc
> (posix or sysv) mechanism, afaik. Plus, we do not compromise kernel data
> structures like this, as we would break userspace if later we change
> posix_msg_tree_node. So NAK to this.
>
> I would just remove the extra
> +       info->qsize += sizeof(struct posix_msg_tree_node);
>
> bits from d6629859b36 (along with -stable v3.5), plus a patch updating
> the manpage that this field only reflects user data.

I've been hoping that Doug would jump into this discussion...

If I recall/understand Doug correctly (see
http://thread.gmane.org/gmane.linux.man/7050/focus=1797645 ), his
rationale for the QSIZE change was that it then revealed a value that
was closer to what was being used to account against the
RLIMIT_MSGQUEUE resource limit. (Even with these changes, the QSIZE
value was not 100% accurate for accounting against RLIMIT_MSGQUEUE,
since some pieces of kernel overhead were still not being accounted
for. Nevertheless, it's much closer than the old (pre 3.5) QSIZE for
some corner cases.) Thus, Marcus's rationale for preserving this info
as QKERSIZE.

Now whether QKERSIZE is actually useful or used by anyone is another
question. As far as I know, there was no user request that drove the
change. But Doug can perhaps say something to this. QSIZE should I
think definitely be fixed (reverted to pre-3.5 behavior). I'm agnostic
about QKERSIZE.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
