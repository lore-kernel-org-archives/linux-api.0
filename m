From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Tue, 14 May 2019 08:19:52 -0700
Message-ID: <CALCETrV3b205L38xqPr6QqwGn6-vxQdPoJGUygJJpgM-JqqXfQ@mail.gmail.com>
References: <dca50ee1-62d8-2256-6fdb-9a786e6cea5a@landley.net>
 <20190512194322.GA71658@rani.riverdale.lan> <3fe0e74b-19ca-6081-3afe-e05921b1bfe6@huawei.com>
 <4f522e28-29c8-5930-5d90-e0086b503613@landley.net> <f7bc547c-61f4-1a17-735c-7e8df97d7965@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f7bc547c-61f4-1a17-735c-7e8df97d7965@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Rob Landley <rob@landley.net>, Arvind Sankar <niveditas98@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, initramfs@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, May 13, 2019 at 5:47 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> On 5/13/2019 11:07 AM, Rob Landley wrote:
> >
> >
> > On 5/13/19 2:49 AM, Roberto Sassu wrote:
> >> On 5/12/2019 9:43 PM, Arvind Sankar wrote:
> >>> On Sun, May 12, 2019 at 05:05:48PM +0000, Rob Landley wrote:
> >>>> On 5/12/19 7:52 AM, Mimi Zohar wrote:
> >>>>> On Sun, 2019-05-12 at 11:17 +0200, Dominik Brodowski wrote:
> >>>>>> On Thu, May 09, 2019 at 01:24:17PM +0200, Roberto Sassu wrote:
> >>>>>>> This proposal consists in marshaling pathnames and xattrs in a file called
> >>>>>>> .xattr-list. They are unmarshaled by the CPIO parser after all files have
> >>>>>>> been extracted.
> >>>>>>
> >>>>>> Couldn't this parsing of the .xattr-list file and the setting of the xattrs
> >>>>>> be done equivalently by the initramfs' /init? Why is kernel involvement
> >>>>>> actually required here?
> >>>>>
> >>>>> It's too late.  The /init itself should be signed and verified.
> >>>>
> >>>> If the initramfs cpio.gz image was signed and verified by the extractor, how is
> >>>> the init in it _not_ verified?
> >>>>
> >>>> Ro
> >>>
> >>> Wouldn't the below work even before enforcing signatures on external
> >>> initramfs:
> >>> 1. Create an embedded initramfs with an /init that does the xattr
> >>> parsing/setting. This will be verified as part of the kernel image
> >>> signature, so no new code required.
> >>> 2. Add a config option/boot parameter to panic the kernel if an external
> >>> initramfs attempts to overwrite anything in the embedded initramfs. This
> >>> prevents overwriting the embedded /init even if the external initramfs
> >>> is unverified.
> >>
> >> Unfortunately, it wouldn't work. IMA is already initialized and it would
> >> verify /init in the embedded initial ram disk.
> >
> > So you made broken infrastructure that's causing you problems. Sounds unfortunate.
>
> The idea is to be able to verify anything that is accessed, as soon as
> rootfs is available, without distinction between embedded or external
> initial ram disk.
>
> Also, requiring an embedded initramfs for xattrs would be an issue for
> systems that use it for other purposes.
>
>
> >> The only reason why
> >> opening .xattr-list works is that IMA is not yet initialized
> >> (late_initcall vs rootfs_initcall).
> >
> > Launching init before enabling ima is bad because... you didn't think of it?
>
> No, because /init can potentially compromise the integrity of the
> system.

I think Rob is right here.  If /init was statically built into the
kernel image, it has no more ability to compromise the kernel than
anything else in the kernel.  What's the problem here?
