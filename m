From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] tracefs: Do not allocate and free proxy_ops for lockdown
Date: Fri, 11 Oct 2019 11:20:30 -0700
Message-ID: <CAHk-=wj7fGPKUspr579Cii-w_y60PtRaiDgKuxVtBAMK0VNNkA@mail.gmail.com>
References: <20191011135458.7399da44@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191011135458.7399da44@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <matthewgarrett@google.com>, James Morris James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 11, 2019 at 10:55 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I bisected this down to the addition of the proxy_ops into tracefs for
> lockdown. It appears that the allocation of the proxy_ops and then freeing
> it in the destroy_inode callback, is causing havoc with the memory system.
> Reading the documentation about destroy_inode, I'm not sure that this is the
> proper way to handle allocating and then freeing the fops of the inode.

What is happening is that *because* it has a "destroy_inode()"
callback, it now expects destroy_inode to not just free free the proxy
ops, but to also schedule the inode itself for freeing.

Which that tracefs)destroy_inode() doesn't do.

So the inode never gets free'd at all - and you eventually run out of
memory due to the inode leak.

The trivial fix would be to instead use the "free_inode()" callback
(which is called after the required RCU grace period) and then free
the proxy op there _and_ call free_inode_nonrcu() too.

But I think your patch to not need a proxy op allocation at all is
probably better.

That said, I think the _best_ option would be to just getting rid of
the proxy fops _entirely_, and just make the (very few)
tracefs_create_file() cases do that LOCKDOWN_TRACEFS in their open in
the first place.

The proxy_fops was a hacky attempt to make the patch smaller. Your
"just wrap all ops" thing now made the patch bigger than just doing
the lockdown thing in all the callers.

In fact, many of them use tracing_open_generic(). And others - like
subsystem_open() already call tracing_open_generic() as part of their
open.

So from a quick glance, just making tracing_open_generic() do the
lockdown testing will take care of most cases.  Add a few other cases
to fill up the whole set, and your'e done.

Willing to do that instead?

                Linus
