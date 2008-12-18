From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH, RESEND2] getrusage: fill ru_maxrss value
Date: Thu, 18 Dec 2008 11:50:09 +0900 (JST)
Message-ID: <20081218111608.615F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081217204607.FF25.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081217155239.77e58da0@psychotron.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753847AbYLRCuh@vger.kernel.org>
In-Reply-To: <20081217155239.77e58da0@psychotron.englab.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Pirko <jpirko@redhat.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Michael Kerrisk <mtk.manpages@googlemail.com>, linux-api@vger.kernel.org, Hugh Dickins <hugh@veritas.com>, jlim@sgi.com
List-Id: linux-api@vger.kernel.org

> > Ah, you talked about /usr/bin/time? sorry, I misunderstood a bit.
> > Why time need number of pages?
> > 
> > In general, getrusage()::ru_maxrss is bsd compatibility feature.
> > as far as possible, the same syscall spec is better.
> > and bsd use KB unit.
> Oh you are right. Now I searched it in FreeBSD kernel. They goes like this:
> rss = pgtok(vmspace_resident_count(vm));
> if (ru->ru_maxrss < rss)
> 	ru->ru_maxrss = rss;
> 
> Seems pretty reasonable to stick with the same behavior. Then I really
> do not understand why /usr/bin/time does the conversion.

me too ;-)

> FreeBSD /usr/bin/time is very different and much simpler and (of
> course) does not do this conversion.
> 
> So I suggest to change the patch to fill KB instead of pages and
> change /usr/bin/time to not do the conversion. What do you think?

Makes really much sense. thanks!!
