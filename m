From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCHv5 1/3] syscalls,x86: implement execveat() system call
Date: Tue, 28 Oct 2014 10:48:02 -0700
Message-ID: <CALCETrU61NCvE7N2TX9gy5R7T4VOwaau1q2Hspfb3Py2kW_jYw@mail.gmail.com>
References: <1413978269-17274-1-git-send-email-drysdale@google.com>
 <1413978269-17274-2-git-send-email-drysdale@google.com> <CALCETrWbj=BTDyKqtbSKteANj3J3UFZnrvWv9DMosCoEZaSoeA@mail.gmail.com>
 <CAHse=S-x6NKEn9EGFos6bS=asK-1mWCr0r9aji2a97_fgxU+Sg@mail.gmail.com>
 <CALCETrWN+bKj_PPRJy2pNDVCRd3xyd-=w7P+9khhd-XuJRXCyA@mail.gmail.com> <CAHse=S8KpmA6X9S11JG=_y7sqgit_S26uC6=NCk742nKRRP=0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAHse=S8KpmA6X9S11JG=_y7sqgit_S26uC6=NCk742nKRRP=0w@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 28, 2014 at 10:30 AM, David Drysdale <drysdale@google.com> wrote:
> [Oops, re-send remembering to turn on plaintext mode -- sorry]
>
> On Mon, Oct 27, 2014 at 6:47 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Mon, Oct 27, 2014 at 11:03 AM, David Drysdale <drysdale@google.com> wrote:
>>> On Wed, Oct 22, 2014 at 7:44 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> On Wed, Oct 22, 2014 at 4:44 AM, David Drysdale <drysdale@google.com> wrote:
>>>>> Add a new system execveat(2) syscall. execveat() is to execve() as
>>>>> openat() is to open(): it takes a file descriptor that refers to a
>>>>> directory, and resolves the filename relative to that.
>>>>>
>>>>
>>>>>         bprm->file = file;
>>>>> -       bprm->filename = bprm->interp = filename->name;
>>>>> +       if (fd == AT_FDCWD || filename->name[0] == '/') {
>>>>> +               bprm->filename = filename->name;
>>>>> +       } else {
>>>>> +               /*
>>>>> +                * Build a pathname that reflects how we got to the file,
>>>>> +                * either "/dev/fd/<fd>" (for an empty filename) or
>>>>> +                * "/dev/fd/<fd>/<filename>".
>>>>> +                */
>>>>> +               pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
>>>>> +               if (!pathbuf) {
>>>>> +                       retval = -ENOMEM;
>>>>> +                       goto out_unmark;
>>>>> +               }
>>>>> +               bprm->filename = pathbuf;
>>>>> +               if (filename->name[0] == '\0')
>>>>> +                       sprintf(pathbuf, "/dev/fd/%d", fd);
>>>>
>>>> If the fd is O_CLOEXEC, then this will result in a confused child
>>>> process.  Should we fail exec attempts like that for non-static
>>>> programs?  (E.g. set filename to "" or something and fix up the binfmt
>>>> drivers to handle that?)
>>>
>>> Isn't it just scripts that get confused here (as normal executables don't
>>> get to see brpm->filename)?
>>>
>>> Given that we don't know which we have at this point, I'd suggest
>>> carrying on regardless.  Or we could fall back to use the previous
>>> best-effort d_path() code for O_CLOEXEC fds.  Thoughts?
>>
>> How hard would it be to mark the bprm as not having a path for the
>> binary?  Then we could fail later on if and when we actually need the
>> path.
>
> Adding a flag to bprm->interp_flags to indicate that the bprm->filename
> will be inaccessible after exec is straightforward.  But I'm not sure who
> should/could make use of the flag...
>
>> I don't really have a strong opinion here, though.  I do prefer
>> actually failing the execveat call over succeeding but invoking a
>> script interpreter than can't possibly work.
>
> Yeah, but that involves the kernel code (e.g. fs/binfmt_script.c) making
> an assumption about what the interpreter is going to do -- specifically
> that it's going to try to open its argv[1].  Admittedly, that's a very likely
> assumption, but I'm not sure it's one the kernel should make -- a script
> like "#!/bin/echo" wouldn't be very useful, but fexecve()ing it would still
> work OK on a name like "/dev/fd/7" after fd 7 is closed.

Hmm.  I'm unconvinced.  If an important part of executing the script
is passing it an argv[0] that can be opened, then I think we shouldn't
allow a known-bad argv[0].

>
> (Also, we need some kind of non-empty name in bprm->filename,
> even if it's going to be inaccessible later, so that any LSM processing
> off of the bprm_set_creds()/bprm_check_security() hooks has something
> to work with; those hooks are pre-exec so the "/dev/fd/<fd>" part should
> still be OK at that point.)
>
> So I guess I lean towards keeping "/dev/fd/<fd>/<path>" regardless.
>
>>>
>>>>> +               else
>>>>> +                       snprintf(pathbuf, PATH_MAX,
>>>>> +                                "/dev/fd/%d/%s", fd, filename->name);
>>>>
>>>> Does this need to handle the case where the result exceeds PATH_MAX?
>>>
>>> I guess we could kmalloc(strlen(filename->name) + 19) to avoid the
>>> possibility of failure, but that just defers the inevitable -- the interpreter
>>> won't be able to open the script file anyway.  But it would at least then
>>> generate the appropriate error (ENAMETOOLONG rather than ENOENT).
>>
>> Depends whether anyone cares about bprm->filename.  But I think the
>> code should either return an error or allocate enough space.
>
> I'll allocate enough space.
>
>>
>> --
>> Andy Lutomirski
>> AMA Capital Management, LLC



-- 
Andy Lutomirski
AMA Capital Management, LLC
