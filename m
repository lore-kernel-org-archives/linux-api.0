From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Fri, 13 Jul 2018 08:30:24 +0100
Message-ID: <3429.1531467024@warthog.procyon.org.uk>
References: <5A7CC3BF-5F4E-4624-A129-4BD0434D0747@amacapital.net> <3236C75A-5D74-4BB4-A1EC-06F6E22D810C@amacapital.net> <611054C7-D6E8-4C89-958E-3128C9305E1E@amacapital.net> <20180712223223.GA28610@thunk.org> <CA+55aFw1WyKY+-2dg62M-QT_F0-waCTCrba1DW4dStYz-f_fjA@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk> <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com> <7002.1531407244@warthog.procyon.org.uk> <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com> <16699.1531426991@warthog.procyon.org.uk> <18233.1531430797@warthog.procyon.org.uk> <22105.1531436081@warth
 og.procyon.org.uk> <23894.1531438559@warthog.procyon.org.uk> <26064.1531440190@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5A7CC3BF-5F4E-4624-A129-4BD0434D0747@amacapital.net>
Content-ID: <3428.1531467024.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: dhowells@redhat.com, "Theodore Y. Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:

> > Also you can't currently directly create a bind mount from userspace as you
> > can only bind from another path point - which you may not be able to access
> > (either by permission failure or because it's not in your mount namespace).
> > 
> 
> Are you trying to preserve the magic bind semantics with the new API?

No, I'm pointing out that you can't emulate this by doing a bind mount from
userspace if you can't access the thing you're binding from.

Now, we could create a syscall that just picks up an extant superblock using a
device and attaches it to a mount for you, but that would have to be at least
partially parameterised - which would be very fs-dependent - so that it can
know whether or not you're allowed to create another mount to that sb.

What you're talking about is emulating sget() in userspace - when we have to
do it in the kernel anyway if we still offer mount(2).

David
