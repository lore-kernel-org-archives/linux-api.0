From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [RFC] fs, proc: don't guard
 /proc/<pid>/task/<tid>/children on CONFIG_CHECKPOINT_RESTORE
Date: Thu, 21 May 2015 13:57:03 -0700
Message-ID: <20150521135703.22af370fdd0799101a6a1b91@linux-foundation.org>
References: <1432204221-1933-1-git-send-email-alban@endocode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1432204221-1933-1-git-send-email-alban@endocode.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alban Crequy <alban.crequy@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>, Pavel Emelyanov <xemul@parallels.com>, Serge Hallyn <serge.hallyn@canonical.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Alban Crequy <alban@endocode.com>, Iago Lopez Galeiras <iago@endocode.com>
List-Id: linux-api@vger.kernel.org

On Thu, 21 May 2015 12:30:21 +0200 Alban Crequy <alban.crequy@gmail.com> wrote:

> commit 818411616baf ("fs, proc: introduce
> /proc/<pid>/task/<tid>/children entry") introduced the children entry
> for checkpoint restore and the file is only available on kernels
> configured with CONFIG_EXPERT and CONFIG_CHECKPOINT_RESTORE.
> 
> This is available in most distributions (Fedora, Debian, Ubuntu, CoreOS)
> because they usually enable CONFIG_EXPERT and CONFIG_CHECKPOINT_RESTORE.
> But Arch does not enable CONFIG_EXPERT or CONFIG_CHECKPOINT_RESTORE.
> 
> However, the children proc file is useful outside of checkpoint restore.
> I would like to use it in rkt. The rkt process exec() another program it
> does not control, and that other program will fork()+exec() a child
> process. I would like to find the pid of the child process from an
> external tool without iterating in /proc over all processes to find
> which one has a parent pid equal to rkt.
> 
> Since the children proc file is useful outside of checkpoint-restore,
> I am removing the guard on CONFIG_CHECKPOINT_RESTORE.

This will add a lump of code to kernels which don't need it.

It's a bit of a pain, but I suppose we should still keep the presence
of get_children_pid() configurable.  That would be by adding a new
CONFIG_PROC_CHILDREN (or similar) and making CONFIG_CHECKPOINT_RESTORE
select that.


