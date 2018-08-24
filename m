From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 30/33] vfs: syscall: Add fspick() to select a superblock for reconfiguration [ver #11]
Date: Fri, 24 Aug 2018 07:54:57 -0700
Message-ID: <FAB6FB68-5B65-41D1-BD5B-78D8553BA601@amacapital.net>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk> <153313724861.13253.3837522702693613670.stgit@warthog.procyon.org.uk> <CAELBmZCv3uAmXiSEk3vdYEy8wn_mP8Rs6qzMqSa56_kPsb_=aA@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAELBmZCv3uAmXiSEk3vdYEy8wn_mP8Rs6qzMqSa56_kPsb_=aA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Aug 24, 2018, at 7:51 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>=20
>> On Wed, Aug 1, 2018 at 5:29 PM David Howells <dhowells@redhat.com> wrote:=

>>=20
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -351,6 +351,11 @@ typedef int __bitwise __kernel_rwf_t;
>>=20
>> #define FSMOUNT_CLOEXEC                0x00000001
>>=20
>> +#define FSPICK_CLOEXEC         0x00000001
>> +#define FSPICK_SYMLINK_NOFOLLOW        0x00000002
>> +#define FSPICK_NO_AUTOMOUNT    0x00000004
>> +#define FSPICK_EMPTY_PATH      0x00000008
>=20
> This caught my eye:  why aren't we using the AT_ constants?  Adding an
> AT_CLOEXEC sounds less horrible than duplicating all the lookup
> related flags for FSPICK...

For a totally new API, is there any need to support !CLOEXEC?  A caller can s=
afely remove the CLOEXEC bit without races.=
