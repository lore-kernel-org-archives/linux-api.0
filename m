From: Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v21 001/100] eclone (1/11): Factor out code to allocate
	pidmap page
Date: Sat, 1 May 2010 20:14:27 -0400
Message-ID: <20100502001427.GH2671@hansolo.jdub.homelinux.org>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu> <1272723382-19470-2-git-send-email-orenl@cs.columbia.edu> <20100501.151022.190375136.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100501.151022.190375136.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, May 01, 2010 at 03:10:22PM -0700, David Miller wrote:
>
>NO WAY, there is no way in the world you should post 100 patches
>at a time to any mailing list, especially those at vger.kernel.org
>that have thousands upon thousands of subscribers.
>
>Post only small, well contained, sets of patches at a time.  At most
>10 or so in one go.
>
>Do you realize how much mail traffic you generate by posting so many
>patches at one time, and how unlikely it is for anyone to actually
>sift through and review your patches after you've spammed them by
>posting so many at one time?
>
>A second infraction and I will have no choice but to block you at the
>SMTP level at vger.kernel.org so please do not do it again.

So I really agree with everything you said here, but I do wonder why you haven't
sent a similar rant about the often 100+ patchsets for the -stable series.  We  
are supposed to review those and follow up on them to be sure they're suitable  
for a stable release.

Or the 100+ emails about regressions from version to version.  Etc, etc.

I'm not saying you're wrong, but it does seem a bit odd that you choose to reply
to this one, and not the other umpteen cases I often see.  Maybe it isn't about 
the size or volume of the emails, and more about the fact that it's 100 patches 
to implement _one_ thing?  If so, then I don't really think it's about list
traffic at all...

josh
