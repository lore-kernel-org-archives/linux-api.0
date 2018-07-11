From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Wed, 11 Jul 2018 02:16:11 +0100
Message-ID: <20180711011610.GM30522@ZenIV.linux.org.uk>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
 <CAG48ez2-p=jGZwmb3soh87RM6qHGEi6ctbLOVZ99LG6aHXUX_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez2-p=jGZwmb3soh87RM6qHGEi6ctbLOVZ99LG6aHXUX_g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 10, 2018 at 06:14:10PM -0700, Jann Horn wrote:

> I also love ioctls, so I think you could also use an ioctl to do the
> commit? You can do anything (well, almost anything) that you can do in
> syscall context in ioctl context, too; and when you already have a
> file descriptor of a specific type that you want to perform an
> operation on, an ioctl works just fine.

Poe's Law in action...
