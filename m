From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 09:31:52 -0700
Message-ID: <CA+55aFxGqLfu1pjT5421k7KbSd94NWU4fw0H-zJe-qSWwBfAeQ@mail.gmail.com>
References: <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
 <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk>
 <7002.1531407244@warthog.procyon.org.uk> <338BC3C4-F3E7-48F0-A82E-2C7295B6640E@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <338BC3C4-F3E7-48F0-A82E-2C7295B6640E@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Howells <dhowells@redhat.com>, Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 9:23 AM Andy Lutomirski <luto@amacapital.net> wrote=
:
>
> (Al- can=E2=80=99t we just stop allowing splice() at all on things that d=
on=E2=80=99t use iov_iter?)

We could add a FMODE_SPLICE_READ/WRITE bit, and let people opt in to
splice. We probably should have.

But again, that really doesn't change the fundamentals.  Using write()
for commands is stupid.

It also means that you have to _parse_ all the damn input at that
level, which is a mistake too. It easily leads to insane decisions
like "you have to use 'write()' calls without buffering", because
re-buffering the stream is a f*cking pain.

Just say no. Seriously. Stop this idiotic discussion.

I'm just happy this came up early, because that way I know to look out
for it and not merge it.

                 Linus
