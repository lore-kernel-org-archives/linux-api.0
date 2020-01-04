From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over symlinks
Date: Sat, 4 Jan 2020 14:52:03 +0900
Message-ID: <52B30961-5933-46D4-87A7-4056892959E8@amacapital.net>
References: <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


> On Jan 1, 2020, at 11:44 PM, Aleksa Sarai <cyphar@cyphar.com> wrote:
>=20
> =EF=BB=BFOn 2020-01-01, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>> On Wed, Jan 01, 2020 at 12:54:46AM +0000, Al Viro wrote:
>>> Note, BTW, that lookup_last() (aka walk_component()) does just
>>> that - we only hit step_into() on LAST_NORM.  The same goes
>>> for do_last().  mountpoint_last() not doing the same is _not_
>>> intentional - it's definitely a bug.
>>>=20
>>> Consider your testcase; link points to . here.  So the only
>>> thing you could expect from trying to follow it would be
>>> the directory 'link' lives in.  And you don't have it
>>> when you reach the fscker via /proc/self/fd/3; what happens
>>> instead is nd->path set to ./link (by nd_jump_link()) *AND*
>>> step_into() called, pushing the same ./link onto stack.
>>> It violates all kinds of assumptions made by fs/namei.c -
>>> when pushing a symlink onto stack nd->path is expected to
>>> contain the base directory for resolving it.
>>>=20
>>> I'm fairly sure that this is the cause of at least some
>>> of the insanity you've caught; there always could be
>>> something else, of course, but this hole needs to be
>>> closed in any case.
>>=20
>> ... and with removal of now unused local variable, that's
>>=20
>> mountpoint_last(): fix the treatment of LAST_BIND
>>=20
>> step_into() should be attempted only in LAST_NORM
>> case, when we have the parent directory (in nd->path).
>> We get away with that for LAST_DOT and LOST_DOTDOT,
>> since those can't be symlinks, making step_init() and
>> equivalent of path_to_nameidata() - we do a bit of
>> useless work, but that's it.  For LAST_BIND (i.e.
>> the case when we'd just followed a procfs-style
>> symlink) we really can't go there - result might
>> be a symlink and we really can't attempt following
>> it.
>>=20
>> lookup_last() and do_last() do handle that properly;
>> mountpoint_last() should do the same.
>>=20
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>=20
> Thanks, this fixes the issue for me (and also fixes another reproducer I
> found -- mounting a symlink on top of itself then trying to umount it).
>=20
> Reported-by: Aleksa Sarai <cyphar@cyphar.com>
> Tested-by: Aleksa Sarai <cyphar@cyphar.com>
>=20
> As for the original topic of bind-mounting symlinks -- given this is a
> supported feature, would you be okay with me sending an updated
> O_EMPTYPATH series?

FWIW, I have an actual use case for mounting over a symlink: replacing /etc/=
resolv.conf.  My virtme tool is presented with somewhat arbitrary crud in /e=
tc, where /etc/resolv.conf might be a plain file or a symlink, but, regardle=
ss, has inappropriate contents. If it=E2=80=99s a file, I can mount a new fi=
le over it. If it=E2=80=99s a symlink and the kernel properly supported it, I=
 could also mount over it.

Yes, I could also use overlayfs.  Maybe I should regardless.
