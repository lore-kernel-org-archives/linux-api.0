From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH v2 1/2] fs: add AT_REPLACE flag for linkat() which
 replaces the target
Date: Tue, 21 Mar 2017 14:06:15 -0700
Message-ID: <CA+55aFxUwM4xaQejaxp5+x2BpdfmCeOLtW3yZ0byjARB1RaYEg@mail.gmail.com>
References: <cover.1490103963.git.osandov@fb.com> <c823982d5b46ea888dc1fdf26c067a7aa0f3585f.1490103963.git.osandov@fb.com>
 <CA+55aFxpzYqt3MYe8Yd7PVVQoPkVpae5diYYBJXh0zu4JCJrYA@mail.gmail.com>
 <20170321184401.GA32507@vader> <CA+55aFyefhwPHzGQo9+nxtUoe-ycK6uRTOF1o1TSvLC28OXpkg@mail.gmail.com>
 <CAELBmZBDLNkNRCh+q+zs3_z5NnsBctF_FA7F91SduADmS_xCJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAELBmZBDLNkNRCh+q+zs3_z5NnsBctF_FA7F91SduADmS_xCJQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Omar Sandoval <osandov@osandov.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Xi Wang <xi@cs.washington.edu>, Omar Sandoval <osandov@fb.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 21, 2017 at 1:37 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> What overlayfs issues?  Overlayfs behaves exactly like a normal
> filesystem wrt negative dentries.

Ignore me. I did indeed just confuse whiteouts with the normal
negative dentries.

> I think this is historic.  may_delete() was doing the same as
> may_create() and more.  Doesn't look like that's still strictly true,
> so it might make sense to add a may_replace() operation that does
> both.

They are definitely very different these days, with may_create()
requiring a valid UID mapping into the filesystem, for example.

That may make no sense for the move/link case, of course (since the
uid comes from the source file, not the current process), so it is
possible that may_delete() ends up being effectively a superset of the
may_create() things apart from that one thing, of course.

The one noticeable difference would seem to be the audit difference.
Maybe nobody cares.

               Linus
