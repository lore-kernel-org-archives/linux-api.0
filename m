From: Nick Kralevich <nnk-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [kernel-hardening] [PATCH] fs: Use CAP_DAC_OVERRIDE to allow for
 file dedupe
Date: Sat, 21 Oct 2017 07:08:31 -0700
Message-ID: <CAFJ0LnGjhjm9iswxh-naLM9qZq-fQ_a0MdyVDsmRUk4ME0xuNA@mail.gmail.com>
References: <20171021132806.18086-1-nicolas@belouin.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171021132806.18086-1-nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Oct 21, 2017 at 6:28 AM, Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org> wrote:
> In its current implementation the check is against CAP_SYS_ADMIN,
> however this capability is bloated and inapropriate for this use.
> Indeed the check aims to avoid dedupe against non writable files,
> falling directly in the use case of CAP_DAC_OVERRIDE.
>
> Signed-off-by: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
> ---
>  fs/read_write.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index f0d4b16873e8..43cc7e84e29e 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1965,7 +1965,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
>         u64 len;
>         int i;
>         int ret;
> -       bool is_admin = capable(CAP_SYS_ADMIN);
> +       bool is_admin = capable(CAP_SYS_ADMIN) || capable(CAP_DAC_OVERRIDE);

Can you please reverse the order of the checks? In particular, on an
SELinux based system, a capable() call generates an SELinux denial,
and people often instinctively allow the first operation performed.
Reordering the elements will ensure that the CAP_DAC_OVERRIDE denial
(least permissive) is generated first.

>         u16 count = same->dest_count;
>         struct file *dst_file;
>         loff_t dst_off;
> --
> 2.14.2
>



-- 
Nick Kralevich | Android Security | nnk-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org | 650.214.4037
