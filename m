From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv6 1/3] syscalls,x86: implement execveat() system call
Date: Fri, 7 Nov 2014 13:19:54 +0000
Message-ID: <CAHse=S9sudiJnLTwd1yXK9jFCPfVq4uPLBjhUDqMFeh2UQ7xqQ@mail.gmail.com>
References: <1415290033-15771-1-git-send-email-drysdale@google.com>
 <1415290033-15771-2-git-send-email-drysdale@google.com> <CAGXu5jKp7wEKnoeOVGUGCeJ3Mv-kkOm+QpXiu4HdWuvQx99auw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jKp7wEKnoeOVGUGCeJ3Mv-kkOm+QpXiu4HdWuvQx99auw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 6, 2014 at 6:06 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> On Thu, Nov 6, 2014 at 8:07 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> diff --git a/fs/exec.c b/fs/exec.c
>> index a2b42a98c743..800d232c17bb 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1422,10 +1431,12 @@ static int exec_binprm(struct linux_binprm *bprm)
>>  /*
>>   * sys_execve() executes a new program.
>>   */
>> -static int do_execve_common(struct filename *filename,
>> -                               struct user_arg_ptr argv,
>> -                               struct user_arg_ptr envp)
>> +static int do_execveat_common(int fd, struct filename *filename,
>> +                             struct user_arg_ptr argv,
>> +                             struct user_arg_ptr envp,
>> +                             int flags)
>>  {
>> +       char *pathbuf = NULL;
>>         struct linux_binprm *bprm;
>>         struct file *file;
>>         struct files_struct *displaced;
>> @@ -1466,7 +1477,7 @@ static int do_execve_common(struct filename *filename,
>>         check_unsafe_exec(bprm);
>>         current->in_execve = 1;
>>
>> -       file = do_open_exec(filename);
>> +       file = do_open_execat(fd, filename, flags);
>>         retval = PTR_ERR(file);
>>         if (IS_ERR(file))
>>                 goto out_unmark;
>> @@ -1474,7 +1485,30 @@ static int do_execve_common(struct filename *filename,
>>         sched_exec();
>>
>>         bprm->file = file;
>> -       bprm->filename = bprm->interp = filename->name;
>> +       if (fd == AT_FDCWD || filename->name[0] == '/') {
>> +               bprm->filename = filename->name;
>> +       } else {
>> +               /* "/dev/fd/2147483647/" + filename->name */
>> +               int maxlen = 19 + strlen(filename->name);
>
> This should be 20 + strlen (to include the trailing NULL). However, I
> think this whole bit of code could be replaced with kasprintf...
>
>> +
>> +               pathbuf = kmalloc(maxlen, GFP_TEMPORARY);
>> +               if (!pathbuf) {
>> +                       retval = -ENOMEM;
>> +                       goto out_unmark;
>> +               }
>> +               if (filename->name[0] == '\0')
>> +                       sprintf(pathbuf, "/dev/fd/%d", fd);
>> +               else
>> +                       snprintf(pathbuf, maxlen,
>> +                                "/dev/fd/%d/%s", fd, filename->name);
>
> Maybe something like this? A bit messy, so maybe your original if/else
> would be more readable.
>
>     } else {
>         pathbuf = kasprintf("/dev/fd/%d%s%s", fd,
>                                        filename->name[0] == '\0' ? "" : "/",
>                                        filename->name[0] == '\0' ? ""
> : filename->name);
>         if (!pathbuf) {
>             retval = -ENOMEM;
>             goto out_unmark;
>         }
>     }

Ah, I didn't know about kasprintf(), that will make things much
easier -- thanks!
