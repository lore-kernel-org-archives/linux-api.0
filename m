From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [RFC v3 0/9] Additional kmsg devices
Date: Mon, 19 Oct 2015 15:26:14 +0200
Message-ID: <CAFLxGvzb7asiOdjPAV+cFxiC1TQisd4e7yPP9s9gqSCdVM-jmA@mail.gmail.com>
References: <1445259503-18158-1-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445259503-18158-1-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 19, 2015 at 2:58 PM, Paul Osmialowski
<p.osmialowsk@samsung.com> wrote:
> Dear All,
>
> This is the third iteration of Marcin Niesluchowski's serie of patches
> extending kmsg interface with ability to dynamically create (and destroy)
> kmsg-like devices which can be used by userspace for logging.
>
> In this iteration, following Joe Perches's suggestion, I've extracted
> kmsg related functions from printk.c to a new file, kmsg.c.
>
> Best regards,
> Paul
>
> Marcin Niesluchowski (7):
>   printk: add one function for storing log in proper format
>   kmsg: introduce additional kmsg devices support
>   kmsg: add additional buffers support to memory class
>   kmsg: add function for adding and deleting additional buffers
>   kmsg: add ioctl for adding and deleting kmsg* devices
>   kmsg: add ioctl for kmsg* devices operating on buffers
>   kmsg: add predefined _PID, _TID, _COMM keywords to kmsg* log dict
>
> Paul Osmialowski (2):
>   printk: extract kmsg-related routines from printk.c to kmsg.c
>   kmsg: selftests

Not CC'ing critical voices it not very nice. 8-)

As I replied to v1 of this series, IHMO we should not encourage
userspace tools to use kmsg as their poor-man's syslog.
Everything what this series does in kernel space can also be done
in userspace.

Just my two cents.

-- 
Thanks,
//richard
