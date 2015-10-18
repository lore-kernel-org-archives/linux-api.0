From: Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Sun, 18 Oct 2015 22:41:11 +0200
Message-ID: <562403E7.6070300@miglix.eu>
References: <5622700C.9090107@miglix.eu>
 <CAFLxGvzJONWTbpD8GFfDWDQiPxONrFaRAuXonXXUWaR1pcTUgw@mail.gmail.com>
 <5623FD86.2030609@miglix.eu> <5623FF36.8080800@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5623FF36.8080800-/L3Ra7n9ekc@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 18.10.2015 22:21, Richard Weinberger wrote:
> Am 18.10.2015 um 22:13 schrieb Tobias Markus:
>> On 17.10.2015 22:17, Richard Weinberger wrote:
>>> On Sat, Oct 17, 2015 at 5:58 PM, Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org> wrote:
>>>> One question remains though: Does this break userspace executables that
>>>> expect being able to create user namespaces without priviledge? Since
>>>> creating user namespaces without CAP_SYS_ADMIN was not possible before
>>>> Linux 3.8, programs should already expect a potential EPERM upon calling
>>>> clone. Since creating a user namespace without CAP_SYS_USER_NS would
>>>> also cause EPERM, we should be on the safe side.
>>>
>>> In case of doubt, yes it will break existing software.
>>> Hiding user namespaces behind CAP_SYS_USER_NS will not magically
>>> make them secure.
>>>
>> The goal is not to make user namespaces secure, but to limit access to
>> them somewhat in order to reduce the potential attack surface.
> 
> We have already a framework to reduce the attack surface, seccomp.
> There is no need to invent new capabilities for every non-trivial
> kernel feature.
> 
> I can understand the user namespaces seems scary and had bugs.
> But which software didn't?
> 
> Are there any unfixed exploitable bugs in user namespaces in recent kerenls?
> 
> Thanks,
> //richard

Isn't seccomp about setting a per-thread syscall filter? Correct me if
I'm wrong, but I don't know of any way of using seccomp to globally ban
the use of clone or unshare with CLONE_NEWUSER except for a few
whiteliste executables, and that's the idea of this hypothetical capability.

Sure, there are no known exploitable bugs in recent kernels, but would
you guarantee that for the next 10 years? Every software has bugs, some
of them exploitable, no amount of testing can prevent that. I'm not
paranoid, but on the other hand, why should every Linux user having
CONFIG_USER_NS enabled have to expose more attack surface than he
absolutely has to?

Richard, would you run an Apache HTTP server exposed to the internet on
your own laptop, without any security precautions? According to your
reasoning, Apache is surely scary and has many bugs, but every software
has bugs, right?

I really don't want to introduce a user-facing API change just for the
fun of it - so if there's any better way to do this, please tell me.
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
