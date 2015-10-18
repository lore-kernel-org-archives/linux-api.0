From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Sun, 18 Oct 2015 22:48:25 +0200
Message-ID: <56240599.3050903@nod.at>
References: <5622700C.9090107@miglix.eu>
 <CAFLxGvzJONWTbpD8GFfDWDQiPxONrFaRAuXonXXUWaR1pcTUgw@mail.gmail.com>
 <5623FD86.2030609@miglix.eu> <5623FF36.8080800@nod.at>
 <562403E7.6070300@miglix.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <562403E7.6070300@miglix.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Tobias Markus <tobias@miglix.eu>
Cc: LKML <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Andrew Morton <akpm@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Christoph Lameter <cl@linux.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, LSM <linux-security-module@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Am 18.10.2015 um 22:41 schrieb Tobias Markus:
> On 18.10.2015 22:21, Richard Weinberger wrote:
>> Am 18.10.2015 um 22:13 schrieb Tobias Markus:
>>> On 17.10.2015 22:17, Richard Weinberger wrote:
>>>> On Sat, Oct 17, 2015 at 5:58 PM, Tobias Markus <tobias@miglix.eu> wrote:
>>>>> One question remains though: Does this break userspace executables that
>>>>> expect being able to create user namespaces without priviledge? Since
>>>>> creating user namespaces without CAP_SYS_ADMIN was not possible before
>>>>> Linux 3.8, programs should already expect a potential EPERM upon calling
>>>>> clone. Since creating a user namespace without CAP_SYS_USER_NS would
>>>>> also cause EPERM, we should be on the safe side.
>>>>
>>>> In case of doubt, yes it will break existing software.
>>>> Hiding user namespaces behind CAP_SYS_USER_NS will not magically
>>>> make them secure.
>>>>
>>> The goal is not to make user namespaces secure, but to limit access to
>>> them somewhat in order to reduce the potential attack surface.
>>
>> We have already a framework to reduce the attack surface, seccomp.
>> There is no need to invent new capabilities for every non-trivial
>> kernel feature.
>>
>> I can understand the user namespaces seems scary and had bugs.
>> But which software didn't?
>>
>> Are there any unfixed exploitable bugs in user namespaces in recent kerenls?
>>
>> Thanks,
>> //richard
> 
> Isn't seccomp about setting a per-thread syscall filter? Correct me if
> I'm wrong, but I don't know of any way of using seccomp to globally ban
> the use of clone or unshare with CLONE_NEWUSER except for a few
> whiteliste executables, and that's the idea of this hypothetical capability.

This is correct.
If you want it globally you can still use LSM.

> Sure, there are no known exploitable bugs in recent kernels, but would
> you guarantee that for the next 10 years? Every software has bugs, some
> of them exploitable, no amount of testing can prevent that. I'm not
> paranoid, but on the other hand, why should every Linux user having
> CONFIG_USER_NS enabled have to expose more attack surface than he
> absolutely has to?

And what about all the other kernel features?
I really don't get why you choose user namespaces as your enemy.

> Richard, would you run an Apache HTTP server exposed to the internet on
> your own laptop, without any security precautions? According to your
> reasoning, Apache is surely scary and has many bugs, but every software
> has bugs, right?

This argument is bogus and you know that too.

> I really don't want to introduce a user-facing API change just for the
> fun of it - so if there's any better way to do this, please tell me.

As I said, it really don't see why we should treat user namespaces in a special
way. It is a kernel feature like many others are. If you don't trust it, disable it.

Thanks,
//richard
