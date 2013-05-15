From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
Subject: Re: RFC: allow empty symlink targets
Date: Wed, 15 May 2013 21:48:53 +0100
Message-ID: <5193F4B5.500@draigBrady.com>
References: <1358427833-3847-1-git-send-email-P@draigBrady.com> <50F8252C.2060404@draigBrady.com> <519381D8.5080206@draigBrady.com> <51939E49.1040209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51939E49.1040209@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Blake <eblake@redhat.com>, linux-api@vger.kernel.org, Alexander Viro <aviro@redhat.com>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 05/15/2013 03:40 PM, Eric Blake wrote:
> On 05/15/2013 06:38 AM, P=C3=A1draig Brady wrote:
>> On 01/17/2013 04:22 PM, P=C3=A1draig Brady wrote:
>>> On 01/17/2013 01:03 PM, P=C3=A1draig Brady wrote:
>>>> The discussion leading to this is at http://bugs.gnu.org/13447
>>>> In summary other systems allow an empty target for a symlink,
>>>> and POSIX specifies that it should be allowed?
>>>
>>> In relation to this, Eric Blake said:
>>>
>>>> In today's Austin Group meeting, I was tasked to open a new bug th=
at
>>>> would state specifically how the empty symlink is resolved; the in=
tent
>>>> is to allow both Solaris behavior (current directory) and BSD beha=
vior
>>>> (ENOENT).  Meanwhile, everyone was in agreement that the Linux ker=
nel
>>>> has a bug for rejecting the creation of an empty symlink, but once=
 that
>>>> bug is fixed, then Linux can choose either Solaris or BSD behavior=
 for
>>>> how to resolve such a symlink.
>>>>
>>>> It will probably be a bug report similar to this one, which regard=
ed how
>>>> to handle a symlink containing just slashes:
>>>> http://austingroupbugs.net/view.php?id=3D541
>>
>> Following up from http://austingroupbugs.net/view.php?id=3D649
>> It seems POSIX will now allow the current Linux behavior of returnin=
g ENOENT,
>=20
> Huh?  Linux currently doesn't allow the creation of an empty symlink.
> That link mentions the current BSD behavior of returning ENOENT when
> resolving such a symlink (that is, what stat() does when chasing thro=
ugh
> an empty symlink, provided such a symlink is first created).

Ah OK. The standards are hard enough to interpret,
never mind the comments discussing the standards :)
Not helping was that symlink() returns ENOENT in this case too.

>> or the Solaris behavior of allowing empty symlink targets.
>=20
> The point made in that bug report is that Linux is buggy for not
> allowing symlink() to create an empty symlink in the first place; onc=
e
> you allow the creation of an empty symlink, then how to handle such a
> symlink in stat() is up to you whether to copy Solaris' or BSD's exam=
ple.

OK cool, that make more sense to me.

Adding in a couple more recipients to garner interest...

thanks,
P=C3=A1draig.
