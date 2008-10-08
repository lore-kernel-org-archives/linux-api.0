From: "Michael Kerrisk" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH, v3] shmat: introduce flag SHM_MAP_NOT_FIXED
Date: Wed, 8 Oct 2008 10:57:21 +0200
Message-ID: <517f3f820810080157j3994ff10j8518178af02e5b22@mail.gmail.com>
References: <1223396117-8118-1-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1223396117-8118-1-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hugh Dickins <hugh-DTz5qymZ9yRBDgjK7y7TUQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Kirill,

On Tue, Oct 7, 2008 at 6:15 PM, Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:
> If SHM_MAP_NOT_FIXED specified and shmaddr is not NULL, then the kernel takes
> shmaddr as a hint about where to place the mapping. The address of the mapping
> is returned as the result of the call.
>
> It's similar to mmap() without MAP_FIXED.

Please CC linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on patches that change the
kernel-userspace interface.

Cheers,

Michael

> Signed-off-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Hugh Dickins <hugh-DTz5qymZ9yRBDgjK7y7TUQ@public.gmane.org>
> Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Cc: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
> Cc: Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> ---
>  include/linux/shm.h |    2 ++
>  ipc/shm.c           |    7 ++++---
>  2 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/shm.h b/include/linux/shm.h
> index eca6235..fd288eb 100644
> --- a/include/linux/shm.h
> +++ b/include/linux/shm.h
> @@ -55,6 +55,8 @@ struct shmid_ds {
>  #define        SHM_RND         020000  /* round attach address to SHMLBA boundary */
>  #define        SHM_REMAP       040000  /* take-over region on attach */
>  #define        SHM_EXEC        0100000 /* execution access */
> +#define        SHM_MAP_NOT_FIXED 0200000 /* interpret attach address as a search
> +                                  * hint */
>
>  /* super user shmctl commands */
>  #define SHM_LOCK       11
> diff --git a/ipc/shm.c b/ipc/shm.c
> index e77ec69..54f3c61 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -819,7 +819,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
>        if (shmid < 0)
>                goto out;
>        else if ((addr = (ulong)shmaddr)) {
> -               if (addr & (SHMLBA-1)) {
> +               if (!(shmflg & SHM_MAP_NOT_FIXED) && (addr & (SHMLBA-1))) {
>                        if (shmflg & SHM_RND)
>                                addr &= ~(SHMLBA-1);       /* round down */
>                        else
> @@ -828,7 +828,8 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
>  #endif
>                                        goto out;
>                }
> -               flags = MAP_SHARED | MAP_FIXED;
> +               flags = MAP_SHARED |
> +                               (shmflg & SHM_MAP_NOT_FIXED ? 0 : MAP_FIXED);
>        } else {
>                if ((shmflg & SHM_REMAP))
>                        goto out;
> @@ -892,7 +893,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
>        sfd->vm_ops = NULL;
>
>        down_write(&current->mm->mmap_sem);
> -       if (addr && !(shmflg & SHM_REMAP)) {
> +       if (addr && !(shmflg & (SHM_REMAP|SHM_MAP_NOT_FIXED))) {
>                err = -EINVAL;
>                if (find_vma_intersection(current->mm, addr, addr + size))
>                        goto invalid;
> --
> 1.5.6.5.GIT
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/ Found a documentation bug?
http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
