From: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Banning checkpoint (was: Re: What can OpenVZ do?)
Date: Mon, 23 Feb 2009 21:11:25 -0800
Message-ID: <1235452285.26788.226.camel@nimitz>
References: <20090217222319.GA10546@elte.hu>
	 <1234909849.4816.9.camel@nimitz> <20090218003217.GB25856@elte.hu>
	 <1234917639.4816.12.camel@nimitz> <20090218051123.GA9367@x200.localdomain>
	 <20090218181644.GD19995@elte.hu> <1234992447.26788.12.camel@nimitz>
	 <20090218231545.GA17524@elte.hu> <20090219190637.GA4846@x200.localdomain>
	 <1235070714.26788.56.camel@nimitz> <20090224044752.GB3202@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090224044752.GB3202-2ev+ksY9ol182hYKe6nXyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2009-02-24 at 07:47 +0300, Alexey Dobriyan wrote:
> > I think what I posted is a decent compromise.  It gets you those
> > warnings at runtime and is a one-way trip for any given process.  But,
> > it does detect in certain cases (fork() and unshare(FILES)) when it is
> > safe to make the trip back to the "I'm checkpointable" state again.
> 
> "Checkpointable" is not even per-process property.
> 
> Imagine, set of SAs (struct xfrm_state) and SPDs (struct xfrm_policy).
> They are a) per-netns, b) persistent.
> 
> You can hook into socketcalls to mark process as uncheckpointable,
> but since SAs and SPDs are persistent, original process already exited.
> You're going to walk every process with same netns as SA adder and mark
> it as uncheckpointable. Definitely doable, but ugly, isn't it?
> 
> Same for iptable rules.
> 
> "Checkpointable" is container property, OK?

Ideally, I completely agree.

But, we don't currently have a concept of a true container in the
kernel.  Do you have any suggestions for any current objects that we
could use in its place for a while?

-- Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
