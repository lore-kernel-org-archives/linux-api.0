From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Wed, 13 May 2015 10:57:46 +1000
Message-ID: <20150513005746.GJ15721@dastard>
References: <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com>
 <20150508221325.GM4327@dastard>
 <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net>
 <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com>
 <20150511073103.GO4327@dastard>
 <alpine.DEB.2.00.1505110925150.28239@cobra.newdream.net>
 <CAHQdGtT3rCf-ycAYw-=7HGaemg1+HfY8sw3+kb54VHONxDyP3w@mail.gmail.com>
 <alpine.DEB.2.00.1505111020120.28239@cobra.newdream.net>
 <20150512012133.GR4327@dastard>
 <alpine.DEB.2.00.1505121454000.20395@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1505121454000.20395@cobra.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>, Zach Brown <zab@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API Mailing List <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 12, 2015 at 04:12:46PM -0700, Sage Weil wrote:
> On Tue, 12 May 2015, Dave Chinner wrote:
> > > > > I'd rather not make this XFS specific as other local filesystmes (ext4,
> > > > > f2fs, possibly btrfs) would similarly benefit.  (And if we want to target
> > > > > XFS specifically the existing XFS open-by-handle ioctl is sufficient as it
> > > > > already does O_NOMTIME unconditionally.)
> > > > 
> > > > Lack of a namespace, doesn't imply that you don't want to manage the
> > > > data. The whole point of using object storage instead of plain old
> > > > block storage is to be able to provide whatever metadata you still
> > > > need in order to manage the object.
> > > 
> > > Yeah, agreed--this is presumably why open_by_handle(2) (which is what we'd 
> > > like to use) doesn't assume O_NOMTIME.
> > 
> > Right - the XFS ioctls were designed specifically for applications
> > that interacted directly with the structure of XFS filesystems and
> > so needed invisible IO (e.g. online defragmenter). IOWs, they are
> > not interfaces intended for general usage. They are also only
> > available to root, so a typical user application won't be making use
> > of them, either.
> 
> I understand that's what they're intended for, but I'm having a hard time 
> parsing out the difference between what they *do* and what O_NOMTIME + -o 
> allow_nomtime does.  The open-by-handle ioctls have nothing to do with the 
> online XFS format--they simply allow you to open a file via an opaque 
> handle (albeit a differently formatted one than the generic 
> open_by_handle_at(2)).  They also force you into an O_NOMTIME-equivalent 
> mode.

Actually, the handle is dervied from the information on disk. We
don't do directory lookups to build handles in many cases, we do a
bulkstat to get *on-disk* inode information (inode number, generation,
timestamps, etc) and then use that to build a handle in userspace
*and* validate the file has not changed since the infomration was
retrieved and the handle was built.

> AFAICS the only difference that I see is that
> 
> 1) the ioctl is XFS specific.  (As open_by_handle_at(2) demonstrates, this 
> needn't be the case.)

Of course - it's been in use for 15 years longer than the generic
interface. :)

> 2) the NOMTIME mode is only available via the open-by-handle interface, 
> not open(2).

Right, because of the XFS handle interfaces are intended for
invisible IO which is required by applications interacting directly
with the XFS on-disk data layout.

> 3) it is an ioctl interface, and thus more obscure.  (Well, there is a 
> libhandle library, but it doesn't seem to be widely used.)

The library only exists for xfsdump and the HSMs that interact
directly with the XFS on disk data. These are very constrained
applications.

> Would you object less if 
> 
> 1) the O_NOMTIME flag were only available via open_by_handle_at(2)?

Which limits it to files that have already by created and written to
disk, otherwise there is no handle....

> 2) an equivalent ioctl were implemented for each file system of interest 
> that (say) called into open_by_handle_at(2) code, adding in the O_NOMTIME 
> flag?

Seems like a silly hoop to jump through. I was thinking of a
root-only fcntl() style flag that could be set, but....

> 3) O_NOMTIME required root (vs a mount option that requires root and 
> unpriviledged O_NOMTIME)?
>
> Just trying to tease apart which part is problematic...

... it's very existence ias either a open or fcntl flag is still
problematic. :/

The concept of it being an on-disk attribute flag is less prone to
silent abuse - it's easily discoverable and is persistent. And it's
managable if we make it an "inherit from parent" style flag, because
then ceph can simply set it on the root dir, and every file it then
creates will not do mtime updates.

The other thing that is worth noting here is that we also have a
NODUMP flag on disk (chattr +d). Hence we could define that the
nomtime attribute also implies/sets the nodump attribute, and hence
makes it clear and upfront that turning on the nomtime inode
attribute will mean the files with this set will not get backed up
by mtime sensitive backup programs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
