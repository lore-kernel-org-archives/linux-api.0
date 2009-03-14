From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
	do?
Date: Sat, 14 Mar 2009 03:20:59 +0300
Message-ID: <20090314002059.GA4167@x200.localdomain>
References: <20090310215305.GA2078@x200.localdomain> <49B775B4.1040800@free.fr> <20090312145311.GC12390@us.ibm.com> <1236891719.32630.14.camel@bahia> <20090312212124.GA25019@us.ibm.com> <604427e00903122129y37ad791aq5fe7ef2552415da9@mail.gmail.com> <20090313053458.GA28833@us.ibm.com> <alpine.LFD.2.00.0903131018390.3940@localhost.localdomain> <20090313193500.GA2285@x200.localdomain> <alpine.LFD.2.00.0903131401070.3940@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903131401070.3940-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Mar 13, 2009 at 02:01:50PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 13 Mar 2009, Alexey Dobriyan wrote:
> > > 
> > > Let's face it, we're not going to _ever_ checkpoint any kind of general 
> > > case process. Just TCP makes that fundamentally impossible in the general 
> > > case, and there are lots and lots of other cases too (just something as 
> > > totally _trivial_ as all the files in the filesystem that don't get rolled 
> > > back).
> > 
> > What do you mean here? Unlinked files?
> 
> Or modified files, or anything else. "External state" is a pretty damn 
> wide net. It's not just TCP sequence numbers and another machine.

I think (I think) you're seriously underestimating what's doable with
kernel C/R and what's already done.

I was told (haven't seen it myself) that Oracle installations and
Counter Strike servers were moved between boxes just fine.

They were run in specially prepared environment of course, but still.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
