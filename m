From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 01/13] vfs: verify param type in vfs_parse_sb_flag()
Date: Mon, 1 Jul 2019 10:45:53 +0200
Message-ID: <CAJfpegv_ezsXOLV2f7yd07=T3MenJoMKhu=MBac1-80s0BFg9A@mail.gmail.com>
References: <20190619123019.30032-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190619123019.30032-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <mszeredi@redhat.com>, Ian Kent <raven@themaw.net>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi David,

Ping?  Have you had a chance of looking at this series?

K=C3=B6szi,
Miklos

On Wed, Jun 19, 2019 at 2:30 PM Miklos Szeredi <mszeredi@redhat.com> wrote:
>
> vfs_parse_sb_flag() accepted any kind of param with a matching key, not
> just a flag.  This is wrong, only allow flag type and return -EINVAL
> otherwise.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/fs_context.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
>
> diff --git a/fs/fs_context.c b/fs/fs_context.c
> index 103643c68e3f..e56310fd8c75 100644
> --- a/fs/fs_context.c
> +++ b/fs/fs_context.c
> @@ -81,30 +81,29 @@ static const char *const forbidden_sb_flag[] =3D {
>  /*
>   * Check for a common mount option that manipulates s_flags.
>   */
> -static int vfs_parse_sb_flag(struct fs_context *fc, const char *key)
> +static int vfs_parse_sb_flag(struct fs_context *fc, struct fs_parameter =
*param)
>  {
> -       unsigned int token;
> +       const char *key =3D param->key;
> +       unsigned int set, clear;
>         unsigned int i;
>
>         for (i =3D 0; i < ARRAY_SIZE(forbidden_sb_flag); i++)
>                 if (strcmp(key, forbidden_sb_flag[i]) =3D=3D 0)
>                         return -EINVAL;
>
> -       token =3D lookup_constant(common_set_sb_flag, key, 0);
> -       if (token) {
> -               fc->sb_flags |=3D token;
> -               fc->sb_flags_mask |=3D token;
> -               return 0;
> -       }
> +       set =3D lookup_constant(common_set_sb_flag, key, 0);
> +       clear =3D lookup_constant(common_clear_sb_flag, key, 0);
> +       if (!set && !clear)
> +               return -ENOPARAM;
>
> -       token =3D lookup_constant(common_clear_sb_flag, key, 0);
> -       if (token) {
> -               fc->sb_flags &=3D ~token;
> -               fc->sb_flags_mask |=3D token;
> -               return 0;
> -       }
> +       if (param->type !=3D fs_value_is_flag)
> +               return invalf(fc, "%s: Unexpected value for '%s'",
> +                             fc->fs_type->name, param->key);
>
> -       return -ENOPARAM;
> +       fc->sb_flags |=3D set;
> +       fc->sb_flags &=3D ~clear;
> +       fc->sb_flags_mask |=3D set | clear;
> +       return 0;
>  }
>
>  /**
> @@ -130,7 +129,7 @@ int vfs_parse_fs_param(struct fs_context *fc, struct =
fs_parameter *param)
>         if (!param->key)
>                 return invalf(fc, "Unnamed parameter\n");
>
> -       ret =3D vfs_parse_sb_flag(fc, param->key);
> +       ret =3D vfs_parse_sb_flag(fc, param);
>         if (ret !=3D -ENOPARAM)
>                 return ret;
>
> --
> 2.21.0
>
