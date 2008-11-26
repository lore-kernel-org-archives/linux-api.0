From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [take2] Inotify: nested attributes support.
Date: Wed, 26 Nov 2008 00:15:38 -0800
Message-ID: <20081126001538.4b1c7c99.akpm@linux-foundation.org>
References: <20081125194234.GA24449@ioremap.net>
	<20081125162434.4feacbbf.akpm@linux-foundation.org>
	<20081126074239.GA17525@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081126074239.GA17525-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Cc: john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pavel-AlSwsSmVLrQ@public.gmane.org, davidn-KzQzY1MbaKjAHznzqCTclw@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 26 Nov 2008 10:42:39 +0300 Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org> wrote:

> Hi Andrew.
> 
> On Tue, Nov 25, 2008 at 04:24:34PM -0800, Andrew Morton (akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org) wrote:
> > I guess I'm being more than usually thick, but I don't understand what
> > this is all about, why it was implemented, what value it provides to
> > users, etc, etc?  Why do I want scalable nested attributes in inotify??
> 
> Originally I just wanted to have a PID value in the inotify events, so
> reused cookie for that, but people rather vocally rised against this. So
> solution is to extend its structure. It would be possible just to add
> couple more bytes and store data there, but if we will want to add some
> more data into event later, we will have to implement inotify3 and so
> on. So I implemented a way to put essentially any number of new and old
> events in any order, turn then on and off, and do not care about
> possible limitation of the structure. As example I added PID, TID,
> write IO start/size and name attributes.

OK, so we have a super-duper framework which will allow us to add pids
(and other things) to inotify messages.

This still doesn't provide a reason for anyone to be interested in the
code!  Why do we want pids in inotify messages?

And how does this work give that pids are (no longer) system-wide unique?

> > I'm buried in patches which I don't understand lately, and having
> > hundreds of people send patches at one guy who doesn't understand them
> > isn't a good system.  Eric Paris is working on inotify-type things as
> > well.  It would be neat if you guys were to understand and review each
> > other's work.  Please.
> 
> No problem, I will review patches if added to the copy. I'm not
> subscsribed to linux-kernel@ so will miss them otherwise.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
