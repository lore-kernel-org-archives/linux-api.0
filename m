From: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC v13][PATCH 00/14] Kernel based checkpoint/restart
Date: Mon, 16 Feb 2009 09:37:13 -0800
Message-ID: <1234805833.30155.258.camel@nimitz>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
	 <1234285547.30155.6.camel@nimitz>
	 <20090211141434.dfa1d079.akpm@linux-foundation.org>
	 <1234462282.30155.171.camel@nimitz>
	 <20090213152836.0fbbfa7d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090213152836.0fbbfa7d.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: mingo-X9Un+BFzKDI@public.gmane.org, orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2009-02-13 at 15:28 -0800, Andrew Morton wrote:
> > > For extra marks:
> > > 
> > > - Will any of this involve non-trivial serialisation of kernel
> > >   objects?  If so, that's getting into the
> > >   unacceptably-expensive-to-maintain space, I suspect.
> > 
> > We have some structures that are certainly tied to the kernel-internal
> > ones.  However, we are certainly *not* simply writing kernel structures
> > to userspace.  We could do that with /dev/mem.  We are carefully pulling
> > out the minimal bits of information from the kernel structures that we
> > *need* to recreate the function of the structure at restart.  There is a
> > maintenance burden here but, so far, that burden is almost entirely in
> > checkpoint/*.c.  We intend to test this functionality thoroughly to
> > ensure that we don't regress once we have integrated it.
> 
> I guess my question can be approximately simplified to: "will it end up
> looking like openvz"?  (I don't believe that we know of any other way
> of implementing this?)
> 
> Because if it does then that's a concern, because my assessment when I
> looked at that code (a number of years ago) was that having code of
> that nature in mainline would be pretty costly to us, and rather
> unwelcome.

With the current path, my guess is that we will end up looking
*something* like OpenVZ.  But, with all the input from the OpenVZ folks
and at least three other projects, I bet we can come up with something
better.  I do wish the OpenVZ folks were being more vocal and
constructive about Oren's current code but I guess silence is the
greatest complement...

> The broadest form of the question is "will we end up regretting having
> done this".
> If we can arrange for the implementation to sit quietly over in a
> corner with a team of people maintaining it and not screwing up other
> people's work then I guess we'd be OK - if it breaks then the breakage
> is localised.
> 
> And it's not just a matter of "does the diffstat only affect a single
> subdirectory".  We also should watch out for the imposition of new
> rules which kernel code must follow.  "you can't do that, because we
> can't serialise it", or something.
> 
> Similar to the way in which perfectly correct and normal kernel
> sometimes has to be changed because it unexpectedly upsets the -rt
> patch.
> 
> Do you expect that any restrictions of this type will be imposed?

Basically, yes.  But, practically, we haven't been thinking about
serializing stuff in the kernel, ever.  That's produced a few
difficult-to-serialize things like AF_UNIX sockets but absolutely
nothing that simply can't be done.  

Having this code in mainline and getting some of people's mindshare
should at least enable us to speak up if we see another thing like
AF_UNIX coming down the pipe.  We could hopefully catch it and at least
tweak it a bit to enhance how easily we can serialize it. 

Again, it isn't likely to be an all-or-nothing situation.  It is a
matter of how many hoops the checkpoint code itself has to jump
through. 

-- Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
