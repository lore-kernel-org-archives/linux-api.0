From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Mon, 11 May 2015 09:39:53 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1505110925150.28239@cobra.newdream.net>
References: <1430949612-21356-1-git-send-email-zab@redhat.com> <20150507002617.GJ4327@dastard> <20150507172053.GA659@lenny.home.zabbo.net> <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net> <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com>
 <20150508221325.GM4327@dastard> <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net> <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com> <20150511073103.GO4327@dastard>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150511073103.GO4327@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>, Zach Brown <zab@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API Mailing List <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, 11 May 2015, Dave Chinner wrote:
> On Sun, May 10, 2015 at 07:13:24PM -0400, Trond Myklebust wrote:
> > On Fri, May 8, 2015 at 6:24 PM, Sage Weil <sage@newdream.net> wrote:
> > > I'm sure you realize what we're try to achieve is the same "invisible IO"
> > > that the XFS open by handle ioctls do by default.  Would you be more
> > > comfortable if this option where only available to the generic
> > > open_by_handle syscall, and not to open(2)?
> > 
> > It should be an ioctl(). It has no business being part of
> > open_by_handle either, since that is another generic interface.

Our use-case doesn't make sense on network file systems, but it does on 
any reasonably featureful local filesystem, and the goal is to be generic 
there.  If mtime is critical to a network file system's consistency it 
seems pretty reasonable to disallow/ignore it for just that file system 
(e.g., by masking off the flag at open time), as others won't have that 
same problem (cephfs doesn't, for example).

Perhaps making each fs opt-in instead of handling it in a generic path 
would alleviate this concern?

> I'm happy for it to be an ioctl interface - even an XFS specific
> interface if you want to go that route, Sage - and it probably
> should emit a warning to syslog first time it is used so there is
> trace for bug triage purposes. i.e. we know the app is not using
> mtime updates, so bug reports that are the result of mtime
> mishandling don't result in large amounts of wasted developer time
> trying to understand them...

A warning on using the interface (or when mounting with user_nomtime) 
sounds reasonable.

I'd rather not make this XFS specific as other local filesystmes (ext4, 
f2fs, possibly btrfs) would similarly benefit.  (And if we want to target 
XFS specifically the existing XFS open-by-handle ioctl is sufficient as it 
already does O_NOMTIME unconditionally.)

sage
