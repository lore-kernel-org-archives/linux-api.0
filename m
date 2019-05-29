From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/7] vfs: Add a mount-notification facility
Date: Wed, 29 May 2019 11:55:10 +0100
Message-ID: <13970.1559127310@warthog.procyon.org.uk>
References: <CAG48ez2rRh2_Kq_EGJs5k-ZBNffGs_Q=vkQdinorBgo58tbGpg@mail.gmail.com> <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk> <155905933492.7587.6968545866041839538.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez2rRh2_Kq_EGJs5k-ZBNffGs_Q=vkQdinorBgo58tbGpg@mail.gmail.com>
Content-ID: <13969.1559127310.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Jann Horn <jannh@google.com> wrote:

> > +                       /* Global root? */
> > +                       if (mnt != parent) {
> > +                               cursor.dentry = READ_ONCE(mnt->mnt_mountpoint);
> > +                               mnt = parent;
> > +                               cursor.mnt = &mnt->mnt;
> > +                               continue;
> > +                       }
> > +                       break;
> 
> (nit: this would look clearer if you inverted the condition and wrote
> it as "if (mnt == parent) break;", then you also wouldn't need that
> "continue" or the braces)

It does look better with the logic inverted, but you *do* still need the
continue.  After the if-statement, there is:

	cursor.dentry = cursor.dentry->d_parent;

which we need to skip.  It might make sense to move that into an
else-statement from an aesthetic point of view.

David
