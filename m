From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Thu, 26 Jan 2017 14:20:12 +0100
Message-ID: <CAEiveUex3aT7T_t8G_s9+W27Q61DmBiQrR526woRPVFLhusnvQ@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
 <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com>
 <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com>
 <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com>
 <CAEiveUevjijnmr7oWzQexi52nJm-BjVwAkb3fJinAbet=QvzxQ@mail.gmail.com>
 <CALCETrUp9CBWykRUQoJOXeLg9u45H+2VWyQ_BKAhwc9OpBYn+g@mail.gmail.com>
 <CAEiveUdOdMr=gJZsi=Fx-CNeC8jkyi8XxC+qSG-LXWj3o2t=_A@mail.gmail.com>
 <CALCETrX_K7XdyCRo1RSLySRu-2uySaR2+3J7qcw4O+JOepTwag@mail.gmail.com>
 <CAEiveUe87HZK45Vs1VsTKcPMpLAav53JZb9_5-3Bc--FCGDf3A@mail.gmail.com> <CALCETrWa5kdm2kk_PmD5grgdO+geLvR2BacAZ7NhcHH-VeQh3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6167-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrWa5kdm2kk_PmD5grgdO+geLvR2BacAZ7NhcHH-VeQh3w@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Lafcadio Wluiki <wluikil@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 23, 2017 at 9:07 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Jan 23, 2017 at 3:46 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
>> On Sat, Jan 21, 2017 at 1:53 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> I agree that the kernel change to do it per task is very simple.  But
>>> this is an unfortunate slippery slope.  What if you want to block off
>>> everything in /proc that isn't associated with a PID?  What if you
>>> want to suppress /sys access?  What if you want ot block *all*
>>> non-current PIDs from being revealed in /proc?  What if you want to
>>> hide /proc/PID/cmdline?
>>
>> For /sys we mount an inaccessible directory on top, we even do that
>> for some static /sys and /proc inodes, of course that doesn't scale
>> but we try... please see below.
>
> So you do have a private fs namespace.

Yes for some cases and they are cheap, however I don't see the relation here ?


>>
>>> I think that the right solution here is to fix procfs to understand
>>> per-superblock mount options.
>>
>> Unfortunately and as also noted by Lafcadio and you this is too
>> complex.
>> ... but lets please stay focused here, fixing procfs is a bit out of the
>> scope for this *specific* use case and patch, we don't have the
>> resources to explore something new...
>
> I'm not the final authority on this (that's probably Eric), but NAK.

(I don't know the final authority. The *only* thing I know is that we
have technical problems here that are *not* fixed, and we try to fix
them).


> For upstream Linux, you can't say "doing it right is too hard so we're
> going to introduce a hackish ABI with questionable security
> properties".

No one said this.

Maybe you think that procfs is the right way, but I certainly can't
predict how much damage any fundamental change on procfs will make.
procfs is a special fs that has its own rules and hacks... everyone
would like to avoid major changes on it...

Could you please explain in clear words what are the benefits to use
mount, retain or regain CAP_SYS_ADMIN for something that we can set
without any privileges ?


> The right solution is IMO quite clearly to fix /proc.  This isn't even
> particularly hard -- there are only 17 instances of s_fs_info in
> fs/proc/.

pid namespaces are tied to procfs to the heart, any change on procfs
has also to count on pid namespaces, flush cached entries of a task
from each /proc... ? pid namespaces have then to be made smarter.
Forward port vulnerability and bug fixes that have been stacked in
procfs ? or at least do not break them. "procfs has always been a
special fs" by git logs. Also cases of some specific directories
/proc/fs/nfs and maybe devices id  ?
persistent of mount options and other userspace information -
https://lkml.org/lkml/2012/3/26/486

These prevent me from asserting that's the best way... where in a
previous thread you said that we should go with the easiest way to fix
the problem.


-- 
tixxdz
http://opendz.org
