From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v8 10/11] docs: proc: add documentation for "hidepid=4"
 and "subset=pidfs" options and new mount behavior
Date: Mon, 10 Feb 2020 10:29:23 -0800
Message-ID: <CALCETrWOXXYy5fo+D0wVBEviyk38ACqvO5Fep_oTEY6+UrS=4g@mail.gmail.com>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com> <20200210150519.538333-11-gladkov.alexey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20200210150519.538333-11-gladkov.alexey@gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Security Module <linux-security-module@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 10, 2020 at 7:06 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> ---
>  Documentation/filesystems/proc.txt | 53 ++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
>
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index 99ca040e3f90..4741fd092f36 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -50,6 +50,8 @@ Table of Contents
>    4    Configuring procfs
>    4.1  Mount options
>
> +  5    Filesystem behavior
> +
>  ------------------------------------------------------------------------------
>  Preface
>  ------------------------------------------------------------------------------
> @@ -2021,6 +2023,7 @@ The following mount options are supported:
>
>         hidepid=        Set /proc/<pid>/ access mode.
>         gid=            Set the group authorized to learn processes information.
> +       subset=         Show only the specified subset of procfs.
>
>  hidepid=0 means classic mode - everybody may access all /proc/<pid>/ directories
>  (default).
> @@ -2042,6 +2045,56 @@ information about running processes, whether some daemon runs with elevated
>  privileges, whether other user runs some sensitive program, whether other users
>  run any program at all, etc.
>
> +hidepid=4 means that procfs should only contain /proc/<pid>/ directories
> +that the caller can ptrace.

I have a couple of minor nits here.

First, perhaps we could stop using magic numbers and use words.
hidepid=ptraceable is actually comprehensible, whereas hidepid=4
requires looking up what '4' means.

Second, there is PTRACE_MODE_ATTACH and PTRACE_MODE_READ.  Which is it?

> +
>  gid= defines a group authorized to learn processes information otherwise
>  prohibited by hidepid=.  If you use some daemon like identd which needs to learn
>  information about processes information, just add identd to this group.

How is this better than just creating an entirely separate mount a
different hidepid and a different gid owning it?  In any event,
usually gid= means that this gid is the group owner of inodes.  Let's
call it something different.  gid_override_hidepid might be credible.
But it's also really weird -- do different groups really see different
contents when they read a directory?
