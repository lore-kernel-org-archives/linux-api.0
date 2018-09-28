From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v7 4/6] files: add a replace_fd_files() function
Date: Thu, 27 Sep 2018 19:20:50 -0700
Message-ID: <CAGXu5jJvkkNNsGj=MK+=Dg0=nauANRkp=b1MrvOOzxkpb+DVkg@mail.gmail.com>
References: <20180927151119.9989-1-tycho@tycho.ws> <20180927151119.9989-5-tycho@tycho.ws>
 <CAGXu5jLOe0izpGoB8c-hAeH2SzA51dF1BuMcXbk-d=QwqfjxxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLOe0izpGoB8c-hAeH2SzA51dF1BuMcXbk-d=QwqfjxxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 2:59 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Sep 27, 2018 at 8:11 AM, Tycho Andersen <tycho@tycho.ws> wrote:
>> Similar to fd_install/__fd_install, we want to be able to replace an fd of
>> an arbitrary struct files_struct, not just current's. We'll use this in the
>> next patch to implement the seccomp ioctl that allows inserting fds into a
>> stopped process' context.
>>
>> v7: new in v7
>>
>> Signed-off-by: Tycho Andersen <tycho@tycho.ws>
>> CC: Alexander Viro <viro@zeniv.linux.org.uk>
>> CC: Kees Cook <keescook@chromium.org>
>> CC: Andy Lutomirski <luto@amacapital.net>
>> CC: Oleg Nesterov <oleg@redhat.com>
>> CC: Eric W. Biederman <ebiederm@xmission.com>
>> CC: "Serge E. Hallyn" <serge@hallyn.com>
>> CC: Christian Brauner <christian.brauner@ubuntu.com>
>> CC: Tyler Hicks <tyhicks@canonical.com>
>> CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
>> ---
>>  fs/file.c            | 22 +++++++++++++++-------
>>  include/linux/file.h |  8 ++++++++
>>  2 files changed, 23 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/file.c b/fs/file.c
>> index 7ffd6e9d103d..3b3c5aadaadb 100644
>> --- a/fs/file.c
>> +++ b/fs/file.c
>> @@ -850,24 +850,32 @@ __releases(&files->file_lock)
>>  }
>>
>>  int replace_fd(unsigned fd, struct file *file, unsigned flags)
>> +{
>> +       return replace_fd_task(current, fd, file, flags);
>> +}
>> +
>> +/*
>> + * Same warning as __alloc_fd()/__fd_install() here.
>> + */
>> +int replace_fd_task(struct task_struct *task, unsigned fd,
>> +                   struct file *file, unsigned flags)
>>  {
>>         int err;
>> -       struct files_struct *files = current->files;
>
> Same feedback as Jann: on a purely "smaller diff" note, this could
> just be s/current/task/ here and all the other s/files/task->files/
> would go away...
>
>>
>>         if (!file)
>> -               return __close_fd(files, fd);
>> +               return __close_fd(task->files, fd);
>>
>> -       if (fd >= rlimit(RLIMIT_NOFILE))
>> +       if (fd >= task_rlimit(task, RLIMIT_NOFILE))
>>                 return -EBADF;
>>
>> -       spin_lock(&files->file_lock);
>> -       err = expand_files(files, fd);
>> +       spin_lock(&task->files->file_lock);
>> +       err = expand_files(task->files, fd);
>>         if (unlikely(err < 0))
>>                 goto out_unlock;
>> -       return do_dup2(files, file, fd, flags);
>> +       return do_dup2(task->files, file, fd, flags);
>>
>>  out_unlock:
>> -       spin_unlock(&files->file_lock);
>> +       spin_unlock(&task->files->file_lock);
>>         return err;
>>  }
>>
>> diff --git a/include/linux/file.h b/include/linux/file.h
>> index 6b2fb032416c..f94277fee038 100644
>> --- a/include/linux/file.h
>> +++ b/include/linux/file.h
>> @@ -11,6 +11,7 @@
>>  #include <linux/posix_types.h>
>>
>>  struct file;
>> +struct task_struct;
>>
>>  extern void fput(struct file *);
>>
>> @@ -79,6 +80,13 @@ static inline void fdput_pos(struct fd f)
>>
>>  extern int f_dupfd(unsigned int from, struct file *file, unsigned flags);
>>  extern int replace_fd(unsigned fd, struct file *file, unsigned flags);
>> +/*
>> + * Warning! This is only safe if you know the owner of the files_struct is
>> + * stopped outside syscall context. It's a very bad idea to use this unless you
>> + * have similar guarantees in your code.
>> + */
>> +extern int replace_fd_task(struct task_struct *task, unsigned fd,
>> +                          struct file *file, unsigned flags);
>
> Perhaps call this __replace_fd() to indicate the "please don't use
> this unless you're very sure"ness of it?
>
>>  extern void set_close_on_exec(unsigned int fd, int flag);
>>  extern bool get_close_on_exec(unsigned int fd);
>>  extern int get_unused_fd_flags(unsigned flags);
>> --
>> 2.17.1
>>
>
> If I can get an Ack from Al, that would be very nice. :)

In out-of-band feedback from Al, he's pointed out a much cleaner
approach: do the work on the "current" side. i.e. current is stopped
in __seccomp_filter in the case SECCOMP_RET_USER_NOTIFY. Instead of
having the ioctl-handing process doing the work, have it done on the
other side. This may cause some additional complexity on the ioctl
return path, but it solves both this problem and the "ptrace attach"
issue: have the work delayed until "current" gets caught by seccomp.

-Kees

-- 
Kees Cook
Pixel Security
