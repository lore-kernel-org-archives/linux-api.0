From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC v1 00/17] seccomp-object: From attack surface reduction to sandboxing
Date: Wed, 27 Apr 2016 19:36:48 -0700
Message-ID: <CAGXu5jK1U12vMk11HD_x_gNz3Rk4ZgEfdThY7DHvm4e4sPRh4g@mail.gmail.com>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458784008-16277-1-git-send-email-mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk-ASgREoAs3yw@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 23, 2016 at 6:46 PM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.=
net> wrote:
> Hi,
>
> This series is a proof of concept (not ready for production) to exten=
d seccomp
> with the ability to check argument pointers of syscalls as kernel obj=
ect (e.g.
> file path). This add a needed feature to create a full sandbox manage=
d by
> userland like the Seatbelt/XNU Sandbox or the OpenBSD Pledge. It was =
initially
> inspired from a partial seccomp-LSM prototype [1] but has evolved a l=
ot since :)
>
> The audience for this RFC is limited to security-related actors to di=
scuss
> about this new feature before enlarging the scope to a wider audience=
=2E This
> aims to focus on the security goal, usability and architecture before=
 entering
> into the gory details of each subsystem. I also wish to get construct=
ive
> criticisms about the userland API and intrusiveness of the code (and =
what could
> be the other ways to do it better) before going further (and addressi=
ng the
> TODO and FIXME in the code).
>
> The approach taken is to add the minimum amount of code while still a=
llowing
> the userland to create access rules via seccomp. The current limitati=
on of
> seccomp is to get raw syscall arguments value but there is no way to
> dereference a pointer to check its content (e.g. the first argument o=
f the open
> syscall). This seccomp evolution brings a generic way to check agains=
t argument
> pointer regardless from the syscall unlike current LSMs.

Okay, I've read through this whole series now (sorry for the huge
delay). I think that it is overly complex for what it results in
providing. Here are some background thoughts I had:

1) People have asked for "dereferenced argument inspection" (I will
call this DAI...), in that they would like to be able to process
arguments like how BPF traditionally processes packets. This series
doesn't provide that. Rather, it provides static checks against
specific arguments types (currently just path checks).

2) When I dig into the requirements people have around DAI, it's
mostly about checking path names. There is some interest in some of
the network structures, but mostly it's path names. This series
certainly underscores this since your first example is path names. :)

3) Solving ToCToU should also solve performance problems. For example,
this series, on a successful syscall, will look up a pathname twice
(once in seccomp, then again in the syscall, and then compares the
results in the LSM as a ToCToU back-stop). This seems like a waste of
effort, since this reimplements the work the kernel is already doing
to pass the resulting structure to the LSM hooks. As such, since this
series is doing static checks and not allowing byte processing for
DAI, I'm convinced that it should entirely happen in the LSM hooks.

4) Performing the checks in the LSM hooks carries a risk of exposing
the syscall's argument processing code to an attacker, but I think
that is okay since very similar code would already need to be written
to do the same thing before entering the syscall. The only way out of
this, I think, would be to standardize syscall argument processing.

5) If we can standardize syscall argument processing, we could also
change when it happens, and retain the results for the syscall,
allowing for full byte processing style of DAI. e.g. copy userspace to
kernel space, do BPF on the argument, if okay, pass the kernel copy to
the syscall where it continues the processing. If the kernel copy
wasn't already created by seccomp, the syscall would just make that
copy itself, etc.

So, I see DAI as going one of two ways:

a) rewrite all syscall entry to use a common cacheable argument parser
and offering true BPF processing of the argument bytes.

b) use the existing LSM hooks and define a policy language that can be
loaded ahead of time.

Doing "a" has many problems, I think. Not the least of which is that I
can't imagine a way for such an architectural change to not have
negative performance impacts for the regular case.

Doing "b" means writing a policy engine. I would expect it to look a
lot like either AppArmor or TOMOYO. TOMOYO has network structure
processing, so probably it would look more like TOMOYO if you wanted
more than just file paths. Maybe a seccomp LSM could share logic from
one of the existing path-based LSMs.

Another note I had for this series was that because the checker tries
to keep a cached struct path, it allows unprivileged users to check
for path names existing or not, regardless of the user's permissions.
Instead, you have to check the path against the policy each time.
AppArmor does this efficiently with a pre-built deterministic finite
automatons (built from regular expressions), and TOMOYO just does
string compares and limited glob parsing every time.

So, I can't take this as-is, but I'll take the one fix near the start.
:) I hope this isn't too discouraging, since I'd love to see this
solved. Hopefully you can keep chipping away at it!
Thanks!

-Kees

--=20
Kees Cook
Chrome OS & Brillo Security
