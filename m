From: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Subject: Re: [PATCH v6 03/21] libnvdimm: control character device and nvdimm_bus sysfs attributes
Date: Thu, 18 Jun 2015 00:00:24 +0200
Message-ID: <55195804.2G24WjSeEI@vostro.rjw.lan>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com> <20150611201024.25175.7686.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611201024.25175.7686.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Robert Moore <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thursday, June 11, 2015 04:10:24 PM Dan Williams wrote:
> The control device for a nvdimm_bus is registered as an "nd" class
> device.  The expectation is that there will usually only be one "nd" bus
> registered under /sys/class/nd.  However, we allow for the possibility
> of multiple buses and they will listed in discovery order as
> ndctl0...ndctlN.  This character device hosts the ioctl for passing
> control messages.  The initial command set has a 1:1 correlation with
> the commands listed in the by the "NFIT DSM Example" document [1], but
> this scheme is extensible to future command sets.
> 
> Note, nd_ioctl() and the backing ->ndctl() implementation are defined in
> a subsequent patch.  This is simply the initial registrations and sysfs
> attributes.
> 
> [1]: http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf
> 
> Cc: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
> Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> Cc: <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Cc: Robert Moore <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

For the ACPI part:

Acked-by: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
