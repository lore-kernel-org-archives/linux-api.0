From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Tue, 14 May 2019 20:52:21 -0400
Message-ID: <20190515005221.GB88615@rani.riverdale.lan>
References: <dca50ee1-62d8-2256-6fdb-9a786e6cea5a@landley.net>
 <20190512194322.GA71658@rani.riverdale.lan>
 <3fe0e74b-19ca-6081-3afe-e05921b1bfe6@huawei.com>
 <4f522e28-29c8-5930-5d90-e0086b503613@landley.net>
 <f7bc547c-61f4-1a17-735c-7e8df97d7965@huawei.com>
 <CALCETrV3b205L38xqPr6QqwGn6-vxQdPoJGUygJJpgM-JqqXfQ@mail.gmail.com>
 <1557861511.3378.19.camel@HansenPartnership.com>
 <4da3dbda-bb76-5d71-d5c5-c03d98350ab0@landley.net>
 <1557878052.2873.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1557878052.2873.6.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Rob Landley <rob@landley.net>, Andy Lutomirski <luto@kernel.org>, Arvind Sankar <niveditas98@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, initramfs@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 14, 2019 at 04:54:12PM -0700, James Bottomley wrote:
> On Tue, 2019-05-14 at 18:39 -0500, Rob Landley wrote:
> > On 5/14/19 2:18 PM, James Bottomley wrote:
> > > > I think Rob is right here.  If /init was statically built into
> > > > the kernel image, it has no more ability to compromise the kernel
> > > > than anything else in the kernel.  What's the problem here?
> > > 
> > > The specific problem is that unless you own the kernel signing key,
> > > which is really untrue for most distribution consumers because the
> > > distro owns the key, you cannot build the initrd statically into
> > > the kernel.  You can take the distro signed kernel, link it with
> > > the initrd then resign the combination with your key, provided you
> > > insert your key into the MoK variables as a trusted secure boot
> > > key, but the distros have been unhappy recommending this as
> > > standard practice.
> > > 
> > > If our model for security is going to be to link the kernel and the
> > > initrd statically to give signature protection over the aggregate
> > > then we need to figure out how to execute this via the distros.  If
> > > we accept that the split model, where the distro owns and signs the
> > > kernel but the machine owner builds and is responsible for the
> > > initrd, then we need to explore split security models like this
> > > proposal.
> > 
> > You can have a built-in and an external initrd? The second extracts
> > over the first? (I know because once upon a time conflicting files
> > would append. It sounds like the desired behavior here is O_EXCL fail
> > and move on.)
> 
> Technically yes, because the first initrd could find the second by some
> predefined means, extract it to a temporary directory and do a
> pivot_root() and then the second would do some stuff, find the real
> root and do a pivot_root() again.  However, while possible, wouldn't it
> just add to the rendezvous complexity without adding any benefits? even
> if the first initrd is built and signed by the distro and the second is
> built by you, the first has to verify the second somehow.  I suppose
> the second could be tar extracted, which would add xattrs, if that's
> the goal?
> 
> James
> 
You can specify multiple initrd's to the boot loader, and they get
loaded in sequence into memory and parsed by the kernel before /init is
launched. Currently I believe later ones will overwrite the earlier
ones, which is why we've been talking about adding an option to prevent
that. You don't have to mess with manually finding/parsing initramfs's
which wouldn't even be feasible since you may not have the drivers
loaded yet to access the device/filesystem on which they live.

Once that's done, the embedded /init is just going to do in userspace
wht the current patch does in the kernel. So all the files in the
external initramfs(es) would need to have IMA signatures via the special
xattr file.

Note that if you want the flexibility to be able to load one or both of
two external initramfs's, the current in-kernel proposal wouldn't be
enough -- the xattr specification would have to be more flexible (eg
reading .xattr-list* to allow each initramfs to specifiy its own
xattrs. This sort of enhancement would be much easier to handle with the
userspace variant.
