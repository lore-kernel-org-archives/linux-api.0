From: Taras Kondratiuk <takondra@cisco.com>
Subject: Re: [PATCH v3 2/2] initramfs: introduce do_readxattrs()
Date: Wed, 22 May 2019 13:21:00 -0700
Message-ID: <155855646075.4574.2642646033980450856@takondra-t460s>
References: <20190517165519.11507-1-roberto.sassu@huawei.com>
 <20190517165519.11507-3-roberto.sassu@huawei.com>
 <CD9A4F89-7CA5-4329-A06A-F8DEB87905A5@zytor.com>
 <20190517210219.GA5998@rani.riverdale.lan>
 <d48f35a1-aab1-2f20-2e91-5e81a84b107f@zytor.com>
 <20190517221731.GA11358@rani.riverdale.lan>
 <7bdca169-7a01-8c55-40e4-a832e876a0e5@huawei.com>
 <9C5B9F98-2067-43D3-B149-57613F38DCD4@zytor.com>
 <3839583c-5466-6573-3048-0da7e6778c88@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3839583c-5466-6573-3048-0da7e6778c88@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Sankar <nivedita@alum.mit.edu>, Rob Landley <rob@landley.net>, Roberto Sassu <roberto.sassu@huawei.com>, hpa@zytor.com
Cc: viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, kamensky@cisco.com, arnd@arndb.de, james.w.mcmechan@gmail.com, niveditas98@gmail.com
List-Id: linux-api@vger.kernel.org

Quoting Rob Landley (2019-05-22 12:26:43)
> =

> =

> On 5/22/19 11:17 AM, hpa@zytor.com wrote:
> > On May 20, 2019 2:39:46 AM PDT, Roberto Sassu <roberto.sassu@huawei.com=
> wrote:
> >> On 5/18/2019 12:17 AM, Arvind Sankar wrote:
> >>> On Fri, May 17, 2019 at 02:47:31PM -0700, H. Peter Anvin wrote:
> >>>> On 5/17/19 2:02 PM, Arvind Sankar wrote:
> >>>>> On Fri, May 17, 2019 at 01:18:11PM -0700, hpa@zytor.com wrote:
> >>>>>>
> >>>>>> Ok... I just realized this does not work for a modular initramfs,
> >> composed at load time from multiple files, which is a very real
> >> problem. Should be easy enough to deal with: instead of one large file,
> >> use one companion file per source file, perhaps something like
> >> filename..xattrs (suggesting double dots to make it less likely to
> >> conflict with a "real" file.) No leading dot, as it makes it more
> >> likely that archivers will sort them before the file proper.
> >>>>> This version of the patch was changed from the previous one exactly
> >> to deal with this case --
> >>>>> it allows for the bootloader to load multiple initramfs archives,
> >> each
> >>>>> with its own .xattr-list file, and to have that work properly.
> >>>>> Could you elaborate on the issue that you see?
> >>>>>
> >>>>
> >>>> Well, for one thing, how do you define "cpio archive", each with its
> >> own
> >>>> .xattr-list file? Second, that would seem to depend on the ordering,
> >> no,
> >>>> in which case you depend critically on .xattr-list file following
> >> the
> >>>> files, which most archivers won't do.
> >>>>
> >>>> Either way it seems cleaner to have this per file; especially if/as
> >> it
> >>>> can be done without actually mucking up the format.
> >>>>
> >>>> I need to run, but I'll post a more detailed explanation of what I
> >> did
> >>>> in a little bit.
> >>>>
> >>>>    -hpa
> >>>>
> >>> Not sure what you mean by how do I define it? Each cpio archive will
> >>> contain its own .xattr-list file with signatures for the files within
> >>> it, that was the idea.
> >>>
> >>> You need to review the code more closely I think -- it does not
> >> depend
> >>> on the .xattr-list file following the files to which it applies.
> >>>
> >>> The code first extracts .xattr-list as though it was a regular file.
> >> If
> >>> a later dupe shows up (presumably from a second archive, although the
> >>> patch will actually allow a second one in the same archive), it will
> >>> then process the existing .xattr-list file and apply the attributes
> >>> listed within it. It then will proceed to read the second one and
> >>> overwrite the first one with it (this is the normal behaviour in the
> >>> kernel cpio parser). At the end once all the archives have been
> >>> extracted, if there is an .xattr-list file in the rootfs it will be
> >>> parsed (it would've been the last one encountered, which hasn't been
> >>> parsed yet, just extracted).
> >>>
> >>> Regarding the idea to use the high 16 bits of the mode field in
> >>> the header that's another possibility. It would just require
> >> additional
> >>> support in the program that actually creates the archive though,
> >> which
> >>> the current patch doesn't.
> >>
> >> Yes, for adding signatures for a subset of files, no changes to the ram
> >> disk generator are necessary. Everything is done by a custom module. To
> >> support a generic use case, it would be necessary to modify the
> >> generator to execute getfattr and the awk script after files have been
> >> placed in the temporary directory.
> >>
> >> If I understood the new proposal correctly, it would be task for cpio
> >> to
> >> read file metadata after the content and create a new record for each
> >> file with mode 0x18000, type of metadata encoded in the file name and
> >> metadata as file content. I don't know how easy it would be to modify
> >> cpio. Probably the amount of changes would be reasonable.
> =

> I could make toybox cpio do it in a weekend, and could probably throw a p=
atch at
> usr/gen_init_cpio.c while I'm at it. I prototyped something like that a c=
ouple
> years ago, it's not hard.
> =

> The real question is scripts/gen_initramfs_list.sh and the text format it
> produces. We can currently generate cpio files with different ownership a=
nd
> permissions than the host system can represent (when not building as root=
, on a
> filesystem that may not support xattrs or would get unhappy about conflic=
ting
> selinux annotations). We work around it by having the metadata represented
> textually in the initramfs_list file gen_initramfs_list.sh produces and
> gen_init_cpio.c consumes.
> =

> xattrs are a terrible idea the Macintosh invented so Finder could remembe=
r where
> you moved a file's icon in its folder without having to modify the file, =
and
> then things like OS/2 copied it and Windows picked it up from there and w=
ent "Of
> course, this is a security mechanism!" and... sigh.
> =

> This is "data that is not data", it's metadata of unbounded size. It seem=
s like
> it should go in gen_initramfs_list.sh but as what, keyword=3Dvalue pairs =
that
> might have embedded newlines in them? A base64 encoding? Something else?

I the previous try to add xattrs to cpio I've used hex encoding in
gen_initramfs_list.sh:
https://lkml.org/lkml/2018/1/24/851 - gen_init_cpio: set extended attribute=
s for newcx format
https://lkml.org/lkml/2018/1/24/852 - gen_initramfs_list.sh: add -x option =
to enable newcx format
