From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [GIT PULL] User namespace related fixes for v4.2
Date: Mon, 6 Jul 2015 15:47:48 -0500
Message-ID: <20150706204748.GB22962@ubuntu-hedt>
References: <87381eyz26.fsf@x220.int.ebiederm.org>
 <878uazhapq.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <878uazhapq.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>, Eric Windisch <ewindisch@docker.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Omar Sandoval <osandov@osandov.com>, Ivan Delalande <colona@arista.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 01, 2015 at 03:41:37PM -0500, Eric W. Biederman wrote:
> This set of changes also starts enforcing the mount flags of fresh
> mounts of proc and sysfs are consistent with the existing mount of proc
> and sysfs.  I expected this to be the boring part of the work but
> unfortunately unprivileged userspace winds up mounting fresh copies of
> proc and sysfs with noexec and nosuid clear when root set those flags on
> the previous mount of proc and sysfs.  So for now only the atime,
> read-only and nodev attributes which userspace happens to keep
> consistent are enforced.  Dealing with the noexec and nosuid attributes
> remains for another time.

Sorry to be the bearer of bad news, but I am seeing a regression in lxc
with 4.2-rc1 due to this change. lxc is doing a fresh mount of sysfs
that never specifies either read-only or nodev regardless of how sysfs
has been mounted previously, and this is causing me to see mount
failures because of the nodev check.

If I comment out only the nodev check then the mount works on my system,
but based on the code in lxc I don't think there's any guarantee at all
of this mount having flags consistent with previous mounts.

Seth
