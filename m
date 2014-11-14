From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC] Possible new execveat(2) Linux syscall
Date: Fri, 14 Nov 2014 14:54:19 +0000
Message-ID: <CAHse=S8ccC2No5EYS0Pex=Ng3oXjfDB9woOBmMY_k+EgxtODZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

Over at the LKML[1] we've been discussing a possible new syscall, execv=
eat(2),
and it would be good to hear a glibc perspective about it (and whether =
there
are any interface changes that would make it easier to use from userspa=
ce).

The syscall prototype is:
  int execveat(int fd, const char *pathname,
                      char *const argv[],  char *const envp[],
                      int flags); /* AT_EMPTY_PATH, AT_SYMLINK_NOFOLLOW=
 */
and it works similarly to execve(2) except:
 - the executable to run is identified by the combination of fd+pathnam=
e, like
   other *at(2) syscalls
 - there's an extra flags field to control behaviour.
(I've attached a text version of the suggested man page below)

One particular benefit of this is that it allows an fexecve(3) implemen=
tation
that doesn't rely on /proc being accessible, which is useful for sandbo=
xed
applications.  (However, that does only work for non-interpreted progra=
ms:
the name passed to a script interpreter is of the form "/dev/fd/<fd>/<p=
ath>"
or "/dev/fd/<fd>", so the executed interpreter will normally still need=
 /proc
access to load the script file).

How does this sound from a glibc perspective?

Thanks,
David

[1] https://lkml.org/lkml/2014/11/7/512, with earlier discussions at
https://lkml.org/lkml/2014/11/6/469, https://lkml.org/lkml/2014/10/22/2=
75
and https://lkml.org/lkml/2014/10/17/428

----

EXECVEAT(2)              Linux Programmer's Manual             EXECVEAT=
(2)

NAME
       execveat - execute program relative to a directory file descript=
or

SYNOPSIS
       #include <unistd.h>

       int execveat(int fd, const char *pathname,
                    char *const argv[],  char *const envp[],
                    int flags);

DESCRIPTION
       The  execveat()  system call executes the program pointed to by =
the
       combination of fd and pathname.  The execveat() system  call  op=
er=E2=80=90
       ates  in  exactly the same way as execve(2), except for the diff=
er=E2=80=90
       ences described in this manual page.

       If the pathname given in pathname is relative, then  it  is  int=
er=E2=80=90
       preted relative to the directory referred to by the file descrip=
tor
       fd (rather than relative to the current working  directory  of  =
the
       calling process, as is done by execve(2) for a relative pathname=
).

       If  pathname is relative and fd is the special value AT_FDCWD, t=
hen
       pathname is interpreted relative to the current  working  direct=
ory
       of the calling process (like execve(2)).

       If pathname is absolute, then fd is ignored.

       If pathname is an empty string and the AT_EMPTY_PATH flag is spe=
ci=E2=80=90
       fied, then the file descriptor fd specifies the  file  to  be  e=
xe=E2=80=90
       cuted.

       flags can either be 0, or include the following flags:

       AT_EMPTY_PATH
              If pathname is an empty string, operate on the file refer=
red
              to by fd (which may have been  obtained  using  the  open=
(2)
              O_PATH flag).

       AT_SYMLINK_NOFOLLOW
              If  the  file  identified by fd and a non-NULL pathname i=
s a
              symbolic link, then the call fails with the error EINVAL.

RETURN VALUE
       On success, execveat() does not return. On error  -1  is  return=
ed,
       and errno is set appropriately.

ERRORS
       The  same  errors  that  occur  for  execve(2)  can  also occur =
for
       execveat().   The  following  additional  errors  can   occur   =
for
       execveat():

       EBADF  fd is not a valid file descriptor.

       ENOENT The  program  identified by fd and pathname requires the =
use
              of an interpreter program (such as a  script  starting  w=
ith
              "#!")  but  the  file  descriptor  fd  was  opened  with =
the
              O_CLOEXEC flag and so the program file  is  inaccessible =
 to
              the launched interpreter.

       EINVAL Invalid flag specified in flags.

       ENOTDIR
              pathname  is  relative and fd is a file descriptor referr=
ing
              to a file other than a directory.

VERSIONS
       execveat() was added to Linux in kernel 3.???.

NOTES
       In addition to the reasons explained in openat(2),  the  execvea=
t()
       system call is also needed to allow fexecve(3) to be implemented=
 on
       systems that do not have the /proc filesystem mounted.

SEE ALSO
       execve(2), fexecve(3)

Linux                           2014-04-02                     EXECVEAT=
(2)
