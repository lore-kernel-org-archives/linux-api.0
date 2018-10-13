From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v3 3/3] namei: aggressively check for nd->root escape on
 ".." resolution
Date: Sat, 13 Oct 2018 09:22:10 +0100
Message-ID: <20181013082210.GU32577@ZenIV.linux.org.uk>
References: <20181009070230.12884-1-cyphar@cyphar.com>
 <20181009070230.12884-4-cyphar@cyphar.com>
 <CAG48ez3Ae5b20g2UquekfBNaUw1tLt4nWy2pYm-LNRMbDVpHfA@mail.gmail.com>
 <20181009153728.2altaqxclntvyc7b@mikami>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181009153728.2altaqxclntvyc7b@mikami>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <asarai@suse.de>
Cc: Jann Horn <jannh@google.com>, cyphar@cyphar.com, "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 10, 2018 at 02:37:28AM +1100, Aleksa Sarai wrote:
> > > +static inline int nd_alloc_dpathbuf(struct nameidata *nd)
> > > +{
> > > +       if (unlikely(!nd->dpathbuf)) {
> > > +               if (nd->flags & LOOKUP_RCU) {
> > > +                       nd->dpathbuf = kmalloc(PATH_MAX, GFP_ATOMIC);
> > > +                       if (unlikely(!nd->dpathbuf))
> > > +                               return -ECHILD;
> > > +               } else {
> > > +                       nd->dpathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
> > > +                       if (unlikely(!nd->dpathbuf))
> > > +                               return -ENOMEM;
> > > +               }
> > > +       }
> > > +       return 0;
> > > +}
> > 
> > Note that a fixed-size path buffer means that if the path is very
> > long, e.g. because you followed long symlinks on the way down, this
> > can cause lookup failures.
> 
> This is already an issue with __d_path (even if the buffer was larger)
> because it will not output a path longer than PATH_MAX. I imagine this
> is a pretty strong argument for why we should refactor __d_path so that
> we can *just* use the escape checking to avoid -ENAMETOOLONG.

Let me get it straight - the whole point of that buffer is to check
if __d_path() returns NULL?  So you allocate it so that you would have
place to copy the path components into... only to have them completely
ignored?

How is that different from path_is_under()?
