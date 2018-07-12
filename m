From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 10:54:02 -0700
Message-ID: <CA+55aFxmvkdzBaT4dxTdATW-Y=KFV1JZhMCQY7O5UNb01PotqQ@mail.gmail.com>
References: <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
 <22370.1531293761@warthog.procyon.org.uk> <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
 <7002.1531407244@warthog.procyon.org.uk> <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com>
 <20180712160030.GV30522@ZenIV.linux.org.uk> <CA+55aFwkiFdhGmT8gaSohAQGMWpGUZBQ0dhGNGWEN4cpjK7XHA@mail.gmail.com>
 <20180712163107.GW30522@ZenIV.linux.org.uk> <CA+55aFz6Uaqag5qPcT2M3Q07-yc_6y2cAarfw7hjXEiQq4tTYw@mail.gmail.com>
 <CA+55aFw9WuyGqRHerhESw+Shzg1UtCjORLVYT=uCMh8jXbLWmg@mail.gmail.com> <20180712174403.GA30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180712174403.GA30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Andrew Lutomirski <luto@kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 10:44 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Separating type name from everything else makes a lot of sense

I do not dispute that at all.

But you can specify the type name in the "commit" phase, it doesn't
have to be at "fsopen" time.

In fact, doing so would _force_ a certain cleanliness to the
interfaces - it would force the rest to be filesystem-agnostic, rather
than possibly have semantic hacks for some part.

            Linus
