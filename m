From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] new flag COPY_FILE_RANGE_FILESIZE for copy_file_range()
Date: Sat, 13 Apr 2019 14:48:41 -0700
Message-ID: <40254CBE-34B0-4783-8B19-FE7EA0BDA1E3@amacapital.net>
References: <20190413204947.9394-1-shawn@git.icu>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190413204947.9394-1-shawn@git.icu>
Sender: linux-kernel-owner@vger.kernel.org
To: Shawn Landden <shawn@git.icu>
Cc: linux-api@vger.kernel, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org



> On Apr 13, 2019, at 1:49 PM, Shawn Landden <shawn@git.icu> wrote:
>=20
> If flags includes COPY_FILE_RANGE_FILESIZE then the length
> copied is the length of the file. off_in and off_out are
> ignored. len must be 0 or the file size.
>=20
> This implementation saves a call to stat() in the common case
> of copying files. It does not fix any race conditions, but that
> is possible in the future with this interface.
>=20
> EAGAIN: If COPY_FILE_RANGE_FILESIZE was passed and len is not 0
> or the file size.

I think you=E2=80=99re asking for trouble here. I assume you have some kind o=
f race prevention in mind here.  The trouble is that passing zero means copy=
 the whole thing, but the size-checking behavior is only available for nonze=
ro sizes. This means that anyone who passes their idea of the size needs to a=
ccount for inconsistent behavior if the size is zero.

Also, what happens if the file size changes mid copy?  I assume the result i=
s more or less arbitrary, but you should document what behavior is allowed. =
 The docs should cover the case where you race against an O_APPEND write.

>=20
> Signed-off-by: Shawn Landden <shawn@git.icu>
> CC: <linux-api@vger.kernel.org>
> ---
> fs/read_write.c           | 14 +++++++++++++-
> include/uapi/linux/stat.h |  4 ++++
> 2 files changed, 17 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 61b43ad7608e..6d06361f0856 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1557,7 +1557,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, lo=
ff_t pos_in,
>    struct inode *inode_out =3D file_inode(file_out);
>    ssize_t ret;
>=20
> -    if (flags !=3D 0)
> +    if ((flags & ~COPY_FILE_RANGE_FILESIZE) !=3D 0)
>        return -EINVAL;
>=20
>    if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
> @@ -1565,6 +1565,18 @@ ssize_t vfs_copy_file_range(struct file *file_in, l=
off_t pos_in,
>    if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
>        return -EINVAL;
>=20
> +    if (flags & COPY_FILE_RANGE_FILESIZE) {
> +        struct kstat stat;
> +        int error;
> +        error =3D vfs_getattr(&file_in->f_path, &stat,
> +                    STATX_SIZE, 0);
> +        if (error < 0)
> +            return error;
> +        if (!(len =3D=3D 0 || len =3D=3D stat.size))
> +            return -EAGAIN;
> +        len =3D stat.size;
> +    }
> +
>    ret =3D rw_verify_area(READ, file_in, &pos_in, len);
>    if (unlikely(ret))
>        return ret;
> diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
> index 7b35e98d3c58..1075aa4666ef 100644
> --- a/include/uapi/linux/stat.h
> +++ b/include/uapi/linux/stat.h
> @@ -170,5 +170,9 @@ struct statx {
>=20
> #define STATX_ATTR_AUTOMOUNT        0x00001000 /* Dir: Automount trigger *=
/
>=20
> +/*
> + * Flags for copy_file_range()
> + */
> +#define COPY_FILE_RANGE_FILESIZE    0x00000001 /* Copy the full length of=
 the input file */
>=20
> #endif /* _UAPI_LINUX_STAT_H */
> --=20
> 2.20.1
>=20
