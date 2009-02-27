From: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
	do?
Date: Fri, 27 Feb 2009 13:54:15 -0800
Message-ID: <1235771655.26788.400.camel@nimitz>
References: <1234462282.30155.171.camel@nimitz>
	 <1234467035.3243.538.camel@calx>
	 <20090212114207.e1c2de82.akpm@linux-foundation.org>
	 <1234475483.30155.194.camel@nimitz>
	 <20090212141014.2cd3d54d.akpm@linux-foundation.org>
	 <1234479845.30155.220.camel@nimitz>
	 <20090226162755.GB1456@x200.localdomain> <20090226173302.GB29439@elte.hu>
	 <20090226223112.GA2939@x200.localdomain>
	 <1235751298.26788.372.camel@nimitz>
	 <20090227215749.GA3453@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090227215749.GA3453-2ev+ksY9ol182hYKe6nXyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, 2009-02-28 at 00:57 +0300, Alexey Dobriyan wrote:
> On Fri, Feb 27, 2009 at 08:14:58AM -0800, Dave Hansen wrote:
> > On Fri, 2009-02-27 at 01:31 +0300, Alexey Dobriyan wrote:
> > > > I think the main question is: will we ever find ourselves in the 
> > > > future saying that "C/R sucks, nobody but a small minority uses 
> > > > it, wish we had never merged it"? I think the likelyhood of that 
> > > > is very low. I think the current OpenVZ stuff already looks very 
> > > > useful, and i dont think we've realized (let alone explored) all 
> > > > the possibilities yet.
> > > 
> > > This is collecting and start of dumping part of cleaned up OpenVZ C/R
> > > implementation, FYI.
> > 
> > Are you just posting this to show how you expect c/r to look eventually?
> > Or are you proposing this as an alternative to what Oren has bee
> > posting?
> 
> This is under discussion right now.

Here as in LKML and containers@?  Or do you mean among the
OpenVZ/Virtuozzo folks?

The reason I ask is that we have gone through several rounds of
community review over the last few months with Oren's code, and I'd hate
to throw that away unless there's something wrong with it.  Is there
something wrong with it?

-- Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
