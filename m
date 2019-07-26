From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Regression in 5.3 for some FS_USERNS_MOUNT (aka
 user-namespace-mountable) filesystems
Date: Sat, 27 Jul 2019 00:22:20 +0100
Message-ID: <20190726232220.GM1131@ZenIV.linux.org.uk>
References: <20190726115956.ifj5j4apn3tmwk64@brauner.io>
 <CAHk-=wgK254RkZg9oAv+Wt4V9zqYJMm3msTofvTUfA9dJw6piQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wgK254RkZg9oAv+Wt4V9zqYJMm3msTofvTUfA9dJw6piQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <christian@brauner.io>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 26, 2019 at 03:47:02PM -0700, Linus Torvalds wrote:

> Of course, then later on, commit 20284ab7427f ("switch mount_capable()
> to fs_context") drops that argument entirely, and hardcodes the
> decision to look at fc->global.
> 
> But that fc->global decision wasn't there originally, and is incorrect
> since it breaks existing users.
> 
> What gets much more confusing about this is that the two different
> users then moved around. The sget_userns() case got moved to
> legacy_get_tree(), and then joined together in vfs_get_tree(), and
> then split and moved out to do_new_mount() and vfs_fsconfig_locked().
> 
> And that "joined together into vfs_get_tree()" must be wrong, because
> the two cases used two different namespace rules. The sget_userns()
> case *did* have that "global" flag check, while the sget_fc() did not.
> 
> Messy. Al?

Digging through that mess...  It's my fuckup, and we obviously need to
restore the old behaviour, but I really hope to manage that with
checks _not_ in superblock allocator ;-/
