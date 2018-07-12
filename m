From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 17:31:07 +0100
Message-ID: <20180712163107.GW30522@ZenIV.linux.org.uk>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
 <22370.1531293761@warthog.procyon.org.uk>
 <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
 <7002.1531407244@warthog.procyon.org.uk>
 <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com>
 <20180712160030.GV30522@ZenIV.linux.org.uk>
 <CA+55aFwkiFdhGmT8gaSohAQGMWpGUZBQ0dhGNGWEN4cpjK7XHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwkiFdhGmT8gaSohAQGMWpGUZBQ0dhGNGWEN4cpjK7XHA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Andrew Lutomirski <luto@kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 09:07:36AM -0700, Linus Torvalds wrote:
> On Thu, Jul 12, 2018 at 9:00 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Wait a sec - that's only a problem if your command contains pointer-chasing
> > et.al.
> 
> No.
> 
> It's a problem if anybody ever does something like "let's have a
> helper splice thread that uses splice to move data automatically from
> one buffer to another".
>
> And yes, it's something people have wanted.
> 
> Seriously. I'm putting my foot down. NO COMMANDS IN WRITE DATA!
> 
> We have made that mistake in the past. Having done stupid things in
> the past is not an excuse for doing so again. Quite the reverse.
> Making the same mistake and not learning from your mistakes is the
> sign of stupidity.
> 
> So I repeat: write is for data. If you want an action, you do it with
> ioctl, or you do it with a system call.

*shrug*

I think you are wrong[1], but it's your decision.  And seriously, ioctl?
_That_ has a great track record...

[1] one man's data is another man's commands, for starters.  All networking
protocols would fit your description.  So would ANSI escape sequences ("move
cursor to line 12 column 45" does sound like a command), so would writing
postscript to printer, etc.

IME it's more about data structures that are not marshalled cleanly - that
tends to go badly wrong.  Again, see SG_IO for recent example...

Anyway, your tree, your policy.
