From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Wed, 21 Oct 2015 11:53:31 -0700
Message-ID: <CALCETrWfZ9hXvLPtJnZhU-ZdoUbYNo-QSydMPvP6Q7Rp0oCQaw@mail.gmail.com>
References: <5622700C.9090107@miglix.eu> <5624FD3B.2050401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5624FD3B.2050401-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Oct 19, 2015 7:25 AM, "Austin S Hemmelgarn" <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On 2015-10-17 11:58, Tobias Markus wrote:
>>
>> Add capability CAP_SYS_USER_NS.
>> Tasks having CAP_SYS_USER_NS are allowed to create a new user namespace
>> when calling clone or unshare with CLONE_NEWUSER.
>>
>> Rationale:
>>
>> Linux 3.8 saw the introduction of unpriviledged user namespaces,
>> allowing unpriviledged users (without CAP_SYS_ADMIN) to be a "fake" root
>> inside a separate user namespace. Before that, any namespace creation
>> required CAP_SYS_ADMIN (or, in practice, the user had to be root).
>> Unfortunately, there have been some security-relevant bugs in the
>> meantime. Because of the fairly complex nature of user namespaces, it is
>> reasonable to say that future vulnerabilties can not be excluded. Some
>> distributions even wholly disable user namespaces because of this.
>>
>> Both options, user namespaces with and without CAP_SYS_ADMIN, can be
>> said to represent the extreme end of the spectrum. In practice, there is
>> no reason for every process to have the abilitiy to create user
>> namespaces. Indeed, only very few and specialized programs require user
>> namespaces. This seems to be a perfect fit for the (file) capability
>> system: Priviledged users could manually allow only a certain executable
>> to be able to create user namespaces by setting a certain capability,
>> I'd suggest the name CAP_SYS_USER_NS. Executables completely unrelated
>> to user namespaces should and can not create them.
>>
>> The capability should only be required in the "root" user namespace (the
>> user namespace with level 0) though, to allow nested user namespaces to
>> work as intended. If a user namespace has a level greater than 0, the
>> original process must have had CAP_SYS_USER_NS, so it is "trusted" anyway.
>>
>> One question remains though: Does this break userspace executables that
>> expect being able to create user namespaces without priviledge? Since
>> creating user namespaces without CAP_SYS_ADMIN was not possible before
>> Linux 3.8, programs should already expect a potential EPERM upon calling
>> clone. Since creating a user namespace without CAP_SYS_USER_NS would
>> also cause EPERM, we should be on the safe side.
>
>
> Potentially stupid counter proposal:
> Make it CAP_SYS_NS, make it allow access to all namespace types for non-root/CAP_SYS_ADMIN users, and teach the stuff that's using userns just to get to mount/pid/net/ipc namespaces to use those instead when it's something that doesn't really need to think it's running as root.
>
> While this would still add a new capability (which is arguably not a good thing), the resultant capability would be significantly more useful for many of the use cases.

Then you'd have to come up with some argument that it could possibly
be safe.  You'd need *at least* no_new_privs forced on.  You would
also have fun defining the privilege to own such a namespace once
created.

--Andy
