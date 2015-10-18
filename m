From: Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Sun, 18 Oct 2015 22:13:54 +0200
Message-ID: <5623FD82.4030902@miglix.eu>
References: <5622700C.9090107@miglix.eu>
 <20151017215501.GA22900@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151017215501.GA22900-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 17.10.2015 23:55, Serge E. Hallyn wrote:
> On Sat, Oct 17, 2015 at 05:58:04PM +0200, Tobias Markus wrote:
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
> 
> Fwiw I'm not in favor of this.  Debian has a patch (I believe the one
> I originally wrote for Ubuntu but which Ubuntu dropped long ago) adding a
> sysctl, off by default, for enabling user namespaces.

While it certainly works, enabling a feature like this at runtime
doesn't seem like a long term solution.

The fact that Debian added this patch in the first place already
demonstrates that there is demand for a way to limit unpriviledged user
namespace creation. Please, don't get me wrong: I would *really like* to
see widespread adoption and continued development of user namespaces!
But the status quo remains: Distributions outright disabling user
namespaces (e.g. Arch Linux) won't make it easier.

> 
> Posix capabilities are intended for privileged actions, not for
> actions which explicitly should not require privilege, but which
> we feel are in development.
> 

Certainly, in an ideal world, user namespaces will never lead to any
kernel-level exploits. But reality is different: There *have been*
serious kernel vulnerabilities due to user namespaces, and there *will
be* serious kernel vulnerabilities due to user namespaces.

Now, those are the alternatives imho:

* Status quo: Some distributions will disable user namespaces by default
in some way or another. User wishing to use user namespaces will have to
use a custom kernel or enable a sysctl flag that was patched in by the
downstream developers. On distributions that enable user namespaces by
default, even users that don't wish to use them in the first places will
be affected by vulnerabilities.

* Adding a capabilitiy: First of all, there would be no need for any
downstream patches or custom kernels. Users that wish to use user
namespaces would only have to enable the capability on the affected
executables, if that hasn't been done by the package maintainers
already. Users that might not even know of user namespaces have their peace.

> In general, the feeling is that putting a feature like this behind a
> wall will only slow down the finding of any bugs, so I think the goal
> itself is questionable.  But the chosen means for achieving your goal
> are definately wrong.

I'm not talking about removing user namespaces altogether or making them
impossible to use - as I said above, user wouldn't notice anything in
the best case. Replacing setuid binaries with capabilitiy-based ones has
been done for quite some time now and I don't think anyone complained.

I honestly don't see why adding a new capability would slow down finding
bugs. Not every program magically profits from user namespaces. Why
would, say, GCC, date or vim improve by using user namespaces? My point
is that use cases for user namespaces won't magically rain down from
Heaven just because it possible to use them without priviledge. And it
is hardly difficult to add the capabilitiy to those applications that
use user namespaces, is it? setcap cap_sys_user_ns+ep $binary doesn't
sound very complicated to me.
I would actually say not adding this capability would slow down finding
bugs since users are less inclined to enable the feature if they can't
limit its security impact.

Furthermore, saying "let's enable this complex security-relevant feature
by default and make it impossible to limit it to certain files so users
will find more bugs" is fundamentally wrong approach to security imho.
First, you aren't likely to get more bug reports because distributions
aren't that risky. Second, even if you get more bug reports, _the damage
is already done_. Sysadmins won't be that happy and will very likely
disable the very feature that caused the damage in the first place.

> 
>> Both options, user namespaces with and without CAP_SYS_ADMIN, can be
>> said to represent the extreme end of the spectrum. In practice, there is
>> no reason for every process to have the abilitiy to create user
>> namespaces. Indeed, only very few and specialized programs require user
> 
> There is.  One of Eric's primary motivations for user namespaces was to
> finally allow unprivileged users to safely do things like manipulate
> their mounts tree without the risk of privileged (setuid) programs
> being tricked.
> 
> -serge
