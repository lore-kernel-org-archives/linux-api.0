From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [RFC 0/8] Additional kmsg devices
Date: Fri, 3 Jul 2015 13:21:43 +0200
Message-ID: <CAFLxGvxvaePEyCpLrB1cjNn4bvnCwt-_HE3zcT-6diMYNOraBw@mail.gmail.com>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Marcin Niesluchowski <m.niesluchow@samsung.com>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.cz>, Tejun Heo <tj@kernel.org>, Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 3, 2015 at 12:49 PM, Marcin Niesluchowski
<m.niesluchow@samsung.com> wrote:
> Dear All,
>
> This series of patches extends kmsg interface with ability to dynamicaly
> create (and destroy) kmsg-like devices which can be used by user space
> for logging. Logging to kernel has number of benefits, including but not
> limited to - always available, requiring no userspace, automatically
> rotating and low overhead.
>
> User-space logging to kernel cyclic buffers was already successfully used
> in android logger concept but it had certain flaws that this commits try
> to address:
> * drops hardcoded number of devices and static paths in favor for dynamic
>   configuration by ioctl interface in userspace
> * extends existing driver instead of creating completely new one

So, now we start moving syslogd into kernel land because userspace is
too broken to provide
decent logging?

I can understand the systemd is using kmsg if no other logging service
is available
but I really don't think we should encourage other programs to do so.

Why can't you just make sure that your target has a working
syslogd/rsyslogd/journald/whatever?
All can be done perfectly fine in userspace.

Just my two cents.

-- 
Thanks,
//richard
