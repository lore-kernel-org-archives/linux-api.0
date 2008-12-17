From: Jiri Pirko <jpirko@redhat.com>
Subject: Re: [PATCH, RESEND2] getrusage: fill ru_maxrss value
Date: Wed, 17 Dec 2008 15:52:39 +0100
Message-ID: <20081217155239.77e58da0@psychotron.englab.brq.redhat.com>
References: <20081217194646.F677.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081217124256.46883fae@psychotron.englab.brq.redhat.com>
	<20081217204607.FF25.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753704AbYLQOxd@vger.kernel.org>
In-Reply-To: <20081217204607.FF25.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Michael Kerrisk <mtk.manpages@googlemail.com>, linux-api@vger.kernel.org, Hugh Dickins <hugh@veritas.com>, jlim@sgi.com
List-Id: linux-api@vger.kernel.org

On Wed, 17 Dec 2008 21:03:27 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > > This patch makes ->ru_maxrss value in struct rusage filled accordingly to
> > > > rss hiwater mark. This struct is filled as a parameter to
> > > > getrusage syscall. ->ru_maxrss value is set to pages which might be correct
> > > > as "time" application converts it to KBs.
> > > 
> > > Why?
> > > if kernel convert to KB, glibc don't need any change.
> > Where exactly glibc is working with this as KBs? I can't find that place.
> > 
> > I looked into sources of time util and maxrss is showed this way:
> > fprintf (fp, "%lu", ptok ((UL) resp->ru.ru_maxrss));
> > ptok() actually does pages_to_KB conversion. If we convert to KB in
> > kernel, this code must be changed.
> 
> Ah, you talked about /usr/bin/time? sorry, I misunderstood a bit.
> Why time need number of pages?
> 
> In general, getrusage()::ru_maxrss is bsd compatibility feature.
> as far as possible, the same syscall spec is better.
> and bsd use KB unit.
Oh you are right. Now I searched it in FreeBSD kernel. They goes like this:
rss = pgtok(vmspace_resident_count(vm));
if (ru->ru_maxrss < rss)
	ru->ru_maxrss = rss;

Seems pretty reasonable to stick with the same behavior. Then I really
do not understand why /usr/bin/time does the conversion.
FreeBSD /usr/bin/time is very different and much simpler and (of
course) does not do this conversion.

So I suggest to change the patch to fill KB instead of pages and
change /usr/bin/time to not do the conversion. What do you think?
> 
> if time command has reasonable reason, I can agree current design.
> but is there?
> 
> 
> 
