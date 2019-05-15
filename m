From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Tue, 14 May 2019 20:25:57 -0400
Message-ID: <20190515002556.GA88615@rani.riverdale.lan>
References: <dca50ee1-62d8-2256-6fdb-9a786e6cea5a@landley.net>
 <20190512194322.GA71658@rani.riverdale.lan>
 <3fe0e74b-19ca-6081-3afe-e05921b1bfe6@huawei.com>
 <4f522e28-29c8-5930-5d90-e0086b503613@landley.net>
 <f7bc547c-61f4-1a17-735c-7e8df97d7965@huawei.com>
 <CALCETrV3b205L38xqPr6QqwGn6-vxQdPoJGUygJJpgM-JqqXfQ@mail.gmail.com>
 <9357cb32-3803-2a7e-4949-f9e4554c1ee9@huawei.com>
 <20190514165842.GC28266@kroah.com>
 <f01ad775-54de-033f-d8cb-f27f36e92f0c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f01ad775-54de-033f-d8cb-f27f36e92f0c@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Andy Lutomirski <luto@kernel.org>, Rob Landley <rob@landley.net>, Arvind Sankar <niveditas98@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, initramfs@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 14, 2019 at 07:20:15PM +0200, Roberto Sassu wrote:
> On 5/14/2019 6:58 PM, Greg KH wrote:
> > On Tue, May 14, 2019 at 06:33:29PM +0200, Roberto Sassu wrote:
> >> Right, the measurement/signature verification of the kernel image is
> >> sufficient.
> >>
> >> Now, assuming that we defer the IMA initialization until /init in the
> >> embedded initramfs has been executed, the problem is how to handle
> >> processes launched with the user mode helper or files directly read by
> >> the kernel (if it can happen before /init is executed). If IMA is not
> >> yet enabled, these operations will be performed without measurement and
> >> signature verification.
> > 
> > If you really care about this, don't launch any user mode helper
> > programs (hint, you have the kernel option to control this and funnel
> > everything into one, or no, binaries).  And don't allow the kernel to
> > read any files either, again, you have control over this.
> > 
> > Or start IMA earlier if you need/want/care about this.
> 
> Yes, this is how it works now. It couldn't start earlier than
> late_initcall, as it has to wait until the TPM driver is initialized.
> 
> Anyway, it is enabled at the time /init is executed. And this would be
> an issue because launching /init and reading xattrs from /.xattr-list
> would be denied (the signature is missing).
> 
> And /.xattr-list won't have a signature, if initramfs is generated
> locally.
> 
> Roberto
> 
> -- 
> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
> Managing Director: Bo PENG, Jian LI, Yanli SHI

The uevent and firmware loader user mode helpers are both obsolete I
believe, so those shouldn't be an issue.

There is still the internal firmware loader (CONFIG_FW_LOADER). If this
is built-in, there's probably no way to 100% stop it racing with /init if we
depend on an embedded /init and a malicious external initramfs image
contains /lib/firmware, but it can be built as an external module, in
which case there should be no danger until the boot process actually loads it.
