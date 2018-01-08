From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?=
        <maheshb@google.com>
Subject: Re: [PATCHv3 0/2] capability controlled user-namespaces
Date: Mon, 8 Jan 2018 09:21:42 -0800
Message-ID: <CAF2d9jgVJpuAH+jgK0v7sQ9Pr75xy=GSnqKDdpeE7d97O0EbcQ@mail.gmail.com>
References: <20171205223052.12687-1-mahesh@bandewar.net> <CAF2d9jit74_VCdD-pEFy3bJo2W1-0cDo0BOJC5beJiy8yFPCWg@mail.gmail.com>
 <alpine.LFD.2.20.1712301931360.24310@localhost> <CAF2d9jiPYvMN=_guoZHyTA5FmMgaJb5mtxroi5D9NvcNrHc5gg@mail.gmail.com>
 <alpine.LFD.2.20.1801081131190.8436@localhost> <20180108062452.GA21717@mail.hallyn.com>
 <alpine.LFD.2.20.1801082040180.12014@localhost> <20180108154733.GA29416@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180108154733.GA29416@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: James Morris <james.l.morris@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Mahesh Bandewar <mahesh@bandewar.net>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 8, 2018 at 7:47 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting James Morris (james.l.morris@oracle.com):
>> On Mon, 8 Jan 2018, Serge E. Hallyn wrote:
>>
>> > > Also, why do we need the concept of a controlled user-ns at all, if the
>> > > default whitelist maintains existing behavior?
>> >
>> > In past discussions two uses have been brought up:
>> >
>> > 1. if an 0-day is discovered which is exacerbated by a specific
>> > privilege in user namespaces, that privilege could be turned off until a
>> > reboot with a fixed kernel is scheduled, without fully disabling all
>> > containers.
>> >
>> > 2. some systems may be specifically designed to run software which
>> > only requires a few capabilities in a userns.  In that case all others
>> > could be disabled.
>> >
>>
>> I meant in terms of "marking" a user ns as "controlled" type -- it's
>> unnecessary jargon from an end user point of view.
>
> Ah, yes, that was my point in
>
> http://lkml.iu.edu/hypermail/linux/kernel/1711.1/01845.html
> and
> http://lkml.iu.edu/hypermail/linux/kernel/1711.1/02276.html
>
>> This may happen internally but don't make it a special case with a
>> different name and don't bother users with internal concepts: simply
>> implement capability whitelists with the default having equivalent
>> behavior of everything allowed.  Then, document the semantics of the
>> whitelist in terms of inheritance etc., as a feature of user namespaces,
>> not as a "type" of user namespace.
>
> The problem with making them inheritable is that an adversarial user
> can just create a user namespace at boot that sits and waits for an
> 0day to be published, then log in and attach to that namespace later,
> since it has already inherited the open whitelist.
>
> It feels like there must be some other approach that doesn't feel as...
> band-aid-y as this does, but I'm not sure what.

We had a long discussion thread about this approach in the past and
many of these points have been discussed there. Serge is to the point
in terms of both the points (0-day issue as well as sandbox
environment). At this moment we are exposed to those threats and apart
from this patch-set I'm not aware of anything that handles it. Of
course there are other alternatives that block user-ns creation
altogether but blocking user-ns is not a real solution that works in
every use-case. I'm open other ideas (if any) that do not block
creation of user-ns, but lack of those will keep the 0-day issue
lingering especially for environments where 'user-ns creation' is used
heavily.

'Controlled-user-ns' jargon is within the kernel-space and is not
exposed to the users (we don't have any API to do that), but I used
those terms to explain within the kernel-community what this patch-set
is trying to do. The user-application does not need nor need to know
any of these changes as such. However, this additional knob gives
admin an ability to control their behavior in those two circumstances.
The default behavior that chose in this patch-set is so that it
doesn't cause regression to anyone whatever is their use case is but
now admin can set whatever default behavior they wish in the
boot-scripts to suite their needs.

Thanks,
--mahesh..
