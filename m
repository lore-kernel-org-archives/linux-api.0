From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH bpf-next 1/6] bpf: introduce BPF_PROG_TYPE_FILE_FILTER
Date: Mon, 8 Oct 2018 11:06:12 +0200
Message-ID: <21525bdd-f36e-e667-c30c-0b1d96d4cfaa@digikod.net>
References: <20181004025750.498303-1-ast@kernel.org>
 <20181004025750.498303-2-ast@kernel.org>
 <CAG48ez2zuJP0qOSU5QAER1xP56d5SvC0HTrM0Yh3wkKEQZ9R3A@mail.gmail.com>
 <20181008022210.33ljgryhodzunf5l@ast-mbp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="ZuFo3URFNuj67zDUHuDr3ZZmLnn0vPwt3"
Return-path: <kernel-hardening-return-14149-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20181008022210.33ljgryhodzunf5l@ast-mbp>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Jann Horn <jannh@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Network Development <netdev@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZuFo3URFNuj67zDUHuDr3ZZmLnn0vPwt3
Content-Type: multipart/mixed; boundary="s8J97wK6jodOSvZAps7GdU01wi6LfJXeM";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Jann Horn <jannh@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>,
 Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>,
 Network Development <netdev@vger.kernel.org>,
 kernel list <linux-kernel@vger.kernel.org>, kernel-team@fb.com,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 linux-security-module <linux-security-module@vger.kernel.org>,
 Linux API <linux-api@vger.kernel.org>
Message-ID: <21525bdd-f36e-e667-c30c-0b1d96d4cfaa@digikod.net>
Subject: Re: [PATCH bpf-next 1/6] bpf: introduce BPF_PROG_TYPE_FILE_FILTER
References: <20181004025750.498303-1-ast@kernel.org>
 <20181004025750.498303-2-ast@kernel.org>
 <CAG48ez2zuJP0qOSU5QAER1xP56d5SvC0HTrM0Yh3wkKEQZ9R3A@mail.gmail.com>
 <20181008022210.33ljgryhodzunf5l@ast-mbp>
In-Reply-To: <20181008022210.33ljgryhodzunf5l@ast-mbp>

--s8J97wK6jodOSvZAps7GdU01wi6LfJXeM
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


On 10/8/18 04:22, Alexei Starovoitov wrote:
> On Mon, Oct 08, 2018 at 02:56:15AM +0200, Jann Horn wrote:
>> +cc kernel-hardening because this is related to sandboxing
>> +cc Micka=C3=ABl Sala=C3=BCn because this looks related to his Landloc=
k proposal

Thanks for the CC. Because this patch series is an access-control
mechanism, it will undoubtedly interest LSM folks as well.

Here is the full thread:
https://lore.kernel.org/lkml/20181004025750.498303-1-ast@kernel.org/

>=20
> It may seem that this work overlaps with landlock, but the goals
> are different. Landlock is LSM based to act as _security_ framework
> with end goal being available to unpriv users.

Right, one of the end goal of Landlock is to make most of its
access-control features available to unprivileged processes. However,
some of them may require higher privileges, but we should minimize them
as much as possible to not end up with the SUID-binary (or
CAP_SYS_ADMIN) syndrome.

> While this cgroup-bpf hook is expected to stay root only,
> since we're trying to restrict what containers can do in a trusted envi=
ronment.
> 'sandboxing' is overloaded word.
> Sandboxing for security and sandboxing of trusted root are different.

Sure we must treat them in a different manner but we must take care of
which capability this sandboxing mechanism really need, and hopefully
not root-like ones, especially for a container.

As a reminder, using cgroups to sandbox processes is definitely a use
case for Landlock, as well as the process hierarchy one (seccomp-like).
I implemented sandboxing with cgroups in a previous patch series, but
put it aside for now to minimize the number of patches.

>=20
>> On Mon, Oct 8, 2018 at 2:30 AM Alexei Starovoitov <ast@kernel.org> wro=
te:
>>> Similar to networking sandboxing programs and cgroup-v2 based hooks
>>> (BPF_CGROUP_INET_[INGRESS|EGRESS,] BPF_CGROUP_INET[4|6]_[BIND|CONNECT=
], etc)
>>> introduce basic per-container sandboxing for file access via
>>> new BPF_PROG_TYPE_FILE_FILTER program type that attaches after
>>> security_file_open() LSM hook and works as additional file_open filte=
r.
>>> The new cgroup bpf hook is called BPF_CGROUP_FILE_OPEN.
>>
>> Why do_dentry_open() specifically, and nothing else? If you want to
>> filter open, wouldn't you also want to filter a bunch of other
>> filesystem operations with LSM hooks, like rename, unlink, truncate
>> and so on? Landlock benefits there from re-using the existing security=

>> hooks.
>=20
> It may make sense to extend in the future, but we don't have clear
> user cases for rename/unlink/truncate at this point.

I guess the users who ask for the current features will come with new
ones, which will move towards the same goal as Landlock.

>=20
> As you can see the amount of pushback even for basic file access is hig=
h.
> Hence I don't think the landlock can be upstreamed in the current form,=

> since it touches VFS layer a lot more than this patch.

That is not true for the main part. The only patch from Landlock
touching the FS subsystem is to add a new LSM hook. This was NAKed by Al
but I guess mostly because of misunderstanding. I'll send a new specific
patch to the FS subsystem soon to properly explain the impact on path
lookup and why it doesn't expose more that userspace have already access.=


Regarding the upstreaming concern, if I remember correctly, the net/BPF
and the LSM maintainers are (mostly ?) OK. The feedback I got (you
included) was good.

I can definitely create a lighter version of Landlock with your use
cases in mind. There is already all the necessary building blocks: the
BPF (un-)privileged handling, the file checks (see the FS_PICK subtype)
and the cgroups handling. I may even be easier to upstream (and answer
Casey's request) to make the patch series smaller.

> It's intrusive to LSM, and adds new concepts to BPF as well.
> This work fits into existing BPF machinery and minimally intrusive to V=
FS.
> I hope we can find a common ground with Al regarding what file
> access primitives are exposed to BPF side.
> Once we agree on that the landlock can piggy back on this work
> and extend it to all file-based LSM hooks.

Can you explain your thought about piggy backing? If your patch is
included, Landlock will still need to add new BPF prog types, and will
still be an LSM (which is designed to handle access-control).

> The first step for everyone interested in bpf-based 'sandboxing'
> is to figure out VFS<->BPF interface.
> If you or Mickael have suggestions on what bpf progs should and should =
not
> see at these hooks, it's a good time to discuss.
> I believe the fields proposed are the obvious minimum.

In a nutshell, Landlock rely on an inode map, which contains references
to inodes. These references/handles can then be used to "compare" with a
requested inode. This way, we can limit the checks to what is already
available to the process which loaded the map. I suggest to not use
these hardcoded fields but use a BFP helper with a file handle as
argument and dedicated flags, as I did in a previous version of Landlock
(which I planned to upstream as a new future feature).

>=20
>>> Just like other cgroup-bpf programs new BPF_PROG_TYPE_FILE_FILTER typ=
e
>>> is only available to root.
>>>
>>> This program type has access to single argument 'struct bpf_file_info=
'
>>> that contains standard sys_stat fields:
>>> struct bpf_file_info {
>>>         __u64 inode;
>>>         __u32 dev_major;
>>>         __u32 dev_minor;
>>>         __u32 fs_magic;
>>>         __u32 mnt_id;
>>>         __u32 nlink;
>>>         __u32 mode;     /* file mode S_ISDIR, S_ISLNK, 0755, etc */
>>>         __u32 flags;    /* open flags O_RDWR, O_CREAT, etc */
>>> };
>>> Other file attributes can be added in the future to the end of this s=
truct
>>> without breaking bpf programs.
>>>
>>> For debugging introduce bpf_get_file_path() helper that returns
>>> NUL-terminated full path of the file. It should never be used for san=
dboxing.

Well, I'm convinced it *will* be used for sandboxing. Once a feature is
available, it is too late to forbid users to use it the way they want,
even if you warn them about security issues=E2=80=A6

>>>
>>> Use cases:
>>> - disallow certain FS types within containers (fs_magic =3D=3D CGROUP=
2_SUPER_MAGIC)
>>> - restrict permissions in particular mount (mnt_id =3D=3D X && (flags=
 & O_RDWR))
>>> - disallow access to hard linked sensitive files (nlink > 1 && mode =3D=
=3D 0700)
>>> - disallow access to world writeable files (mode =3D=3D 0..7)
>>> - disallow access to given set of files (dev_major =3D=3D X && dev_mi=
nor =3D=3D Y && inode =3D=3D Z)

These use cases are interesting and should help to harden containers.
They are definitely in the scope of what Landlock can do.

However, I would like to see which capabilities are needed to access
these properties.

>>
>> That last one sounds weird. It doesn't work if you want to ban access
>> to a whole directory at once. And in general, highly specific
>> blocklists make me nervous, because if you add anything new and forget=

>> to put it on the list, you have a problem.
>=20
> In the upcoming V2 of the patches the direct exposure to dev and inode =
will be removed.
> And instead the opaque 'struct file_handle' will be available to bpf pr=
ogs.
> The use case is indeed to restrict access to specific blacklist of file=
s.
> The user space will collect the set of files via sys_name_to_handle_at(=
),
> then store the fhandles in bpf map, and bpf prog will consult the map
> to deny the access.
> It's not a replacement for ACLs, directory permissions, etc. The use ca=
se
> is to prevent trusted containers messing up the environment.
> The continuous integration system needs to run some containers (and tes=
ts inside them)
> with root privs. When these jobs mess up the system the subsequent jobs=
 may incorrectly
> fail. We believe that this cgroup based container enforcement will solv=
e this use case
> and similar other use cases when containers are trusted, but could be b=
uggy when
> it comes to file access.
>=20
> To recap what I'm implementing in V2:
> 1.
> struct bpf_file_info {
>         __u32 fs_magic; // file->f_inode->i_sb->s_magic
>         __u32 mnt_id;   // real_mount(file->f_path.mnt)->mnt_id
>         __u32 nlink;    // file->f_inode->i_nlink
>         __u32 mode;     // file->f_inode->i_mode
>         __u32 flags;    // file->f_flags
> };
> I double checked what VFS layer does with above fields and I think
> there is no additional user space exposure will be made when such
> fields are seen by bpf progs.
> But since I'm not a VFS expert, I'd like Al to confirm.
>=20
> 2.
> bpf_get_file_handle(struct bpf_file_info *ctx, struct file_handle *fh, =
int fh_size);
> helper that bpf prog will use to obtain fh of the file about to be open=
=2E

This looks like Landlock. :)

>=20
> 3.
> bpf_get_file_statx(struct bpf_file_info *ctx, struct statx *sx, int siz=
e, int flags);
> Though struct statx is 256 bytes, and the helper would have to touch al=
l bytes
> I couldn't figure out the faster way to get to inode/dev/uid of the giv=
en file
> that will work on all underlying FSes.

This looks like a previous helper I implemented, but tried to avoid
because of security issues (mostly for unpriv processes).

>=20
> Thoughts?
>=20
>=20


--s8J97wK6jodOSvZAps7GdU01wi6LfJXeM--

--ZuFo3URFNuj67zDUHuDr3ZZmLnn0vPwt3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAlu7HgQACgkQIt7+33O9
apX6vwf/Yoz6uZpV/fRRnoY7ZggduD1e+0cvDjXg4I7IYibXzjS7yOgGOyE1VKZQ
70tZD8sO8txFBTRppcIoGsfK/NTL2DMyf7dbdNzcmV4k+JODkOCf8pIpcDdiw8sL
QZQ6yJbAhWfcc7ZWsnkEeiBVQ4s1lulpFCSLSsw8eCUK6x96Kh2FSf5jOXf27Fdb
C68ckQyeSuEMpU95btYIERZkBfCqohawcoBZor+CqNBLBcxWCU6SrivwkUf+08nP
PhcA2bmjUriXoUIEXj5J28GUKK5sAAxles89DO88TPNxKr/A46RivVCgsEMG3R+V
wn6D7BccQ8sb9Qt9pGcJcN4uUoeTBA==
=Xjv6
-----END PGP SIGNATURE-----

--ZuFo3URFNuj67zDUHuDr3ZZmLnn0vPwt3--
