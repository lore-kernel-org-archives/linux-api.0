From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Tue, 12 May 2015 16:12:46 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1505121454000.20395@cobra.newdream.net>
References: <20150507172053.GA659@lenny.home.zabbo.net> <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net> <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com> <20150508221325.GM4327@dastard> <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net>
 <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com> <20150511073103.GO4327@dastard> <alpine.DEB.2.00.1505110925150.28239@cobra.newdream.net> <CAHQdGtT3rCf-ycAYw-=7HGaemg1+HfY8sw3+kb54VHONxDyP3w@mail.gmail.com> <alpine.DEB.2.00.1505111020120.28239@cobra.newdream.net>
 <20150512012133.GR4327@dastard>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150512012133.GR4327@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>, Zach Brown <zab@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API Mailing List <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 12 May 2015, Dave Chinner wrote:
> > > Neither of these examples cases are under the control of the 
> > > application that calls open(O_NOMTIME).
> > 
> > Wouldn't a mount option (e.g., allow_nomtime) address this concern?  Only 
> > nodes provisioned explicitly to run these systems would be enable this 
> > option.
> 
> Back to my Joe Speedracer comments.....
> 
> I'm not sure what the right answer is - mount options are simply too
> easy to add without understanding the full implications of them.
> e.g. we didn't merge FALLOC_FL_NO_HIDE_STALE simply because it was
> too dangerous for unsuspecting users. This isn't at that same level
> or concern, but it's still a landmine we want to avoid users from
> arming without realising it...
> 
> > > >> I'm happy for it to be an ioctl interface - even an XFS specific
> > > >> interface if you want to go that route, Sage - and it probably
> > > >> should emit a warning to syslog first time it is used so there is
> > > >> trace for bug triage purposes. i.e. we know the app is not using
> > > >> mtime updates, so bug reports that are the result of mtime
> > > >> mishandling don't result in large amounts of wasted developer time
> > > >> trying to understand them...
> > > >
> > > > A warning on using the interface (or when mounting with user_nomtime)
> > > > sounds reasonable.
> > > >
> > > > I'd rather not make this XFS specific as other local filesystmes (ext4,
> > > > f2fs, possibly btrfs) would similarly benefit.  (And if we want to target
> > > > XFS specifically the existing XFS open-by-handle ioctl is sufficient as it
> > > > already does O_NOMTIME unconditionally.)
> > > 
> > > Lack of a namespace, doesn't imply that you don't want to manage the
> > > data. The whole point of using object storage instead of plain old
> > > block storage is to be able to provide whatever metadata you still
> > > need in order to manage the object.
> > 
> > Yeah, agreed--this is presumably why open_by_handle(2) (which is what we'd 
> > like to use) doesn't assume O_NOMTIME.
> 
> Right - the XFS ioctls were designed specifically for applications
> that interacted directly with the structure of XFS filesystems and
> so needed invisible IO (e.g. online defragmenter). IOWs, they are
> not interfaces intended for general usage. They are also only
> available to root, so a typical user application won't be making use
> of them, either.

I understand that's what they're intended for, but I'm having a hard time 
parsing out the difference between what they *do* and what O_NOMTIME + -o 
allow_nomtime does.  The open-by-handle ioctls have nothing to do with the 
online XFS format--they simply allow you to open a file via an opaque 
handle (albeit a differently formatted one than the generic 
open_by_handle_at(2)).  They also force you into an O_NOMTIME-equivalent 
mode.

AFAICS the only difference that I see is that

1) the ioctl is XFS specific.  (As open_by_handle_at(2) demonstrates, this 
needn't be the case.)

2) the NOMTIME mode is only available via the open-by-handle interface, 
not open(2).

3) it is an ioctl interface, and thus more obscure.  (Well, there is a 
libhandle library, but it doesn't seem to be widely used.)

Would you object less if 

1) the O_NOMTIME flag were only available via open_by_handle_at(2)?

2) an equivalent ioctl were implemented for each file system of interest 
that (say) called into open_by_handle_at(2) code, adding in the O_NOMTIME 
flag?

3) O_NOMTIME required root (vs a mount option that requires root and 
unpriviledged O_NOMTIME)?

Just trying to tease apart which part is problematic...

Thanks!
sage
