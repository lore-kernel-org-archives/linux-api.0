From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Thu, 8 Mar 2018 16:57:25 -0800
Message-ID: <357c330f-0165-b7a4-7ecc-4cd797e61e15@fb.com>
References: <20180306013457.1955486-1-ast@kernel.org>
 <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 3/8/18 4:24 PM, Kees Cook wrote:
> How is this not marked [RFC]? :)
>
> On Mon, Mar 5, 2018 at 5:34 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>> As the first step in development of bpfilter project [1] the request_module()
>> code is extended to allow user mode helpers to be invoked. Idea is that
>> user mode helpers are built as part of the kernel build and installed as
>> traditional kernel modules with .ko file extension into distro specified
>> location, such that from a distribution point of view, they are no different
>> than regular kernel modules. Thus, allow request_module() logic to load such
>> user mode helper (umh) modules via:
>>
>>   request_module("foo") ->
>>     call_umh("modprobe foo") ->
>>       sys_finit_module(FD of /lib/modules/.../foo.ko) ->
>>         call_umh(struct file)
>
> Yikes. This means autoloaded artbitrary exec() now, instead of
> autoloading just loading arbitrary modules? That seems extremely bad.
> This just extends all the problems we've had with defining security
> boundaries with modules out to umh too. I would need some major
> convincing that this can be made safe.
>
> It's easy for container to trigger arbitrary module loading, so if it
> can find/use a similar one of the bugs we've seen in the past to
> redirect the module loading we don't just get new module-created
> attack surface added to the kernel, but we again get arbitrary ELF
> running in the root ns (not in the container). And in the insane case
> of a container with CAP_SYS_MODULE, this is a trivial escape without
> even needing to build a special kernel module: the root ns, running
> with all privileges runs an arbitrary ELF.
>
> As it stands, I have to NAK this. At the very least, you need to solve
> the execution environment problems here: the ELF should run with no
> greater privileges than what loaded the module, and very importantly,
> must not be allowed to bypass these checks through autoloading. What
> _triggered_ the autoload must be the environment, not the "modprobe",
> since that's running with full privileges. Basically, we need to fix
> module autoloading first, or at least a significant subset of the
> problems: https://lkml.org/lkml/2017/11/27/754

The above are three paragraphs of security paranoia without single
concrete example of a security issue.

>> Such approach enables kernel to delegate functionality traditionally done
>> by kernel modules into user space processes (either root or !root) and
>> reduces security attack surface of such new code, meaning in case of
>> potential bugs only the umh would crash but not the kernel. Another
>> advantage coming with that would be that bpfilter.ko can be debugged and
>> tested out of user space as well (e.g. opening the possibility to run
>> all clang sanitizers, fuzzers or test suites for checking translation).
>> Also, such architecture makes the kernel/user boundary very precise:
>> control plane is done by the user space while data plane stays in the kernel.
>>
>> It's easy to distinguish "umh module" from traditional kernel module:
>>
>> $ readelf -h bld/net/bpfilter/bpfilter.ko|grep Type
>>   Type:                              EXEC (Executable file)
>
> As Andy asked earlier, why not DYN too to catch PIE executables? Seems
> like forcing the userspace helper to be non-PIE would defeat some of
> the userspace defenses in use in most distros.

because we don't add features without concrete users.

>> $ readelf -h bld/net/ipv4/netfilter/iptable_filter.ko |grep Type
>>   Type:                              REL (Relocatable file)
>>
>> Since umh can crash, can be oom-ed by the kernel, killed by admin,
>> the subsystem that uses them (like bpfilter) need to manage life
>> time of umh on its own, so module infra doesn't do any accounting
>> of them. They don't appear in "lsmod" and cannot be "rmmod".
>> Multiple request_module("umh") will load multiple umh.ko processes.
>>
>> Similar to kernel modules the kernel will be tainted if "umh module"
>> has invalid signature.
>>
>> [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__lwn.net_Articles_747551_&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=i6WobKxbeG3slzHSIOxTVtYIJw7qjCE6S0spDTKL-J4&m=pMlEM-qKOmGljadUKAdwKBpuYHQRXzApvSGkZFIT4Gg&s=0-vP6LH-GxXnL7LuV-KfMl1NbqsVJUINSygoVa9R6nk&e=
>>
>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>> ---
>>  fs/exec.c               | 40 +++++++++++++++++++++++++++++++---------
>>  include/linux/binfmts.h |  1 +
>>  include/linux/umh.h     |  3 +++
>>  kernel/module.c         | 43 ++++++++++++++++++++++++++++++++++++++-----
>>  kernel/umh.c            | 24 +++++++++++++++++++++---
>>  5 files changed, 94 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 7eb8d21bcab9..0483c438de7d 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1691,14 +1691,13 @@ static int exec_binprm(struct linux_binprm *bprm)
>>  /*
>>   * sys_execve() executes a new program.
>>   */
>> -static int do_execveat_common(int fd, struct filename *filename,
>> -                             struct user_arg_ptr argv,
>> -                             struct user_arg_ptr envp,
>> -                             int flags)
>> +static int __do_execve_file(int fd, struct filename *filename,
>> +                           struct user_arg_ptr argv,
>> +                           struct user_arg_ptr envp,
>> +                           int flags, struct file *file)
>>  {
>>         char *pathbuf = NULL;
>>         struct linux_binprm *bprm;
>> -       struct file *file;
>>         struct files_struct *displaced;
>>         int retval;
>>
>> @@ -1737,7 +1736,8 @@ static int do_execveat_common(int fd, struct filename *filename,
>>         check_unsafe_exec(bprm);
>>         current->in_execve = 1;
>>
>> -       file = do_open_execat(fd, filename, flags);
>> +       if (!file)
>> +               file = do_open_execat(fd, filename, flags);
>>         retval = PTR_ERR(file);
>>         if (IS_ERR(file))
>>                 goto out_unmark;
>> @@ -1745,7 +1745,9 @@ static int do_execveat_common(int fd, struct filename *filename,
>>         sched_exec();
>>
>>         bprm->file = file;
>> -       if (fd == AT_FDCWD || filename->name[0] == '/') {
>> +       if (!filename) {
>> +               bprm->filename = "/dev/null";
>> +       } else if (fd == AT_FDCWD || filename->name[0] == '/') {
>>                 bprm->filename = filename->name;
>>         } else {
>>                 if (filename->name[0] == '\0')
>> @@ -1811,7 +1813,8 @@ static int do_execveat_common(int fd, struct filename *filename,
>>         task_numa_free(current);
>>         free_bprm(bprm);
>>         kfree(pathbuf);
>> -       putname(filename);
>> +       if (filename)
>> +               putname(filename);
>>         if (displaced)
>>                 put_files_struct(displaced);
>>         return retval;
>> @@ -1834,10 +1837,29 @@ static int do_execveat_common(int fd, struct filename *filename,
>>         if (displaced)
>>                 reset_files_struct(displaced);
>>  out_ret:
>> -       putname(filename);
>> +       if (filename)
>> +               putname(filename);
>>         return retval;
>>  }
>>
>> +static int do_execveat_common(int fd, struct filename *filename,
>> +                             struct user_arg_ptr argv,
>> +                             struct user_arg_ptr envp,
>> +                             int flags)
>> +{
>> +       struct file *file = NULL;
>> +
>> +       return __do_execve_file(fd, filename, argv, envp, flags, file);
>> +}
>> +
>> +int do_execve_file(struct file *file, void *__argv, void *__envp)
>> +{
>> +       struct user_arg_ptr argv = { .ptr.native = __argv };
>> +       struct user_arg_ptr envp = { .ptr.native = __envp };
>> +
>> +       return __do_execve_file(AT_FDCWD, NULL, argv, envp, 0, file);
>> +}
>
> The exec.c changes should be split into a separate patch. Something
> feels incorrectly refactored here, though. Passing all three of fd,
> filename, and file to __do_execve_file() seems wrong; perhaps the fd
> to file handling needs to happen externally in what you have here as
> do_execveat_common()? The resulting __do_execve_file() has repeated
> conditionals on filename... maybe what I object to is being able to
> pass a NULL filename at all. The filename can be (painfully)
> reconstructed from the struct file.

reconstruct the path and instantly introduce the race between execing
something by path vs prior check that it's actual elf of already
opened file ?!
excellent suggestion to improve security.

>> [...]
>> diff --git a/kernel/module.c b/kernel/module.c
>> index ad2d420024f6..6cfa35795741 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> [...]
>> @@ -3870,14 +3896,21 @@ SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
>>                       |MODULE_INIT_IGNORE_VERMAGIC))
>>                 return -EINVAL;
>>
>> -       err = kernel_read_file_from_fd(fd, &hdr, &size, INT_MAX,
>> -                                      READING_MODULE);
>> +       f = fdget(fd);
>> +       if (!f.file)
>> +               return -EBADF;
>> +
>> +       err = kernel_read_file(f.file, &hdr, &size, INT_MAX, READING_MODULE);
>
> For the LSM subsystem, I think this should also get it's own enum
> kernel_read_file_id. This is really no longer a kernel module...

at this point it's a _file_. It could have been text file just well.
If lsm is thinking that at this point kernel is processing
kernel module that lsm is badly broken.

>>         if (err)
>> -               return err;
>> +               goto out;
>>         info.hdr = hdr;
>>         info.len = size;
>> +       info.file = f.file;
>>
>> -       return load_module(&info, uargs, flags);
>> +       err = load_module(&info, uargs, flags);
>> +out:
>> +       fdput(f);
>> +       return err;
>>  }
>>
>>  static inline int within(unsigned long addr, void *start, unsigned long size)
>> diff --git a/kernel/umh.c b/kernel/umh.c
>> index 18e5fa4b0e71..4361c694bdb1 100644
>> --- a/kernel/umh.c
>> +++ b/kernel/umh.c
>> @@ -97,9 +97,13 @@ static int call_usermodehelper_exec_async(void *data)
>>
>>         commit_creds(new);
>>
>> -       retval = do_execve(getname_kernel(sub_info->path),
>> -                          (const char __user *const __user *)sub_info->argv,
>> -                          (const char __user *const __user *)sub_info->envp);
>> +       if (sub_info->file)
>> +               retval = do_execve_file(sub_info->file,
>> +                                       sub_info->argv, sub_info->envp);
>> +       else
>> +               retval = do_execve(getname_kernel(sub_info->path),
>> +                                  (const char __user *const __user *)sub_info->argv,
>> +                                  (const char __user *const __user *)sub_info->envp);
>>  out:
>>         sub_info->retval = retval;
>>         /*
>> @@ -393,6 +397,20 @@ struct subprocess_info *call_usermodehelper_setup(const char *path, char **argv,
>>  }
>>  EXPORT_SYMBOL(call_usermodehelper_setup);
>>
>> +struct subprocess_info *call_usermodehelper_setup_file(struct file *file)
>> +{
>> +       struct subprocess_info *sub_info;
>> +
>> +       sub_info = kzalloc(sizeof(struct subprocess_info), GFP_KERNEL);
>> +       if (!sub_info)
>> +               return NULL;
>> +
>> +       INIT_WORK(&sub_info->work, call_usermodehelper_exec_work);
>> +       sub_info->path = "/dev/null";
>> +       sub_info->file = file;
>
> This use of "/dev/null" here and in execve is just wrong. It _does_
> have a path and filename...

already answered that earlier in the thread.
