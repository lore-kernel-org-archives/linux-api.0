From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Wed, 13 May 2015 14:32:28 +0200
Message-ID: <20150513123227.GA3512@quack.suse.cz>
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
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon 11-05-15 09:24:09, Sage Weil wrote:
> On Mon, 11 May 2015, Theodore Ts'o wrote:
> > On Sun, May 10, 2015 at 07:13:24PM -0400, Trond Myklebust wrote:
> > > That makes it completely non-generic though. By putting this in the
> > > VFS, you are giving applications a loaded gun that is pointed straight
> > > at the application user's head.
> > 
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
  Can we get some numbers on this? Before we go on and implement new mount
options, persistent inode flags, open flags, or whatever other crap
(neither of which looks particularly appealing to me) I'd like to know how
big is the performance difference between lazytime + fdatasync and not
updating mtime at all for Ceph...
								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
