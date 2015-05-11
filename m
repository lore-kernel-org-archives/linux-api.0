From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Mon, 11 May 2015 19:10:21 -0400
Message-ID: <20150511231021.GC14088@thunk.org>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
 <20150507002617.GJ4327@dastard>
 <20150507172053.GA659@lenny.home.zabbo.net>
 <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net>
 <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com>
 <20150508221325.GM4327@dastard>
 <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net>
 <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com>
 <20150511144719.GA14088@thunk.org>
 <alpine.DEB.2.00.1505110920520.28239@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1505110920520.28239-vIokxiIdD2AQNTJnQDzGJqxOck334EZe@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
Cc: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 11, 2015 at 09:24:09AM -0700, Sage Weil wrote:
> > Let me re-ask the question that I asked last week (and was apparently
> > ignored).  Why not trying to use the lazytime feature instead of
> > pointing a head straight at the application's --- and system
> > administrators' --- heads?
> 
> Sorry Ted, I thought I responded already.
> 
> The goal is to avoid inode writeout entirely when we can, and 
> as I understand it lazytime will still force writeout before the inode 
> is dropped from the cache.  In systems like Ceph in particular, the 
> IOs can be spread across lots of files, so simply deferring writeout 
> doesn't always help.

Sure, but it would reduce the writeout by orders of magnitude.  I can
understand if you want to reduce it further, but it might be good
enough for your purposes.

I considered doing the equivalent of O_NOMTIME for our purposes at
$WORK, and our use case is actually not that different from Ceph's
(i.e., using a local disk file system to support a cluster file
system), and lazytime was (a) something I figured was something I
could upstream in good conscience, and (b) was more than good enough
for us.

Cheers,

					- Ted

P.S.  I do agree that if we do need this upstream, requiring a mount
option to enable the feature is probably a good compromise.
