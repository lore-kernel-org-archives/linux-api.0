From: Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>
Subject: Re: [RFC v1 00/17] seccomp-object: From attack surface reduction
 to sandboxing
Date: Sat, 21 May 2016 17:19:52 +0200
Message-ID: <57407C98.3090508@iogearbox.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net> <CAGXu5jK1U12vMk11HD_x_gNz3Rk4ZgEfdThY7DHvm4e4sPRh4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jK1U12vMk11HD_x_gNz3Rk4ZgEfdThY7DHvm4e4sPRh4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk-ASgREoAs3yw@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Micka=C3=ABl,

[ sorry for commenting so late ... ]

On 04/28/2016 04:36 AM, Kees Cook wrote:
> On Wed, Mar 23, 2016 at 6:46 PM, Micka=C3=ABl Sala=C3=BCn <mic@digiko=
d.net> wrote:
>> Hi,
>>
>> This series is a proof of concept (not ready for production) to exte=
nd seccomp
>> with the ability to check argument pointers of syscalls as kernel ob=
ject (e.g.
>> file path). This add a needed feature to create a full sandbox manag=
ed by
>> userland like the Seatbelt/XNU Sandbox or the OpenBSD Pledge. It was=
 initially
>> inspired from a partial seccomp-LSM prototype [1] but has evolved a =
lot since :)
>>
>> The audience for this RFC is limited to security-related actors to d=
iscuss
>> about this new feature before enlarging the scope to a wider audienc=
e. This
>> aims to focus on the security goal, usability and architecture befor=
e entering
>> into the gory details of each subsystem. I also wish to get construc=
tive
>> criticisms about the userland API and intrusiveness of the code (and=
 what could
>> be the other ways to do it better) before going further (and address=
ing the
>> TODO and FIXME in the code).
>>
>> The approach taken is to add the minimum amount of code while still =
allowing
>> the userland to create access rules via seccomp. The current limitat=
ion of
>> seccomp is to get raw syscall arguments value but there is no way to
>> dereference a pointer to check its content (e.g. the first argument =
of the open
>> syscall). This seccomp evolution brings a generic way to check again=
st argument
>> pointer regardless from the syscall unlike current LSMs.
>
> Okay, I've read through this whole series now (sorry for the huge
> delay). I think that it is overly complex for what it results in
> providing. Here are some background thoughts I had:
>
> 1) People have asked for "dereferenced argument inspection" (I will
> call this DAI...), in that they would like to be able to process
> arguments like how BPF traditionally processes packets. This series
> doesn't provide that. Rather, it provides static checks against
> specific arguments types (currently just path checks).
>
> 2) When I dig into the requirements people have around DAI, it's
> mostly about checking path names. There is some interest in some of
> the network structures, but mostly it's path names. This series
> certainly underscores this since your first example is path names. :)

Out of curiosity, did you have a look whether adding some very basic
eBPF support for seccomp-BPF could also enable you for the option of
inspecting arguments eventually?

With basic, I mean adding new eBPF program type BPF_PROG_TYPE_SECCOMP
and the only things allowed would be to use a very limited set of
helpers. No maps, etc allowed for this type. If needed for extracting
args, you could extend struct seccomp_data for eBPF use, and add new
set of helper functions that would allow you to extract/walk arguments,
and, for example, pass the extracted buffer back to the eBPF prog for
further inspection.

Have a look at samples in [1,2], which are for tracing though, but poss=
ibly
it could be designed in a more or less similar way, where clang compile=
s
this policy down into eBPF bytecode. Did you have a look at this direct=
ion
or any thoughts on it?

   [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/=
tree/samples/bpf/tracex5_kern.c
   [2] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/=
tree/samples/bpf/tracex1_kern.c

> 3) Solving ToCToU should also solve performance problems. For example=
,
> this series, on a successful syscall, will look up a pathname twice
> (once in seccomp, then again in the syscall, and then compares the
> results in the LSM as a ToCToU back-stop). This seems like a waste of
> effort, since this reimplements the work the kernel is already doing
> to pass the resulting structure to the LSM hooks. As such, since this
> series is doing static checks and not allowing byte processing for
> DAI, I'm convinced that it should entirely happen in the LSM hooks.
>
> 4) Performing the checks in the LSM hooks carries a risk of exposing
> the syscall's argument processing code to an attacker, but I think
> that is okay since very similar code would already need to be written
> to do the same thing before entering the syscall. The only way out of
> this, I think, would be to standardize syscall argument processing.
>
> 5) If we can standardize syscall argument processing, we could also
> change when it happens, and retain the results for the syscall,
> allowing for full byte processing style of DAI. e.g. copy userspace t=
o
> kernel space, do BPF on the argument, if okay, pass the kernel copy t=
o
> the syscall where it continues the processing. If the kernel copy
> wasn't already created by seccomp, the syscall would just make that
> copy itself, etc.
>
> So, I see DAI as going one of two ways:
>
> a) rewrite all syscall entry to use a common cacheable argument parse=
r
> and offering true BPF processing of the argument bytes.
>
> b) use the existing LSM hooks and define a policy language that can b=
e
> loaded ahead of time.
>
> Doing "a" has many problems, I think. Not the least of which is that =
I
> can't imagine a way for such an architectural change to not have
> negative performance impacts for the regular case.
>
> Doing "b" means writing a policy engine. I would expect it to look a
> lot like either AppArmor or TOMOYO. TOMOYO has network structure
> processing, so probably it would look more like TOMOYO if you wanted
> more than just file paths. Maybe a seccomp LSM could share logic from
> one of the existing path-based LSMs.
>
> Another note I had for this series was that because the checker tries
> to keep a cached struct path, it allows unprivileged users to check
> for path names existing or not, regardless of the user's permissions.
> Instead, you have to check the path against the policy each time.
> AppArmor does this efficiently with a pre-built deterministic finite
> automatons (built from regular expressions), and TOMOYO just does
> string compares and limited glob parsing every time.
>
> So, I can't take this as-is, but I'll take the one fix near the start=
=2E
> :) I hope this isn't too discouraging, since I'd love to see this
> solved. Hopefully you can keep chipping away at it!
> Thanks!
>
> -Kees
>
