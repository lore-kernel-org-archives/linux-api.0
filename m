From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Tue, 12 May 2015 11:21:33 +1000
Message-ID: <20150512012133.GR4327@dastard>
References: <20150507172053.GA659@lenny.home.zabbo.net>
 <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net>
 <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com>
 <20150508221325.GM4327@dastard>
 <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net>
 <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com>
 <20150511073103.GO4327@dastard>
 <alpine.DEB.2.00.1505110925150.28239@cobra.newdream.net>
 <CAHQdGtT3rCf-ycAYw-=7HGaemg1+HfY8sw3+kb54VHONxDyP3w@mail.gmail.com>
 <alpine.DEB.2.00.1505111020120.28239@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1505111020120.28239@cobra.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>, Zach Brown <zab@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API Mailing List <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 11, 2015 at 10:30:58AM -0700, Sage Weil wrote:
> On Mon, 11 May 2015, Trond Myklebust wrote:
> > On Mon, May 11, 2015 at 12:39 PM, Sage Weil <sage@newdream.net> wrote:
> > > On Mon, 11 May 2015, Dave Chinner wrote:
> > >> On Sun, May 10, 2015 at 07:13:24PM -0400, Trond Myklebust wrote:
> > >> > On Fri, May 8, 2015 at 6:24 PM, Sage Weil <sage@newdream.net> wrote:
> > >> > > I'm sure you realize what we're try to achieve is the same "invisible IO"
> > >> > > that the XFS open by handle ioctls do by default.  Would you be more
> > >> > > comfortable if this option where only available to the generic
> > >> > > open_by_handle syscall, and not to open(2)?
> > >> >
> > >> > It should be an ioctl(). It has no business being part of
> > >> > open_by_handle either, since that is another generic interface.
> > >
> > > Our use-case doesn't make sense on network file systems, but it does on
> > > any reasonably featureful local filesystem, and the goal is to be generic
> > > there.  If mtime is critical to a network file system's consistency it
> > > seems pretty reasonable to disallow/ignore it for just that file system
> > > (e.g., by masking off the flag at open time), as others won't have that
> > > same problem (cephfs doesn't, for example).
> > >
> > > Perhaps making each fs opt-in instead of handling it in a generic path
> > > would alleviate this concern?
> > 
> > The issue isn't whether or not you have a network file system, it's
> > whether or not you want users to be able to manage data. mtime isn't
> > useful for the application (which knows whether or not it has changed
> > the file) or for the filesystem (ditto). It exists, rather, in order
> > to enable data management by users and other applications, letting
> > them know whether or not the data contents of the file have changed,
> > and when that change occurred.
> 
> Agreed.
>  
> > If you are able to guarantee that your users don't care about that,
> > then fine, but that would be a very special case that doesn't fit the
> > way that most data centres are run. Backups are one case where mtime
> > matters, tiering and archiving is another.
> 
> This is true, although I argue it is becoming increasingly common for the 
> data management (including backups and so forth) to be layered not on top 
> of the POSIX file system but on something higher up in the stack. This is 

In the cloud storage world, yes. In the rest of the world, no.
It's the rest of the world we are worried about here. :/

> > Neither of these examples
> > cases are under the control of the application that calls
> > open(O_NOMTIME).
> 
> Wouldn't a mount option (e.g., allow_nomtime) address this concern?  Only 
> nodes provisioned explicitly to run these systems would be enable this 
> option.

Back to my Joe Speedracer comments.....

I'm not sure what the right answer is - mount options are simply too
easy to add without understanding the full implications of them.
e.g. we didn't merge FALLOC_FL_NO_HIDE_STALE simply because it was
too dangerous for unsuspecting users. This isn't at that same level
or concern, but it's still a landmine we want to avoid users from
arming without realising it...

> > >> I'm happy for it to be an ioctl interface - even an XFS specific
> > >> interface if you want to go that route, Sage - and it probably
> > >> should emit a warning to syslog first time it is used so there is
> > >> trace for bug triage purposes. i.e. we know the app is not using
> > >> mtime updates, so bug reports that are the result of mtime
> > >> mishandling don't result in large amounts of wasted developer time
> > >> trying to understand them...
> > >
> > > A warning on using the interface (or when mounting with user_nomtime)
> > > sounds reasonable.
> > >
> > > I'd rather not make this XFS specific as other local filesystmes (ext4,
> > > f2fs, possibly btrfs) would similarly benefit.  (And if we want to target
> > > XFS specifically the existing XFS open-by-handle ioctl is sufficient as it
> > > already does O_NOMTIME unconditionally.)
> > 
> > Lack of a namespace, doesn't imply that you don't want to manage the
> > data. The whole point of using object storage instead of plain old
> > block storage is to be able to provide whatever metadata you still
> > need in order to manage the object.
> 
> Yeah, agreed--this is presumably why open_by_handle(2) (which is what we'd 
> like to use) doesn't assume O_NOMTIME.

Right - the XFS ioctls were designed specifically for applications
that interacted directly with the structure of XFS filesystems and
so needed invisible IO (e.g. online defragmenter). IOWs, they are
not interfaces intended for general usage. They are also only
available to root, so a typical user application won't be making use
of them, either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
