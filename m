From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RFC 0/8] Additional kmsg devices
Date: Wed, 08 Jul 2015 13:17:19 +0200
Message-ID: <2470387.lBYrfq1ai1@amdc1976>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
 <559CDF8B.2090000@samsung.com> <559CE110.70503@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <559CE110.70503@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: Marcin Niesluchowski <m.niesluchow@samsung.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.cz>, Tejun Heo <tj@kernel.org>, Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Karol Lewandowski <k.lewandowsk@samsung.com>
List-Id: linux-api@vger.kernel.org


Hi,

On Wednesday, July 08, 2015 10:36:32 AM Richard Weinberger wrote:
> Am 08.07.2015 um 10:30 schrieb Marcin Niesluchowski:
> > On 07/03/2015 05:19 PM, Richard Weinberger wrote:
> >> Am 03.07.2015 um 17:09 schrieb Marcin Niesluchowski:
> >>>> Why can't you just make sure that your target has a working
> >>>> syslogd/rsyslogd/journald/whatever?
> >>>> All can be done perfectly fine in userspace.
> >>> * Message credibility: Lets imagine simple service which collects logs via unix sockets. There is no reliable way of identifying logging process. getsockopt() with SO_PEERCRED
> >>> option would give pid form cred structure, but according to manual it may not be of actual logging process:
> >>>    "The returned credentials are those that were in effect at the time of the call to connect(2) or socketpair(2)."
> >>>        - select(7)
> >> This interface can be improved. Should be easy.
> > 
> > What kind of improvement do you have in mind?
> 
> I was wrong, we have the needed functionality already.
> See Andy's reply.

Please note that Andy has pointed out that the existing interface
(SCM_CREDENTIALS) is dangerous (=> should not be used).

Unfortunately his code for SCM_IDENTITY (which would replace
SCM_CREDENTIALS) has not materialized beyond initial 10% done
a year ago during SCP_PROCINFO discussion (it also has not been
explained enough to allow implementation by someone else).

> >>> * Early userspace tool: Helpful especially for embeded systems.
> >> This is what we do already. In early user space spawn your logger as early as possible.
> >> "embedded Linux is special" is not an excuse btw. ;)
> > 
> > I would say "embedded Linux is real use case"instead of "special". What I meant that it does only require one ioctl and no additional resources are needed.
> > 
> >>> * Reliability: Userspace service may be killed due to out of memory (OOM). This is kernel cyclic buffer, which size can be specified differently according to situation.
> >> This is what we have /proc/<pid>/oom_adj and /proc/<pid>/oom_score_adj for.
> > 
> > You are right, but additional resources and complexity is required.
> 
> A few "echo foo > /proc/xy/bar" commands are far less complexity than adding a pseudo syslogd to kernel land...

Please read actual patches.  In roughly 600 new LOC they are doing
mainly two things:

* adding possibility to have more than one /dev/kmsg device & kernel
  log buffer (~200 LOC)

* adding user interface for managing these additional devices/buffers
  (~400 LOC)

I actually imagine that some time in the future we may also want to
have separate kernel log buffers for kernel usage itself..

> >>> * Possibility of using it with pstore: This code could be extended to log additional buffers to persistent storage same way main (kmsg) log buffer is.
> >> pstorefs and friends?
> > 
> > pstore filesystem is used to access already stored kernel data (e.g. kmsg buffer). But does not provide mechanism of storing userspace memory.
> 
> Which can be easily improved. Again, it will be less complex than your current approach.
> 
> >>> * Use case of attaching file descriptor to stdout/stderr: Especially in early userspace.
> >> You can redirect these also in userspace.
> > 
> > True for that, but as I said in my first argument there is no possibility of logging process identification in case of sockets.
> > 
> > 
> >>> * Performance: Those services mentioned by You are weeker solutions in that case. Especially systemd-journald is much too heavy soulution.
> >> Do you have numbers? I agree systemd-journald is heavy wight. But it is by far not the only logging daemon we have...
> > 
> > I compared write operations on kmsg buffervia write/read operations on socketon SOCK_STREAM socket and sendmsg/recv on SOCK_DGRAM socket. Compared toSOCK_STREAM socket it was about
> > 39% slowerbut compared toSOCK_DGRAM socket it was about 326% faster.syslogfor example uses SOCK_DGRAM sockets.In all cases there were 2^20 (1048576) write/sendmsg operations of 2^8
> > (256) bytes.
> 
> I still think the whole approach is wrong. Instead of giving up and going to kernel land, come up with a minimal userspace ringbuffer-syslogd.
> If the kernel lacks some support you need, add it. But don't move the whole thing int the kernel.

When it comes to possibility of logging things from user space to
kernel log buffer (through /dev/kmsg) then it has been added 3 years
ago in v3.5..

The changes being proposed are not doing what you're are trying to
imply - this is not kernel syslogd (like kdbus is a kernel dbus
implementation).  They are merely enhancing existing /dev/kmsg
interface and may be useful also for kernel logging purposes some
time in the future..

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
