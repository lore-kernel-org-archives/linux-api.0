From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v3 2/2] initramfs: introduce do_readxattrs()
Date: Fri, 17 May 2019 18:17:32 -0400
Message-ID: <20190517221731.GA11358@rani.riverdale.lan>
References: <20190517165519.11507-1-roberto.sassu@huawei.com>
 <20190517165519.11507-3-roberto.sassu@huawei.com>
 <CD9A4F89-7CA5-4329-A06A-F8DEB87905A5@zytor.com>
 <20190517210219.GA5998@rani.riverdale.lan>
 <d48f35a1-aab1-2f20-2e91-5e81a84b107f@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d48f35a1-aab1-2f20-2e91-5e81a84b107f@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>, Roberto Sassu <roberto.sassu@huawei.com>, viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, arnd@arndb.de, rob@landley.net, james.w.mcmechan@gmail.com, niveditas98@gmail.com
List-Id: linux-api@vger.kernel.org

On Fri, May 17, 2019 at 02:47:31PM -0700, H. Peter Anvin wrote:
> On 5/17/19 2:02 PM, Arvind Sankar wrote:
> > On Fri, May 17, 2019 at 01:18:11PM -0700, hpa@zytor.com wrote:
> >>
> >> Ok... I just realized this does not work for a modular initramfs, composed at load time from multiple files, which is a very real problem. Should be easy enough to deal with: instead of one large file, use one companion file per source file, perhaps something like filename..xattrs (suggesting double dots to make it less likely to conflict with a "real" file.) No leading dot, as it makes it more likely that archivers will sort them before the file proper.
> > This version of the patch was changed from the previous one exactly to deal with this case --
> > it allows for the bootloader to load multiple initramfs archives, each
> > with its own .xattr-list file, and to have that work properly.
> > Could you elaborate on the issue that you see?
> > 
> 
> Well, for one thing, how do you define "cpio archive", each with its own
> .xattr-list file? Second, that would seem to depend on the ordering, no,
> in which case you depend critically on .xattr-list file following the
> files, which most archivers won't do.
> 
> Either way it seems cleaner to have this per file; especially if/as it
> can be done without actually mucking up the format.
> 
> I need to run, but I'll post a more detailed explanation of what I did
> in a little bit.
> 
> 	-hpa
> 
Not sure what you mean by how do I define it? Each cpio archive will
contain its own .xattr-list file with signatures for the files within
it, that was the idea.

You need to review the code more closely I think -- it does not depend
on the .xattr-list file following the files to which it applies.

The code first extracts .xattr-list as though it was a regular file. If
a later dupe shows up (presumably from a second archive, although the
patch will actually allow a second one in the same archive), it will
then process the existing .xattr-list file and apply the attributes
listed within it. It then will proceed to read the second one and
overwrite the first one with it (this is the normal behaviour in the
kernel cpio parser). At the end once all the archives have been
extracted, if there is an .xattr-list file in the rootfs it will be
parsed (it would've been the last one encountered, which hasn't been
parsed yet, just extracted).

Regarding the idea to use the high 16 bits of the mode field in
the header that's another possibility. It would just require additional
support in the program that actually creates the archive though, which
the current patch doesn't.
