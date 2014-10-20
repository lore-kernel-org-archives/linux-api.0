From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 4/6] tpm: TPM 2.0 sysfs attributes
Date: Mon, 20 Oct 2014 13:35:55 +0300
Message-ID: <20141020103555.GA5647@intel.com>
References: <1413372916-12091-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1413372916-12091-5-git-send-email-jarkko.sakkinen@linux.intel.com>
 <CALCETrUt8wK+wPULZpPQks3xEB0JkQkUD=peLSnBrMo70LT13w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUt8wK+wPULZpPQks3xEB0JkQkUD=peLSnBrMo70LT13w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, monty.wiseman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Oct 19, 2014 at 03:07:49PM -0700, Andy Lutomirski wrote:
> On Wed, Oct 15, 2014 at 4:35 AM, Jarkko Sakkinen
> <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > Implemented sysfs attributes for TPM2 devices. TPM2 sysfs attributes
> > are mounted in the actual device associated with the chip instead of
> > platform device like with TPM1 devices.
> >
> > Documentation/ABI/stable/sysfs-class/tpm2 contains descriptions
> > of these attributes.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> 
> > +What:          /sys/class/misc/tpmX/device/cancel
> > +Date:          October 2014
> > +KernelVersion: 3.19
> > +Contact:       tpmdd-devel-TtF/mJH4Jtrk1uMJSBkQmQ@public.gmane.org
> > +Description:   The "cancel" property allows you to cancel the currently
> > +               pending TPM command. Writing any value to cancel will call the
> > +               TPM chip specific cancel operation.
> 
> This is weird.  From the POV of a sysfs user, what operation gets
> canceled?  What if it's a kernel-internal operation?
> 
> Shouldn't this be an ioctl?

This was a really good insight, thank you. I just followed along the
lines what was defined for TPM1 but didn't think too much. This is
racy attribute and should not be added for TPM2.

I'll drop this. Adding ioctl() later would much better idea as it is
not racy but I think it should be postponed after this patch set so
that it stays digestable size.

> --Andy

/Jarkko
