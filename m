From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RESEND Patch v6 2/2] fpga: dfl: fme: add performance reporting
 support
Date: Thu, 23 Jan 2020 10:05:56 +0800
Message-ID: <20200123020556.GA9716@hao-dev>
References: <1579230628-22243-1-git-send-email-hao.wu@intel.com>
 <1579230628-22243-3-git-send-email-hao.wu@intel.com>
 <20200122141026.GA10399@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200122141026.GA10399-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Luwei Kang <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xu Yilun <yilun.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 22, 2020 at 03:10:26PM +0100, Greg KH wrote:
> On Fri, Jan 17, 2020 at 11:10:28AM +0800, Wu Hao wrote:
> > +static const struct attribute_group fme_perf_fabric_events_group = {
> > +	.name = "events",
> > +	.attrs = fme_perf_fabric_events_attrs,
> > +	.is_visible = fme_perf_fabric_events_visible,
> > +};
> > +
> 
> I don't see any Documentation/ABI/ entries for all of these new files.
> Please properly document them so we know how to review this.

Hi Greg,

Thanks a lot for the review. Actually all the sysfs entries under events
are perf monitoring events following the same format documented in 
"Documentation/ABI/testing/sysfs-bus-event_source-devices-events" and
we added some description in our fpga documentation in patch #1.

Yes, I can add something in ABI directly as well in the next version.
I pasted related descriptions below. I hope this won't block review.

Thank you very much!
Hao


>From Documentation/ABI/testing/sysfs-bus-event_source-devices-events

What: /sys/bus/event_source/devices/<pmu>/events/<event>
Date: 2014/02/24
Contact:        Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Description:    Per-pmu performance monitoring events specific to the running system

                Each file (except for some of those with a '.' in them, '.unit'
                and '.scale') in the 'events' directory describes a single
                performance monitoring event supported by the <pmu>. The name
                of the file is the name of the event.

                File contents:

                        <term>[=<value>][,<term>[=<value>]]...

                Where <term> is one of the terms listed under
                /sys/bus/event_source/devices/<pmu>/format/ and <value> is
                a number is base-16 format with a '0x' prefix (lowercase only).
                If a <term> is specified alone (without an assigned value), it
                is implied that 0x1 is assigned to that <term>.

                Examples (each of these lines would be in a seperate file):

                        event=0x2abc
                        event=0x423,inv,cmask=0x3
                        domain=0x1,offset=0x8,starting_index=0xffff
                        domain=0x1,offset=0x8,core=?

                Each of the assignments indicates a value to be assigned to a
                particular set of bits (as defined by the format file
                corresponding to the <term>) in the perf_event structure passed
                to the perf_open syscall.

                In the case of the last example, a value replacing "?" would
                need to be provided by the user selecting the particular event.
                This is referred to as "event parameterization". Event
                parameters have the format 'param=?'.

>From Documentation/fpga/dfl.rst added by patch #1.

"
The "events" directory describes the configuration templates for all available
events which can be used with perf tool directly. For example, fab_mmio_read
has the configuration "event=0x06,evtype=0x02,portid=0xff", which shows this
event belongs to fabric type (0x02), the local event id is 0x06 and it is for
overall monitoring (portid=0xff).
"

> 
> thanks,
> 
> greg k-h
