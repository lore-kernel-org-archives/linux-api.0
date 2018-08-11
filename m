From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: BUG: Mount ignores mount options
Date: Sat, 11 Aug 2018 09:31:29 -0700
Message-ID: <9B6E2781-484B-4C42-95F5-F900EA36CEA5@amacapital.net>
References: <87pnyphf8i.fsf@xmission.com> <87d0uqpba5.fsf@xmission.com> <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk> <22361.1533913891@warthog.procyon.org.uk> <30365.1533972586@warthog.procyon.org.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <30365.1533972586@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, viro@zeniv.linux.org.uk, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Theodore Y. Ts'o
List-Id: linux-api@vger.kernel.org



> On Aug 11, 2018, at 12:29 AM, David Howells <dhowells@redhat.com> wrote:
>=20
> Eric W. Biederman <ebiederm@xmission.com> wrote:
>=20
>>> Yes, I agree it would be nice to have, but it *doesn't* really need
>>> supporting right this minute, since what I have now oughtn't to break th=
e
>>> current behaviour.
>>=20
>> I am really reluctant to endorse anything that propagates the issues of
>> the current interface in the new mount interface.
>=20
> Do realise that your problem cannot be solved through fsopen() until every=

> filesystem is converted to the new fs_context-based sget() since the flag h=
as
> to make it from the VFS through the filesystem to sget().
>=20
> I'm reluctant to add this flag till that point until that time unless we e=
rror
> out if the flag is set against a legacy filesystem.
>=20
>=20

I don=E2=80=99t see why we need all this fancy =E2=80=9Cdo the options match=
=E2=80=9D stuff.  For the handful of filesystems (like NFS) that do somethin=
g intelligent when multiple non-bind mount requests against the same underly=
ing storage happen,  we can keep that behavior in the new API. For other fil=
esystems that don=E2=80=99t have this feature, we should simply fail the req=
uest.

IOW I see so compelling reason to call sget() at all from the new API.  The o=
nly sort-of-legit use case I can think of is mounting more than one btrfs su=
bvolume. But even that should probably not be done by asking the kernel to s=
eparately instantiate the filesystem.

As another way of looking at it: for a network filesystem, mounting the same=
 target ip and path from two different Linux machines works, so mounting it t=
wice from the same machine should also work.  But mounting the same underlyi=
ng ext4 block device from two different Linux machines (using nbd, iscsi, et=
c) would be a catastrophe, so I see no reason that it needs to be supported i=
f it=E2=80=99s two mounts from one machine.

The case folding example is interesting, and I think it should probably have=
 a slightly different API. A program could open_tree a nocasefold mount and t=
hen make a request to create what is functionally a bind mount but with diff=
erent options.

mount(8) will presumably just keep using mount(2).=
