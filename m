From: Marcus Gelderie <redmnic@gmail.com>
Subject: Re: [PATCH v2] ipc: Modify message queue accounting to reflect both
 total user data and auxiliary kernel data
Date: Thu, 25 Jun 2015 20:50:19 +0200
Message-ID: <20150625185019.GA17933@ramsey.Speedport_W_724V_09011603_00_009>
References: <20150622222546.GA32432@ramsey.localdomain>
 <1435211229.11852.23.camel@stgolabs.net>
 <CAKgNAkieR5zdpKm=P2dcTDJ_3X4HMRoeOQ2D8yghYVKOjDsYAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkieR5zdpKm=P2dcTDJ_3X4HMRoeOQ2D8yghYVKOjDsYAg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Doug Ledford <dledford@redhat.com>, lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, John Duffy <jb_duffy@btinternet.com>, Arto Bendiken <arto@bendiken.net>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hey all,

answers in text below... 

TLDR: I can remove the QKERSIZE field, as I believe that it does not affect he
RLIMIT accounting (details [=code] below). Question is: Should it?

Before I provide another patch, I would appreciate another round of feedback, though.

So...

On Thu, Jun 25, 2015 at 09:23:33AM +0200, Michael Kerrisk (man-pages) wrote:
> On 25 June 2015 at 07:47, Davidlohr Bueso <dave@stgolabs.net> wrote:
> > Good catch, and a nice opportunity to make the mq manpage more specific
> > wrt to queue sizes.
> >
> > [...]
> >
ACK, I can write a patch for the manpage once we figure out what to do
here.
> >> Reporting the size of the message queue in kernel has its merits, but
> >> doing so in the QSIZE field of the pseudo file corresponding to the
> >> queue is a breaking change, as mentioned above. This patch therefore
> >> returns the QSIZE  field to its original meaning. At the same time,
> >> it introduces a new field QKERSIZE that reflects the size of the queue
> >> in kernel (user data + kernel data).
> >
> > Hmmm I'm not sure about this. What are the specific benefits of having
> > QKERSIZE? We don't export in-kernel data like this in any other ipc
> > (posix or sysv) mechanism, afaik. Plus, we do not compromise kernel data
> > structures like this, as we would break userspace if later we change
> > posix_msg_tree_node. So NAK to this.
> >
> > I would just remove the extra
> > +       info->qsize += sizeof(struct posix_msg_tree_node);
> >
> > bits from d6629859b36 (along with -stable v3.5), plus a patch updating
> > the manpage that this field only reflects user data.
> 
This can be done if the RLIMIT accounting is not done against that
value (more below).

> I've been hoping that Doug would jump into this discussion...
> 
> If I recall/understand Doug correctly (see
> http://thread.gmane.org/gmane.linux.man/7050/focus=1797645 ), his
> rationale for the QSIZE change was that it then revealed a value that
> was closer to what was being used to account against the
> RLIMIT_MSGQUEUE resource limit. (Even with these changes, the QSIZE
> value was not 100% accurate for accounting against RLIMIT_MSGQUEUE,
> since some pieces of kernel overhead were still not being accounted
> for. Nevertheless, it's much closer than the old (pre 3.5) QSIZE for
> some corner cases.) Thus, Marcus's rationale for preserving this info
> as QKERSIZE.
> 

Actually, looking at the code, it seems to me that the QKERSIZE
(a.k.a. the current qsize field) is actually not used for the purpose of
accounting at all. From ipc/mqueue.c (line 281 ff, comments added by me):
		
		/* worst case estimate for the btree in memory */
		
		mq_treesize = info->attr.mq_maxmsg * sizeof(struct msg_msg) +
			min_t(unsigned int, info->attr.mq_maxmsg, MQ_PRIO_MAX) *
			sizeof(struct posix_msg_tree_node);

		/* worst case estimate for the user data in the queue */
		
		mq_bytes = mq_treesize + (info->attr.mq_maxmsg *
					  info->attr.mq_msgsize);

		spin_lock(&mq_lock);
		    
		    /* acutal accounting; u->mq_bytes is the other
		     * message queus for this user (computed in the way
		     * above (i.e. worst-case estimates) 
		     */

		if (u->mq_bytes + mq_bytes < u->mq_bytes ||
		    u->mq_bytes + mq_bytes > rlimit(RLIMIT_MSGQUEUE)) {
			[....]
			ret = -EMFILE;
			[.....]

So, I think that if the RLIMIT should take the actual size (not the
worst case) into account, then we have a bug. I can write a patch, but that
should be separate from this... meaning I'll turn this into a patchset.

However, we should decide what we want first: If I read the manpage (mq_overview), I
am inclined to think that the RLIMIT should use the acutal amount of
data occupied by the queue (or at least the user data). But it does not
necessarily rule out an accounting against worst-case estimation (to me
at least).


> Now whether QKERSIZE is actually useful or used by anyone is another
> question. As far as I know, there was no user request that drove the
> change. But Doug can perhaps say something to this. QSIZE should I
> think definitely be fixed (reverted to pre-3.5 behavior). I'm agnostic
> about QKERSIZE.
> 
> Cheers,
> 
> Michael
> 
> 
> -- 
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/
