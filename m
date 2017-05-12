From: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch v4 resend 2/2] kcmp: Add KCMP_EPOLL_TFD mode to compare
 epoll target files
Date: Sat, 13 May 2017 00:41:30 +0200
Message-ID: <CAG48ez33xco_cHeaHYg2TOCquosbrAStnHikBDZ89No6c7E0Kg@mail.gmail.com>
References: <20170424154423.511592110@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170424154423.511592110-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[resending as plaintext]

On Mon, Apr 24, 2017 at 5:39 PM, Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> With current epoll architecture target files are addressed
> with file_struct and file descriptor number, where the last
> is not unique. Moreover files can be transferred from another
> process via unix socket, added into queue and closed then
> so we won't find this descriptor in the task fdinfo list.
>
> Thus to checkpoint and restore such processes CRIU needs to
> find out where exactly the target file is present to add it into
> epoll queue. For this sake one can use kcmp call where
> some particular target file from the queue is compared with
> arbitrary file passed as an argument.
[...]
> +#ifdef CONFIG_EPOLL
> +static int kcmp_epoll_target(struct task_struct *task1,
> +                            struct task_struct *task2,
> +                            unsigned long idx1,
> +                            struct kcmp_epoll_slot __user *uslot)
> +{
> +       struct file *filp, *filp_epoll, *filp_tgt;
> +       struct kcmp_epoll_slot slot;
> +       struct files_struct *files;
> +
> +       if (copy_from_user(&slot, uslot, sizeof(slot)))
> +               return -EFAULT;
> +
> +       filp = get_file_raw_ptr(task1, idx1);
> +       if (!filp)
> +               return -EBADF;
> +
> +       files = get_files_struct(task2);
> +       if (!files)
> +               return -EBADF;
> +
> +       spin_lock(&files->file_lock);
> +       filp_epoll = fcheck_files(files, slot.efd);
> +       if (filp_epoll)
> +               get_file(filp_epoll);
> +       else
> +               filp_tgt = ERR_PTR(-EBADF);
> +       spin_unlock(&files->file_lock);
> +       put_files_struct(files);
> +
> +       if (filp_epoll) {
> +               filp_tgt = get_epoll_tfile_raw_ptr(filp_epoll, slot.tfd, slot.toff);
> +               fput(filp_epoll);
> +       } else
> +
> +       if (IS_ERR(filp_tgt))
> +               return PTR_ERR(filp_tgt);
> +
> +       return kcmp_ptr(filp, filp_tgt, KCMP_FILE);
> +}

I realize that the existing kcmp code has the same issue, but:

Why are you not taking a reference to filp or filp_tgt? This can end up
performing a comparison between a pointer to a freed struct file and a
pointer to a struct file that was allocated afterwards, right? So it can
return a false "is equal" result when the two files aren't actually the same
if one of the target tasks is running? This looks like it unnecessarily
exposes information about whether an allocation reuses the memory of
a previously freed allocation.
