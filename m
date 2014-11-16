From: Rich Felker <dalias@aerifal.cx>
Subject: Re: [RFC] Possible new execveat(2) Linux syscall
Date: Sun, 16 Nov 2014 14:52:46 -0500
Message-ID: <20141116195246.GX22465@brightrain.aerifal.cx>
References: <CAHse=S8ccC2No5EYS0Pex=Ng3oXjfDB9woOBmMY_k+EgxtODZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-54410-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <CAHse=S8ccC2No5EYS0Pex=Ng3oXjfDB9woOBmMY_k+EgxtODZA@mail.gmail.com>
To: David Drysdale <drysdale@google.com>
Cc: libc-alpha@sourceware.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, musl@lists.openwall.com
List-Id: linux-api@vger.kernel.org

On Fri, Nov 14, 2014 at 02:54:19PM +0000, David Drysdale wrote:
> Hi,
> 
> Over at the LKML[1] we've been discussing a possible new syscall, execveat(2),
> and it would be good to hear a glibc perspective about it (and whether there
> are any interface changes that would make it easier to use from userspace).
> 
> The syscall prototype is:
>   int execveat(int fd, const char *pathname,
>                       char *const argv[],  char *const envp[],
>                       int flags); /* AT_EMPTY_PATH, AT_SYMLINK_NOFOLLOW */
> and it works similarly to execve(2) except:
>  - the executable to run is identified by the combination of fd+pathname, like
>    other *at(2) syscalls
>  - there's an extra flags field to control behaviour.
> (I've attached a text version of the suggested man page below)
> 
> One particular benefit of this is that it allows an fexecve(3) implementation
> that doesn't rely on /proc being accessible, which is useful for sandboxed
> applications.  (However, that does only work for non-interpreted programs:
> the name passed to a script interpreter is of the form "/dev/fd/<fd>/<path>"
> or "/dev/fd/<fd>", so the executed interpreter will normally still need /proc
> access to load the script file).
> 
> How does this sound from a glibc perspective?

I've been following the discussions so far and everything looks mostly
okay. There are still issues to be resolved with the different
semantics between Linux O_PATH and what POSIX requires for O_EXEC (and
O_SEARCH) but as long as the intent is that, once O_EXEC is defined to
save the permissions at the time of open and cause them to be used in
place of the current file permissions at the time of execveat

One major issue however is FD_CLOEXEC with scripts. Last I checked,
this didn't work because the file is already closed by the time the
interpreted runs. The intended usage of fexecve is almost certainly to
call it with the file descriptor set close-on-exec; otherwise, there
would be no clean way to close it, since the program being executed
doesn't know that it's being executed via fexecve. So this is a
serious problem that needs to be solved if it hasn't already. I have
some ideas I could offer, but I'm not an expert on the kernel side
things so I'm not sure they'd be correct.

Rich

> Thanks,
> David
> 
> [1] https://lkml.org/lkml/2014/11/7/512, with earlier discussions at
> https://lkml.org/lkml/2014/11/6/469, https://lkml.org/lkml/2014/10/22/275
> and https://lkml.org/lkml/2014/10/17/428
> 
> ----
> 
> EXECVEAT(2)              Linux Programmer's Manual             EXECVEAT(2)
> 
> NAME
>        execveat - execute program relative to a directory file descriptor
> 
> SYNOPSIS
>        #include <unistd.h>
> 
>        int execveat(int fd, const char *pathname,
>                     char *const argv[],  char *const envp[],
>                     int flags);
> 
> DESCRIPTION
>        The  execveat()  system call executes the program pointed to by the
>        combination of fd and pathname.  The execveat() system  call  oper‐
>        ates  in  exactly the same way as execve(2), except for the differ‐
>        ences described in this manual page.
> 
>        If the pathname given in pathname is relative, then  it  is  inter‐
>        preted relative to the directory referred to by the file descriptor
>        fd (rather than relative to the current working  directory  of  the
>        calling process, as is done by execve(2) for a relative pathname).
> 
>        If  pathname is relative and fd is the special value AT_FDCWD, then
>        pathname is interpreted relative to the current  working  directory
>        of the calling process (like execve(2)).
> 
>        If pathname is absolute, then fd is ignored.
> 
>        If pathname is an empty string and the AT_EMPTY_PATH flag is speci‐
>        fied, then the file descriptor fd specifies the  file  to  be  exe‐
>        cuted.
> 
>        flags can either be 0, or include the following flags:
> 
>        AT_EMPTY_PATH
>               If pathname is an empty string, operate on the file referred
>               to by fd (which may have been  obtained  using  the  open(2)
>               O_PATH flag).
> 
>        AT_SYMLINK_NOFOLLOW
>               If  the  file  identified by fd and a non-NULL pathname is a
>               symbolic link, then the call fails with the error EINVAL.
> 
> RETURN VALUE
>        On success, execveat() does not return. On error  -1  is  returned,
>        and errno is set appropriately.
> 
> ERRORS
>        The  same  errors  that  occur  for  execve(2)  can  also occur for
>        execveat().   The  following  additional  errors  can   occur   for
>        execveat():
> 
>        EBADF  fd is not a valid file descriptor.
> 
>        ENOENT The  program  identified by fd and pathname requires the use
>               of an interpreter program (such as a  script  starting  with
>               "#!")  but  the  file  descriptor  fd  was  opened  with the
>               O_CLOEXEC flag and so the program file  is  inaccessible  to
>               the launched interpreter.
> 
>        EINVAL Invalid flag specified in flags.
> 
>        ENOTDIR
>               pathname  is  relative and fd is a file descriptor referring
>               to a file other than a directory.
> 
> VERSIONS
>        execveat() was added to Linux in kernel 3.???.
> 
> NOTES
>        In addition to the reasons explained in openat(2),  the  execveat()
>        system call is also needed to allow fexecve(3) to be implemented on
>        systems that do not have the /proc filesystem mounted.
> 
> SEE ALSO
>        execve(2), fexecve(3)
> 
> Linux                           2014-04-02                     EXECVEAT(2)
