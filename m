From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] afs: Add metadata xattrs
Date: Sat, 8 Jul 2017 12:44:54 -0700
Message-ID: <CA+55aFyFEW8LTEoyckW2YNeMrk5q_FweRsGbZKxXHWQjGLRw8w@mail.gmail.com>
References: <20170706152304.GA10584@infradead.org> <149935261019.29744.8564287571048506851.stgit@warthog.procyon.org.uk>
 <149935262759.29744.6299062653432480230.stgit@warthog.procyon.org.uk>
 <31934.1499357651@warthog.procyon.org.uk> <2863583A-79F1-4998-8AC4-1C4C9D4C060F@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2863583A-79F1-4998-8AC4-1C4C9D4C060F@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-afs@lists.infradead.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 6, 2017 at 11:27 AM, Andreas Dilger <adilger@dilger.ca> wrote:
>
> IMHO, xattrs are a fairly reasonable interface for accessing filesystem-specific
> attributes of a file that do not have generic equivalents on other filesystems.
> I can't see there being much value to having AFS-specific syscalls, and xattrs
> also are more easily accessed by generic userspace tools than ioctl() calls.

Yeah, I think attributes are likely much better than some random crazy
ioctl interface. They can be listed with generic tools, and have
various scripting interfaces in ways that ioctl's do not sanely have.

And people tend to be encouraged to use good descriptive interfaces
due to attributes having *names* instead of numbers.

That said, if these things have some actual generic cross-filesystem
meaning, then some ad-hoc fs attribute might be debatable. It might
still be an attribute, but perhaps better in an actual generic
namespace.

I haven't looked at these particular attibutes yet, though.

                 Linus
