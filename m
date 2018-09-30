From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH 0/3] namei: implement various scoping AT_* flags
Date: Mon, 1 Oct 2018 00:37:48 +0200
Message-ID: <0ca12a6e-a86b-5d50-40b9-e76c1a4bc6a0@digikod.net>
References: <20180929103453.12025-1-cyphar@cyphar.com>
 <39d64180-73d5-6f27-e455-956143a5b5d3@digikod.net>
 <CAG48ez1CUHTKrpbwJxXkYoUKm5eYV15LuRRO+dXveo=MQvjJkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="wgVj6Afw3fQKMXeLO1nDVYZugpUwkmgK4"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez1CUHTKrpbwJxXkYoUKm5eYV15LuRRO+dXveo=MQvjJkA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: cyphar@cyphar.com, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, christian@brauner.io, "Eric W. Biederman" <ebiederm@xmission.com>, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-kselftest@vger.kernel.org, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-security-module <linux-security-module@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wgVj6Afw3fQKMXeLO1nDVYZugpUwkmgK4
Content-Type: multipart/mixed; boundary="NawprYHEhbBncao4pQ5R3xEtnbnBAuJxY";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Jann Horn <jannh@google.com>
Cc: cyphar@cyphar.com, jlayton@kernel.org, Bruce Fields
 <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org,
 David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 christian@brauner.io, "Eric W. Biederman" <ebiederm@xmission.com>,
 Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>,
 linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>,
 linux-kselftest@vger.kernel.org, dev@opencontainers.org,
 containers@lists.linux-foundation.org,
 linux-security-module <linux-security-module@vger.kernel.org>,
 Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>
Message-ID: <0ca12a6e-a86b-5d50-40b9-e76c1a4bc6a0@digikod.net>
Subject: Re: [PATCH 0/3] namei: implement various scoping AT_* flags
References: <20180929103453.12025-1-cyphar@cyphar.com>
 <39d64180-73d5-6f27-e455-956143a5b5d3@digikod.net>
 <CAG48ez1CUHTKrpbwJxXkYoUKm5eYV15LuRRO+dXveo=MQvjJkA@mail.gmail.com>
In-Reply-To: <CAG48ez1CUHTKrpbwJxXkYoUKm5eYV15LuRRO+dXveo=MQvjJkA@mail.gmail.com>

--NawprYHEhbBncao4pQ5R3xEtnbnBAuJxY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


On 9/30/18 23:46, Jann Horn wrote:
> On Sun, Sep 30, 2018 at 10:39 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.=
net> wrote:
>> As a side note, I'm still working on Landlock which can achieve the sa=
me
>> goal but in a more flexible and dynamic way: https://landlock.io
>=20
> Isn't Landlock mostly intended for userspace that wants to impose a
> custom Mandatory Access Control policy on itself, restricting the
> whole process?
>=20
> As far as I can tell, a major usecase for AT_BENEATH are privileged
> processes that do not want to restrict all filesystem operations they
> perform, but want to sometimes impose limits on filesystem traversal
> for the duration of a single system call. For example, a process might
> want to first open a file from an untrusted filesystem area with
> AT_BENEATH, and afterwards open a configuration file without
> AT_BENEATH.

I didn't realized this was the main use case for AT_BENEATH. Landlock is
indeed dedicated to apply a security policy on a set of processes. This
set can be a process and its children (seccomp-like), or another set of
processes that may be identified with a cgroup.

>=20
> How would you do this in Landlock? Use a BPF map to store per-thread
> filesystem restrictions, and then do bpf() calls before and after
> every restricted filesystem access to set and unset the policy for the
> current syscall?

Another way to apply a security policy could be to tied it to a file
descriptor, similarly to Capsicum, which could enable to create
programmable (real) capabilities. This way, it would be possible to
"wrap" a file descriptor with a Landlock program and use it with
FD-based syscalls or pass it to other processes. This would not require
changes to the FS subsystem, but only the Landlock LSM code. This isn't
done yet but I plan to add this new way to restrict operations on file
descriptors.

Anyway, for the use case you mentioned, the AT_BENEATH flag(s) should be
simple to use and enough for now. We must be careful of the hardcoded
policy though.


>=20
>> On 9/29/18 12:34, Aleksa Sarai wrote:
>>> The need for some sort of control over VFS's path resolution (to avoi=
d
>>> malicious paths resulting in inadvertent breakouts) has been a very
>>> long-standing desire of many userspace applications. This patchset is=
 a
>>> revival of Al Viro's old AT_NO_JUMPS[1] patchset with a few additions=
=2E
>>>
>>> The most obvious change is that AT_NO_JUMPS has been split as dicusse=
d
>>> in the original thread, along with a further split of AT_NO_PROCLINKS=

>>> which means that each individual property of AT_NO_JUMPS is now a
>>> separate flag:
>>>
>>>   * Path-based escapes from the starting-point using "/" or ".." are
>>>     blocked by AT_BENEATH.
>>>   * Mountpoint crossings are blocked by AT_XDEV.
>>>   * /proc/$pid/fd/$fd resolution is blocked by AT_NO_PROCLINKS (more
>>>       correctly it actually blocks any user of nd_jump_link() because=
 it
>>>       allows out-of-VFS path resolution manipulation).
>>>
>>> AT_NO_JUMPS is now effectively (AT_BENEATH|AT_XDEV|AT_NO_PROCLINKS). =
At
>>> Linus' suggestion in the original thread, I've also implemented
>>> AT_NO_SYMLINKS which just denies _all_ symlink resolution (including
>>> "proclink" resolution).
>>>
>>> An additional improvement was made to AT_XDEV. The original AT_NO_JUM=
PS
>>> path didn't consider "/tmp/.." as a mountpoint crossing -- this patch=

>>> blocks this as well (feel free to ask me to remove it if you feel thi=
s
>>> is not sane).
>>>
>>> Currently I've only enabled these for openat(2) and the stat(2) famil=
y.
>>> I would hope we could enable it for basically every *at(2) syscall --=

>>> but many of them appear to not have a @flags argument and thus we'll
>>> need to add several new syscalls to do this. I'm more than happy to s=
end
>>> those patches, but I'd prefer to know that this preliminary work is
>>> acceptable before doing a bunch of copy-paste to add new sets of *at(=
2)
>>> syscalls.
>>>
>>> One additional feature I've implemented is AT_THIS_ROOT (I imagine th=
is
>>> is probably going to be more contentious than the refresh of
>>> AT_NO_JUMPS, so I've included it in a separate patch). The patch itse=
lf
>>> describes my reasoning, but the shortened version of the premise is t=
hat
>>> continer runtimes need to have a way to resolve paths within a
>>> potentially malicious rootfs. Container runtimes currently do this in=

>>> userspace[2] which has implicit race conditions that are not resolvab=
le
>>> in userspace (or use fork+exec+chroot and SCM_RIGHTS passing which is=

>>> inefficient). AT_THIS_ROOT allows for per-call chroot-like semantics =
for
>>> path resolution, which would be invaluable for us -- and the
>>> implementation is basically identical to AT_BENEATH (except that we
>>> don't return errors when someone actually hits the root).
>>>
>>> I've added some selftests for this, but it's not clear to me whether
>>> they should live here or in xfstests (as far as I can tell there are =
no
>>> other VFS tests in selftests, while there are some tests that look li=
ke
>>> generic VFS tests in xfstests). If you'd prefer them to be included i=
n
>>> xfstests, let me know.
>>>
>>> [1]: https://lore.kernel.org/patchwork/patch/784221/
>>> [2]: https://github.com/cyphar/filepath-securejoin
>>>
>>> Aleksa Sarai (3):
>>>   namei: implement O_BENEATH-style AT_* flags
>>>   namei: implement AT_THIS_ROOT chroot-like path resolution
>>>   selftests: vfs: add AT_* path resolution tests
>>>
>>>  fs/fcntl.c                                    |   2 +-
>>>  fs/namei.c                                    | 158 ++++++++++++----=
--
>>>  fs/open.c                                     |  10 ++
>>>  fs/stat.c                                     |  15 +-
>>>  include/linux/fcntl.h                         |   3 +-
>>>  include/linux/namei.h                         |   8 +
>>>  include/uapi/asm-generic/fcntl.h              |  20 +++
>>>  include/uapi/linux/fcntl.h                    |  10 ++
>>>  tools/testing/selftests/Makefile              |   1 +
>>>  tools/testing/selftests/vfs/.gitignore        |   1 +
>>>  tools/testing/selftests/vfs/Makefile          |  13 ++
>>>  tools/testing/selftests/vfs/at_flags.h        |  40 +++++
>>>  tools/testing/selftests/vfs/common.sh         |  37 ++++
>>>  .../selftests/vfs/tests/0001_at_beneath.sh    |  72 ++++++++
>>>  .../selftests/vfs/tests/0002_at_xdev.sh       |  54 ++++++
>>>  .../vfs/tests/0003_at_no_proclinks.sh         |  50 ++++++
>>>  .../vfs/tests/0004_at_no_symlinks.sh          |  49 ++++++
>>>  .../selftests/vfs/tests/0005_at_this_root.sh  |  66 ++++++++
>>>  tools/testing/selftests/vfs/vfs_helper.c      | 154 ++++++++++++++++=
+
>>>  19 files changed, 707 insertions(+), 56 deletions(-)
>>>  create mode 100644 tools/testing/selftests/vfs/.gitignore
>>>  create mode 100644 tools/testing/selftests/vfs/Makefile
>>>  create mode 100644 tools/testing/selftests/vfs/at_flags.h
>>>  create mode 100644 tools/testing/selftests/vfs/common.sh
>>>  create mode 100755 tools/testing/selftests/vfs/tests/0001_at_beneath=
=2Esh
>>>  create mode 100755 tools/testing/selftests/vfs/tests/0002_at_xdev.sh=

>>>  create mode 100755 tools/testing/selftests/vfs/tests/0003_at_no_proc=
links.sh
>>>  create mode 100755 tools/testing/selftests/vfs/tests/0004_at_no_syml=
inks.sh
>>>  create mode 100755 tools/testing/selftests/vfs/tests/0005_at_this_ro=
ot.sh
>>>  create mode 100644 tools/testing/selftests/vfs/vfs_helper.c
>>>
>>
>=20
>=20


--NawprYHEhbBncao4pQ5R3xEtnbnBAuJxY--

--wgVj6Afw3fQKMXeLO1nDVYZugpUwkmgK4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAluxUEMACgkQIt7+33O9
apU5Owf/XNm8KqxfTvQVtaS5jy3nbuB400j05atRqOyQGZswXbulq5/izrXmVWm1
WOGTtY+gfU8FPrZ7vkrcuagx3GbPdouNpPBw1fHaI4wt+fjq7MSAS65Up6Thp726
jGPVwsEe30JGe/j1xxYCrh6z7g6g6H73sAKiQtrscf3HzIm/YXJDpOEvFanwjR1y
XNcoFflB7poRHNdCQVzur5VA3rYibLh/B93Tef2dNaznhp5e6cSWndmlo6MA4FpS
DR2CDLFsnKMT6ne8ODgkdQrJsSL0nIwWkc98fFIxV3JC56z1iTxymKkJaLHqrSAk
rNfNtC5eDDuvS2fAzocH/by3q7BBLA==
=IdO2
-----END PGP SIGNATURE-----

--wgVj6Afw3fQKMXeLO1nDVYZugpUwkmgK4--
