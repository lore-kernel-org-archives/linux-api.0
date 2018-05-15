From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v5 1/7] proc: add proc_fs_info struct to store proc information
Date: Tue, 15 May 2018 18:19:18 +0200
Message-ID: <CAG48ez1T5v=iryQk0fPkUr2umRpfMrSPJ2pYcB5HDbc3-kYBUw@mail.gmail.com>
References: <20180511093445.GA1008@comp-core-i7-2640m-0182e6>
 <CAG48ez3xYHsKMkPJhjq-yrrTxMHmrHDov-P7bTy8T2xf_7=OAQ@mail.gmail.com> <20180515072153.GD28179@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180515072153.GD28179@comp-core-i7-2640m-0182e6>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, aniel Micay <danielmicay@gmail.com>, Jon
List-Id: linux-api@vger.kernel.org

On Tue, May 15, 2018 at 9:21 AM, Alexey Gladkov
<gladkov.alexey@gmail.com> wrote:
> On Fri, May 11, 2018 at 03:49:13PM +0200, Jann Horn wrote:
>> On Fri, May 11, 2018 at 11:34 AM, Alexey Gladkov
>> <gladkov.alexey@gmail.com> wrote:
>> > From: Djalal Harouni <tixxdz@gmail.com>
>> >
>> > This is a preparation patch that adds proc_fs_info to be able to store
>> > different procfs options and informations. Right now some mount options
>> > are stored inside the pid namespace which makes it hard to change or
>> > modernize procfs without affecting pid namespaces. Plus we do want to
>> > treat proc as more of a real mount point and filesystem. procfs is part
>> > of Linux API where it offers some features using filesystem syscalls and
>> > in order to support some features where we are able to have multiple
>> > instances of procfs, each one with its mount options inside the same pid
>> > namespace, we have to separate these procfs instances.
>> >
>> > This is the same feature that was also added to other Linux interfaces
>> > like devpts in order to support containers, sandboxes, and to have
>> > multiple instances of devpts filesystem [1].
>> >
>> > [1] http://lxr.free-electrons.com/source/Documentation/filesystems/devpts.txt?v=3.14
>> >
>> > Cc: Kees Cook <keescook@chromium.org>
>> > Suggested-by: Andy Lutomirski <luto@kernel.org>
>> > Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
>> > Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
>> > ---
>> [...]
>> >  static struct dentry *proc_mount(struct file_system_type *fs_type,
>> >         int flags, const char *dev_name, void *data)
>> >  {
>> > +       int error;
>> > +       struct super_block *sb;
>> >         struct pid_namespace *ns;
>> > +       struct proc_fs_info *fs_info;
>> > +
>> > +       /*
>> > +        * Don't allow mounting unless the caller has CAP_SYS_ADMIN over
>> > +        * the namespace.
>> > +        */
>> > +       if (!(flags & MS_KERNMOUNT) && !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
>> > +               return ERR_PTR(-EPERM);
>>
>> Is this correct?
>>
>> The old code invoked a check with the same comment through mount_ns();
>> however, this patch changes the semantics of the check.
>> The old code checked that the caller has privileges over the user
>> namespace that contains the PID namespace; in other words, it checked
>> that the caller has privileges over the PID namespace. The current
>> code just checks that the caller is privileged over its own user
>> namespace.
>>
>> As far as I can tell, this means that by doing something like this:
>>
>>     unshare(CLONE_NEWNS|CLONE_NEWUSER);
>>     mount("none", "/", NULL, MS_REC|MS_PRIVATE, NULL);
>>     mount("proc", "/proc", "proc", 0, "newinstance,pids=all");
>>
>> any process could create a new unrestricted procfs mount for its PID
>> namespace, even if it is only supposed to have access to a more
>> restricted procfs mount.
>
> Hm... let me investigate this. It looks like mount with "newinstance"
> option should fail if pid namespace is the same and the current and parent
> user namespace do not match.

I don't understand that last sentence. What does "if pid namespace is
the same" mean, and what does "current and parent user namespace do
not match" mean?

Just changing "ns_capable(current_user_ns(), CAP_SYS_ADMIN)" to
"ns_capable(task_active_pid_ns(current)->user_ns, CAP_SYS_ADMIN)"
should be enough to get the old semantics again: It checks whether the
current task is capable over its PID namespace.
