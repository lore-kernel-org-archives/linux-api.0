From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Fri, 20 Jan 2017 17:33:31 +0100
Message-ID: <CAEiveUdOdMr=gJZsi=Fx-CNeC8jkyi8XxC+qSG-LXWj3o2t=_A@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
 <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com>
 <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com>
 <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com>
 <CAEiveUevjijnmr7oWzQexi52nJm-BjVwAkb3fJinAbet=QvzxQ@mail.gmail.com> <CALCETrUp9CBWykRUQoJOXeLg9u45H+2VWyQ_BKAhwc9OpBYn+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6115-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrUp9CBWykRUQoJOXeLg9u45H+2VWyQ_BKAhwc9OpBYn+g@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Lafcadio Wluiki <wluikil@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 19, 2017 at 8:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Jan 19, 2017 at 5:53 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
[...]
>> Sure, the hidepid mount option is old enough, and this per-task
>> hidepid is clearly defined only for procfs and per task, we can't add
>> another switch that's relate to both a filesystem and pid namespaces,
>> it will be a bit complicated and not really useful for cases that are
>> in *same* pidns where *each* one have to mount its procfs, it will
>> propagate. Also as noted by Lafcadio, the gid thing is a bit hard to
>> use now.
>
> What I'm trying to say is that I want to understand a complete,
> real-world use case.  Adding a security-related per-task flag is can
> be quite messy and requires a lot of careful thought to get right, and
> I'd rather avoid it if at all possible.

I do agree, but that's not what we are proposing here. This use case
is limited we do not manipulate the creds of the task, there are no
security transitions. The task does not change, its only related to
procfs and pid entries there. Also the flag applies only to current
task and not on remote ones... Nothing new here it's an extension of
procfs hidepid.

> I'm imaging something like a new RestrictPidVisisbility= option in
> systemd.  I agree that this is currently a mess to do.  But maybe a

Yes that's one use case, If we manage to land this I'll follow up with
it... plus there is, I've a use case related to kubernetes where I do
want to reduce the number of processes inside containers per pod to
minimal. Some other cases are: lock down children where being
unprivileged. Also as noted in other replies on today's desktop
systems, under a normal user session, the user should see all
processes of the system where the media player, browser etc have no
business to see the process tree. This can be easily implemented when
launching apps without the need to regain privileges...

> simpler solution would be to add a new mount option local_hidepid to
> procfs.  If you set that option, then it overrides hidepid for that
> instance.  Most of these semi-sandboxed daemon processes already have
> their own mount namespace, so the overhead should be minimal.

Andy If that could work :-/    we have to re-write or adapt lot of
things inside procfs... plus:
Procfs is a miror to the current pid namespace. Mount options are not
procfs but rather pid namespace. That would not work.
Also having multiple mount namespaces where each one with its setup
and having to migrate tasks between these environements: I would
rather have the security information or context or any minor flag
attached to the task itself rather than the object.
The prctl() interface is really simple for userspace. The kernel
change is not intrusive, and current approach does not require any
privileges. For others you may have to gain privileges or ask some one
to set it up. The current tendency is to allow more unprivileged
code/containers... to setup such mini jails. Note to mention that this
schema is simple and can be isolated from other complexities, set it
once and that's it.


> --Andy



-- 
tixxdz
http://opendz.org
