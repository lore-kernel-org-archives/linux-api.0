From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v7 2/2] fpga: dfl: fme: add performance reporting support
Date: Mon, 10 Feb 2020 12:56:18 -0800
Message-ID: <20200210205618.GA1347752@kroah.com>
References: <1581306469-22629-1-git-send-email-hao.wu@intel.com>
 <1581306469-22629-3-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1581306469-22629-3-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yilun.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Luwei Kang <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 10, 2020 at 11:47:49AM +0800, Wu Hao wrote:
> +What:		/sys/bus/event_source/devices/fmeX/format
> +Date:		February 2020
> +KernelVersion:  5.7
> +Contact:	Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> +Description:	Read-only. Attribute group to describe the magic bits
> +		that go into perf_event_attr.config for a particular pmu.
> +		(See ABI/testing/sysfs-bus-event_source-devices-format).
> +
> +		Each attribute under this group defines a bit range of the
> +		perf_event_attr.config. All supported attributes are listed
> +		below.
> +
> +		  event  = "config:0-11"  - event ID
> +		  evtype = "config:12-15" - event type
> +		  portid = "config:16-23" - event source
> +
> +		For example,
> +
> +		  fab_mmio_read = "event=0x06,evtype=0x02,portid=0xff"

Are perf sysfs files always this bad "multiple values per file"?  Or is
that unique to this driver?  If not unique, do you have specific
examples in the kernel that currently do this today?


> +static struct attribute *fme_perf_events_attrs_empty[] = {
> +	NULL,

Huh?

> +};
> +
> +static struct attribute_group fme_perf_events_group = {
> +	.name = "events",
> +	.attrs = fme_perf_events_attrs_empty,

You create an empty directory?  Why?  What goes in here?

very odd...

greg k-h
