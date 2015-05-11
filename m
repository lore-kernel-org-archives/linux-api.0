From: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Mon, 11 May 2015 10:30:58 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1505111020120.28239@cobra.newdream.net>
References: <1430949612-21356-1-git-send-email-zab@redhat.com> <20150507002617.GJ4327@dastard> <20150507172053.GA659@lenny.home.zabbo.net> <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net> <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com>
 <20150508221325.GM4327@dastard> <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net> <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com> <20150511073103.GO4327@dastard> <alpine.DEB.2.00.1505110925150.28239@cobra.newdream.net>
 <CAHQdGtT3rCf-ycAYw-=7HGaemg1+HfY8sw3+kb54VHONxDyP3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHQdGtT3rCf-ycAYw-=7HGaemg1+HfY8sw3+kb54VHONxDyP3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 11 May 2015, Trond Myklebust wrote:
> On Mon, May 11, 2015 at 12:39 PM, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org> wrote:
> > On Mon, 11 May 2015, Dave Chinner wrote:
> >> On Sun, May 10, 2015 at 07:13:24PM -0400, Trond Myklebust wrote:
> >> > On Fri, May 8, 2015 at 6:24 PM, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org> wrote:
> >> > > I'm sure you realize what we're try to achieve is the same "invisible IO"
> >> > > that the XFS open by handle ioctls do by default.  Would you be more
> >> > > comfortable if this option where only available to the generic
> >> > > open_by_handle syscall, and not to open(2)?
> >> >
> >> > It should be an ioctl(). It has no business being part of
> >> > open_by_handle either, since that is another generic interface.
> >
> > Our use-case doesn't make sense on network file systems, but it does on
> > any reasonably featureful local filesystem, and the goal is to be generic
> > there.  If mtime is critical to a network file system's consistency it
> > seems pretty reasonable to disallow/ignore it for just that file system
> > (e.g., by masking off the flag at open time), as others won't have that
> > same problem (cephfs doesn't, for example).
> >
> > Perhaps making each fs opt-in instead of handling it in a generic path
> > would alleviate this concern?
> 
> The issue isn't whether or not you have a network file system, it's
> whether or not you want users to be able to manage data. mtime isn't
> useful for the application (which knows whether or not it has changed
> the file) or for the filesystem (ditto). It exists, rather, in order
> to enable data management by users and other applications, letting
> them know whether or not the data contents of the file have changed,
> and when that change occurred.

Agreed.
 
> If you are able to guarantee that your users don't care about that,
> then fine, but that would be a very special case that doesn't fit the
> way that most data centres are run. Backups are one case where mtime
> matters, tiering and archiving is another.

This is true, although I argue it is becoming increasingly common for the 
data management (including backups and so forth) to be layered not on top 
of the POSIX file system but on something higher up in the stack. This is 
true of pretty much any distributed system (ceph, cassandra, mongo, etc., 
and I assume commercial databases like Oracle, too) where backups, 
replication, and any other DR strategies need to be orchestrated across 
nodes to be consistent--simply copying files out from underneath them is 
already insufficient and a recipe for disaster.

There is a growing category of applications that can benefit from this 
capability...

> Neither of these examples
> cases are under the control of the application that calls
> open(O_NOMTIME).

Wouldn't a mount option (e.g., allow_nomtime) address this concern?  Only 
nodes provisioned explicitly to run these systems would be enable this 
option.

> >> I'm happy for it to be an ioctl interface - even an XFS specific
> >> interface if you want to go that route, Sage - and it probably
> >> should emit a warning to syslog first time it is used so there is
> >> trace for bug triage purposes. i.e. we know the app is not using
> >> mtime updates, so bug reports that are the result of mtime
> >> mishandling don't result in large amounts of wasted developer time
> >> trying to understand them...
> >
> > A warning on using the interface (or when mounting with user_nomtime)
> > sounds reasonable.
> >
> > I'd rather not make this XFS specific as other local filesystmes (ext4,
> > f2fs, possibly btrfs) would similarly benefit.  (And if we want to target
> > XFS specifically the existing XFS open-by-handle ioctl is sufficient as it
> > already does O_NOMTIME unconditionally.)
> 
> Lack of a namespace, doesn't imply that you don't want to manage the
> data. The whole point of using object storage instead of plain old
> block storage is to be able to provide whatever metadata you still
> need in order to manage the object.

Yeah, agreed--this is presumably why open_by_handle(2) (which is what we'd 
like to use) doesn't assume O_NOMTIME.

Thanks!
sage
