From: Sandeep Patil <sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 2/2] staging: ion: create one device entry per heap
Date: Tue, 3 Oct 2017 16:08:30 -0700
Message-ID: <20171003230830.GA132839@sspatil-desktop.mtv.corp.google.com>
References: <1506518409-16887-1-git-send-email-benjamin.gaignard@linaro.org>
 <1506518409-16887-3-git-send-email-benjamin.gaignard@linaro.org>
 <2e15edc2-a17f-3930-7d5b-4b5b7d2e0a4d@redhat.com>
 <20171003164849.rcdgez6lbpmq5llt@sirena.org.uk>
 <2417c969-357f-d5d9-153a-2180d09b0dc6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2417c969-357f-d5d9-153a-2180d09b0dc6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, riandrews-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 03, 2017 at 02:42:32PM -0700, Laura Abbott wrote:
> On 10/03/2017 09:48 AM, Mark Brown wrote:
> > On Mon, Oct 02, 2017 at 11:07:48AM -0700, Laura Abbott wrote:
> > 
> >> Thinking about this a bit more, I'm not 100% sure if this
> >> will allow the security rules we want. Heap ids are assigned
> >> dynamically and therefore so will the /dev/ionX designation.
> >> From my understanding, security rules like selinux need to
> >> be fully specified at boot time so I'm not sure how you would
> >> be able to write rules to differentiate between /dev/ionX and
> >> /dev/ionY without knowing the values at boottime.
> > 
> > Isn't this something that should be managable via udev rules that ensure
> > stable names in the same way as for things like disks or ethernet
> > controllers (even if it just ends up doing something like /dev/ion-gpu
> > or whatever)?  If we're not giving it enough information to assign stable
> > names where needed we probably need to fix that anyway.
> > 
> 
> Android doesn't use a standard udev so we'd need something that
> would work there. My understanding was that android needs everything
> specified at boot unless that's changed.
> 
> There would be enough information to assign stable names
> (e.g. /dev/ion-system) if we used the query ioctl to find out
> what's actually available. Is just the ioctl useful though?

Wouldn't this new ioctl() to query the heap name also result in special case
handling of all ion devices in user space?

If the devices are named with their corresponding heap names like ion-system, ion-cma etc.
It is entirely possible and easy in android/ueventd to create those nodes
under "/dev/ion/".  (assuming the heap 'subsystem' for these new devices will
point to 'ion').

Something like the following should work if added in ueventd.rc

  subsystem ion
    devname uevent_devname
    dirname /dev/ion

Also, makes SElinux labelling easier.

(Also FWIW, the SELinux permissions are also possible with the current ion
implementation by adding rules to disallow specific ioctls instead of adding
permissions to access device node as this change would do)


- ssp

> 
> Thanks,
> Laura
> _______________________________________________
> devel mailing list
> devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
