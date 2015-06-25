From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH v2] ipc: Modify message queue accounting to reflect both
 total user data and auxiliary kernel data
Date: Wed, 24 Jun 2015 22:47:09 -0700
Message-ID: <1435211229.11852.23.camel@stgolabs.net>
References: <20150622222546.GA32432@ramsey.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150622222546.GA32432-W7fNxlbxG8VSq9BJjBFyUp/QNRX+jHPU@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcus Gelderie <marcus.gelderie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, John Duffy <jb_duffy-FhtRXb7CoQBt1OO0OYaSVA@public.gmane.org>, Arto Bendiken <arto-TQ6thHYR8Svk1uMJSBkQmQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2015-06-23 at 00:25 +0200, Marcus Gelderie wrote:
> A while back, the message queue implementation in the kernel was
> improved to use btrees to speed up retrieval of messages (commit
> d6629859b36). The patch introducing the improved kernel handling of
> message queues (using btrees) has, as a by-product, changed the
> meaning of the QSIZE field in the pseudo-file created for the queue.
> Before, this field reflected the size of the user-data in the queue.
> Since, it also takes kernel data structures into account. For
> example, if 13 bytes of user data are in the queue, on my machine the
> file reports a size of 61 bytes.

Good catch, and a nice opportunity to make the mq manpage more specific
wrt to queue sizes.

[...]

> Reporting the size of the message queue in kernel has its merits, but
> doing so in the QSIZE field of the pseudo file corresponding to the
> queue is a breaking change, as mentioned above. This patch therefore
> returns the QSIZE  field to its original meaning. At the same time,
> it introduces a new field QKERSIZE that reflects the size of the queue
> in kernel (user data + kernel data).

Hmmm I'm not sure about this. What are the specific benefits of having
QKERSIZE? We don't export in-kernel data like this in any other ipc
(posix or sysv) mechanism, afaik. Plus, we do not compromise kernel data
structures like this, as we would break userspace if later we change
posix_msg_tree_node. So NAK to this.

I would just remove the extra
+       info->qsize += sizeof(struct posix_msg_tree_node);

bits from d6629859b36 (along with -stable v3.5), plus a patch updating
the manpage that this field only reflects user data.

Thanks,
Davidlohr
