From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Mon, 11 May 2015 17:31:04 +1000
Message-ID: <20150511073103.GO4327@dastard>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
 <20150507002617.GJ4327@dastard>
 <20150507172053.GA659@lenny.home.zabbo.net>
 <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net>
 <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com>
 <20150508221325.GM4327@dastard>
 <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net>
 <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, May 10, 2015 at 07:13:24PM -0400, Trond Myklebust wrote:
> On Fri, May 8, 2015 at 6:24 PM, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org> wrote:
> > I'm sure you realize what we're try to achieve is the same "invisible IO"
> > that the XFS open by handle ioctls do by default.  Would you be more
> > comfortable if this option where only available to the generic
> > open_by_handle syscall, and not to open(2)?
> 
> It should be an ioctl(). It has no business being part of
> open_by_handle either, since that is another generic interface.

I'm happy for it to be an ioctl interface - even an XFS specific
interface if you want to go that route, Sage - and it probably
should emit a warning to syslog first time it is used so there is
trace for bug triage purposes. i.e. we know the app is not using
mtime updates, so bug reports that are the result of mtime
mishandling don't result in large amounts of wasted developer time
trying to understand them...

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
