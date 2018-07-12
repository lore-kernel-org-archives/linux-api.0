From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 13:34:42 -0700
Message-ID: <CA+55aFw1WyKY+-2dg62M-QT_F0-waCTCrba1DW4dStYz-f_fjA@mail.gmail.com>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk>
 <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
 <7002.1531407244@warthog.procyon.org.uk> <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com>
 <16699.1531426991@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <16699.1531426991@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 1:23 PM David Howells <dhowells@redhat.com> wrote:
>
> It's all very well to say "use file->f_creds".  The problem is this has to be
> handed down all the way through the filesystem and down into the block layer
> as appropriate to anywhere there's an LSM call, a CAP_* check or a pathwalk -
> but there's not currently any way to do that.

.. and the reason is simple: you damn well shouldn't do that.

The unix semantics are that credentials are checked at open time.

If your interface involves checking credentials at write() time, your
interface is garbage shit.

Really.

This is the whole "write() is only for data". If you ever have
credentials mattering at write time, you're doing something wrong.

Really really.

Don't do it.

             Linus
