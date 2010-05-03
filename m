From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH v21 001/100] eclone (1/11): Factor out code to allocate
 pidmap page
Date: Mon, 03 May 2010 14:12:40 -0700 (PDT)
Message-ID: <20100503.141240.22516688.davem@davemloft.net>
References: <1272723382-19470-2-git-send-email-orenl@cs.columbia.edu>
	<20100501.151022.190375136.davem@davemloft.net>
	<1272920551.12034.4729.camel@nimitz>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1272920551.12034.4729.camel@nimitz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Cc: orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date: Mon, 03 May 2010 14:02:31 -0700

> It has implications _everywhere_.

That does not remove the responsibility to break things up into
managable pieces, not does it make such a task impossible or
even hard to do.

You post sets of 10 to 15 at a time, once those are agreed to
and to everyone's general liking, you toss them into a GIT tree
and you say "here's the next 10 to 15 and they are relative to
the changes in GIT tree X which have already been fully reviewed"

And so on and so forth.

And this is the only logical thing to do, because if someone wants
a change in patch 7, it can effect patch 23 so it's pointless to
post for review a patch that's going to end up changing anyways.
That's a waste of reviewer resources.

To be honest, I'm really tired of what tends to be people's knee jerk
reaction to this situations, which is a lot of people doing nothing
but defending themselves.  Even if it did not violate documented
policy (it did), it violates common sense.  So, can people do
something more constructive than trying to defend themselves on this?

It's stupid and shouldn't have been done, and we should move on.
