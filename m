From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/7] vfs: Add a mount-notification facility
Date: Wed, 29 May 2019 12:00:57 +0100
Message-ID: <14347.1559127657@warthog.procyon.org.uk>
References: <CAG48ez2rRh2_Kq_EGJs5k-ZBNffGs_Q=vkQdinorBgo58tbGpg@mail.gmail.com> <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk> <155905933492.7587.6968545866041839538.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez2rRh2_Kq_EGJs5k-ZBNffGs_Q=vkQdinorBgo58tbGpg@mail.gmail.com>
Content-ID: <14346.1559127657.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>, casey@schaufler-ca.com
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Jann Horn <jannh@google.com> wrote:

> > +void post_mount_notification(struct mount *changed,
> > +                            struct mount_notification *notify)
> > +{
> > +       const struct cred *cred = current_cred();
> 
> This current_cred() looks bogus to me. Can't mount topology changes
> come from all sorts of places? For example, umount_mnt() from
> umount_tree() from dissolve_on_fput() from __fput(), which could
> happen pretty much anywhere depending on where the last reference gets
> dropped?

IIRC, that's what Casey argued is the right thing to do from a security PoV.
Casey?

Maybe I should pass in NULL creds in the case that an event is being generated
because an object is being destroyed due to the last usage[*] being removed.

 [*] Usage, not ref - Superblocks are a bit weird in their accounting.

David
