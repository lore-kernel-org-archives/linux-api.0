From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC v1 00/17] seccomp-object: From attack surface reduction to
 sandboxing
Date: Wed, 20 Apr 2016 20:21:11 +0200
Message-ID: <5717C897.1050508@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="cjdmfTBaSuixTUX1hHqGmmHxDRFEq4bEw"
Return-path: <kernel-hardening-return-3070-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1458784008-16277-1-git-send-email-mic@digikod.net>
To: linux-security-module@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cjdmfTBaSuixTUX1hHqGmmHxDRFEq4bEw
Content-Type: multipart/mixed; boundary="wFqwdnB7W48aCPvjMu5PXRJ7kiQHkAm11"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: linux-security-module@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
 Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 Daniel Borkmann <daniel@iogearbox.net>, David Drysdale
 <drysdale@google.com>, Eric Paris <eparis@redhat.com>,
 James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>,
 Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <pmoore@redhat.com>,
 Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>,
 Stephen Smalley <sds@tycho.nsa.gov>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org,
 kernel-hardening@lists.openwall.com
Message-ID: <5717C897.1050508@digikod.net>
Subject: Re: [RFC v1 00/17] seccomp-object: From attack surface reduction to
 sandboxing
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
In-Reply-To: <1458784008-16277-1-git-send-email-mic@digikod.net>

--wFqwdnB7W48aCPvjMu5PXRJ7kiQHkAm11
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Does anyone had time to review some patches?

What do you think about the ToCToU workarounds?
What about the userland API?

The series can be found here: https://github.com/l0kod/linux/commits/secc=
omp-object-v1

 Micka=C3=ABl


On 24/03/2016 02:46, Micka=C3=ABl Sala=C3=BCn wrote:
> Hi,
>=20
> This series is a proof of concept (not ready for production) to extend =
seccomp
> with the ability to check argument pointers of syscalls as kernel objec=
t (e.g.
> file path). This add a needed feature to create a full sandbox managed =
by
> userland like the Seatbelt/XNU Sandbox or the OpenBSD Pledge. It was in=
itially
> inspired from a partial seccomp-LSM prototype [1] but has evolved a lot=
 since :)
>=20
> The audience for this RFC is limited to security-related actors to disc=
uss
> about this new feature before enlarging the scope to a wider audience. =
This
> aims to focus on the security goal, usability and architecture before e=
ntering
> into the gory details of each subsystem. I also wish to get constructiv=
e
> criticisms about the userland API and intrusiveness of the code (and wh=
at could
> be the other ways to do it better) before going further (and addressing=
 the
> TODO and FIXME in the code).
>=20
> The approach taken is to add the minimum amount of code while still all=
owing
> the userland to create access rules via seccomp. The current limitation=
 of
> seccomp is to get raw syscall arguments value but there is no way to
> dereference a pointer to check its content (e.g. the first argument of =
the open
> syscall). This seccomp evolution brings a generic way to check against =
argument
> pointer regardless from the syscall unlike current LSMs.
>=20
> Here is the use case scenario:
> * First, a process must load some groups of seccomp checkers. This chec=
kers are
>   dedicated structs describing a pointed data (e.g. path). They are
>   semantically grouped to be efficiently managed and checked in batch. =
Each
>   group have a static ID. This IDs are unique and they reference groups=
 only
>   accessible from the filters created by the same process.
> * The loaded checkers are inherited and accessible by the newly created=

>   filters. This groups can be referenced by filters with a new return v=
alue
>   SECCOMP_RET_ARGEVAL. Value in  SECCOMP_RET_DATA contains a group ID a=
nd an
>   argument bitmask. This return value is only meaningful between stacke=
d
>   filters to ask a check and get the result in the extended struct
>   seccomp_data. The new fields are "is_valid_syscall", "arg_group" cont=
aining a
>   group ID and "matches[6]" consisting of one 64-bits mask per argument=
=2E This
>   bitmasks are useful to get the check result of each checker from a gr=
oup on a
>   syscall argument which is handy to create a custom access control eng=
ine from
>   userland.
> * SECCOMP_RET_ARGEVAL is equivalent to SECCOMP_RET_ACCESS except that t=
he
>   following filters can take a decision regarding a match (e.g. return =
EACCESS
>   or emulate the syscall).
>=20
> Each checker is autonomous and new ones can easily be added in the futu=
re.
> There is currently two checkers for path objects:
> * SECCOMP_CHECK_FS_LITERAL checks if a string match a defined path;
> * SECCOMP_CHECK_FS_BENEATH checks if the path representation of a strin=
g is
>   equal or equivalent to a file belonging to a defined path.
>=20
> This design does not seems too intrusive but is flexible enough to allo=
w a
> powerful sandbox mechanism accessible by any process on Linux. The use =
of
> seccomp, including this new feature, is more suitable with the help of =
a
> userland library (e.g. libseccomp) that could help to specify a high-le=
vel
> language to express a security policy instead of raw syscall rules.
>=20
> The main concern should be about time-of-check-time-of-use (TOCTOU) rac=
e
> conditions attacks. Because of the nature of seccomp (executed before t=
he
> effective syscall and before a potential ptrace), it is not possible to=
 block
> all races but to detect them.
>=20
> There is still some questions I couldn't answer for sure (grep for FIXM=
E or
> XXX). Comments appreciated.
>=20
> Tested on the x86 and UM architectures in 32 and 64 bits (with audit en=
abled).
>=20
> [1] https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=3D=
seccomp/lsm
>=20
>=20
> # Need for LSM
>=20
> Because the arguments can be checked before the syscall actually evalua=
te them,
> there is two race condition classes:
> * The data pointed by the user address is in control of the userland (e=
=2Eg. a
>   tracing process) and is so subject to TOCTOU race conditions between =
the
>   seccomp filter evaluation and the effective resource grabbing (part o=
f each
>   syscall code).
> * The semantic of the pointed data is also subject to race condition be=
cause
>   there is no lock on the resource (e.g. file) between the evaluation o=
f the
>   argument by the seccomp filter and the use of the pointed resource by=
 each
>   part of the syscall code.
>=20
> The solution to fix these race conditions is to copy the userspace data=
 and to
> lock the pointed resource. Whereas it is easy to copy the userspace dat=
a, it is
> not realistic to lock any pointed resources because of obvious locking =
issues.
> However, it is possible to detect a TOCTOU race condition with the help=
 of LSM
> hooks. This way, we can keep a flexible access control (e.g. by control=
ling
> syscall return values) while blocking unattended malicious or bogus use=
rland
> behavior (e.g. exploit a race-condition).
>=20
> To be able to deny access to a malicious userland behavior we must repl=
ay the
> seccomp filters and verify the intermediate return values to find out i=
f the
> filters policy is still respected. Thanks to a cache we can detect if a=
 check
> replay is necessary. Otherwise, the LSM hooks are really quick for
> non-malicious userland.
>=20
> # Cache handling
>=20
> Each time a checker is called, for each argument to check, it get them =
from
> it's seccomp_argeval_checked cache if any, or create a new cache entry =
and put
> it otherwise. This cache entries will be used to evaluate arguments.
>=20
> When rechecking in the LSM hooks, first it find out which argument is m=
apped to
> the hook check and find if it differ from the corresponding cache entry=
=2E If it
> match, then return OK without replaying the checks, or if nothing match=
, replay
> all the checks from this check type.
>=20
> # How to use it
>=20
> The SECCOMP_ARGFLAG_* help to narrow the rules constraints:
> * SECCOMP_ARGFLAG_FS_DENTRY: Check and rely on the path name.
> * SECCOMP_ARGFLAG_FS_INODE: Check the data "container" whatever it's pa=
th name.
> * SECCOMP_ARGFLAG_FS_DEVICE: Check the device (i.e. file system) on whi=
ch the
>   file is, e.g. it can be use to allow access to USB mass-storage or dm=
-verity
>   content only
> * SECCOMP_ARGFLAG_FS_MOUNT: Check the file mount point, e.g. can enforc=
e a
>   read-only bind mount (but is less flexible than the other checks)
> * SECCOMP_ARGFLAG_FS_NOFOLLOW: Check the file without following it if i=
t is a
>   symlink. Useful for rename(2) or open(2) with O_NOFOLLOW to have cons=
istent
>   check. However, LSM hooks will deny all unattended accesses set by th=
e rules
>   ignoring this flag (i.e. it act as a fail-safe).
>=20
> # Limitations
>=20
> ## Ptrace
> If a process can ptrace another one, the tracer can execute whatever sy=
scall it
> wants without being constrained by any seccomp filter from the tracee. =
This
> apply for this seccomp extension as well. Any seccomp filter should the=
n deny
> the use of ptrace.
>=20
> The LSM hooks must ensure that the filters results are the same (with t=
he same
> arguments) but must not deny any ptraced modifications (e.g. syscall ar=
gument
> change).
>=20
> ## Stateless access
> Unlike current LSMs, the policies are stateless. It's not possible to m=
ark and
> track a kernel object (e.g. file descriptor). Capsicum seems more appro=
priate
> for this kind of feature.
>=20
> ## Resource usage
> We must limit the resources taken by a filter list, and so the number o=
f rules,
> to not allow any process to exhaust the system.
>=20
>=20
> Regards,
>=20
> Micka=C3=ABl Sala=C3=BCn (17):
>   um: Export the sys_call_table
>   seccomp: Fix typo
>   selftest/seccomp: Fix the flag name SECCOMP_FILTER_FLAG_TSYNC
>   selftest/seccomp: Fix the seccomp(2) signature
>   security/seccomp: Add LSM and create arrays of syscall metadata
>   seccomp: Add the SECCOMP_ADD_CHECKER_GROUP command
>   seccomp: Add seccomp object checker evaluation
>   selftest/seccomp: Remove unknown_ret_is_kill_above_allow test
>   selftest/seccomp: Extend seccomp_data until matches[6]
>   selftest/seccomp: Add field_is_valid_syscall test
>   selftest/seccomp: Add argeval_open_whitelist test
>   audit,seccomp: Extend audit with seccomp state
>   selftest/seccomp: Rename TRACE_poke to TRACE_poke_sys_read
>   selftest/seccomp: Make tracer_poke() more generic
>   selftest/seccomp: Add argeval_toctou_argument test
>   security/seccomp: Protect against filesystem TOCTOU
>   selftest/seccomp: Add argeval_toctou_filesystem test
>=20
>  arch/x86/um/asm/syscall.h                     |   2 +
>  include/asm-generic/vmlinux.lds.h             |  22 +
>  include/linux/audit.h                         |  25 ++
>  include/linux/compat.h                        |  10 +
>  include/linux/lsm_hooks.h                     |   5 +
>  include/linux/seccomp.h                       | 136 +++++-
>  include/linux/syscalls.h                      |  68 +++
>  include/uapi/linux/seccomp.h                  | 105 +++++
>  kernel/audit.h                                |   3 +
>  kernel/auditsc.c                              |  36 +-
>  kernel/fork.c                                 |  13 +-
>  kernel/seccomp.c                              | 594 ++++++++++++++++++=
+++++++-
>  security/Kconfig                              |   1 +
>  security/Makefile                             |   2 +
>  security/seccomp/Kconfig                      |  14 +
>  security/seccomp/Makefile                     |   3 +
>  security/seccomp/checker_fs.c                 | 524 ++++++++++++++++++=
+++++
>  security/seccomp/checker_fs.h                 |  18 +
>  security/seccomp/lsm.c                        | 135 ++++++
>  security/seccomp/lsm.h                        |  19 +
>  security/security.c                           |   1 +
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 572 ++++++++++++++++++=
+++++--
>  22 files changed, 2248 insertions(+), 60 deletions(-)
>  create mode 100644 security/seccomp/Kconfig
>  create mode 100644 security/seccomp/Makefile
>  create mode 100644 security/seccomp/checker_fs.c
>  create mode 100644 security/seccomp/checker_fs.h
>  create mode 100644 security/seccomp/lsm.c
>  create mode 100644 security/seccomp/lsm.h
>=20


--wFqwdnB7W48aCPvjMu5PXRJ7kiQHkAm11--

--cjdmfTBaSuixTUX1hHqGmmHxDRFEq4bEw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCgAGBQJXF8igAAoJECLe/t9zvWqVp4YH/1YcatDkhZtQB4bfsCue3vYW
tvKSId2sNEVcRq9CyTy62BEEsJTNW6GA1GRc/sgOnBq6n5AwFwM8RALP8oGe1tYT
lt8npc/by/9LMMa4yt0G8Wgg5RgH+AY4d85VvmQ3lOfqSD0fw98ezCPdOoc4nbCd
1fG5KkyrCzeWC3Hqw5C49newbZWrw975HLlZIf5flxzl659tcB8aIzxu3swPm0Yr
UBpZDCzSb95Bkfnyj3rFEjoguewI36lKzh1kpK5Xww0MNgmJq0EXSw+5yWO/d2gC
FLA7/3n++PEpUVhxlIPa4ntMMI2uytHIZzwiiau9J/tiBKFLVxsxigf5N1hcEyQ=
=ub6J
-----END PGP SIGNATURE-----

--cjdmfTBaSuixTUX1hHqGmmHxDRFEq4bEw--
