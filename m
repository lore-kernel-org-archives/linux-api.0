From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v3 2/2] initramfs: introduce do_readxattrs()
Date: Wed, 22 May 2019 14:26:43 -0500
Message-ID: <3839583c-5466-6573-3048-0da7e6778c88@landley.net>
References: <20190517165519.11507-1-roberto.sassu@huawei.com>
 <20190517165519.11507-3-roberto.sassu@huawei.com>
 <CD9A4F89-7CA5-4329-A06A-F8DEB87905A5@zytor.com>
 <20190517210219.GA5998@rani.riverdale.lan>
 <d48f35a1-aab1-2f20-2e91-5e81a84b107f@zytor.com>
 <20190517221731.GA11358@rani.riverdale.lan>
 <7bdca169-7a01-8c55-40e4-a832e876a0e5@huawei.com>
 <9C5B9F98-2067-43D3-B149-57613F38DCD4@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9C5B9F98-2067-43D3-B149-57613F38DCD4@zytor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: hpa@zytor.com, Roberto Sassu <roberto.sassu@huawei.com>, Arvind Sankar <nivedita@alum.mit.edu>
Cc: viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, arnd@arndb.de, james.w.mcmechan@gmail.com, niveditas98@gmail.com
List-Id: linux-api@vger.kernel.org



On 5/22/19 11:17 AM, hpa@zytor.com wrote:
> On May 20, 2019 2:39:46 AM PDT, Roberto Sassu <roberto.sassu@huawei.com> wrote:
>> On 5/18/2019 12:17 AM, Arvind Sankar wrote:
>>> On Fri, May 17, 2019 at 02:47:31PM -0700, H. Peter Anvin wrote:
>>>> On 5/17/19 2:02 PM, Arvind Sankar wrote:
>>>>> On Fri, May 17, 2019 at 01:18:11PM -0700, hpa@zytor.com wrote:
>>>>>>
>>>>>> Ok... I just realized this does not work for a modular initramfs,
>> composed at load time from multiple files, which is a very real
>> problem. Should be easy enough to deal with: instead of one large file,
>> use one companion file per source file, perhaps something like
>> filename..xattrs (suggesting double dots to make it less likely to
>> conflict with a "real" file.) No leading dot, as it makes it more
>> likely that archivers will sort them before the file proper.
>>>>> This version of the patch was changed from the previous one exactly
>> to deal with this case --
>>>>> it allows for the bootloader to load multiple initramfs archives,
>> each
>>>>> with its own .xattr-list file, and to have that work properly.
>>>>> Could you elaborate on the issue that you see?
>>>>>
>>>>
>>>> Well, for one thing, how do you define "cpio archive", each with its
>> own
>>>> .xattr-list file? Second, that would seem to depend on the ordering,
>> no,
>>>> in which case you depend critically on .xattr-list file following
>> the
>>>> files, which most archivers won't do.
>>>>
>>>> Either way it seems cleaner to have this per file; especially if/as
>> it
>>>> can be done without actually mucking up the format.
>>>>
>>>> I need to run, but I'll post a more detailed explanation of what I
>> did
>>>> in a little bit.
>>>>
>>>> 	-hpa
>>>>
>>> Not sure what you mean by how do I define it? Each cpio archive will
>>> contain its own .xattr-list file with signatures for the files within
>>> it, that was the idea.
>>>
>>> You need to review the code more closely I think -- it does not
>> depend
>>> on the .xattr-list file following the files to which it applies.
>>>
>>> The code first extracts .xattr-list as though it was a regular file.
>> If
>>> a later dupe shows up (presumably from a second archive, although the
>>> patch will actually allow a second one in the same archive), it will
>>> then process the existing .xattr-list file and apply the attributes
>>> listed within it. It then will proceed to read the second one and
>>> overwrite the first one with it (this is the normal behaviour in the
>>> kernel cpio parser). At the end once all the archives have been
>>> extracted, if there is an .xattr-list file in the rootfs it will be
>>> parsed (it would've been the last one encountered, which hasn't been
>>> parsed yet, just extracted).
>>>
>>> Regarding the idea to use the high 16 bits of the mode field in
>>> the header that's another possibility. It would just require
>> additional
>>> support in the program that actually creates the archive though,
>> which
>>> the current patch doesn't.
>>
>> Yes, for adding signatures for a subset of files, no changes to the ram
>> disk generator are necessary. Everything is done by a custom module. To
>> support a generic use case, it would be necessary to modify the
>> generator to execute getfattr and the awk script after files have been
>> placed in the temporary directory.
>>
>> If I understood the new proposal correctly, it would be task for cpio
>> to
>> read file metadata after the content and create a new record for each
>> file with mode 0x18000, type of metadata encoded in the file name and
>> metadata as file content. I don't know how easy it would be to modify
>> cpio. Probably the amount of changes would be reasonable.

I could make toybox cpio do it in a weekend, and could probably throw a patch at
usr/gen_init_cpio.c while I'm at it. I prototyped something like that a couple
years ago, it's not hard.

The real question is scripts/gen_initramfs_list.sh and the text format it
produces. We can currently generate cpio files with different ownership and
permissions than the host system can represent (when not building as root, on a
filesystem that may not support xattrs or would get unhappy about conflicting
selinux annotations). We work around it by having the metadata represented
textually in the initramfs_list file gen_initramfs_list.sh produces and
gen_init_cpio.c consumes.

xattrs are a terrible idea the Macintosh invented so Finder could remember where
you moved a file's icon in its folder without having to modify the file, and
then things like OS/2 copied it and Windows picked it up from there and went "Of
course, this is a security mechanism!" and... sigh.

This is "data that is not data", it's metadata of unbounded size. It seems like
it should go in gen_initramfs_list.sh but as what, keyword=value pairs that
might have embedded newlines in them? A base64 encoding? Something else?

>> The kernel will behave in a similar way. It will call do_readxattrs()
>> in
>> do_copy() for each file. Since the only difference between the current
>> and the new proposal would be two additional calls to do_readxattrs()
>> in
>> do_name() and unpack_to_rootfs(), maybe we could support both.
>>
>> Roberto
> 
> The nice thing with explicit metadata is that it doesn't have to contain the filename per se, and each file is self-contained. There is a reason why each cpio header starts with the magic number: each cpio record is formally independent and can be processed in isolation.  The TRAILER!!! thing is a huge wart in the format, although in practice TRAILER!!! always has a mode of 0 and so can be distinguished from an actual file.

Not adding the requirement that the cpio.gz must be generated as root from a
filesystem with the same users and selinux rules as the target system would be nice.

> The use of mode 0x18000 for metadata allows for optional backwards compatibility for extraction; for encoding this can be handled with very simple postprocessing.

The representation within the cpio file was never a huge deal to me. 0x18000
sounds fine for that.

> So my suggestion would be to have mode 0x18000 indicate extended file metadata, with the filename of the form:
> 
> optional_filename!XXXXX!
> 
> ... where XXXXX indicates the type of metadata (e.g. !XATTR!). The optional_filename prefix allows an unaware decoder to extract to a well-defined name; simple postprocessing would be able to either remove (for size) or add (for compatibility) this prefix. It would be an error for this prefix, if present, to not match the name of the previous file.

I'd suggest METADATA!!! to look like TRAILER!!!. (METADATA!!!XXXXX! if you
really think a keyword=value pair store is _not_ universal and we're going to
invent entire new _categories_ of this side channel nonsense.)

And extracting conflicting filenames is presumably already covered, it either
replaces or the new one fails to create the file and the extractor moves on.
(You need a working error recovery path that skips the right amount of data so
you can handle the next file properly, but you should have that anyway.)

Rob
