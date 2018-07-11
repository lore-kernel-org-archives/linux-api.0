From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Wed, 11 Jul 2018 08:22:41 +0100
Message-ID: <22370.1531293761@warthog.procyon.org.uk>
References: <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, jannh@google.com
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:

> >    sfd = fsopen("ext4", FSOPEN_CLOEXEC);
> >    write(sfd, "s /dev/sdb1"); // note I'm ignoring write's length arg
> 
> Imagine some malicious program passes sfd as stdout to a setuid
> program. That program gets persuaded to write "s /etc/shadow".  What
> happens?  You’re okay as long as *every single fs* gets it right, but that’s
> asking a lot.

Do note that you must already have CAP_SYS_ADMIN to be able to call fsopen().

David
