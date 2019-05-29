From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 01/25] vfs: syscall: Add fsinfo() to query filesystem
 information [ver #13]
Date: Wed, 29 May 2019 09:42:49 +0200
Message-ID: <CAJfpegtkpNNOOWQ3TnLPGSm=bwL2otQp1--GjNNFiXO7imMxEQ@mail.gmail.com>
References: <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk>
 <155905627049.1662.17033721577309385838.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155905627049.1662.17033721577309385838.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 28, 2019 at 5:11 PM David Howells <dhowells@redhat.com> wrote:
>
> Add a system call to allow filesystem information to be queried.  A request
> value can be given to indicate the desired attribute.  Support is provided
> for enumerating multi-value attributes.
>

[...]

> +static u32 calc_sb_flags(u32 s_flags)
> +{
> +       u32 flags = 0;
> +
> +       if (s_flags & SB_RDONLY)        flags |= MS_RDONLY;
> +       if (s_flags & SB_SYNCHRONOUS)   flags |= MS_SYNCHRONOUS;
> +       if (s_flags & SB_MANDLOCK)      flags |= MS_MANDLOCK;
> +       if (s_flags & SB_DIRSYNC)       flags |= MS_DIRSYNC;
> +       if (s_flags & SB_SILENT)        flags |= MS_SILENT;
> +       if (s_flags & SB_POSIXACL)      flags |= MS_POSIXACL;
> +       if (s_flags & SB_LAZYTIME)      flags |= MS_LAZYTIME;
> +       if (s_flags & SB_I_VERSION)     flags |= MS_I_VERSION;

Please don't resurrect MS_ flags.  They are from the old API and
shouldn't be used in the new one.  Some of them (e.g. MS_POSIXACL,
MS_I_VERSION) are actually internal flags despite being exported on
the old API.  And there's SB_SILENT which is simply not a superblock
flag and we might be better getting rid of it entirely.

The proper way to query mount options should be analogous to the way
they are set on the new API: list of {key, type, value, aux} tuples.

Thanks,
Miklos
