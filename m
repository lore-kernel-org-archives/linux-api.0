From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Mon, 13 May 2019 04:07:08 -0500
Message-ID: <4f522e28-29c8-5930-5d90-e0086b503613@landley.net>
References: <dca50ee1-62d8-2256-6fdb-9a786e6cea5a@landley.net>
 <20190512194322.GA71658@rani.riverdale.lan>
 <3fe0e74b-19ca-6081-3afe-e05921b1bfe6@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3fe0e74b-19ca-6081-3afe-e05921b1bfe6@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>, Arvind Sankar <niveditas98@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org
List-Id: linux-api@vger.kernel.org



On 5/13/19 2:49 AM, Roberto Sassu wrote:
> On 5/12/2019 9:43 PM, Arvind Sankar wrote:
>> On Sun, May 12, 2019 at 05:05:48PM +0000, Rob Landley wrote:
>>> On 5/12/19 7:52 AM, Mimi Zohar wrote:
>>>> On Sun, 2019-05-12 at 11:17 +0200, Dominik Brodowski wrote:
>>>>> On Thu, May 09, 2019 at 01:24:17PM +0200, Roberto Sassu wrote:
>>>>>> This proposal consists in marshaling pathnames and xattrs in a file called
>>>>>> .xattr-list. They are unmarshaled by the CPIO parser after all files have
>>>>>> been extracted.
>>>>>
>>>>> Couldn't this parsing of the .xattr-list file and the setting of the xattrs
>>>>> be done equivalently by the initramfs' /init? Why is kernel involvement
>>>>> actually required here?
>>>>
>>>> It's too late.  The /init itself should be signed and verified.
>>>
>>> If the initramfs cpio.gz image was signed and verified by the extractor, how is
>>> the init in it _not_ verified?
>>>
>>> Ro
>>
>> Wouldn't the below work even before enforcing signatures on external
>> initramfs:
>> 1. Create an embedded initramfs with an /init that does the xattr
>> parsing/setting. This will be verified as part of the kernel image
>> signature, so no new code required.
>> 2. Add a config option/boot parameter to panic the kernel if an external
>> initramfs attempts to overwrite anything in the embedded initramfs. This
>> prevents overwriting the embedded /init even if the external initramfs
>> is unverified.
> 
> Unfortunately, it wouldn't work. IMA is already initialized and it would
> verify /init in the embedded initial ram disk.

So you made broken infrastructure that's causing you problems. Sounds unfortunate.

> The only reason why
> opening .xattr-list works is that IMA is not yet initialized
> (late_initcall vs rootfs_initcall).

Launching init before enabling ima is bad because... you didn't think of it?

> Allowing a kernel with integrity enforcement to parse the CPIO image
> without verifying it first is the weak point.

If you don't verify the CPIO image then in theory it could have anything in it,
yes. You seem to believe that signing individual files is more secure than
signing the archive. This is certainly a point of view.

> However, extracted files
> are not used, and before they are used they are verified. At the time
> they are verified, they (included /init) must already have a signature
> or otherwise access would be denied.

You build infrastructure that works a certain way, the rest of the system
doesn't fit your assumptions, so you need to change the rest of the system to
fit your assumptions.

> This scheme relies on the ability of the kernel to not be corrupted in
> the event it parses a malformed CPIO image.

I'm unaware of any buffer overruns or wild pointer traversals in the cpio
extraction code. You can fill up all physical memory with initramfs and lock the
system hard, though.

It still only parses them at boot time before launching PID 1, right? So you
have a local physical exploit and you're trying to prevent people from working
around your Xbox copy protection without a mod chip?

> Mimi suggested to use
> digital signatures to prevent this issue, but it cannot be used in all
> scenarios, since conventional systems generate the initial ram disk
> locally.

So you use a proprietary init binary you can't rebuild from source, and put it
in a cpio where /dev/urandom is a file with known contents? Clearly, not
exploitable at all. (And we update the initramfs.cpio but not the kernel because
clearly keeping the kernel up to date is less important to security...)

Whatever happened to https://lwn.net/Articles/532778/ ? Modules are signed
in-band in the file, but you need xattrs for some reason?

> Roberto

Rob
