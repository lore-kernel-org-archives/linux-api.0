From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Fri, 13 Jul 2018 14:27:02 +0100
Message-ID: <21131.1531488422@warthog.procyon.org.uk>
References: <CA+55aFzaTQJp6aHG_9+W2ShxeZncq7k9G3FkVFjFm7W=ECUiMw@mail.gmail.com> <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk> <7002.1531407244@warthog.procyon.org.uk> <338BC3C4-F3E7-48F0-A82E-2C7295B6640E@amacapital.net> <17749.1531429218@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzaTQJp6aHG_9+W2ShxeZncq7k9G3FkVFjFm7W=ECUiMw@mail.gmail.com>
Content-ID: <21130.1531488422.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Andy Lutomirski <luto@amacapital.net>, Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

Whilst I'm at it, do we want the option of doing the equivalent of mountat()?
I.e. offering the option to open all the device files used by a superblock
with dfd and AT_* flags in combination with the filename?

David
