From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression in 5.3 for some FS_USERNS_MOUNT (aka
 user-namespace-mountable) filesystems
Date: Fri, 26 Jul 2019 15:47:02 -0700
Message-ID: <CAHk-=wgK254RkZg9oAv+Wt4V9zqYJMm3msTofvTUfA9dJw6piQ@mail.gmail.com>
References: <20190726115956.ifj5j4apn3tmwk64@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190726115956.ifj5j4apn3tmwk64@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 26, 2019 at 5:00 AM Christian Brauner <christian@brauner.io> wrote:
>
> The commit that introduced the regression is:
>
> commit 0ce0cf12fc4c6a089717ff613d76457052cf4303
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Sun May 12 15:42:48 2019 -0400
>
>     consolidate the capability checks in sget_{fc,userns}()
>
>     ... into a common helper - mount_capable(type, userns)

The commit message there tries to imply that it's just consolidating
existing checks, but you're right - that's not at all the case.

In sget_fc(), the tests are all the exact same tests, but it uses a
different 'user_ns' after the commit. It *used* to use fc->user_ns,
now it uses 'user_ns' which depends on that 'global' bit.

And in sget_userns(), the userns is the same, but the tests are
different. Before that commit, it *always* checked for capability in
user_ns, and then (for non-FS_USERNS_MOUNT) it checked for capability
in the init namespace.

I guess the semantic change in sget_userns() is immaterial - if you
have CAP_SYS_ADMIN in the init namespace, you will have it in user_ns
too.

But the sget_fc() semantic change is a more serious change. Maybe that
was just unintentional, and Al _meant_ to pass in "fc->user_ns", but
didn't?

Of course, then later on, commit 20284ab7427f ("switch mount_capable()
to fs_context") drops that argument entirely, and hardcodes the
decision to look at fc->global.

But that fc->global decision wasn't there originally, and is incorrect
since it breaks existing users.

What gets much more confusing about this is that the two different
users then moved around. The sget_userns() case got moved to
legacy_get_tree(), and then joined together in vfs_get_tree(), and
then split and moved out to do_new_mount() and vfs_fsconfig_locked().

And that "joined together into vfs_get_tree()" must be wrong, because
the two cases used two different namespace rules. The sget_userns()
case *did* have that "global" flag check, while the sget_fc() did not.

Messy. Al?

               Linus
