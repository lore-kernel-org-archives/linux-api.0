From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH bpf-next v8 05/11] seccomp,landlock: Enforce Landlock
 programs per process hierarchy
Date: Tue, 27 Feb 2018 22:48:14 +0100
Message-ID: <ab8dda73-4a6e-4e10-cda0-3e91c5019a63@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
 <20180227004121.3633-6-mic@digikod.net>
 <20180227020856.teq4hobw3zwussu2@ast-mbp>
 <CALCETrVKRYnGJ9XNW-x7eHdMt+eGP90j7cAed-KTzp1KT_kMeQ@mail.gmail.com>
 <20180227045458.wjrbbsxf3po656du@ast-mbp>
 <CALCETrXZ=xJEd53RhA67_VDoAKBWgUeyBi9XN7ibrE7V6nzk5Q@mail.gmail.com>
 <20180227053255.a7ua24kjd6tvei2a@ast-mbp>
 <CALCETrUqc0wbig4ntQe9KNS-fOgYOpD+MPodXYruCRyJ7bhagA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="ESjYG37a7HMlzA6jvwvgG0E5hf6jsyPcT"
Return-path: <kernel-hardening-return-12016-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrUqc0wbig4ntQe9KNS-fOgYOpD+MPodXYruCRyJ7bhagA@mail.gmail.com>
To: Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ESjYG37a7HMlzA6jvwvgG0E5hf6jsyPcT
Content-Type: multipart/mixed; boundary="Ffhu0e8id3FY0vYUzxb23jBd9hDEvTORe";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Andy Lutomirski <luto@kernel.org>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Daniel Borkmann <daniel@iogearbox.net>, David Drysdale
 <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>,
 "Eric W . Biederman" <ebiederm@xmission.com>, Jann Horn <jann@thejh.net>,
 Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>,
 Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>,
 Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>,
 Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
 Will Drewry <wad@chromium.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 LSM List <linux-security-module@vger.kernel.org>,
 Network Development <netdev@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Message-ID: <ab8dda73-4a6e-4e10-cda0-3e91c5019a63@digikod.net>
Subject: Re: [PATCH bpf-next v8 05/11] seccomp,landlock: Enforce Landlock
 programs per process hierarchy
References: <20180227004121.3633-1-mic@digikod.net>
 <20180227004121.3633-6-mic@digikod.net>
 <20180227020856.teq4hobw3zwussu2@ast-mbp>
 <CALCETrVKRYnGJ9XNW-x7eHdMt+eGP90j7cAed-KTzp1KT_kMeQ@mail.gmail.com>
 <20180227045458.wjrbbsxf3po656du@ast-mbp>
 <CALCETrXZ=xJEd53RhA67_VDoAKBWgUeyBi9XN7ibrE7V6nzk5Q@mail.gmail.com>
 <20180227053255.a7ua24kjd6tvei2a@ast-mbp>
 <CALCETrUqc0wbig4ntQe9KNS-fOgYOpD+MPodXYruCRyJ7bhagA@mail.gmail.com>
In-Reply-To: <CALCETrUqc0wbig4ntQe9KNS-fOgYOpD+MPodXYruCRyJ7bhagA@mail.gmail.com>

--Ffhu0e8id3FY0vYUzxb23jBd9hDEvTORe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


On 27/02/2018 17:39, Andy Lutomirski wrote:
> On Tue, Feb 27, 2018 at 5:32 AM, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>> On Tue, Feb 27, 2018 at 05:20:55AM +0000, Andy Lutomirski wrote:
>>> On Tue, Feb 27, 2018 at 4:54 AM, Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>>>> On Tue, Feb 27, 2018 at 04:40:34AM +0000, Andy Lutomirski wrote:
>>>>> On Tue, Feb 27, 2018 at 2:08 AM, Alexei Starovoitov
>>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>> On Tue, Feb 27, 2018 at 01:41:15AM +0100, Micka=C3=ABl Sala=C3=BCn=
 wrote:
>>>>>>> The seccomp(2) syscall can be used by a task to apply a Landlock =
program
>>>>>>> to itself. As a seccomp filter, a Landlock program is enforced fo=
r the
>>>>>>> current task and all its future children. A program is immutable =
and a
>>>>>>> task can only add new restricting programs to itself, forming a l=
ist of
>>>>>>> programss.
>>>>>>>
>>>>>>> A Landlock program is tied to a Landlock hook. If the action on a=
 kernel
>>>>>>> object is allowed by the other Linux security mechanisms (e.g. DA=
C,
>>>>>>> capabilities, other LSM), then a Landlock hook related to this ki=
nd of
>>>>>>> object is triggered. The list of programs for this hook is then
>>>>>>> evaluated. Each program return a 32-bit value which can deny the =
action
>>>>>>> on a kernel object with a non-zero value. If every programs of th=
e list
>>>>>>> return zero, then the action on the object is allowed.
>>>>>>>
>>>>>>> Multiple Landlock programs can be chained to share a 64-bits valu=
e for a
>>>>>>> call chain (e.g. evaluating multiple elements of a file path).  T=
his
>>>>>>> chaining is restricted when a process construct this chain by loa=
ding a
>>>>>>> program, but additional checks are performed when it requests to =
apply
>>>>>>> this chain of programs to itself.  The restrictions ensure that i=
t is
>>>>>>> not possible to call multiple programs in a way that would imply =
to
>>>>>>> handle multiple shared values (i.e. cookies) for one chain.  For =
now,
>>>>>>> only a fs_pick program can be chained to the same type of program=
,
>>>>>>> because it may make sense if they have different triggers (cf. ne=
xt
>>>>>>> commits).  This restrictions still allows to reuse Landlock progr=
ams in
>>>>>>> a safe way (e.g. use the same loaded fs_walk program with multipl=
e
>>>>>>> chains of fs_pick programs).
>>>>>>>
>>>>>>> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>>>>>>
>>>>>> ...
>>>>>>
>>>>>>> +struct landlock_prog_set *landlock_prepend_prog(
>>>>>>> +             struct landlock_prog_set *current_prog_set,
>>>>>>> +             struct bpf_prog *prog)
>>>>>>> +{
>>>>>>> +     struct landlock_prog_set *new_prog_set =3D current_prog_set=
;
>>>>>>> +     unsigned long pages;
>>>>>>> +     int err;
>>>>>>> +     size_t i;
>>>>>>> +     struct landlock_prog_set tmp_prog_set =3D {};
>>>>>>> +
>>>>>>> +     if (prog->type !=3D BPF_PROG_TYPE_LANDLOCK_HOOK)
>>>>>>> +             return ERR_PTR(-EINVAL);
>>>>>>> +
>>>>>>> +     /* validate memory size allocation */
>>>>>>> +     pages =3D prog->pages;
>>>>>>> +     if (current_prog_set) {
>>>>>>> +             size_t i;
>>>>>>> +
>>>>>>> +             for (i =3D 0; i < ARRAY_SIZE(current_prog_set->prog=
rams); i++) {
>>>>>>> +                     struct landlock_prog_list *walker_p;
>>>>>>> +
>>>>>>> +                     for (walker_p =3D current_prog_set->program=
s[i];
>>>>>>> +                                     walker_p; walker_p =3D walk=
er_p->prev)
>>>>>>> +                             pages +=3D walker_p->prog->pages;
>>>>>>> +             }
>>>>>>> +             /* count a struct landlock_prog_set if we need to a=
llocate one */
>>>>>>> +             if (refcount_read(&current_prog_set->usage) !=3D 1)=

>>>>>>> +                     pages +=3D round_up(sizeof(*current_prog_se=
t), PAGE_SIZE)
>>>>>>> +                             / PAGE_SIZE;
>>>>>>> +     }
>>>>>>> +     if (pages > LANDLOCK_PROGRAMS_MAX_PAGES)
>>>>>>> +             return ERR_PTR(-E2BIG);
>>>>>>> +
>>>>>>> +     /* ensure early that we can allocate enough memory for the =
new
>>>>>>> +      * prog_lists */
>>>>>>> +     err =3D store_landlock_prog(&tmp_prog_set, current_prog_set=
, prog);
>>>>>>> +     if (err)
>>>>>>> +             return ERR_PTR(err);
>>>>>>> +
>>>>>>> +     /*
>>>>>>> +      * Each task_struct points to an array of prog list pointer=
s.  These
>>>>>>> +      * tables are duplicated when additions are made (which mea=
ns each
>>>>>>> +      * table needs to be refcounted for the processes using it)=
=2E When a new
>>>>>>> +      * table is created, all the refcounters on the prog_list a=
re bumped (to
>>>>>>> +      * track each table that references the prog). When a new p=
rog is
>>>>>>> +      * added, it's just prepended to the list for the new table=
 to point
>>>>>>> +      * at.
>>>>>>> +      *
>>>>>>> +      * Manage all the possible errors before this step to not u=
selessly
>>>>>>> +      * duplicate current_prog_set and avoid a rollback.
>>>>>>> +      */
>>>>>>> +     if (!new_prog_set) {
>>>>>>> +             /*
>>>>>>> +              * If there is no Landlock program set used by the =
current task,
>>>>>>> +              * then create a new one.
>>>>>>> +              */
>>>>>>> +             new_prog_set =3D new_landlock_prog_set();
>>>>>>> +             if (IS_ERR(new_prog_set))
>>>>>>> +                     goto put_tmp_lists;
>>>>>>> +     } else if (refcount_read(&current_prog_set->usage) > 1) {
>>>>>>> +             /*
>>>>>>> +              * If the current task is not the sole user of its =
Landlock
>>>>>>> +              * program set, then duplicate them.
>>>>>>> +              */
>>>>>>> +             new_prog_set =3D new_landlock_prog_set();
>>>>>>> +             if (IS_ERR(new_prog_set))
>>>>>>> +                     goto put_tmp_lists;
>>>>>>> +             for (i =3D 0; i < ARRAY_SIZE(new_prog_set->programs=
); i++) {
>>>>>>> +                     new_prog_set->programs[i] =3D
>>>>>>> +                             READ_ONCE(current_prog_set->program=
s[i]);
>>>>>>> +                     if (new_prog_set->programs[i])
>>>>>>> +                             refcount_inc(&new_prog_set->program=
s[i]->usage);
>>>>>>> +             }
>>>>>>> +
>>>>>>> +             /*
>>>>>>> +              * Landlock program set from the current task will =
not be freed
>>>>>>> +              * here because the usage is strictly greater than =
1. It is
>>>>>>> +              * only prevented to be freed by another task thank=
s to the
>>>>>>> +              * caller of landlock_prepend_prog() which should b=
e locked if
>>>>>>> +              * needed.
>>>>>>> +              */
>>>>>>> +             landlock_put_prog_set(current_prog_set);
>>>>>>> +     }
>>>>>>> +
>>>>>>> +     /* prepend tmp_prog_set to new_prog_set */
>>>>>>> +     for (i =3D 0; i < ARRAY_SIZE(tmp_prog_set.programs); i++) {=

>>>>>>> +             /* get the last new list */
>>>>>>> +             struct landlock_prog_list *last_list =3D
>>>>>>> +                     tmp_prog_set.programs[i];
>>>>>>> +
>>>>>>> +             if (last_list) {
>>>>>>> +                     while (last_list->prev)
>>>>>>> +                             last_list =3D last_list->prev;
>>>>>>> +                     /* no need to increment usage (pointer repl=
acement) */
>>>>>>> +                     last_list->prev =3D new_prog_set->programs[=
i];
>>>>>>> +                     new_prog_set->programs[i] =3D tmp_prog_set.=
programs[i];
>>>>>>> +             }
>>>>>>> +     }
>>>>>>> +     new_prog_set->chain_last =3D tmp_prog_set.chain_last;
>>>>>>> +     return new_prog_set;
>>>>>>> +
>>>>>>> +put_tmp_lists:
>>>>>>> +     for (i =3D 0; i < ARRAY_SIZE(tmp_prog_set.programs); i++)
>>>>>>> +             put_landlock_prog_list(tmp_prog_set.programs[i]);
>>>>>>> +     return new_prog_set;
>>>>>>> +}
>>>>>>
>>>>>> Nack on the chaining concept.
>>>>>> Please do not reinvent the wheel.
>>>>>> There is an existing mechanism for attaching/detaching/quering mul=
tiple
>>>>>> programs attached to cgroup and tracing hooks that are also
>>>>>> efficiently executed via BPF_PROG_RUN_ARRAY.
>>>>>> Please use that instead.
>>>>>>
>>>>>
>>>>> I don't see how that would help.  Suppose you add a filter, then
>>>>> fork(), and then the child adds another filter.  Do you want to
>>>>> duplicate the entire array?  You certainly can't *modify* the array=

>>>>> because you'll affect processes that shouldn't be affected.
>>>>>
>>>>> In contrast, doing this through seccomp like the earlier patches
>>>>> seemed just fine to me, and seccomp already had the right logic.
>>>>
>>>> it doesn't look to me that existing seccomp side of managing fork
>>>> situation can be reused. Here there is an attempt to add 'chaining'
>>>> concept which sort of an extension of existing seccomp style,
>>>> but somehow heavily done on bpf side and contradicts cgroup/tracing.=

>>>>
>>>
>>> I don't see why the seccomp way can't be used.  I agree with you that=

>>> the seccomp *style* shouldn't be used in bpf code like this, but I
>>> think that Landlock programs can and should just live in the existing=

>>> seccomp chain.  If the existing seccomp code needs some modification
>>> to make this work, then so be it.
>>
>> +1
>> if that was the case...
>> but that's not my reading of the patch set.
>=20
> An earlier version of the patch set used the seccomp filter chain.
> Micka=C3=ABl, what exactly was wrong with that approach other than that=
 the
> seccomp() syscall was awkward for you to use?  You could add a
> seccomp_add_landlock_rule() syscall if you needed to.

Nothing was wrong about about that, this part did not changed (see my
next comment).

>=20
> As a side comment, why is this an LSM at all, let alone a non-stacking
> LSM?  It would make a lot more sense to me to make Landlock depend on
> having LSMs configured in but to call the landlock hooks directly from
> the security_xyz() hooks.

See Casey's answer and his patch series: https://lwn.net/Articles/741963/=


>=20
>>
>>> In other words, the kernel already has two kinds of chaining:
>>> seccomp's and bpf's.  bpf's doesn't work right for this type of usage=

>>> across fork(), whereas seccomp's already handles that case correctly.=

>>> (In contrast, seccomp's is totally wrong for cgroup-attached filters.=
)
>>>  So IMO Landlock should use the seccomp core code and call into bpf
>>> for the actual filtering.
>>
>> +1
>> in cgroup we had to invent this new BPF_PROG_RUN_ARRAY mechanism,
>> since cgroup hierarchy can be complicated with bpf progs attached
>> at different levels with different override/multiprog properties,
>> so walking link list and checking all flags at run-time would have
>> been too slow. That's why we added compute_effective_progs().
>=20
> If we start adding override flags to Landlock, I think we're doing it
> wrong.   With cgroup bpf programs, the whole mess is set up by the
> administrator.  With seccomp, and with Landlock if done correctly, it
> *won't* be set up by the administrator, so the chance that everyone
> gets all the flags right is about zero.  All attached filters should
> run unconditionally.


There is a misunderstanding about this chaining mechanism. This should
not be confused with the list of seccomp filters nor the cgroup
hierarchies. Landlock programs can be stacked the same way seccomp's
filters can (cf. struct landlock_prog_set, the "chain_last" field is an
optimization which is not used for this struct handling). This stackable
property did not changed from the previous patch series. The chaining
mechanism is for another use case, which does not make sense for seccomp
filters nor other eBPF program types, at least for now, from what I can
tell.

You may want to get a look at my talk at FOSDEM
(https://landlock.io/talks/2018-02-04_landlock-fosdem.pdf), especially
slides 11 and 12.

Let me explain my reasoning about this program chaining thing.

To check if an action on a file is allowed, we first need to identify
this file and match it to the security policy. In a previous
(non-public) patch series, I tried to use one type of eBPF program to
check every kind of access to a file. To be able to identify a file, I
relied on an eBPF map, similar to the current inode map. This map store
a set of references to file descriptors. I then created a function
bpf_is_file_beneath() to check if the requested file was beneath a file
in the map. This way, no chaining, only one eBPF program type to check
an access to a file... but some issues then emerged. First, this design
create a side-channel which help an attacker using such a program to
infer some information not normally available, for example to get a hint
on where a file descriptor (received from a UNIX socket) come from.
Another issue is that this type of program would be called for each
component of a path. Indeed, when the kernel check if an access to a
file is allowed, it walk through all of the directories in its path
(checking if the current process is allowed to execute them). That first
attempt led me to rethink the way we could filter an access to a file
*path*.

To minimize the number of called to an eBPF program dedicated to
validate an access to a file path, I decided to create three subtype of
eBPF programs. The FS_WALK type is called when walking through every
directory of a file path (except the last one if it is the target). We
can then restrict this type of program to the minimum set of functions
it is allowed to call and the minimum set of data available from its
context. The first implicit chaining is for this type of program. To be
able to evaluate a path while being called for all its components, this
program need to store a state (to remember what was the parent directory
of this path). There is no "previous" field in the subtype for this
program because it is chained with itself, for each directories. This
enable to create a FS_WALK program to evaluate a file hierarchy, thank
to the inode map which can be used to check if a directory of this
hierarchy is part of an allowed (or denied) list of directories. This
design enables to express a file hierarchy in a programmatic way,
without requiring an eBPF helper to do the job (unlike my first experimen=
t).

The explicit chaining is used to tied a path evaluation (with a FS_WALK
program) to an access to the actual file being requested (the last
component of a file path), with a FS_PICK program. It is only at this
time that the kernel check for the requested action (e.g. read, write,
chdir, append...). To be able to filter such access request we can have
one call to the same program for every action and let this program check
for which action it was called. However, this design does not allow the
kernel to know if the current action is indeed handled by this program.
Hence, it is not possible to implement a cache mechanism to only call
this program if it knows how to handle this action.

The approach I took for this FS_PICK type of program is to add to its
subtype which action it can handle (with the "triggers" bitfield, seen
as ORed actions). This way, the kernel knows if a call to a FS_PICK
program is necessary. If the user wants to enforce a different security
policy according to the action requested on a file, then it needs
multiple FS_PICK programs. However, to reduce the number of such
programs, this patch series allow a FS_PICK program to be chained with
another, the same way a FS_WALK is chained with itself. This way, if the
user want to check if the action is a for example an "open" and a "read"
and not a "map" and a "read", then it can chain multiple FS_PICK
programs with different triggers actions. The OR check performed by the
kernel is not a limitation then, only a way to know if a call to an eBPF
program is needed.

The last type of program is FS_GET. This one is called when a process
get a struct file or change its working directory. This is the only
program type able (and allowed) to tag a file. This restriction is
important to not being subject to resource exhaustion attacks (i.e.
tagging every inode accessible to an attacker, which would allocate too
much kernel memory).

This design gives room for improvements to create a cache of eBPF
context (input data, including maps if any), with the result of an eBPF
program. This would help limit the number of call to an eBPF program the
same way SELinux or other kernel components do to limit costly checks.

The eBPF maps of progs are useful to call the same type of eBPF
program. It does not fit with this use case because we may want multiple
eBPF program according to the action requested on a kernel object (e.g.
FS_GET). The other reason is because the eBPF program does not know what
will be the next (type of) access check performed by the kernel.

To say it another way, this chaining mechanism is a way to split a
kernel object evaluation with multiple specialized programs, each of
them being able to deal with data tied to their type. Using a monolithic
eBPF program to check everything does not scale and does not fit with
unprivileged use either.

As a side note, the cookie value is only an ephemeral value to keep a
state between multiple programs call. It can be used to create a state
machine for an object evaluation.

I don't see a way to do an efficient and programmatic path evaluation,
with different access checks, with the current eBPF features. Please let
me know if you know how to do it another way.


--Ffhu0e8id3FY0vYUzxb23jBd9hDEvTORe--

--ESjYG37a7HMlzA6jvwvgG0E5hf6jsyPcT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAlqV0iYACgkQIt7+33O9
apXR1Qf9EznPsAir3/5ic0l1Ubilz8VdXThGY+37NGpuIOO/eThafCmyVRDq66DD
Ydeh0SK7v6k4pF7Vu2bOofRWMGD6u1ebQDB7nOmyTvf1Vi/YM4TRCY96lh1Y7WW3
YkTdjMTNk+yzKR+nGIcHd+burze6ujC/gGfrQO6LFKpUq69jiyhRlwIPWGeEgwkW
4Y5RFlHsLKqllKM2anHyAG95jMtcV3dFqlkyIuOqf018aVP17EmCk7IFYKLfF2ll
k7WvTfxMnNjBtTGTpR7WJYwarcA+WAmO2HLEe7/PFFsxOp9lL8e/skDkpaYChhfC
z08IinqYpT0xcnk0v14rpS7z6W9RyQ==
=yXci
-----END PGP SIGNATURE-----

--ESjYG37a7HMlzA6jvwvgG0E5hf6jsyPcT--
