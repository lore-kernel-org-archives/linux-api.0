From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Thu, 16 May 2019 01:29:35 -0400
Message-ID: <20190516052934.GA68777@rani.riverdale.lan>
References: <4f522e28-29c8-5930-5d90-e0086b503613@landley.net>
 <f7bc547c-61f4-1a17-735c-7e8df97d7965@huawei.com>
 <CALCETrV3b205L38xqPr6QqwGn6-vxQdPoJGUygJJpgM-JqqXfQ@mail.gmail.com>
 <1557861511.3378.19.camel@HansenPartnership.com>
 <4da3dbda-bb76-5d71-d5c5-c03d98350ab0@landley.net>
 <1557878052.2873.6.camel@HansenPartnership.com>
 <20190515005221.GB88615@rani.riverdale.lan>
 <a138af12-d983-453e-f0b2-661a80b7e837@huawei.com>
 <20190515160834.GA81614@rani.riverdale.lan>
 <ce65240a-4df6-8ebc-8360-c01451e724f0@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ce65240a-4df6-8ebc-8360-c01451e724f0@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Rob Landley <rob@landley.net>, Andy Lutomirski <luto@kernel.org>, Arvind Sankar <niveditas98@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, initramfs@vger.kernel.org, Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>
List-Id: linux-api@vger.kernel.org

On Wed, May 15, 2019 at 07:06:52PM +0200, Roberto Sassu wrote:
> On 5/15/2019 6:08 PM, Arvind Sankar wrote:
> > On Wed, May 15, 2019 at 01:19:04PM +0200, Roberto Sassu wrote:
> >> On 5/15/2019 2:52 AM, Arvind Sankar wrote:
> > I don't understand what you mean? The IMA hashes are signed by some key,
> > but I don't see how what that key is needs to be different between the
> > two proposals. If the only files used are from the distro, in my scheme
> > as well you can use the signatures and key provided by the distro. If
> > they're not, then in your scheme as well you would have to allow for a
> > local signing key to be used. Both schemes are using the same
> > .xattr-list file, no?
> 
> I was referring to James's proposal to load an external initramfs from
> the embedded initramfs. If the embedded initramfs opens the external
> initramfs when IMA is enabled, the external initramfs needs to be
> signed with a local signing key. But I read your answer that this
> wouldn't be feasible. You have to specify all initramfs in the boot
> loader configuration.
> 
> I think deferring IMA initialization is not the safest approach, as it
> cannot be guaranteed for all possible scenarios that there won't be any
> file read before /init is executed.
> 
> But if IMA is enabled, there is the problem of who signs .xattr-list.
> There should be a local signing key that it is not necessary if the user
> only accesses distro files.
> 
I think that's a separate issue. If you want to allow people to be able
to put files onto the system that will be IMA verified, they need to
have some way to locally sign them whether it's inside an initramfs or
on a real root filesystem.
> 
> > Right, I guess this would be sort of the minimal "modification" to the
> > CPIO format to allow it to support xattrs.
> 
> I would try to do it without modification of the CPIO format. However,
> at the time .xattr-list is parsed (in do_copy() before .xattr-list is
> closed), it is not guaranteed that all files are extracted. These must
> be created before xattrs are added, but the file type must be correct,
> otherwise clean_path() removes the existing file with xattrs.
> 
> Roberto
> 
> -- 
> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
> Managing Director: Bo PENG, Jian LI, Yanli SHI

Right by "modification" in quotes I meant the format is actually the
same, but the kernel now interprets it a bit differently.

Regarding the order you don't have to handle that in the kernel. The
kernel CPIO format is already restricted in that directories have to be
specified before the files that contain them for example. It can very
well be restricted so that an .xattr-list can only specify xattrs for
files that were already extracted, else you bail out with an error. The
archive creation tooling can easily handle that. If someone wants to
shoot themselves in the foot by trying to add more files/replace
existing files after the .xattr-list its ok, the IMA policy will prevent
such files from being accessed and they can fix the archive for the next
boot.
