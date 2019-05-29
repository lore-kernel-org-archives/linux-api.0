From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 04/25] vfs: Implement parameter value retrieval with
 fsinfo() [ver #13]
Date: Wed, 29 May 2019 10:08:58 +0200
Message-ID: <CAJfpegutheVtnmN6BFSjzrmz8p9+DpZxFoKa4CoShoh4MW+5gQ@mail.gmail.com>
References: <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk>
 <155905629702.1662.7233272785972036117.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155905629702.1662.7233272785972036117.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 28, 2019 at 5:11 PM David Howells <dhowells@redhat.com> wrote:
>
> Implement parameter value retrieval with fsinfo() - akin to parsing
> /proc/mounts.
>
> This allows all the parameters to be retrieved in one go with:
>
>         struct fsinfo_params params = {
>                 .request        = FSINFO_ATTR_PARAMETER,
>         };

Ah, here it is.

>
> Each parameter comes as a pair of blobs with a length tacked on the front
> rather than using separators, since any printable character that could be
> used as a separator can be found in some value somewhere (including comma).
> In fact, cifs allows the separator to be set using the "sep=" option in
> parameter parsing.
>
> The length on the front of each blob is 1-3 bytes long.  Each byte has a
> flag in bit 7 that's set if there are more bytes and clear on the last
> byte; bits 0-6 should be shifted and OR'd into the length count.  The bytes
> are most-significant first.
>
> For example, 0x83 0xf5 0x06 is the length (0x03<<14 | 0x75<<7 | 0x06).

Sounds way too complicated.  What about fixed 4byte sizes?  Or using
the nul charater as separator (and binary blobs be damned)?

[...]

> +static void fsinfo_insert_sb_flag_parameters(struct path *path,
> +                                            struct fsinfo_kparams *params)
> +{
> +       int s_flags = READ_ONCE(path->dentry->d_sb->s_flags);
> +
> +       if (s_flags & SB_DIRSYNC)
> +               fsinfo_note_param(params, "dirsync", NULL);
> +       if (s_flags & SB_LAZYTIME)
> +               fsinfo_note_param(params, "lazytime", NULL);
> +       if (s_flags & SB_MANDLOCK)
> +               fsinfo_note_param(params, "mand", NULL);
> +       if (s_flags & SB_POSIXACL)
> +               fsinfo_note_param(params, "posixacl", NULL);
> +       if (s_flags & SB_RDONLY)
> +               fsinfo_note_param(params, "ro", NULL);
> +       if (s_flags & SB_SYNCHRONOUS)
> +               fsinfo_note_param(params, "sync", NULL);

Again, don't blindly transform s_flags into options, because some of
them may have been internally manipulated by the filesystem.

You could do a helper for filesystems that does the the common ones
(ro/sync/dirsync) but all of that *should* go through the filesystem.

Same goes for vfs_parse_sb_flag() btw.   It should be moved into each
filesystem's ->parse_param() and not be a mandatory thing.

Thanks,
Miklos
