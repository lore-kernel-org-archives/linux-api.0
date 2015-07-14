From: Marcus Gelderie <redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/1] ipc,mqueue: Delete bogus overflow check
Date: Tue, 14 Jul 2015 18:11:18 +0200
Message-ID: <20150714161118.GA18565@ramsey.client.m3-hotspots.de>
References: <20150622222546.GA32432@ramsey.localdomain>
 <1435211229.11852.23.camel@stgolabs.net>
 <CAKgNAkieR5zdpKm=P2dcTDJ_3X4HMRoeOQ2D8yghYVKOjDsYAg@mail.gmail.com>
 <1435256484.11852.30.camel@stgolabs.net>
 <20150706154928.GA19828@ramsey.localdomain>
 <1436575691.27924.53.camel@stgolabs.net>
 <20150711020300.GH17109@ZenIV.linux.org.uk>
 <55A0867A.1060202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55A0867A.1060202-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Duffy <jb_duffy-FhtRXb7CoQBt1OO0OYaSVA@public.gmane.org>, Arto Bendiken <arto-TQ6thHYR8Svk1uMJSBkQmQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hey,

I think Davidlohr has a point though on the computation of mq_treesize
being redundant code.

So even though the overflow check turns out to be necessary, it wouldn't 
hurt to do some refactoring of the computations, especially, because
they occur in mutiple places as copy-paste code.


@Davidlohr: Will there be a v2 of your patch?

On Fri, Jul 10, 2015 at 10:59:06PM -0400, Doug Ledford wrote:
> On 07/10/2015 10:03 PM, Al Viro wrote:
> > On Fri, Jul 10, 2015 at 05:48:11PM -0700, Davidlohr Bueso wrote:
> >> Mathematically, returning -EOVERFLOW in mq_attr_ok()
> >> cannot occur under this condition:
> >>
> >>        mq_treesize = attr->mq_maxmsg * sizeof(struct msg_msg) +
> >> 	       min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
> >> 	       sizeof(struct posix_msg_tree_node);
> >>        total_size = attr->mq_maxmsg * attr->mq_msgsize;
> >>        if (total_size + mq_treesize < total_size)
> >> 	       return -EOVERFLOW;
> > 
> > A proof would be nice.  More detailed one than "cannot occur", that is.
> > 
> > 	Condition in question is basically mq_treesize < 0 or
> > total_size + mq_treesize (in natural numbers) > 2^BITS_PER_LONG.
> > Now, the maximal values of ->mq_maxmsg and ->mq_msgsize are 2^16 and
> > 2^24 resp. and we are guaranteed that their product is below 2^BITS_PER_LONG.
> > For mq_treesize we are guaranteed that it's below 2^31.  Now, on a 64bit
> > box that would suffice to avoid overflow - the product is at most 2^40 and
> > its sum with mq_treesize can't wrap around.
> > 
> > For 32bit system, though...  Suppose attr->mq_maxmsg == 65535 and
> > attr->mq_msgsize == 65537.  Their product *is* below 2^BITS_PER_LONG - it's
> > exactly 1 less than that.  _Any_ non-zero value for mq_tresize (and it
> > will be non-zero in the above) will lead to wraparound.
> > 
> > Looks like a counterexample to your assertion above...
> > 
> 
> I'm pretty sure you're right.  The above looks like an example of "Gee,
> we need to protect against signed wrap around.  Wait, it's unsigned, no
> worries." when in fact unsigned will wrap around too if the total
> exceeds the maximum (it just wraps to a small positive value instead of
> a large negative value).
> 
> -- 
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
> 
> 
