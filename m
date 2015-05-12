From: Kevin Easton <kevin@guarana.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Tue, 12 May 2015 15:08:21 +1000
Message-ID: <20150512050821.GA9404@chicago.guarana.org>
References: <20150507002617.GJ4327@dastard>
 <20150507172053.GA659@lenny.home.zabbo.net>
 <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net>
 <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com>
 <20150508221325.GM4327@dastard>
 <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net>
 <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com>
 <20150511144719.GA14088@thunk.org>
 <alpine.DEB.2.00.1505110920520.28239@cobra.newdream.net>
 <20150511231021.GC14088@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150511231021.GC14088@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Sage Weil <sage@newdream.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Dave Chinner <david@fromorbit.com>, Zach Brown <zab@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API Mailing List <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 11, 2015 at 07:10:21PM -0400, Theodore Ts'o wrote:
> On Mon, May 11, 2015 at 09:24:09AM -0700, Sage Weil wrote:
> > > Let me re-ask the question that I asked last week (and was apparently
> > > ignored).  Why not trying to use the lazytime feature instead of
> > > pointing a head straight at the application's --- and system
> > > administrators' --- heads?
> > 
> > Sorry Ted, I thought I responded already.
> > 
> > The goal is to avoid inode writeout entirely when we can, and 
> > as I understand it lazytime will still force writeout before the inode 
> > is dropped from the cache.  In systems like Ceph in particular, the 
> > IOs can be spread across lots of files, so simply deferring writeout 
> > doesn't always help.
> 
> Sure, but it would reduce the writeout by orders of magnitude.  I can
> understand if you want to reduce it further, but it might be good
> enough for your purposes.
> 
> I considered doing the equivalent of O_NOMTIME for our purposes at
> $WORK, and our use case is actually not that different from Ceph's
> (i.e., using a local disk file system to support a cluster file
> system), and lazytime was (a) something I figured was something I
> could upstream in good conscience, and (b) was more than good enough
> for us.

A safer alternative might be a chattr file attribute that if set, the
mtime is not updated on writes, and stat() on the file always shows the
mtime as "right now".  At least that way, the file won't accidentally
get left out of backups that rely on the mtime.

(If the file attribute is unset, you immediately update the mtime then
too, and from then on the file is back to normal).

    - Kevin
