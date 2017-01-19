From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Thu, 19 Jan 2017 11:52:54 -0800
Message-ID: <CALCETrUp9CBWykRUQoJOXeLg9u45H+2VWyQ_BKAhwc9OpBYn+g@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
 <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com>
 <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com>
 <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com> <CAEiveUevjijnmr7oWzQexi52nJm-BjVwAkb3fJinAbet=QvzxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAEiveUevjijnmr7oWzQexi52nJm-BjVwAkb3fJinAbet=QvzxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Lafcadio Wluiki <wluikil@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 19, 2017 at 5:53 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
> On Thu, Jan 19, 2017 at 12:35 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Wed, Jan 18, 2017 at 2:50 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
>>>> Also, this one-way thing seems wrong to me.  I think it should roughly
>>>> follow the no_new_privs rules instead.  IOW, if you unshare your
>>>> pidns, it gets cleared.  Also, maybe you shouldn't be able to set it
>>>
>>> Andy I don't follow here, no_new_privs is never cleared right ? I
>>> can't see the corresponding clear bit code for it.
>>
>> I believe that unsharing userns clears no_new_privs.
> No, it is not cleared, and I can't see the clear bit for it. Maybe due
> to userns+filesystems limitations it was not noticed.

Hmm, maybe I remembered wrong.

>> I feel like this feature (per-task hidepid) is subtle and complex
>> enough that it should have a very clear purpose and use case before
>> it's merged and that we should make sure that there isn't a better way
>> to accomplish what you're trying to do.
>
> Sure, the hidepid mount option is old enough, and this per-task
> hidepid is clearly defined only for procfs and per task, we can't add
> another switch that's relate to both a filesystem and pid namespaces,
> it will be a bit complicated and not really useful for cases that are
> in *same* pidns where *each* one have to mount its procfs, it will
> propagate. Also as noted by Lafcadio, the gid thing is a bit hard to
> use now.

What I'm trying to say is that I want to understand a complete,
real-world use case.  Adding a security-related per-task flag is can
be quite messy and requires a lot of careful thought to get right, and
I'd rather avoid it if at all possible.

I'm imaging something like a new RestrictPidVisisbility= option in
systemd.  I agree that this is currently a mess to do.  But maybe a
simpler solution would be to add a new mount option local_hidepid to
procfs.  If you set that option, then it overrides hidepid for that
instance.  Most of these semi-sandboxed daemon processes already have
their own mount namespace, so the overhead should be minimal.

--Andy
