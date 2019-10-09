From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH RFC 1/3] symlink.7: document magic-links more completely
Date: Wed, 9 Oct 2019 09:55:08 +0200
Message-ID: <2fd9e82d-2a9c-cda9-0c17-3a20034eca1d@gmail.com>
References: <20191003145542.17490-1-cyphar@cyphar.com>
 <20191003145542.17490-2-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191003145542.17490-2-cyphar@cyphar.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: mtk.manpages@gmail.com, Christian Brauner <christian@brauner.io>, Aleksa Sarai <asarai@suse.de>, linux-man@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello Aleksa,


On 10/3/19 4:55 PM, Aleksa Sarai wrote:
> Traditionally, magic-links have not been a well-understood topic in
> Linux. Given the new changes in their semantics (related to the link
> mode of trailing magic-links), it seems like a good opportunity to shine
> more light on magic-links and their semantics.
> 
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>

Thanks for doing this. Some comments below.

> ---
>  man7/path_resolution.7 | 15 +++++++++++++++
>  man7/symlink.7         | 39 ++++++++++++++++++++++++++++++---------
>  2 files changed, 45 insertions(+), 9 deletions(-)
> 
> diff --git a/man7/path_resolution.7 b/man7/path_resolution.7
> index 07664ed8faec..46f25ec4cdfa 100644
> --- a/man7/path_resolution.7
> +++ b/man7/path_resolution.7
> @@ -136,6 +136,21 @@ we are just creating it.
>  The details on the treatment
>  of the final entry are described in the manual pages of the specific
>  system calls.
> +.PP
> +Since Linux 5.FOO, if the final entry is a "magic-link" (see

"magic link". As Jann points out, this is more normal English usage.

> +.BR symlink (7)),
> +and the user is attempting to
> +.BR open (2)
> +it, then there is an additional permission-related restriction applied to the
> +operation: the requested access mode must not exceed the "link mode" of the
> +magic-link (unlike ordinary symlinks, magic-links have their own file mode.)

Remove the hyphens (magic link). And also, as someone else pointed out,
manual pages fairly consistently uses the term "symbolic link"
(written in full).

You use the term "file mode" here. Do you mean the file permissions bits?
If yes, it is a bit misleading to suggest that symbolic links don't
have these mode bits. They do, but--as noted in the existing symlink(7)
manual page text--these bits are ignored. I suggest just removing the
parenthesized text.

> +For example, if
> +.I /proc/[pid]/fd/[num]
> +has a link mode of
> +.BR 0500 ,
> +unprivileged users are not permitted to
> +.BR open ()
> +the magic-link for writing.
>  .SS . and ..
>  By convention, every directory has the entries "." and "..",
>  which refer to the directory itself and to its parent directory,
> diff --git a/man7/symlink.7 b/man7/symlink.7
> index 9f5bddd5dc21..33f0ec703acd 100644
> --- a/man7/symlink.7
> +++ b/man7/symlink.7
> @@ -84,6 +84,25 @@ as they are implemented on Linux and other systems,
>  are outlined here.
>  It is important that site-local applications also conform to these rules,
>  so that the user interface can be as consistent as possible.
> +.SS Magic-links
> +There is a special class of symlink-like objects known as "magic-links" which

"magic links" (and through the rest of the page).

> +can be found in certain pseudo-filesystems such as

pseudofilesystems

> +.BR proc (5)
> +(examples include
> +.IR /proc/[pid]/exe " and " /proc/[pid]/fd/* .)
> +Unlike normal symlinks, magic-links are not resolved through

symbolic links

> +pathname-expansion, but instead act as direct references to the kernel's own

pathname expansion

> +representation of a file handle. As such, these magic-links allow users to
> +access files which cannot be referenced with normal paths (such as unlinked
> +files still referenced by a running program.)
> +.PP
> +Because they can bypass ordinary
> +.BR mount_namespaces (7)-based
> +restrictions, magic-links have been used as attack vectors in various exploits.
> +As such (since Linux 5.FOO), there are additional restrictions placed on the
> +re-opening of magic-links (see
> +.BR path_resolution (7)
> +for more details.)
>  .SS Symbolic link ownership, permissions, and timestamps
>  The owner and group of an existing symbolic link can be changed
>  using
> @@ -99,16 +118,18 @@ of a symbolic link can be changed using
>  or
>  .BR lutimes (3).
>  .PP
> -On Linux, the permissions of a symbolic link are not used
> -in any operations; the permissions are always
> -0777 (read, write, and execute for all user categories),
>  .\" Linux does not currently implement an lchmod(2).
> -and can't be changed.
> -(Note that there are some "magic" symbolic links in the
> -.I /proc
> -directory tree\(emfor example, the
> -.IR /proc/[pid]/fd/*
> -files\(emthat have different permissions.)
> +On Linux, the permissions of an ordinary symbolic link are not used in any
> +operations; the permissions are always 0777 (read, write, and execute for all
> +user categories), and can't be changed.
> +.PP
> +However, magic-links do not follow this rule. They can have a non-0777 mode,
> +which is used for permission checks when the final
> +component of an
> +.BR open (2)'s
> +path is a magic-link (see
> +.BR path_resolution (7).)
> +
>  .\"
>  .\" The
>  .\" 4.4BSD

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
