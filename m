From: Petr Mladek <pmladek@suse.com>
Subject: Re: [RFC 0/8] Additional kmsg devices
Date: Wed, 8 Jul 2015 12:45:19 +0200
Message-ID: <20150708104519.GK32664@pathway.suse.cz>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
 <CAFLxGvxvaePEyCpLrB1cjNn4bvnCwt-_HE3zcT-6diMYNOraBw@mail.gmail.com>
 <5596A58F.7090208@samsung.com>
 <20150707131124.GI32664@pathway.suse.cz>
 <559C0820.3060805@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <559C0820.3060805@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: Marcin Niesluchowski <m.niesluchow@samsung.com>, Richard Weinberger <richard.weinberger@gmail.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Kyungmin Park <kmpark@infradead.org>
List-Id: linux-api@vger.kernel.org

On Tue 2015-07-07 19:10:56, Karol Lewandowski wrote:
> On 2015-07-07 15:11, Petr Mladek wrote:
> > On Fri 2015-07-03 17:09:03, Marcin Niesluchowski wrote:
> >> On 07/03/2015 01:21 PM, Richard Weinberger wrote:
> >>> On Fri, Jul 3, 2015 at 12:49 PM, Marcin Niesluchowski
> >>> <m.niesluchow@samsung.com> wrote:
> >>>> Dear All,
> >>>>
> >>>> This series of patches extends kmsg interface with ability to dynamicaly
> >>>> create (and destroy) kmsg-like devices which can be used by user space
> >>>> for logging. Logging to kernel has number of benefits, including but not
> >>>> limited to - always available, requiring no userspace, automatically
> >>>> rotating and low overhead.
> >>>>
> >>>> User-space logging to kernel cyclic buffers was already successfully used
> >>>> in android logger concept but it had certain flaws that this commits try
> >>>> to address:
> >>>> * drops hardcoded number of devices and static paths in favor for dynamic
> >>>>   configuration by ioctl interface in userspace
> >>>> * extends existing driver instead of creating completely new one
> >>> So, now we start moving syslogd into kernel land because userspace is
> >>> too broken to provide
> >>> decent logging?
> >>>
> >>> I can understand the systemd is using kmsg if no other logging service
> >>> is available
> >>> but I really don't think we should encourage other programs to do so.
> >>>
> >>> Why can't you just make sure that your target has a working
> >>> syslogd/rsyslogd/journald/whatever?
> >>> All can be done perfectly fine in userspace.
> >> * Message credibility: Lets imagine simple service which collects
> >> logs via unix sockets. There is no reliable way of identifying
> >> logging process. getsockopt() with SO_PEERCRED option would give pid
> >> form cred structure, but according to manual it may not be of actual
> >> logging process:
> >>   "The returned credentials are those that were in effect at the
> >> time of the call to connect(2) or socketpair(2)."
> >>       - select(7)
> >>
> >> * Early userspace tool: Helpful especially for embeded systems.
> >>
> >> * Reliability: Userspace service may be killed due to out of memory
> >> (OOM). This is kernel cyclic buffer, which size can be specified
> >> differently according to situation.
> > But then many services will fight for the space in the kernel ring
> > buffer.
> 
> Yes.   Please note however that problems you describe are also valid for
> /dev/kmsg today.

Mea culpa, I should not write when I do not have enough time to read
the patches. I somehow missed the patch that added more buffers, so
many opinions were misleading.

> > It will be harder to handle continuous lines.
> 
> I don't see how it would be different from what we have today.

There is currently only one buffer for continuous lines. It is flushed
when you write from another CPU even before the current message is completed.
It needs to be flushed also when you write from another devkmsg.

I thought that there would be much bigger chance to mix parts of
messages in a single buffer but it is not true after all.


Best Regards,
Petr
