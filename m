From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH review 0/11] General unprivileged mount support
Date: Mon, 4 Jul 2016 10:52:20 +0200
Message-ID: <20160704085220.GC5200@quack2.suse.cz>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87ziq03qnj.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Seth Forshee <seth.forshee@canonical.com>, Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Sat 02-07-16 12:18:08, Eric W. Biederman wrote:
> 
> As well as in these patches the code is also available from:
> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing
> 
> It has been a long time in coming but recently in the userns tree the
> superblock has been expanded with a s_user_ns field indicating the user
> namespace that owns a superblock.
> 
> The s_user_ns owner of a superblock has three implications.
> - Only kuids and kgids that map into s_user_ns are allowed to be sent to a
>  filesystem from the vfs.
> - If the uid or gid on the filesystem does not map into s_user_ns i_uid
>   is set to INVALID_UID and i_gid is set to INVALID_GID.
> - The scope of permission checks can be changed from global to a
>   capabilitiy check in s_user_ns.

OK, to check that I understand it right:

So the uids and gids that are stored on disk are still expected to be in
the initial id namespace, aren't they?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
