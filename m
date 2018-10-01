From: Jann Horn <jannh@google.com>
Subject: Re: [RFC 2/2] binfmt_misc: move data to binfmt_namespace
Date: Mon, 1 Oct 2018 10:54:14 +0200
Message-ID: <CAG48ez3hmmSndm2dS1Jr6AFuXY8_wFQwndLbO5v0GO-NmDtO-g@mail.gmail.com>
References: <20180930234628.25528-1-laurent@vivier.eu> <20180930234628.25528-3-laurent@vivier.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180930234628.25528-3-laurent@vivier.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: laurent@vivier.eu
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, dima@arista.com, Andrei Vagin <avagin@openvz.org>, containers@lists.linux-foundation.org, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 1, 2018 at 1:47 AM Laurent Vivier <laurent@vivier.eu> wrote:
> @@ -716,7 +711,8 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
>         if (!inode)
>                 goto out2;
>
> -       err = simple_pin_fs(&bm_fs_type, &bm_mnt, &entry_count);
> +       err = simple_pin_fs(&bm_fs_type, &binfmt_ns(bm_mnt),
> +                           &binfmt_ns(entry_count));
>         if (err) {
>                 iput(inode);
>                 inode = NULL;
> @@ -730,7 +726,8 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
>                 if (IS_ERR(f)) {
>                         err = PTR_ERR(f);
>                         pr_notice("register: failed to install interpreter file %s\n", e->interpreter);
> -                       simple_release_fs(&bm_mnt, &entry_count);
> +                       simple_release_fs(&binfmt_ns(bm_mnt),
> +                                         &binfmt_ns(entry_count));
>                         iput(inode);
>                         inode = NULL;
>                         goto out2;
> @@ -743,9 +740,9 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
>         inode->i_fop = &bm_entry_operations;
>
>         d_instantiate(dentry, inode);
> -       write_lock(&entries_lock);
> -       list_add(&e->list, &entries);
> -       write_unlock(&entries_lock);
> +       write_lock(&binfmt_ns(entries_lock));
> +       list_add(&e->list, &binfmt_ns(entries));
> +       write_unlock(&binfmt_ns(entries_lock));

This looks wrong. A write handler's behavior should not depend on the
namespace of the process that is using it.

Ideally, the affected namespace should depend on the file you're writing to.
If that's not possible, the affected namespace should at least be the
namespace of the process that opened the file.
