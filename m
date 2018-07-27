From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 29/38] vfs: syscall: Add fsconfig() for configuring and
 managing a context [ver #10]
Date: Sat, 28 Jul 2018 00:32:53 +0200
Message-ID: <CAG48ez2f+J+UeFN0u1Hpfq3tFXJbi7ckts8sua3eY4jDwnh6-Q@mail.gmail.com>
References: <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk>
 <153271287586.9458.6001928723332685410.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153271287586.9458.6001928723332685410.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 27, 2018 at 7:34 PM David Howells <dhowells@redhat.com> wrote:
>
> Add a syscall for configuring a filesystem creation context and triggering
> actions upon it, to be used in conjunction with fsopen, fspick and fsmount.
>
>     long fsconfig(int fs_fd, unsigned int cmd, const char *key,
>                   const void *value, int aux);
>
> Where fs_fd indicates the context, cmd indicates the action to take, key
> indicates the parameter name for parameter-setting actions and, if needed,
> value points to a buffer containing the value and aux can give more
> information for the value.
[...]
> +SYSCALL_DEFINE5(fsconfig,
> +               int, fd,
> +               unsigned int, cmd,
> +               const char __user *, _key,
> +               const void __user *, _value,
> +               int, aux)
> +{
[...]
> +       switch (cmd) {
[...]
> +       case fsconfig_set_binary:
> +               if (!_key || !_value || aux <= 0 || aux > 1024 * 1024)
> +                       return -EINVAL;
> +               break;
[...]
> +       }
> +
> +       f = fdget(fd);
> +       if (!f.file)
> +               return -EBADF;
> +       ret = -EINVAL;
> +       if (f.file->f_op != &fscontext_fops)
> +               goto out_f;

We should probably add an fdget_typed(fd, fops) helper, or something
like that, to file.h at some point... there are probably dozens of
such invocations across the kernel at this point, each one with a
couple lines of boilerplate to deal with the two separate error paths.

[...]
> +       case fsconfig_set_binary:
> +               param.type = fs_value_is_blob;
> +               param.size = aux;
> +               param.blob = memdup_user_nul(_value, aux);
> +               if (IS_ERR(param.blob)) {
> +                       ret = PTR_ERR(param.blob);
> +                       goto out_key;
> +               }
> +               break;

This means that a namespace admin (iow, an unprivileged user) can
allocate 1MB of unswappable kmalloc memory per userspace task, right?
Using userfaultfd or FUSE, you can then stall the task as long as you
want while it has that allocation. Is that problematic, or is that
normal?
