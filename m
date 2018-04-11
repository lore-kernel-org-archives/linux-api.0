From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH bpf-next v8 05/11] seccomp,landlock: Enforce Landlock
 programs per process hierarchy
Date: Thu, 12 Apr 2018 00:18:20 +0200
Message-ID: <a47530c5-6238-c270-b204-19ca94f49f7f@digikod.net>
References: <20180227020856.teq4hobw3zwussu2@ast-mbp>
 <CALCETrVKRYnGJ9XNW-x7eHdMt+eGP90j7cAed-KTzp1KT_kMeQ@mail.gmail.com>
 <20180227045458.wjrbbsxf3po656du@ast-mbp>
 <CALCETrXZ=xJEd53RhA67_VDoAKBWgUeyBi9XN7ibrE7V6nzk5Q@mail.gmail.com>
 <20180227053255.a7ua24kjd6tvei2a@ast-mbp>
 <CALCETrUqc0wbig4ntQe9KNS-fOgYOpD+MPodXYruCRyJ7bhagA@mail.gmail.com>
 <ab8dda73-4a6e-4e10-cda0-3e91c5019a63@digikod.net>
 <498f8193-c909-78b2-e4ca-c1dd05605255@digikod.net>
 <CALCETrViaXEx1iQ6q8bEEWSLchj=FH6LjcRY6+hjMx8A+rtgDQ@mail.gmail.com>
 <c6621359-e8f8-dc14-d449-f8e5d7149a97@digikod.net>
 <20180410044821.tllxbaq2uj6gtzpn@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="vlwq20IK90nFIa3nSeiQogCIz0MqNWdsy"
Return-path: <kernel-hardening-return-12979-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180410044821.tllxbaq2uj6gtzpn@ast-mbp.dhcp.thefacebook.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>, Kernel
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vlwq20IK90nFIa3nSeiQogCIz0MqNWdsy
Content-Type: multipart/mixed; boundary="UwKe6vgHx7r0XJUu4pM81A25wr460Z4m9";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, LKML <linux-kernel@vger.kernel.org>,
 Alexei Starovoitov <ast@kernel.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Casey Schaufler <casey@schaufler-ca.com>,
 David Drysdale <drysdale@google.com>, "David S . Miller"
 <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>,
 Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>,
 Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>,
 "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
 Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>,
 Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 LSM List <linux-security-module@vger.kernel.org>,
 Network Development <netdev@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Al Viro
 <viro@ZenIV.linux.org.uk>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Message-ID: <a47530c5-6238-c270-b204-19ca94f49f7f@digikod.net>
Subject: Re: [PATCH bpf-next v8 05/11] seccomp,landlock: Enforce Landlock
 programs per process hierarchy
References: <20180227020856.teq4hobw3zwussu2@ast-mbp>
 <CALCETrVKRYnGJ9XNW-x7eHdMt+eGP90j7cAed-KTzp1KT_kMeQ@mail.gmail.com>
 <20180227045458.wjrbbsxf3po656du@ast-mbp>
 <CALCETrXZ=xJEd53RhA67_VDoAKBWgUeyBi9XN7ibrE7V6nzk5Q@mail.gmail.com>
 <20180227053255.a7ua24kjd6tvei2a@ast-mbp>
 <CALCETrUqc0wbig4ntQe9KNS-fOgYOpD+MPodXYruCRyJ7bhagA@mail.gmail.com>
 <ab8dda73-4a6e-4e10-cda0-3e91c5019a63@digikod.net>
 <498f8193-c909-78b2-e4ca-c1dd05605255@digikod.net>
 <CALCETrViaXEx1iQ6q8bEEWSLchj=FH6LjcRY6+hjMx8A+rtgDQ@mail.gmail.com>
 <c6621359-e8f8-dc14-d449-f8e5d7149a97@digikod.net>
 <20180410044821.tllxbaq2uj6gtzpn@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20180410044821.tllxbaq2uj6gtzpn@ast-mbp.dhcp.thefacebook.com>

--UwKe6vgHx7r0XJUu4pM81A25wr460Z4m9
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


On 04/10/2018 06:48 AM, Alexei Starovoitov wrote:
> On Mon, Apr 09, 2018 at 12:01:59AM +0200, Micka=EBl Sala=FCn wrote:
>>
>> On 04/08/2018 11:06 PM, Andy Lutomirski wrote:
>>> On Sun, Apr 8, 2018 at 6:13 AM, Micka=EBl Sala=FCn <mic@digikod.net> =
wrote:
>>>>
>>>> On 02/27/2018 10:48 PM, Micka=EBl Sala=FCn wrote:
>>>>>
>>>>> On 27/02/2018 17:39, Andy Lutomirski wrote:
>>>>>> On Tue, Feb 27, 2018 at 5:32 AM, Alexei Starovoitov
>>>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>>> On Tue, Feb 27, 2018 at 05:20:55AM +0000, Andy Lutomirski wrote:
>>>>>>>> On Tue, Feb 27, 2018 at 4:54 AM, Alexei Starovoitov
>>>>>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>>>>> On Tue, Feb 27, 2018 at 04:40:34AM +0000, Andy Lutomirski wrote=
:
>>>>>>>>>> On Tue, Feb 27, 2018 at 2:08 AM, Alexei Starovoitov
>>>>>>>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>>>>>>> On Tue, Feb 27, 2018 at 01:41:15AM +0100, Micka=EBl Sala=FCn =
wrote:
>>>>>>>>>>>> The seccomp(2) syscall can be used by a task to apply a Land=
lock program
>>>>>>>>>>>> to itself. As a seccomp filter, a Landlock program is enforc=
ed for the
>>>>>>>>>>>> current task and all its future children. A program is immut=
able and a
>>>>>>>>>>>> task can only add new restricting programs to itself, formin=
g a list of
>>>>>>>>>>>> programss.
>>>>>>>>>>>>
>>>>>>>>>>>> A Landlock program is tied to a Landlock hook. If the action=
 on a kernel
>>>>>>>>>>>> object is allowed by the other Linux security mechanisms (e.=
g. DAC,
>>>>>>>>>>>> capabilities, other LSM), then a Landlock hook related to th=
is kind of
>>>>>>>>>>>> object is triggered. The list of programs for this hook is t=
hen
>>>>>>>>>>>> evaluated. Each program return a 32-bit value which can deny=
 the action
>>>>>>>>>>>> on a kernel object with a non-zero value. If every programs =
of the list
>>>>>>>>>>>> return zero, then the action on the object is allowed.
>>>>>>>>>>>>
>>>>>>>>>>>> Multiple Landlock programs can be chained to share a 64-bits=
 value for a
>>>>>>>>>>>> call chain (e.g. evaluating multiple elements of a file path=
).  This
>>>>>>>>>>>> chaining is restricted when a process construct this chain b=
y loading a
>>>>>>>>>>>> program, but additional checks are performed when it request=
s to apply
>>>>>>>>>>>> this chain of programs to itself.  The restrictions ensure t=
hat it is
>>>>>>>>>>>> not possible to call multiple programs in a way that would i=
mply to
>>>>>>>>>>>> handle multiple shared values (i.e. cookies) for one chain. =
 For now,
>>>>>>>>>>>> only a fs_pick program can be chained to the same type of pr=
ogram,
>>>>>>>>>>>> because it may make sense if they have different triggers (c=
f. next
>>>>>>>>>>>> commits).  This restrictions still allows to reuse Landlock =
programs in
>>>>>>>>>>>> a safe way (e.g. use the same loaded fs_walk program with mu=
ltiple
>>>>>>>>>>>> chains of fs_pick programs).
>>>>>>>>>>>>
>>>>>>>>>>>> Signed-off-by: Micka=EBl Sala=FCn <mic@digikod.net>
>>>>>>>>>>>
>>>>>>>>>>> ...
>>>>>>>>>>>
>>>>>>>>>>>> +struct landlock_prog_set *landlock_prepend_prog(
>>>>>>>>>>>> +             struct landlock_prog_set *current_prog_set,
>>>>>>>>>>>> +             struct bpf_prog *prog)
>>>>>>>>>>>> +{
>>>>>>>>>>>> +     struct landlock_prog_set *new_prog_set =3D current_pro=
g_set;
>>>>>>>>>>>> +     unsigned long pages;
>>>>>>>>>>>> +     int err;
>>>>>>>>>>>> +     size_t i;
>>>>>>>>>>>> +     struct landlock_prog_set tmp_prog_set =3D {};
>>>>>>>>>>>> +
>>>>>>>>>>>> +     if (prog->type !=3D BPF_PROG_TYPE_LANDLOCK_HOOK)
>>>>>>>>>>>> +             return ERR_PTR(-EINVAL);
>>>>>>>>>>>> +
>>>>>>>>>>>> +     /* validate memory size allocation */
>>>>>>>>>>>> +     pages =3D prog->pages;
>>>>>>>>>>>> +     if (current_prog_set) {
>>>>>>>>>>>> +             size_t i;
>>>>>>>>>>>> +
>>>>>>>>>>>> +             for (i =3D 0; i < ARRAY_SIZE(current_prog_set-=
>programs); i++) {
>>>>>>>>>>>> +                     struct landlock_prog_list *walker_p;
>>>>>>>>>>>> +
>>>>>>>>>>>> +                     for (walker_p =3D current_prog_set->pr=
ograms[i];
>>>>>>>>>>>> +                                     walker_p; walker_p =3D=
 walker_p->prev)
>>>>>>>>>>>> +                             pages +=3D walker_p->prog->pag=
es;
>>>>>>>>>>>> +             }
>>>>>>>>>>>> +             /* count a struct landlock_prog_set if we need=
 to allocate one */
>>>>>>>>>>>> +             if (refcount_read(&current_prog_set->usage) !=3D=
 1)
>>>>>>>>>>>> +                     pages +=3D round_up(sizeof(*current_pr=
og_set), PAGE_SIZE)
>>>>>>>>>>>> +                             / PAGE_SIZE;
>>>>>>>>>>>> +     }
>>>>>>>>>>>> +     if (pages > LANDLOCK_PROGRAMS_MAX_PAGES)
>>>>>>>>>>>> +             return ERR_PTR(-E2BIG);
>>>>>>>>>>>> +
>>>>>>>>>>>> +     /* ensure early that we can allocate enough memory for=
 the new
>>>>>>>>>>>> +      * prog_lists */
>>>>>>>>>>>> +     err =3D store_landlock_prog(&tmp_prog_set, current_pro=
g_set, prog);
>>>>>>>>>>>> +     if (err)
>>>>>>>>>>>> +             return ERR_PTR(err);
>>>>>>>>>>>> +
>>>>>>>>>>>> +     /*
>>>>>>>>>>>> +      * Each task_struct points to an array of prog list po=
inters.  These
>>>>>>>>>>>> +      * tables are duplicated when additions are made (whic=
h means each
>>>>>>>>>>>> +      * table needs to be refcounted for the processes usin=
g it). When a new
>>>>>>>>>>>> +      * table is created, all the refcounters on the prog_l=
ist are bumped (to
>>>>>>>>>>>> +      * track each table that references the prog). When a =
new prog is
>>>>>>>>>>>> +      * added, it's just prepended to the list for the new =
table to point
>>>>>>>>>>>> +      * at.
>>>>>>>>>>>> +      *
>>>>>>>>>>>> +      * Manage all the possible errors before this step to =
not uselessly
>>>>>>>>>>>> +      * duplicate current_prog_set and avoid a rollback.
>>>>>>>>>>>> +      */
>>>>>>>>>>>> +     if (!new_prog_set) {
>>>>>>>>>>>> +             /*
>>>>>>>>>>>> +              * If there is no Landlock program set used by=
 the current task,
>>>>>>>>>>>> +              * then create a new one.
>>>>>>>>>>>> +              */
>>>>>>>>>>>> +             new_prog_set =3D new_landlock_prog_set();
>>>>>>>>>>>> +             if (IS_ERR(new_prog_set))
>>>>>>>>>>>> +                     goto put_tmp_lists;
>>>>>>>>>>>> +     } else if (refcount_read(&current_prog_set->usage) > 1=
) {
>>>>>>>>>>>> +             /*
>>>>>>>>>>>> +              * If the current task is not the sole user of=
 its Landlock
>>>>>>>>>>>> +              * program set, then duplicate them.
>>>>>>>>>>>> +              */
>>>>>>>>>>>> +             new_prog_set =3D new_landlock_prog_set();
>>>>>>>>>>>> +             if (IS_ERR(new_prog_set))
>>>>>>>>>>>> +                     goto put_tmp_lists;
>>>>>>>>>>>> +             for (i =3D 0; i < ARRAY_SIZE(new_prog_set->pro=
grams); i++) {
>>>>>>>>>>>> +                     new_prog_set->programs[i] =3D
>>>>>>>>>>>> +                             READ_ONCE(current_prog_set->pr=
ograms[i]);
>>>>>>>>>>>> +                     if (new_prog_set->programs[i])
>>>>>>>>>>>> +                             refcount_inc(&new_prog_set->pr=
ograms[i]->usage);
>>>>>>>>>>>> +             }
>>>>>>>>>>>> +
>>>>>>>>>>>> +             /*
>>>>>>>>>>>> +              * Landlock program set from the current task =
will not be freed
>>>>>>>>>>>> +              * here because the usage is strictly greater =
than 1. It is
>>>>>>>>>>>> +              * only prevented to be freed by another task =
thanks to the
>>>>>>>>>>>> +              * caller of landlock_prepend_prog() which sho=
uld be locked if
>>>>>>>>>>>> +              * needed.
>>>>>>>>>>>> +              */
>>>>>>>>>>>> +             landlock_put_prog_set(current_prog_set);
>>>>>>>>>>>> +     }
>>>>>>>>>>>> +
>>>>>>>>>>>> +     /* prepend tmp_prog_set to new_prog_set */
>>>>>>>>>>>> +     for (i =3D 0; i < ARRAY_SIZE(tmp_prog_set.programs); i=
++) {
>>>>>>>>>>>> +             /* get the last new list */
>>>>>>>>>>>> +             struct landlock_prog_list *last_list =3D
>>>>>>>>>>>> +                     tmp_prog_set.programs[i];
>>>>>>>>>>>> +
>>>>>>>>>>>> +             if (last_list) {
>>>>>>>>>>>> +                     while (last_list->prev)
>>>>>>>>>>>> +                             last_list =3D last_list->prev;=

>>>>>>>>>>>> +                     /* no need to increment usage (pointer=
 replacement) */
>>>>>>>>>>>> +                     last_list->prev =3D new_prog_set->prog=
rams[i];
>>>>>>>>>>>> +                     new_prog_set->programs[i] =3D tmp_prog=
_set.programs[i];
>>>>>>>>>>>> +             }
>>>>>>>>>>>> +     }
>>>>>>>>>>>> +     new_prog_set->chain_last =3D tmp_prog_set.chain_last;
>>>>>>>>>>>> +     return new_prog_set;
>>>>>>>>>>>> +
>>>>>>>>>>>> +put_tmp_lists:
>>>>>>>>>>>> +     for (i =3D 0; i < ARRAY_SIZE(tmp_prog_set.programs); i=
++)
>>>>>>>>>>>> +             put_landlock_prog_list(tmp_prog_set.programs[i=
]);
>>>>>>>>>>>> +     return new_prog_set;
>>>>>>>>>>>> +}
>>>>>>>>>>>
>>>>>>>>>>> Nack on the chaining concept.
>>>>>>>>>>> Please do not reinvent the wheel.
>>>>>>>>>>> There is an existing mechanism for attaching/detaching/querin=
g multiple
>>>>>>>>>>> programs attached to cgroup and tracing hooks that are also
>>>>>>>>>>> efficiently executed via BPF_PROG_RUN_ARRAY.
>>>>>>>>>>> Please use that instead.
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> I don't see how that would help.  Suppose you add a filter, th=
en
>>>>>>>>>> fork(), and then the child adds another filter.  Do you want t=
o
>>>>>>>>>> duplicate the entire array?  You certainly can't *modify* the =
array
>>>>>>>>>> because you'll affect processes that shouldn't be affected.
>>>>>>>>>>
>>>>>>>>>> In contrast, doing this through seccomp like the earlier patch=
es
>>>>>>>>>> seemed just fine to me, and seccomp already had the right logi=
c.
>>>>>>>>>
>>>>>>>>> it doesn't look to me that existing seccomp side of managing fo=
rk
>>>>>>>>> situation can be reused. Here there is an attempt to add 'chain=
ing'
>>>>>>>>> concept which sort of an extension of existing seccomp style,
>>>>>>>>> but somehow heavily done on bpf side and contradicts cgroup/tra=
cing.
>>>>>>>>>
>>>>>>>>
>>>>>>>> I don't see why the seccomp way can't be used.  I agree with you=
 that
>>>>>>>> the seccomp *style* shouldn't be used in bpf code like this, but=
 I
>>>>>>>> think that Landlock programs can and should just live in the exi=
sting
>>>>>>>> seccomp chain.  If the existing seccomp code needs some modifica=
tion
>>>>>>>> to make this work, then so be it.
>>>>>>>
>>>>>>> +1
>>>>>>> if that was the case...
>>>>>>> but that's not my reading of the patch set.
>>>>>>
>>>>>> An earlier version of the patch set used the seccomp filter chain.=

>>>>>> Micka=EBl, what exactly was wrong with that approach other than th=
at the
>>>>>> seccomp() syscall was awkward for you to use?  You could add a
>>>>>> seccomp_add_landlock_rule() syscall if you needed to.
>>>>>
>>>>> Nothing was wrong about about that, this part did not changed (see =
my
>>>>> next comment).
>>>>>
>>>>>>
>>>>>> As a side comment, why is this an LSM at all, let alone a non-stac=
king
>>>>>> LSM?  It would make a lot more sense to me to make Landlock depend=
 on
>>>>>> having LSMs configured in but to call the landlock hooks directly =
from
>>>>>> the security_xyz() hooks.
>>>>>
>>>>> See Casey's answer and his patch series: https://lwn.net/Articles/7=
41963/
>>>>>
>>>>>>
>>>>>>>
>>>>>>>> In other words, the kernel already has two kinds of chaining:
>>>>>>>> seccomp's and bpf's.  bpf's doesn't work right for this type of =
usage
>>>>>>>> across fork(), whereas seccomp's already handles that case corre=
ctly.
>>>>>>>> (In contrast, seccomp's is totally wrong for cgroup-attached fil=
ters.)
>>>>>>>>  So IMO Landlock should use the seccomp core code and call into =
bpf
>>>>>>>> for the actual filtering.
>>>>>>>
>>>>>>> +1
>>>>>>> in cgroup we had to invent this new BPF_PROG_RUN_ARRAY mechanism,=

>>>>>>> since cgroup hierarchy can be complicated with bpf progs attached=

>>>>>>> at different levels with different override/multiprog properties,=

>>>>>>> so walking link list and checking all flags at run-time would hav=
e
>>>>>>> been too slow. That's why we added compute_effective_progs().
>>>>>>
>>>>>> If we start adding override flags to Landlock, I think we're doing=
 it
>>>>>> wrong.   With cgroup bpf programs, the whole mess is set up by the=

>>>>>> administrator.  With seccomp, and with Landlock if done correctly,=
 it
>>>>>> *won't* be set up by the administrator, so the chance that everyon=
e
>>>>>> gets all the flags right is about zero.  All attached filters shou=
ld
>>>>>> run unconditionally.
>>>>>
>>>>>
>>>>> There is a misunderstanding about this chaining mechanism. This sho=
uld
>>>>> not be confused with the list of seccomp filters nor the cgroup
>>>>> hierarchies. Landlock programs can be stacked the same way seccomp'=
s
>>>>> filters can (cf. struct landlock_prog_set, the "chain_last" field i=
s an
>>>>> optimization which is not used for this struct handling). This stac=
kable
>>>>> property did not changed from the previous patch series. The chaini=
ng
>>>>> mechanism is for another use case, which does not make sense for se=
ccomp
>>>>> filters nor other eBPF program types, at least for now, from what I=
 can
>>>>> tell.
>>>>>
>>>>> You may want to get a look at my talk at FOSDEM
>>>>> (https://landlock.io/talks/2018-02-04_landlock-fosdem.pdf), especia=
lly
>>>>> slides 11 and 12.
>>>>>
>>>>> Let me explain my reasoning about this program chaining thing.
>>>>>
>>>>> To check if an action on a file is allowed, we first need to identi=
fy
>>>>> this file and match it to the security policy. In a previous
>>>>> (non-public) patch series, I tried to use one type of eBPF program =
to
>>>>> check every kind of access to a file. To be able to identify a file=
, I
>>>>> relied on an eBPF map, similar to the current inode map. This map s=
tore
>>>>> a set of references to file descriptors. I then created a function
>>>>> bpf_is_file_beneath() to check if the requested file was beneath a =
file
>>>>> in the map. This way, no chaining, only one eBPF program type to ch=
eck
>>>>> an access to a file... but some issues then emerged. First, this de=
sign
>>>>> create a side-channel which help an attacker using such a program t=
o
>>>>> infer some information not normally available, for example to get a=
 hint
>>>>> on where a file descriptor (received from a UNIX socket) come from.=

>>>>> Another issue is that this type of program would be called for each=

>>>>> component of a path. Indeed, when the kernel check if an access to =
a
>>>>> file is allowed, it walk through all of the directories in its path=

>>>>> (checking if the current process is allowed to execute them). That =
first
>>>>> attempt led me to rethink the way we could filter an access to a fi=
le
>>>>> *path*.
>>>>>
>>>>> To minimize the number of called to an eBPF program dedicated to
>>>>> validate an access to a file path, I decided to create three subtyp=
e of
>>>>> eBPF programs. The FS_WALK type is called when walking through ever=
y
>>>>> directory of a file path (except the last one if it is the target).=
 We
>>>>> can then restrict this type of program to the minimum set of functi=
ons
>>>>> it is allowed to call and the minimum set of data available from it=
s
>>>>> context. The first implicit chaining is for this type of program. T=
o be
>>>>> able to evaluate a path while being called for all its components, =
this
>>>>> program need to store a state (to remember what was the parent dire=
ctory
>>>>> of this path). There is no "previous" field in the subtype for this=

>>>>> program because it is chained with itself, for each directories. Th=
is
>>>>> enable to create a FS_WALK program to evaluate a file hierarchy, th=
ank
>>>>> to the inode map which can be used to check if a directory of this
>>>>> hierarchy is part of an allowed (or denied) list of directories. Th=
is
>>>>> design enables to express a file hierarchy in a programmatic way,
>>>>> without requiring an eBPF helper to do the job (unlike my first exp=
eriment).
>>>>>
>>>>> The explicit chaining is used to tied a path evaluation (with a FS_=
WALK
>>>>> program) to an access to the actual file being requested (the last
>>>>> component of a file path), with a FS_PICK program. It is only at th=
is
>>>>> time that the kernel check for the requested action (e.g. read, wri=
te,
>>>>> chdir, append...). To be able to filter such access request we can =
have
>>>>> one call to the same program for every action and let this program =
check
>>>>> for which action it was called. However, this design does not allow=
 the
>>>>> kernel to know if the current action is indeed handled by this prog=
ram.
>>>>> Hence, it is not possible to implement a cache mechanism to only ca=
ll
>>>>> this program if it knows how to handle this action.
>>>>>
>>>>> The approach I took for this FS_PICK type of program is to add to i=
ts
>>>>> subtype which action it can handle (with the "triggers" bitfield, s=
een
>>>>> as ORed actions). This way, the kernel knows if a call to a FS_PICK=

>>>>> program is necessary. If the user wants to enforce a different secu=
rity
>>>>> policy according to the action requested on a file, then it needs
>>>>> multiple FS_PICK programs. However, to reduce the number of such
>>>>> programs, this patch series allow a FS_PICK program to be chained w=
ith
>>>>> another, the same way a FS_WALK is chained with itself. This way, i=
f the
>>>>> user want to check if the action is a for example an "open" and a "=
read"
>>>>> and not a "map" and a "read", then it can chain multiple FS_PICK
>>>>> programs with different triggers actions. The OR check performed by=
 the
>>>>> kernel is not a limitation then, only a way to know if a call to an=
 eBPF
>>>>> program is needed.
>>>>>
>>>>> The last type of program is FS_GET. This one is called when a proce=
ss
>>>>> get a struct file or change its working directory. This is the only=

>>>>> program type able (and allowed) to tag a file. This restriction is
>>>>> important to not being subject to resource exhaustion attacks (i.e.=

>>>>> tagging every inode accessible to an attacker, which would allocate=
 too
>>>>> much kernel memory).
>>>>>
>>>>> This design gives room for improvements to create a cache of eBPF
>>>>> context (input data, including maps if any), with the result of an =
eBPF
>>>>> program. This would help limit the number of call to an eBPF progra=
m the
>>>>> same way SELinux or other kernel components do to limit costly chec=
ks.
>>>>>
>>>>> The eBPF maps of progs are useful to call the same type of eBPF
>>>>> program. It does not fit with this use case because we may want mul=
tiple
>>>>> eBPF program according to the action requested on a kernel object (=
e.g.
>>>>> FS_GET). The other reason is because the eBPF program does not know=
 what
>>>>> will be the next (type of) access check performed by the kernel.
>>>>>
>>>>> To say it another way, this chaining mechanism is a way to split a
>>>>> kernel object evaluation with multiple specialized programs, each o=
f
>>>>> them being able to deal with data tied to their type. Using a monol=
ithic
>>>>> eBPF program to check everything does not scale and does not fit wi=
th
>>>>> unprivileged use either.
>>>>>
>>>>> As a side note, the cookie value is only an ephemeral value to keep=
 a
>>>>> state between multiple programs call. It can be used to create a st=
ate
>>>>> machine for an object evaluation.
>>>>>
>>>>> I don't see a way to do an efficient and programmatic path evaluati=
on,
>>>>> with different access checks, with the current eBPF features. Pleas=
e let
>>>>> me know if you know how to do it another way.
>>>>>
>>>>
>>>> Andy, Alexei, Daniel, what do you think about this Landlock program
>>>> chaining and cookie?
>>>>
>>>
>>> Can you give a small pseudocode real world example that acutally need=
s
>>> chaining?  The mechanism is quite complicated and I'd like to
>>> understand how it'll be used.
>>>
>>
>> Here is the interesting part from the example (patch 09/11):
>>
>> +SEC("maps")
>> +struct bpf_map_def inode_map =3D {
>> +	.type =3D BPF_MAP_TYPE_INODE,
>> +	.key_size =3D sizeof(u32),
>> +	.value_size =3D sizeof(u64),
>> +	.max_entries =3D 20,
>> +};
>> +
>> +SEC("subtype/landlock1")
>> +static union bpf_prog_subtype _subtype1 =3D {
>> +	.landlock_hook =3D {
>> +		.type =3D LANDLOCK_HOOK_FS_WALK,
>> +	}
>> +};
>> +
>> +static __always_inline __u64 update_cookie(__u64 cookie, __u8 lookup,=

>> +		void *inode, void *chain, bool freeze)
>> +{
>> +	__u64 map_allow =3D 0;
>> +
>> +	if (cookie =3D=3D 0) {
>> +		cookie =3D bpf_inode_get_tag(inode, chain);
>> +		if (cookie)
>> +			return cookie;
>> +		/* only look for the first match in the map, ignore nested
>> +		 * paths in this example */
>> +		map_allow =3D bpf_inode_map_lookup(&inode_map, inode);
>> +		if (map_allow)
>> +			cookie =3D 1 | map_allow;
>> +	} else {
>> +		if (cookie & COOKIE_VALUE_FREEZED)
>> +			return cookie;
>> +		map_allow =3D cookie & _MAP_MARK_MASK;
>> +		cookie &=3D ~_MAP_MARK_MASK;
>> +		switch (lookup) {
>> +		case LANDLOCK_CTX_FS_WALK_INODE_LOOKUP_DOTDOT:
>> +			cookie--;
>> +			break;
>> +		case LANDLOCK_CTX_FS_WALK_INODE_LOOKUP_DOT:
>> +			break;
>> +		default:
>> +			/* ignore _MAP_MARK_MASK overflow in this example */
>> +			cookie++;
>> +			break;
>> +		}
>> +		if (cookie >=3D 1)
>> +			cookie |=3D map_allow;
>> +	}
>> +	/* do not modify the cookie for each fs_pick */
>> +	if (freeze && cookie)
>> +		cookie |=3D COOKIE_VALUE_FREEZED;
>> +	return cookie;
>> +}
>> +
>> +SEC("landlock1")
>> +int fs_walk(struct landlock_ctx_fs_walk *ctx)
>> +{
>> +	ctx->cookie =3D update_cookie(ctx->cookie, ctx->inode_lookup,
>> +			(void *)ctx->inode, (void *)ctx->chain, false);
>> +	return LANDLOCK_RET_ALLOW;
>> +}
>>
>> The program "landlock1" is called for every directory execution (excep=
t
>> the last one if it is the leaf of a path). This enables to identify a
>> file hierarchy with only a (one dimension) list of file descriptors
>> (i.e. inode_map).
>>
>> Underneath, the Landlock LSM part looks if there is an associated path=

>> walk (nameidata) with each inode access request. If there is one, then=

>> the cookie associated with the path walk (if any) is made available
>> through the eBPF program context. This enables to develop a state
>> machine with an eBPF program to "evaluate" a file path (without string=

>> parsing).
>>
>> The goal with this chaining mechanism is to be able to express a compl=
ex
>> kernel object like a file, with multiple run of one or more eBPF
>> programs, as a multilayer evaluation. This semantic may only make sens=
e
>> for the user/developer and his security policy. We must keep in mind
>> that this object identification should be available to unprivileged
>> processes. This means that we must be very careful to what kind of
>> information are available to an eBPF program because this can then lea=
k
>> to a process (e.g. through a map). With this mechanism, only informati=
on
>> already available to user space is available to the eBPF program.
>>
>> In this example, the complexity of the path evaluation is in the eBPF
>> program. We can then keep the kernel code more simple and generic. Thi=
s
>> enables more flexibility for a security policy definition.
>=20
> it all sounds correct on paper, but it's pretty novel
> approach and I'm not sure I see all the details in the patch.
> When people say "inode" they most of the time mean inode integer number=
,
> whereas in this patch do you mean a raw pointer to in-kernel
> 'struct inode' ?
> To avoid confusion it should probably be called differently.

It's indeed a pointer to a "struct inode", not an inode number.

I was thinking about generalizing the BPF_MAP_TYPE_INODE by renaming it
to BPF_MAP_TYPE_FD. This map type could then be used either to identify
a set of inodes (pointers) or other kernel objects identifiable by a
file descriptor. A "subtype" (similar to the BPF prog subtype introduced
in this patch series) may be used to specialize such a map to statically
identify the kind of content it may hold. We could then add more
subtypes to identify sockets, devices, processes, and so on.

>=20
> If you meant inode as a number then why inode only?
> where is superblock, device, mount point?
> How bpf side can compare inodes without this additional info?
> How bpf side will know what inode to compare to?
> What if inode number is reused?

This pointer can identify if a giver inode is the same as one pointed by
a file descriptor (or a file path).


> This approach is an optimization to compare inodes
> instead of strings passed into sys_open ?

Comparing paths with strings is less efficient but it is also very
error-prone. Another advantage of using file descriptors is for
unprivileged processes: we can be sure that this processes are allowed
to access a file referred by a file descriptor (opened file). Indeed we
check (security_inode_getattr) that the process is allowed to stat an
opened file. This way, a malicious process can't infer information by
crafting path strings.


>=20
> If you meant inode as a pointer how bpf side will
> know the pointer before the walk begins?

The BPF map is filled by user space with file descriptors pointing to
opened files. When a path walk begin, the LSM part of Landlock is
notified that a process is requesting an access to the first element of
the path (e.g. "/"). This first element may be part of a map or not. The
BPF program can then choose if this request is legitimate or not.


> What guarantees that it's not a stale pointer?

When user space updates a map with a new file descriptor, the kernel
checks if this FD is valid. If this is the case, then the inode's usage
counter is incremented and its address is stored in the map.


--UwKe6vgHx7r0XJUu4pM81A25wr460Z4m9--

--vlwq20IK90nFIa3nSeiQogCIz0MqNWdsy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAlrOibIACgkQIt7+33O9
apWINgf/be8Sxkf5IIJWqrJtC9cRbS+RHQtCiHt6kHVXxFqzNaB1mLPAjvwdUcQT
lmX0dm072KPM4tOJppTi/A4e0CdNu2ZbRTrJ9PzTtcWSyVgsWC5aaToGa6eZY4A4
U9AH1sGbeLtoFDNAlJC/vN4mKry8MWw1pQdVU5Oghb8nPV4PPn+9eGhp7+CvzWCC
IWbOFOTgvTQ4+bME9O+Q0nIxpaku220OeumCiXlsMZ1fsBn4FrcnWxMwnGesTSQO
wEkI+SQmnJEUsQy13e34hTv9MP/vKkUS+BZWTahQYwtTDcdS1tJygoj55nwaRinO
kvpgsF+YjfZ4sIovNqQRwh+uLwUg6w==
=VGj3
-----END PGP SIGNATURE-----

--vlwq20IK90nFIa3nSeiQogCIz0MqNWdsy--
