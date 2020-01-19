From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 0/2] openat2: minor uapi cleanups
Date: Sun, 19 Jan 2020 01:12:33 +0000
Message-ID: <20200119011233.GU8904@ZenIV.linux.org.uk>
References: <20200115144831.GJ8904@ZenIV.linux.org.uk>
 <20200118120800.16358-1-cyphar@cyphar.com>
 <20200118152833.GS8904@ZenIV.linux.org.uk>
 <20200118180941.GT8904@ZenIV.linux.org.uk>
 <20200118230313.y4a3s7elierw4wzw@yavin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-108813-glibc-alpha=m.gmane-mx.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane-mx.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20200118230313.y4a3s7elierw4wzw@yavin>
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>, Florian Weimer <fweimer@redhat.com>, David Laight <david.laight@aculab.com>, Christian Brauner <christian.brauner@ubuntu.com>, quae@daurnimator.com, dev@opencontainers.org, containers@lists.linux-foundation.org, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, Jan 19, 2020 at 10:03:13AM +1100, Aleksa Sarai wrote:

> > possibly trigger?  The only things that ever clean ->root.mnt are
> 
> You're quite right -- the codepath I was worried about was pick_link()
> failing (which *does* clear nd->path.mnt, and I must've misread it at
> the time as nd->root.mnt).

pick_link() (allocation failure of external stack in RCU case, followed
by failure to legitimize the link) is, unfortunately, subtle and nasty.
We *must* path_put() the link; if we'd managed to legitimize the mount
and failed on dentry, the mount needs to be dropped.  No way around it.
And while everything else there can be left for soon-to-be-reached
terminate_walk(), this cannot.  We have no good way to pass what
we need to drop to the place where that eventual terminate_walk()
drops rcu_read_lock().  So we end up having to do what terminate_walk()
would've done and do it right there, so we could do that path_put(link)
before we bugger off.

I'm not happy about that, but I don't see cleaner solutions, more's the
pity.  However, it doesn't mess with ->root - nor should it, since
we don't have LOOKUP_ROOT_GRABBED (not in RCU mode), so it can and
should be left alone.
 
> We can drop this check, though now complete_walk()'s main defence
> against a NULL nd->root.mnt is that path_is_under() will fail and
> trigger -EXDEV (or set_root() will fail at some point in the future).
> However, as you pointed out, a NULL nd->root.mnt won't happen with
> things as they stand today -- I might be a little too paranoid. :P

The only reason why complete_walk() zeroes nd->root in some cases is
microoptimization - we *know* we won't be using it later, so we don't
care whether it's stale or not and can spare unlazy_walk() a bit of
work.  All there is to that one.

I don't see any reason for adding code that would clear nd->root in later
work; if such thing does get added (again, I don't see what purpose
could that possibly serve), we'll need to watch out for a lot of things.
Starting with LOOKUP_ROOT case...  It's not something likely to slip
in unnoticed.
