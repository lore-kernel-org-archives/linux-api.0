From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Tue, 14 May 2019 10:44:07 -0400
Message-ID: <20190514144406.GA37109@rani.riverdale.lan>
References: <20190512194322.GA71658@rani.riverdale.lan>
 <3fe0e74b-19ca-6081-3afe-e05921b1bfe6@huawei.com>
 <4f522e28-29c8-5930-5d90-e0086b503613@landley.net>
 <f7bc547c-61f4-1a17-735c-7e8df97d7965@huawei.com>
 <20190513172007.GA69717@rani.riverdale.lan>
 <20190513175250.GC69717@rani.riverdale.lan>
 <1557772584.4969.62.camel@linux.ibm.com>
 <20190513184744.GA12386@rani.riverdale.lan>
 <1557785351.4969.94.camel@linux.ibm.com>
 <66b57ae5-bb5a-c008-8490-2c90e050fc65@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <66b57ae5-bb5a-c008-8490-2c90e050fc65@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Arvind Sankar <nivedita@alum.mit.edu>, Arvind Sankar <niveditas98@gmail.com>, Roberto Sassu <roberto.sassu@huawei.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 14, 2019 at 01:06:45AM -0500, Rob Landley wrote:
> On 5/13/19 5:09 PM, Mimi Zohar wrote:
> >> Ok, but wouldn't my idea still work? Leave the default compiled-in
> >> policy set to not appraise initramfs. The embedded /init sets all the
> >> xattrs, changes the policy to appraise tmpfs, and then exec's the real
> >> init? Then everything except the embedded /init and the file with the
> >> xattrs will be appraised, and the embedded /init was verified as part of
> >> the kernel image signature. The only additional kernel change needed
> >> then is to add a config option to the kernel to disallow overwriting the
> >> embedded initramfs (or at least the embedded /init).
> > 
> > Yes and no.  The current IMA design allows a builtin policy to be
> > specified on the boot command line ("ima_policy="), so that it exists
> > from boot, and allows it to be replaced once with a custom policy.
> >  After that, assuming that CONFIG_IMA_WRITE_POLICY is configured,
> > additional rules may be appended.  As your embedded /init solution
> > already replaces the builtin policy, the IMA policy couldn't currently
> > be replaced a second time with a custom policy based on LSM labels.
> 
> So your design assumption you're changing other code to work around in that
> instance is the policy can only be replaced once rather than having a "finalize"
> option when it's set, making it immutable from then on.
> 
> Rob
I agree it would be better to have a finalize option. Outside of my
idea, it seems the current setup would make it so while developing an
IMA policy you need to keep rebooting to test your changes?

I'd suggest having a knob that starts out unrestricted, and can be
one-way changed to append-only or immutable. This seems like a good idea
even if you decide the embedded image is too much trouble or unworkable
for other reasons.
