From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 13:36:22 -0700
Message-ID: <CA+55aFx=tVoeyDWqeNtv-v=r_v7pwbTV+KCrzg4Mzab66MuxEA@mail.gmail.com>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk>
 <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
 <7002.1531407244@warthog.procyon.org.uk> <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com>
 <16699.1531426991@warthog.procyon.org.uk> <CA+55aFw1WyKY+-2dg62M-QT_F0-waCTCrba1DW4dStYz-f_fjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFw1WyKY+-2dg62M-QT_F0-waCTCrba1DW4dStYz-f_fjA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 1:34 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This is the whole "write() is only for data". If you ever have
> credentials mattering at write time, you're doing something wrong.
>
> Really really.
>
> Don't do it.

.. and I'd like to repeat: we *have* done things wrong. But that's
simply not an excuse. We've done it wrong in SCSI, we've done it wrong
in various /proc files, we've done it wrong in many places.

But let's not do it wrong AGAIN.

                Linus
