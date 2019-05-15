From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Wed, 15 May 2019 12:08:36 -0400
Message-ID: <20190515160834.GA81614@rani.riverdale.lan>
References: <20190512194322.GA71658@rani.riverdale.lan>
 <3fe0e74b-19ca-6081-3afe-e05921b1bfe6@huawei.com>
 <4f522e28-29c8-5930-5d90-e0086b503613@landley.net>
 <f7bc547c-61f4-1a17-735c-7e8df97d7965@huawei.com>
 <CALCETrV3b205L38xqPr6QqwGn6-vxQdPoJGUygJJpgM-JqqXfQ@mail.gmail.com>
 <1557861511.3378.19.camel@HansenPartnership.com>
 <4da3dbda-bb76-5d71-d5c5-c03d98350ab0@landley.net>
 <1557878052.2873.6.camel@HansenPartnership.com>
 <20190515005221.GB88615@rani.riverdale.lan>
 <a138af12-d983-453e-f0b2-661a80b7e837@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a138af12-d983-453e-f0b2-661a80b7e837@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Rob Landley <rob@landley.net>, Andy Lutomirski <luto@kernel.org>, Arvind Sankar <niveditas98@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, initramfs@vger.kernel.org, Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>
List-Id: linux-api@vger.kernel.org

On Wed, May 15, 2019 at 01:19:04PM +0200, Roberto Sassu wrote:
> On 5/15/2019 2:52 AM, Arvind Sankar wrote:
> > You can specify multiple initrd's to the boot loader, and they get
> > loaded in sequence into memory and parsed by the kernel before /init is
> > launched. Currently I believe later ones will overwrite the earlier
> > ones, which is why we've been talking about adding an option to prevent
> > that. You don't have to mess with manually finding/parsing initramfs's
> > which wouldn't even be feasible since you may not have the drivers
> > loaded yet to access the device/filesystem on which they live.
> > 
> > Once that's done, the embedded /init is just going to do in userspace
> > wht the current patch does in the kernel. So all the files in the
> > external initramfs(es) would need to have IMA signatures via the special
> > xattr file.
> 
> So, the scheme you are proposing is not equivalent: using the distro key
> to verify signatures, compared to adding a new user key to verify the
> initramfs he builds. Why would it be necessary for the user to share
> responsibility with the distro, if the only files he uses come from the
> distro?
> 
I don't understand what you mean? The IMA hashes are signed by some key,
but I don't see how what that key is needs to be different between the
two proposals. If the only files used are from the distro, in my scheme
as well you can use the signatures and key provided by the distro. If
they're not, then in your scheme as well you would have to allow for a
local signing key to be used. Both schemes are using the same
.xattr-list file, no?

If the external initramfs is to be signed, and it is built locally, in
both schemes there will have to be a provision for a local signing key,
but this key in any case is verified by the bootloader so there can't
be a difference between the two schemes since they're the same there.

What is the difference you're seeing here?
> 
> > Note that if you want the flexibility to be able to load one or both of
> > two external initramfs's, the current in-kernel proposal wouldn't be
> > enough -- the xattr specification would have to be more flexible (eg
> > reading .xattr-list* to allow each initramfs to specifiy its own
> > xattrs. This sort of enhancement would be much easier to handle with the
> > userspace variant.
> 
> Yes, the alternative solution is to parse .xattr-list at the time it is
> extracted. The .xattr-list of each initramfs will be processed. Also,
> the CPIO parser doesn't have to reopen the file after all other files
> have been extracted.
> 
> Roberto
Right, I guess this would be sort of the minimal "modification" to the
CPIO format to allow it to support xattrs.
> 
> -- 
> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
> Managing Director: Bo PENG, Jian LI, Yanli SHI
