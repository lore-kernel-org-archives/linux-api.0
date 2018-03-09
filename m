From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Thu, 8 Mar 2018 17:24:11 -0800
Message-ID: <CAGXu5j+tL-3BM70kfY-XfEovKB30XuSFCaom5yaGHOD-ngokFA@mail.gmail.com>
References: <20180306013457.1955486-1-ast@kernel.org> <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
 <357c330f-0165-b7a4-7ecc-4cd797e61e15@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <357c330f-0165-b7a4-7ecc-4cd797e61e15@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Paul Moore <pmoore@redhat.com>, James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 8, 2018 at 4:57 PM, Alexei Starovoitov <ast@fb.com> wrote:
> The above are three paragraphs of security paranoia without single
> concrete example of a security issue.

How is running an arbitrary ELF as full init_ns root from a container
not a concrete example?

I'm not saying this approach can never happen. And this isn't
paranoia. There are very real security boundary violations in this
model, IMO. Though, as Andy says, it's more about autoloading than umh
itself. I just don't want to extend that problem further.

>> As Andy asked earlier, why not DYN too to catch PIE executables? Seems
>> like forcing the userspace helper to be non-PIE would defeat some of
>> the userspace defenses in use in most distros.
>
>
> because we don't add features without concrete users.

It's just a two-line change, and then it would work on distros that
build PIE-by-default. That seems like a concrete use-case.

>> The exec.c changes should be split into a separate patch. Something
>> feels incorrectly refactored here, though. Passing all three of fd,
>> filename, and file to __do_execve_file() seems wrong; perhaps the fd
>> to file handling needs to happen externally in what you have here as
>> do_execveat_common()? The resulting __do_execve_file() has repeated
>> conditionals on filename... maybe what I object to is being able to
>> pass a NULL filename at all. The filename can be (painfully)
>> reconstructed from the struct file.
>
> reconstruct the path and instantly introduce the race between execing
> something by path vs prior check that it's actual elf of already
> opened file ?!
> excellent suggestion to improve security.

I'm not sure why you're being so hostile. We're both interested in
improving the kernel.

Path names aren't stable, but they provide good _debugging_ about
things when needed. For example, the LSM hooks, if they report on one
of these loads, can produce a hint to the user about what happened.
Passing "/dev/null" around is confusing at the very least. The ELF is
absolutely not /dev/null. Why make someone guess?

>>> [...]
>>> diff --git a/kernel/module.c b/kernel/module.c
>>> index ad2d420024f6..6cfa35795741 100644
>>> --- a/kernel/module.c
>>> +++ b/kernel/module.c
>>> [...]
>>> @@ -3870,14 +3896,21 @@ SYSCALL_DEFINE3(finit_module, int, fd, const char
>>> __user *, uargs, int, flags)
>>>                       |MODULE_INIT_IGNORE_VERMAGIC))
>>>                 return -EINVAL;
>>>
>>> -       err = kernel_read_file_from_fd(fd, &hdr, &size, INT_MAX,
>>> -                                      READING_MODULE);
>>> +       f = fdget(fd);
>>> +       if (!f.file)
>>> +               return -EBADF;
>>> +
>>> +       err = kernel_read_file(f.file, &hdr, &size, INT_MAX,
>>> READING_MODULE);
>>
>>
>> For the LSM subsystem, I think this should also get it's own enum
>> kernel_read_file_id. This is really no longer a kernel module...
>
>
> at this point it's a _file_. It could have been text file just well.
> If lsm is thinking that at this point kernel is processing
> kernel module that lsm is badly broken.

Again, this is about making things more discoverable. We already know
if we're loading a kernel module or a umh ELF. Passing this
information to the LSM is valuable to the LSM to distinguish between
types of files. They have very different effects on the system, for
example. The issue is about validating intent with target. "Is this
kernel module allowed?" and "Is this umh ELF allowed?" are better
questions that "Is something loaded through finit_module() allowed?"
Note already that the LSM distinguishes between many other file types
in kernel_read_file*().

-Kees

-- 
Kees Cook
Pixel Security
