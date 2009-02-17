From: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: What can OpenVZ do?
Date: Tue, 17 Feb 2009 14:30:49 -0800
Message-ID: <1234909849.4816.9.camel@nimitz>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
	 <1234285547.30155.6.camel@nimitz>
	 <20090211141434.dfa1d079.akpm@linux-foundation.org>
	 <1234462282.30155.171.camel@nimitz> <1234467035.3243.538.camel@calx>
	 <20090212114207.e1c2de82.akpm@linux-foundation.org>
	 <1234475483.30155.194.camel@nimitz>
	 <20090212141014.2cd3d54d.akpm@linux-foundation.org>
	 <20090213105302.GC4608@elte.hu> <1234817490.30155.287.camel@nimitz>
	 <20090217222319.GA10546@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090217222319.GA10546-X9Un+BFzKDI@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2009-02-17 at 23:23 +0100, Ingo Molnar wrote:
> * Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> > On Fri, 2009-02-13 at 11:53 +0100, Ingo Molnar wrote:
> > > In any case, by designing checkpointing to reuse the existing LSM
> > > callbacks, we'd hit multiple birds with the same stone. (One of
> > > which is the constant complaints about the runtime costs of the LSM
> > > callbacks - with checkpointing we get an independent, non-security
> > > user of the facility which is a nice touch.)
> > 
> > There's a fundamental problem with using LSM that I'm seeing 
> > now that I look at using it for file descriptors.  The LSM 
> > hooks are there to say, "No, you can't do this" and abort 
> > whatever kernel operation was going on.  That's good for 
> > detecting when we do something that's "bad" for checkpointing.
> > 
> > *But* it completely falls on its face when we want to find out 
> > when we are doing things that are *good*.  For instance, let's 
> > say that we open a network socket.  The LSM hook sees it and 
> > marks us as uncheckpointable.  What about when we close it?  
> > We've become checkpointable again.  But, there's no LSM hook 
> > for the close side because we don't currently have a need for 
> > it.
> 
> Uncheckpointable should be a one-way flag anyway. We want this 
> to become usable, so uncheckpointable functionality should be as 
> painful as possible, to make sure it's getting fixed ...

Again, as these patches stand, we don't support checkpointing when
non-simple files are opened.  Basically, if a open()/lseek() pair won't
get you back where you were, we don't deal with them.

init does non-checkpointable things.  If the flag is a one-way trip,
we'll never be able to checkpoint because we'll always inherit init's !
checkpointable flag.  

To fix this, we could start working on making sure we can checkpoint
init, but that's practically worthless.

-- Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
