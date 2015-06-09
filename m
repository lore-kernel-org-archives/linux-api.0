From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 05/21] libnvdimm: control (ioctl) messages for
 libnvdimm bus and dimm devices
Date: Mon, 8 Jun 2015 23:57:42 -0700
Message-ID: <CAPcyv4jmHpg4YrseBWH-k=achv4N-V8n2X0CkFw+-AFsiRuH8A@mail.gmail.com>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150602001435.4506.42614.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150609063418.GB9804@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150609063418.GB9804-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jmoyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 8, 2015 at 11:34 PM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> On Mon, Jun 01, 2015 at 08:14:35PM -0400, Dan Williams wrote:
>> Most discovery/configuration of the libnvdimm-subsystem is done via
>> sysfs attributes.  However, some libnvdimm buses, particularly the
>> ACPI.NFIT bus, define a small set of messages that can be passed to the
>> platform.  For convenience we derive the initial libnvdimm-ioctl command
>> formats directly from the NFIT DSM Interface Example formats.
>
> Why not merge these into the extensive sysfs interface?

Data payload size for one, these commands transfer more than a page
worth of data at a time.

Even if we killed the ioctl interface to userspace we still need all
the ugly data marshaling code in the kernel to craft properly
formatted ACPI _DSM messages.  I try to share as much common
infrastructure from the ACPI _DSM implementation to the ioctl
interface (nd_cmd_dimm_desc() + nd_cmd_bus_desc()).
