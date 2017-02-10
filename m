From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Fri, 10 Feb 2017 08:18:11 -0800
Message-ID: <CALCETrVpOczwpVRFd8yoSZGcYEG=qHuRmTND8L7V_oZRu1sbCA@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
 <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com>
 <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com>
 <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com>
 <CAEiveUevjijnmr7oWzQexi52nJm-BjVwAkb3fJinAbet=QvzxQ@mail.gmail.com>
 <CALCETrUp9CBWykRUQoJOXeLg9u45H+2VWyQ_BKAhwc9OpBYn+g@mail.gmail.com>
 <CAEiveUdOdMr=gJZsi=Fx-CNeC8jkyi8XxC+qSG-LXWj3o2t=_A@mail.gmail.com>
 <CALCETrX_K7XdyCRo1RSLySRu-2uySaR2+3J7qcw4O+JOepTwag@mail.gmail.com> <CAOWbf6f-3Ha3dkNuTfar0-u1SdSu=gDt0tK3Wq9+f9LZqB4gMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6473-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAOWbf6f-3Ha3dkNuTfar0-u1SdSu=gDt0tK3Wq9+f9LZqB4gMQ@mail.gmail.com>
To: Lafcadio Wluiki <wluikil@gmail.com>
Cc: Djalal Harouni <tixxdz@gmail.com>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 10, 2017 at 6:40 AM, Lafcadio Wluiki <wluikil@gmail.com> wrote:
> On Sat, Jan 21, 2017 at 1:53 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
>> I agree that the kernel change to do it per task is very simple.  But
>> this is an unfortunate slippery slope.  What if you want to block off
>> everything in /proc that isn't associated with a PID?  What if you
>> want to suppress /sys access?  What if you want ot block *all*
>> non-current PIDs from being revealed in /proc?  What if you want to
>> hide /proc/PID/cmdline?
>
> These are all what-ifs that noone was interested in so far. I have a
> very specific itch I want to scratch, and I found a reasonably generic
> concept of exposing it. But now you are trying to lead this all down
> onto a paths asking for features noone is actually really interested
> in.

If you have an itch and want to scratch it by adding a new API, the
API has to be right, full stop.

>
>> I think that the right solution here is to fix procfs to understand
>> per-superblock mount options.
>
> Andy, this is really not helpful. Doing that is far from easy, that's
> a major undertaking: asking us to rework procfs in such a major way I
> only can understand as an indirect way for you to say "go away" to
> us... Expecting newcomers to kernel work to basically clean up an
> entire kernel subsystem, dealing with all the politics involved is
> just not going to work.

Once upon a time, a newbish kernel hacker named Andy wrote some code
to change the way the vDSO worked.  The maintainers told me that it
was a nice thought and that it was too messy and wasn't acceptable in
its present form.  So the patchset got quite a bit longer, I learned
more about the mess that was the vDSO, and I fixed it.  The
maintainers were right.

It's just not the case that a newcomer gets to add fields to
task_struct that a more experienced developer wouldn't get to add.
Sorry.

>
> And again: I am very sure the proposed prctl() based solution is
> actually much much nicer than any procfs superblock based one, since
> it works naturally, and easily for unprivileged processes too!
> Anything that requires mount options means privileges are required in
> some form or another. Yes userns would open that up, but that comes
> with a huge amount of additional problems.

If you want to design a generic mechanism by which a task can change
the way that pseudo filesystems look for itself and its children
without using mount options, and you come up with something that is
sane, safe, generic, and reasonable clean, you're welcome to do so.
This sounds like a considerably more challenging undertaking than just
fixing procfs.

>
> Anyway, I understand it is your intention to derail this. I can accept
> that. It's a pity though.

I have no intention of derailing improvements to hidepid.  In fact,
I'd love to see improvements here.  I'm just saying that the current
proposal isn't the way to do it.
