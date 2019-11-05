From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/1] userfaultfd: require CAP_SYS_PTRACE for
 UFFD_FEATURE_EVENT_FORK
Date: Tue, 5 Nov 2019 10:37:35 -0500
Message-ID: <20191105153735.GF30717@redhat.com>
References: <1572967777-8812-1-git-send-email-rppt@linux.ibm.com>
 <1572967777-8812-2-git-send-email-rppt@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1572967777-8812-2-git-send-email-rppt@linux.ibm.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Pavel Emelyanov <ovzxemul@gmail.com>, Tim Murray <timmurray@google.com>, linux-api@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

Hello Mike,

On Tue, Nov 05, 2019 at 05:29:37PM +0200, Mike Rapoport wrote:
> Current implementation of UFFD_FEATURE_EVENT_FORK modifies the file
> descriptor table from the read() implementation of uffd, which may have
> security implications for unprivileged use of the userfaultfd.
>=20
> Limit availability of UFFD_FEATURE_EVENT_FORK only for callers that have
> CAP_SYS_PTRACE.
>=20
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  fs/userfaultfd.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index f9fd18670e22..d99d166fd892 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1834,13 +1834,12 @@ static int userfaultfd_api(struct userfaultfd_ctx=
 *ctx,
>  =09if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
>  =09=09goto out;
>  =09features =3D uffdio_api.features;
> -=09if (uffdio_api.api !=3D UFFD_API || (features & ~UFFD_API_FEATURES)) =
{
> -=09=09memset(&uffdio_api, 0, sizeof(uffdio_api));
> -=09=09if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
> -=09=09=09goto out;
> -=09=09ret =3D -EINVAL;
> -=09=09goto out;
> -=09}
> +=09ret =3D -EINVAL;
> +=09if (uffdio_api.api !=3D UFFD_API || (features & ~UFFD_API_FEATURES))
> +=09=09goto err_out;
> +=09ret =3D -EPERM;
> +=09if ((features & UFFD_FEATURE_EVENT_FORK) && !capable(CAP_SYS_PTRACE))
> +=09=09goto err_out;
>  =09/* report all available features and ioctls to userland */
>  =09uffdio_api.features =3D UFFD_API_FEATURES;
>  =09uffdio_api.ioctls =3D UFFD_API_IOCTLS;
> @@ -1853,6 +1852,11 @@ static int userfaultfd_api(struct userfaultfd_ctx =
*ctx,
>  =09ret =3D 0;
>  out:
>  =09return ret;
> +err_out:
> +=09memset(&uffdio_api, 0, sizeof(uffdio_api));
> +=09if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
> +=09=09ret =3D -EFAULT;
> +=09goto out;
>  }
> =20
>  static long userfaultfd_ioctl(struct file *file, unsigned cmd,

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

Thanks,
Andrea
