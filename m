From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH RFC 1/3] symlink.7: document magic-links more completely
Date: Mon, 7 Oct 2019 18:36:40 +0200
Message-ID: <CAG48ez2LuOGAXgKftZKfDKxhdb6xcBTdoK468-HXdcpxCW4r4w@mail.gmail.com>
References: <20191003145542.17490-1-cyphar@cyphar.com> <20191003145542.17490-2-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191003145542.17490-2-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Michael Kerrisk <mtk.manpages@gmail.com>, Christian Brauner <christian@brauner.io>, Aleksa Sarai <asarai@suse.de>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 3, 2019 at 4:56 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> Traditionally, magic-links have not been a well-understood topic in
> Linux. Given the new changes in their semantics (related to the link
> mode of trailing magic-links), it seems like a good opportunity to shine
> more light on magic-links and their semantics.
[...]
> +++ b/man7/symlink.7
> @@ -84,6 +84,25 @@ as they are implemented on Linux and other systems,
>  are outlined here.
>  It is important that site-local applications also conform to these rules,
>  so that the user interface can be as consistent as possible.
> +.SS Magic-links
> +There is a special class of symlink-like objects known as "magic-links" which

I think names like that normally aren't hypenated in english, and
instead of "magic-links", it'd be "magic links"? Just like how you
wouldn't write "symbolic-link", but "symbolic link". But this is
bikeshedding, and if you disagree, feel free to ignore this comment.

> +can be found in certain pseudo-filesystems such as
> +.BR proc (5)
> +(examples include
> +.IR /proc/[pid]/exe " and " /proc/[pid]/fd/* .)
> +Unlike normal symlinks, magic-links are not resolved through

nit: AFAICS symlinks are always referred to as "symbolic links"
throughout the manpages.

> +pathname-expansion, but instead act as direct references to the kernel's own
> +representation of a file handle. As such, these magic-links allow users to
> +access files which cannot be referenced with normal paths (such as unlinked
> +files still referenced by a running program.)

Could maybe add "and files in different mount namespaces" as another
example here; at least for me, that's the main usecases for
/proc/*/root.

[...]
> +However, magic-links do not follow this rule. They can have a non-0777 mode,
> +which is used for permission checks when the final
> +component of an
> +.BR open (2)'s

Maybe leave out the "open" part, since the same restriction has to
also apply to other syscalls operating on files, like truncate() and
so on?

> +path is a magic-link (see
> +.BR path_resolution (7).)
