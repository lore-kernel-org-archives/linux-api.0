From: Kees Cook <keescook@chromium.org>
Subject: Re: [RFC v1 00/17] seccomp-object: From attack surface reduction to sandboxing
Date: Tue, 26 Apr 2016 15:46:00 -0700
Message-ID: <CAGXu5jJEQ0gm=bZ+c3ttxsz3WFU6xWPcpcpdUH0ttQTwwCfnqA@mail.gmail.com>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
	<5717C897.1050508@digikod.net>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-hardening-return-3109-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: keescook@google.com
In-Reply-To: <5717C897.1050508@digikod.net>
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 20, 2016 at 11:21 AM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net=
> wrote:
> Hi,
>
> Does anyone had time to review some patches?

Hi! Sorry for the delay on this. I keep getting distracted by other
stuff. I've got some time on a plane tomorrow, so I'll bring your
series along and spend some time reading through it more carefully.

-Kees

>
> What do you think about the ToCToU workarounds?
> What about the userland API?
>
> The series can be found here: https://github.com/l0kod/linux/commits/secc=
omp-object-v1
>
>  Micka=C3=ABl
>
>
> On 24/03/2016 02:46, Micka=C3=ABl Sala=C3=BCn wrote:
>> Hi,
>>
>> This series is a proof of concept (not ready for production) to extend s=
eccomp
>> with the ability to check argument pointers of syscalls as kernel object=
 (e.g.
>> file path). This add a needed feature to create a full sandbox managed b=
y
>> userland like the Seatbelt/XNU Sandbox or the OpenBSD Pledge. It was ini=
tially
>> inspired from a partial seccomp-LSM prototype [1] but has evolved a lot =
since :)
>>
>> The audience for this RFC is limited to security-related actors to discu=
ss
>> about this new feature before enlarging the scope to a wider audience. T=
his
>> aims to focus on the security goal, usability and architecture before en=
tering
>> into the gory details of each subsystem. I also wish to get constructive
>> criticisms about the userland API and intrusiveness of the code (and wha=
t could
>> be the other ways to do it better) before going further (and addressing =
the
>> TODO and FIXME in the code).
>>
>> The approach taken is to add the minimum amount of code while still allo=
wing
>> the userland to create access rules via seccomp. The current limitation =
of
>> seccomp is to get raw syscall arguments value but there is no way to
>> dereference a pointer to check its content (e.g. the first argument of t=
he open
>> syscall). This seccomp evolution brings a generic way to check against a=
rgument
>> pointer regardless from the syscall unlike current LSMs.
>>
>> Here is the use case scenario:
>> * First, a process must load some groups of seccomp checkers. This check=
ers are
>>   dedicated structs describing a pointed data (e.g. path). They are
>>   semantically grouped to be efficiently managed and checked in batch. E=
ach
>>   group have a static ID. This IDs are unique and they reference groups =
only
>>   accessible from the filters created by the same process.
>> * The loaded checkers are inherited and accessible by the newly created
>>   filters. This groups can be referenced by filters with a new return va=
lue
>>   SECCOMP_RET_ARGEVAL. Value in  SECCOMP_RET_DATA contains a group ID an=
d an
>>   argument bitmask. This return value is only meaningful between stacked
>>   filters to ask a check and get the result in the extended struct
>>   seccomp_data. The new fields are "is_valid_syscall", "arg_group" conta=
ining a
>>   group ID and "matches[6]" consisting of one 64-bits mask per argument.=
 This
>>   bitmasks are useful to get the check result of each checker from a gro=
up on a
>>   syscall argument which is handy to create a custom access control engi=
ne from
>>   userland.
>> * SECCOMP_RET_ARGEVAL is equivalent to SECCOMP_RET_ACCESS except that th=
e
>>   following filters can take a decision regarding a match (e.g. return E=
ACCESS
>>   or emulate the syscall).
>>
>> Each checker is autonomous and new ones can easily be added in the futur=
e.
>> There is currently two checkers for path objects:
>> * SECCOMP_CHECK_FS_LITERAL checks if a string match a defined path;
>> * SECCOMP_CHECK_FS_BENEATH checks if the path representation of a string=
 is
>>   equal or equivalent to a file belonging to a defined path.
>>
>> This design does not seems too intrusive but is flexible enough to allow=
 a
>> powerful sandbox mechanism accessible by any process on Linux. The use o=
f
>> seccomp, including this new feature, is more suitable with the help of a
>> userland library (e.g. libseccomp) that could help to specify a high-lev=
el
>> language to express a security policy instead of raw syscall rules.
>>
>> The main concern should be about time-of-check-time-of-use (TOCTOU) race
>> conditions attacks. Because of the nature of seccomp (executed before th=
e
>> effective syscall and before a potential ptrace), it is not possible to =
block
>> all races but to detect them.
>>
>> There is still some questions I couldn't answer for sure (grep for FIXME=
 or
>> XXX). Comments appreciated.
>>
>> Tested on the x86 and UM architectures in 32 and 64 bits (with audit ena=
bled).
>>
>> [1] https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=
=3Dseccomp/lsm
>>
>>
>> # Need for LSM
>>
>> Because the arguments can be checked before the syscall actually evaluat=
e them,
>> there is two race condition classes:
>> * The data pointed by the user address is in control of the userland (e.=
g. a
>>   tracing process) and is so subject to TOCTOU race conditions between t=
he
>>   seccomp filter evaluation and the effective resource grabbing (part of=
 each
>>   syscall code).
>> * The semantic of the pointed data is also subject to race condition bec=
ause
>>   there is no lock on the resource (e.g. file) between the evaluation of=
 the
>>   argument by the seccomp filter and the use of the pointed resource by =
each
>>   part of the syscall code.
>>
>> The solution to fix these race conditions is to copy the userspace data =
and to
>> lock the pointed resource. Whereas it is easy to copy the userspace data=
, it is
>> not realistic to lock any pointed resources because of obvious locking i=
ssues.
>> However, it is possible to detect a TOCTOU race condition with the help =
of LSM
>> hooks. This way, we can keep a flexible access control (e.g. by controll=
ing
>> syscall return values) while blocking unattended malicious or bogus user=
land
>> behavior (e.g. exploit a race-condition).
>>
>> To be able to deny access to a malicious userland behavior we must repla=
y the
>> seccomp filters and verify the intermediate return values to find out if=
 the
>> filters policy is still respected. Thanks to a cache we can detect if a =
check
>> replay is necessary. Otherwise, the LSM hooks are really quick for
>> non-malicious userland.
>>
>> # Cache handling
>>
>> Each time a checker is called, for each argument to check, it get them f=
rom
>> it's seccomp_argeval_checked cache if any, or create a new cache entry a=
nd put
>> it otherwise. This cache entries will be used to evaluate arguments.
>>
>> When rechecking in the LSM hooks, first it find out which argument is ma=
pped to
>> the hook check and find if it differ from the corresponding cache entry.=
 If it
>> match, then return OK without replaying the checks, or if nothing match,=
 replay
>> all the checks from this check type.
>>
>> # How to use it
>>
>> The SECCOMP_ARGFLAG_* help to narrow the rules constraints:
>> * SECCOMP_ARGFLAG_FS_DENTRY: Check and rely on the path name.
>> * SECCOMP_ARGFLAG_FS_INODE: Check the data "container" whatever it's pat=
h name.
>> * SECCOMP_ARGFLAG_FS_DEVICE: Check the device (i.e. file system) on whic=
h the
>>   file is, e.g. it can be use to allow access to USB mass-storage or dm-=
verity
>>   content only
>> * SECCOMP_ARGFLAG_FS_MOUNT: Check the file mount point, e.g. can enforce=
 a
>>   read-only bind mount (but is less flexible than the other checks)
>> * SECCOMP_ARGFLAG_FS_NOFOLLOW: Check the file without following it if it=
 is a
>>   symlink. Useful for rename(2) or open(2) with O_NOFOLLOW to have consi=
stent
>>   check. However, LSM hooks will deny all unattended accesses set by the=
 rules
>>   ignoring this flag (i.e. it act as a fail-safe).
>>
>> # Limitations
>>
>> ## Ptrace
>> If a process can ptrace another one, the tracer can execute whatever sys=
call it
>> wants without being constrained by any seccomp filter from the tracee. T=
his
>> apply for this seccomp extension as well. Any seccomp filter should then=
 deny
>> the use of ptrace.
>>
>> The LSM hooks must ensure that the filters results are the same (with th=
e same
>> arguments) but must not deny any ptraced modifications (e.g. syscall arg=
ument
>> change).
>>
>> ## Stateless access
>> Unlike current LSMs, the policies are stateless. It's not possible to ma=
rk and
>> track a kernel object (e.g. file descriptor). Capsicum seems more approp=
riate
>> for this kind of feature.
>>
>> ## Resource usage
>> We must limit the resources taken by a filter list, and so the number of=
 rules,
>> to not allow any process to exhaust the system.
>>
>>
>> Regards,
>>
>> Micka=C3=ABl Sala=C3=BCn (17):
>>   um: Export the sys_call_table
>>   seccomp: Fix typo
>>   selftest/seccomp: Fix the flag name SECCOMP_FILTER_FLAG_TSYNC
>>   selftest/seccomp: Fix the seccomp(2) signature
>>   security/seccomp: Add LSM and create arrays of syscall metadata
>>   seccomp: Add the SECCOMP_ADD_CHECKER_GROUP command
>>   seccomp: Add seccomp object checker evaluation
>>   selftest/seccomp: Remove unknown_ret_is_kill_above_allow test
>>   selftest/seccomp: Extend seccomp_data until matches[6]
>>   selftest/seccomp: Add field_is_valid_syscall test
>>   selftest/seccomp: Add argeval_open_whitelist test
>>   audit,seccomp: Extend audit with seccomp state
>>   selftest/seccomp: Rename TRACE_poke to TRACE_poke_sys_read
>>   selftest/seccomp: Make tracer_poke() more generic
>>   selftest/seccomp: Add argeval_toctou_argument test
>>   security/seccomp: Protect against filesystem TOCTOU
>>   selftest/seccomp: Add argeval_toctou_filesystem test
>>
>>  arch/x86/um/asm/syscall.h                     |   2 +
>>  include/asm-generic/vmlinux.lds.h             |  22 +
>>  include/linux/audit.h                         |  25 ++
>>  include/linux/compat.h                        |  10 +
>>  include/linux/lsm_hooks.h                     |   5 +
>>  include/linux/seccomp.h                       | 136 +++++-
>>  include/linux/syscalls.h                      |  68 +++
>>  include/uapi/linux/seccomp.h                  | 105 +++++
>>  kernel/audit.h                                |   3 +
>>  kernel/auditsc.c                              |  36 +-
>>  kernel/fork.c                                 |  13 +-
>>  kernel/seccomp.c                              | 594 +++++++++++++++++++=
++++++-
>>  security/Kconfig                              |   1 +
>>  security/Makefile                             |   2 +
>>  security/seccomp/Kconfig                      |  14 +
>>  security/seccomp/Makefile                     |   3 +
>>  security/seccomp/checker_fs.c                 | 524 +++++++++++++++++++=
++++
>>  security/seccomp/checker_fs.h                 |  18 +
>>  security/seccomp/lsm.c                        | 135 ++++++
>>  security/seccomp/lsm.h                        |  19 +
>>  security/security.c                           |   1 +
>>  tools/testing/selftests/seccomp/seccomp_bpf.c | 572 +++++++++++++++++++=
++++--
>>  22 files changed, 2248 insertions(+), 60 deletions(-)
>>  create mode 100644 security/seccomp/Kconfig
>>  create mode 100644 security/seccomp/Makefile
>>  create mode 100644 security/seccomp/checker_fs.c
>>  create mode 100644 security/seccomp/checker_fs.h
>>  create mode 100644 security/seccomp/lsm.c
>>  create mode 100644 security/seccomp/lsm.h
>>
>



--=20
Kees Cook
Chrome OS & Brillo Security
