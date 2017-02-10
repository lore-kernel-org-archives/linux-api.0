From: Lafcadio Wluiki <wluikil@gmail.com>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Fri, 10 Feb 2017 15:40:47 +0100
Message-ID: <CAOWbf6f-3Ha3dkNuTfar0-u1SdSu=gDt0tK3Wq9+f9LZqB4gMQ@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
 <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com>
 <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com>
 <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com>
 <CAEiveUevjijnmr7oWzQexi52nJm-BjVwAkb3fJinAbet=QvzxQ@mail.gmail.com>
 <CALCETrUp9CBWykRUQoJOXeLg9u45H+2VWyQ_BKAhwc9OpBYn+g@mail.gmail.com>
 <CAEiveUdOdMr=gJZsi=Fx-CNeC8jkyi8XxC+qSG-LXWj3o2t=_A@mail.gmail.com> <CALCETrX_K7XdyCRo1RSLySRu-2uySaR2+3J7qcw4O+JOepTwag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6467-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrX_K7XdyCRo1RSLySRu-2uySaR2+3J7qcw4O+JOepTwag@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Djalal Harouni <tixxdz@gmail.com>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jan 21, 2017 at 1:53 AM, Andy Lutomirski <luto@amacapital.net> wrote:

> I agree that the kernel change to do it per task is very simple.  But
> this is an unfortunate slippery slope.  What if you want to block off
> everything in /proc that isn't associated with a PID?  What if you
> want to suppress /sys access?  What if you want ot block *all*
> non-current PIDs from being revealed in /proc?  What if you want to
> hide /proc/PID/cmdline?

These are all what-ifs that noone was interested in so far. I have a
very specific itch I want to scratch, and I found a reasonably generic
concept of exposing it. But now you are trying to lead this all down
onto a paths asking for features noone is actually really interested
in.

> I think that the right solution here is to fix procfs to understand
> per-superblock mount options.

Andy, this is really not helpful. Doing that is far from easy, that's
a major undertaking: asking us to rework procfs in such a major way I
only can understand as an indirect way for you to say "go away" to
us... Expecting newcomers to kernel work to basically clean up an
entire kernel subsystem, dealing with all the politics involved is
just not going to work.

And again: I am very sure the proposed prctl() based solution is
actually much much nicer than any procfs superblock based one, since
it works naturally, and easily for unprivileged processes too!
Anything that requires mount options means privileges are required in
some form or another. Yes userns would open that up, but that comes
with a huge amount of additional problems.

Anyway, I understand it is your intention to derail this. I can accept
that. It's a pity though.

L.
