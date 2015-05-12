From: bfields@fieldses.org (J. Bruce Fields)
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Tue, 12 May 2015 10:36:37 -0400
Message-ID: <20150512143637.GA6370@fieldses.org>
References: <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com>
 <20150508221325.GM4327@dastard>
 <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net>
 <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com>
 <20150511144719.GA14088@thunk.org>
 <alpine.DEB.2.00.1505110920520.28239@cobra.newdream.net>
 <20150511231021.GC14088@thunk.org>
 <20150512050821.GA9404@chicago.guarana.org>
 <5551E7EB.8040301@gmail.com>
 <21842.1555.38099.868100@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <21842.1555.38099.868100@quad.stoffel.home>
Sender: linux-kernel-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Kevin Easton <kevin@guarana.org>, Theodore Ts'o <tytso@mit.edu>, Sage Weil <sage@newdream.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Dave Chinner <david@fromorbit.com>, Zach Brown <zab@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API Mailing List <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 12, 2015 at 09:54:27AM -0400, John Stoffel wrote:
> >>>>> "Austin" == Austin S Hemmelgarn <ahferroin7@gmail.com> writes:
> 
> Austin> On 2015-05-12 01:08, Kevin Easton wrote:
> >> On Mon, May 11, 2015 at 07:10:21PM -0400, Theodore Ts'o wrote:
> >>> On Mon, May 11, 2015 at 09:24:09AM -0700, Sage Weil wrote:
> >>>>> Let me re-ask the question that I asked last week (and was apparently
> >>>>> ignored).  Why not trying to use the lazytime feature instead of
> >>>>> pointing a head straight at the application's --- and system
> >>>>> administrators' --- heads?
> >>>> 
> >>>> Sorry Ted, I thought I responded already.
> >>>> 
> >>>> The goal is to avoid inode writeout entirely when we can, and
> >>>> as I understand it lazytime will still force writeout before the inode
> >>>> is dropped from the cache.  In systems like Ceph in particular, the
> >>>> IOs can be spread across lots of files, so simply deferring writeout
> >>>> doesn't always help.
> >>> 
> >>> Sure, but it would reduce the writeout by orders of magnitude.  I can
> >>> understand if you want to reduce it further, but it might be good
> >>> enough for your purposes.
> >>> 
> >>> I considered doing the equivalent of O_NOMTIME for our purposes at
> >>> $WORK, and our use case is actually not that different from Ceph's
> >>> (i.e., using a local disk file system to support a cluster file
> >>> system), and lazytime was (a) something I figured was something I
> >>> could upstream in good conscience, and (b) was more than good enough
> >>> for us.
> >> 
> >> A safer alternative might be a chattr file attribute that if set, the
> >> mtime is not updated on writes, and stat() on the file always shows the
> >> mtime as "right now".  At least that way, the file won't accidentally
> >> get left out of backups that rely on the mtime.
> >> 
> >> (If the file attribute is unset, you immediately update the mtime then
> >> too, and from then on the file is back to normal).
> >> 
> 
> Austin> I like this even better than the flag suggestion, it provides
> Austin> better control, means that you don't need to update
> Austin> applications to get the benefits, and prevents backup software
> Austin> from breaking (although backups would be bigger).
> 
> Me too, it fails in a safer mode, where you do more work on backups
> than strictly needed.  I'm still against this as a mount option
> though, way way way too many bullets in the foot gun.  And as someone
> else said, once you mount with O_NOMTIME, then unmount, then mount
> again without O_NOMTIME, you've lost information.  Not good.  

That was me.  Zach also pointed out to me that'd mean figuring out where
to store that information on-disk for every filesystem you care about.
I like the idea of something persistent, but maybe it's more trouble
than it's worth--I honestly don't know.

--b.
