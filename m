From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Fri, 13 Jul 2018 01:03:10 +0100
Message-ID: <26064.1531440190@warthog.procyon.org.uk>
References: <3236C75A-5D74-4BB4-A1EC-06F6E22D810C@amacapital.net> <611054C7-D6E8-4C89-958E-3128C9305E1E@amacapital.net> <20180712223223.GA28610@thunk.org> <CA+55aFw1WyKY+-2dg62M-QT_F0-waCTCrba1DW4dStYz-f_fjA@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk> <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com> <7002.1531407244@warthog.procyon.org.uk> <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com> <16699.1531426991@warthog.procyon.org.uk> <18233.1531430797@warthog.procyon.org.uk> <22105.1531436081@warthog.procyon.org.uk> <23894.1531438559@warthog.procyon.o
 rg.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3236C75A-5D74-4BB4-A1EC-06F6E22D810C@amacapital.net>
Content-ID: <26063.1531440190.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: dhowells@redhat.com, "Theodore Y. Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:

> >> I tend to think that this *should* fail using the new API.  The semantics
> >> of the second mount request are bizarre at best.
> > 
> > You still have to support existing behaviour lest you break userspace.
> > 
> 
> I assume the existing behavior is that a bind mount is created?  If so, the
> new mount(8) tool could do it in user code.

You have a race there.

Also you can't currently directly create a bind mount from userspace as you
can only bind from another path point - which you may not be able to access
(either by permission failure or because it's not in your mount namespace).

David
