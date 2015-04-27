From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] iio: derive the mounting matrix from ACPI _PLD objects
Date: Mon, 27 Apr 2015 18:54:54 +0300
Message-ID: <CAE1zot+YKTPmVbG-_fNRy-E_VCcqq1VE78H3PMSMb5HvsBheQw@mail.gmail.com>
References: <1430146908-27919-1-git-send-email-octavian.purdila@intel.com>
	<1430146908-27919-4-git-send-email-octavian.purdila@intel.com>
	<64714.10.254.87.235.1430149342.squirrel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <64714.10.254.87.235.1430149342.squirrel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sathyanarayanan.kuppuswamy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Robert Moore <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael J Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 27, 2015 at 6:42 PM, Kuppuswamy Sathyanarayanan
<sathyanarayanan.kuppuswamy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> Since Acpi framework already exports this info to user space, Why not do
> this derivation in user space code ? Why do we need new ABI, if the same
> can be derived from existing one.
>

The ABI was added in the previous patch so that we can present the
sensor orientation information to userspace even in the case of device
tree.

The purpose of this patch is to provide a consistent ABI to userspace,
i.e. to avoid doing one thing in the ACPI case and another thing in
the case of device tree.
