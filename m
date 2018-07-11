From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Wed, 11 Jul 2018 10:06:39 -0700
Message-ID: <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <22370.1531293761@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

> On Jul 11, 2018, at 12:22 AM, David Howells <dhowells@redhat.com> wrote:
>
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>>>   sfd =3D fsopen("ext4", FSOPEN_CLOEXEC);
>>>   write(sfd, "s /dev/sdb1"); // note I'm ignoring write's length arg
>>
>> Imagine some malicious program passes sfd as stdout to a setuid
>> program. That program gets persuaded to write "s /etc/shadow".  What
>> happens?  You=E2=80=99re okay as long as *every single fs* gets it right=
, but that=E2=80=99s
>> asking a lot.
>
> Do note that you must already have CAP_SYS_ADMIN to be able to call fsope=
n().

If you=E2=80=99re not allowing it already, someone will want user namespace
root to be able to use this very, very soon.
