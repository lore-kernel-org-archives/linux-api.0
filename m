From: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 05/13] vfs: don't parse "silent" option
Date: Thu, 20 Jun 2019 12:40:26 +0800
Message-ID: <1ea8ec52ce19499f021510b5c9e38be8d8ebe38f.camel@themaw.net>
References: <20190619123019.30032-1-mszeredi@redhat.com>
         <20190619123019.30032-5-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190619123019.30032-5-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>, David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 2019-06-19 at 14:30 +0200, Miklos Szeredi wrote:
> While this is a standard option as documented in mount(8), it is ignored by
> most filesystems.  So reject, unless filesystem explicitly wants to handle
> it.
> 
> The exception is unconverted filesystems, where it is unknown if the
> filesystem handles this or not.
> 
> Any implementation, such as mount(8) that needs to parse this option
> without failing should simply ignore the return value from fsconfig().

In theory this is fine but every time someone has attempted
to change the handling of this in the past autofs has had
problems so I'm a bit wary of the change.

It was originally meant to tell the file system to ignore
invalid options such as could be found in automount maps that
are used with multiple OS implementations that have differences
in their options.

That was, IIRC, primarily NFS although NFS should handle most
(if not all of those) cases these days.

Nevertheless I'm a bit nervous about it, ;)

> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/fs_context.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/fs_context.c b/fs/fs_context.c
> index 49636e541293..c26b353aa858 100644
> --- a/fs/fs_context.c
> +++ b/fs/fs_context.c
> @@ -51,7 +51,6 @@ static const struct constant_table common_clear_sb_flag[] =
> {
>  	{ "nolazytime",	SB_LAZYTIME },
>  	{ "nomand",	SB_MANDLOCK },
>  	{ "rw",		SB_RDONLY },
> -	{ "silent",	SB_SILENT },
>  };
>  
>  /*
> @@ -535,6 +534,9 @@ static int legacy_parse_param(struct fs_context *fc,
> struct fs_parameter *param)
>  	if (ret != -ENOPARAM)
>  		return ret;
>  
> +	if (strcmp(param->key, "silent") == 0)
> +		fc->sb_flags |= SB_SILENT;
> +
>  	if (strcmp(param->key, "source") == 0) {
>  		if (param->type != fs_value_is_string)
>  			return invalf(fc, "VFS: Legacy: Non-string source");
