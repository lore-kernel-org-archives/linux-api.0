From: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Tue, 12 May 2015 14:35:52 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1505112225170.28239@cobra.newdream.net>
References: <20150507002617.GJ4327@dastard> <20150507172053.GA659@lenny.home.zabbo.net> <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net> <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com> <20150508221325.GM4327@dastard>
 <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net> <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com> <20150511144719.GA14088@thunk.org> <alpine.DEB.2.00.1505110920520.28239@cobra.newdream.net> <20150511231021.GC14088@thunk.org>
 <20150512050821.GA9404@chicago.guarana.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150512050821.GA9404-Qr0l8DEfScZEV+tojptmR0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kevin Easton <kevin-RFfraI6bZkdAfugRpC6u6w@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 12 May 2015, Kevin Easton wrote:
> On Mon, May 11, 2015 at 07:10:21PM -0400, Theodore Ts'o wrote:
> > On Mon, May 11, 2015 at 09:24:09AM -0700, Sage Weil wrote:
> > > > Let me re-ask the question that I asked last week (and was apparently
> > > > ignored).  Why not trying to use the lazytime feature instead of
> > > > pointing a head straight at the application's --- and system
> > > > administrators' --- heads?
> > > 
> > > Sorry Ted, I thought I responded already.
> > > 
> > > The goal is to avoid inode writeout entirely when we can, and 
> > > as I understand it lazytime will still force writeout before the inode 
> > > is dropped from the cache.  In systems like Ceph in particular, the 
> > > IOs can be spread across lots of files, so simply deferring writeout 
> > > doesn't always help.
> > 
> > Sure, but it would reduce the writeout by orders of magnitude.  I can
> > understand if you want to reduce it further, but it might be good
> > enough for your purposes.
> > 
> > I considered doing the equivalent of O_NOMTIME for our purposes at
> > $WORK, and our use case is actually not that different from Ceph's
> > (i.e., using a local disk file system to support a cluster file
> > system), and lazytime was (a) something I figured was something I
> > could upstream in good conscience, and (b) was more than good enough
> > for us.
> 
> A safer alternative might be a chattr file attribute that if set, the
> mtime is not updated on writes, and stat() on the file always shows the
> mtime as "right now".  At least that way, the file won't accidentally
> get left out of backups that rely on the mtime.
> 
> (If the file attribute is unset, you immediately update the mtime then
> too, and from then on the file is back to normal).

Interesting!  I didn't realize there was already a chattr +A that disabled 
atime (although I suspect it doesn't do the "right now" for stat thing). 
This makes the nomtime-ness a bit more obscure (I don't think most users 
would think to check these file attributes), but it's a safer failure 
condition for backups at least.

The fact that chattr +A (and hopefully +M) will work for non-root is a 
bonus, as we're also trying to get ceph daemons to drop most privileges.

sage
