From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Thu, 22 Oct 2015 10:10:43 -0700
Message-ID: <CALCETrWzT2CaY3AUSTjWgzogRofW8p3-Rowjn=v4VisTrCrATw@mail.gmail.com>
References: <5622700C.9090107@miglix.eu> <5624FD3B.2050401@gmail.com>
 <CALCETrWfZ9hXvLPtJnZhU-ZdoUbYNo-QSydMPvP6Q7Rp0oCQaw@mail.gmail.com> <5627E3D3.1070407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5627E3D3.1070407@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Christoph Lameter <cl@linux.com>, Al Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, LSM List <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Tobias Markus <tobias@miglix.eu>, linux-man <linux-man@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 21, 2015 at 12:13 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-10-21 14:53, Andy Lutomirski wrote:
>>
>> On Oct 19, 2015 7:25 AM, "Austin S Hemmelgarn" <ahferroin7@gmail.com>
>> wrote:
>>>
>>>
>>> On 2015-10-17 11:58, Tobias Markus wrote:
>>>>
>>>>
>>>> Add capability CAP_SYS_USER_NS.
>>>> Tasks having CAP_SYS_USER_NS are allowed to create a new user namespace
>>>> when calling clone or unshare with CLONE_NEWUSER.
>>>>
>>>> Rationale:
>>>>
>>>> Linux 3.8 saw the introduction of unpriviledged user namespaces,
>>>> allowing unpriviledged users (without CAP_SYS_ADMIN) to be a "fake" root
>>>> inside a separate user namespace. Before that, any namespace creation
>>>> required CAP_SYS_ADMIN (or, in practice, the user had to be root).
>>>> Unfortunately, there have been some security-relevant bugs in the
>>>> meantime. Because of the fairly complex nature of user namespaces, it is
>>>> reasonable to say that future vulnerabilties can not be excluded. Some
>>>> distributions even wholly disable user namespaces because of this.
>>>>
>>>> Both options, user namespaces with and without CAP_SYS_ADMIN, can be
>>>> said to represent the extreme end of the spectrum. In practice, there is
>>>> no reason for every process to have the abilitiy to create user
>>>> namespaces. Indeed, only very few and specialized programs require user
>>>> namespaces. This seems to be a perfect fit for the (file) capability
>>>> system: Priviledged users could manually allow only a certain executable
>>>> to be able to create user namespaces by setting a certain capability,
>>>> I'd suggest the name CAP_SYS_USER_NS. Executables completely unrelated
>>>> to user namespaces should and can not create them.
>>>>
>>>> The capability should only be required in the "root" user namespace (the
>>>> user namespace with level 0) though, to allow nested user namespaces to
>>>> work as intended. If a user namespace has a level greater than 0, the
>>>> original process must have had CAP_SYS_USER_NS, so it is "trusted"
>>>> anyway.
>>>>
>>>> One question remains though: Does this break userspace executables that
>>>> expect being able to create user namespaces without priviledge? Since
>>>> creating user namespaces without CAP_SYS_ADMIN was not possible before
>>>> Linux 3.8, programs should already expect a potential EPERM upon calling
>>>> clone. Since creating a user namespace without CAP_SYS_USER_NS would
>>>> also cause EPERM, we should be on the safe side.
>>>
>>>
>>>
>>> Potentially stupid counter proposal:
>>> Make it CAP_SYS_NS, make it allow access to all namespace types for
>>> non-root/CAP_SYS_ADMIN users, and teach the stuff that's using userns just
>>> to get to mount/pid/net/ipc namespaces to use those instead when it's
>>> something that doesn't really need to think it's running as root.
>>>
>>> While this would still add a new capability (which is arguably not a good
>>> thing), the resultant capability would be significantly more useful for many
>>> of the use cases.
>>
>>
>> Then you'd have to come up with some argument that it could possibly
>> be safe.  You'd need *at least* no_new_privs forced on.  You would
>> also have fun defining the privilege to own such a namespace once
>> created.
>
> Excellent point about the privileges, although wouldn't that also apply to
> just using a capability for non-root/CAP_SYS_ADMIN access to userns?
>

I'm not sure I understand your question.

Allowing the owner of a userns(or a holder of sufficient privilege in
that namespace) to create other types of namespaces in that userns is
safe, as long as there are no bug left.  There are plenty of ways for
the creator of a network namespace, mount namespace, or similar to
corrupt the user namespace to which they belong, which is why
unprivileged userns creators can only create new namespaces of other
types within the userns that they control.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
