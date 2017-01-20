From: Lafcadio Wluiki <wluikil@gmail.com>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Fri, 20 Jan 2017 16:56:24 +0100
Message-ID: <CAOWbf6cF23UGugNGb4wc9KNK7Yb4BG=V7yTnOP61+h2q5dA-nQ@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
 <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com>
 <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com>
 <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com>
 <CAEiveUevjijnmr7oWzQexi52nJm-BjVwAkb3fJinAbet=QvzxQ@mail.gmail.com> <CALCETrUp9CBWykRUQoJOXeLg9u45H+2VWyQ_BKAhwc9OpBYn+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUp9CBWykRUQoJOXeLg9u45H+2VWyQ_BKAhwc9OpBYn+g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Djalal Harouni <tixxdz@gmail.com>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 19, 2017 at 8:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:

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
>
> I'm imaging something like a new RestrictPidVisisbility= option in
> systemd.  I agree that this is currently a mess to do.  But maybe a

It's not just a "mess" to do, it's not possible afaics. The hidepid
thing is after all not really a mount option, but an option of the pid
namespace. Hence, if you want to restrict the visibility for one
service only, then you have to get your own PID namespace, but that
does a lot more than just hide visibility: it renumbers everything
after all...

> simpler solution would be to add a new mount option local_hidepid to
> procfs.  If you set that option, then it overrides hidepid for that
> instance.  Most of these semi-sandboxed daemon processes already have
> their own mount namespace, so the overhead should be minimal.

When I worked on the patches originally, I actually wanted to
implement this as true per-superblock procfs mount option. But this is
really hard to do, as the private superblock pointer of the procfs
instance currently points to the pid namespace, and breaking that up,
so that you can have multiple procfs superblocks per pid namespace is
a ton of work, and I doubt anyone would really like the complexity
this brings, just for adding a single 2bit option...

The per-process option is much simpler code-wise. It also has
semantical benefits: if the thing isn't a mount option it is
accessible with absolutely minimal privileges, as it does not imply
namespaces and mounting. This means, my Firefox can run with hidepid
turned on without my KDE Konsole instance also having to turn it on.
Or to say this differently: your suggested RestrictPidVisibility=
works nicely both for "systemd" as PID 1 and for "systemd --user" as
user "lafcadio", when it is per-process, but is much more complex to
implement if it was a true mount option.

L.
