From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC] Possible new execveat(2) Linux syscall
Date: Sun, 16 Nov 2014 13:20:39 -0800
Message-ID: <CALCETrWWUyizL8HxZKaYE+xuV5eGi8mQcequT9HPvvac=X-dLg@mail.gmail.com>
References: <CAHse=S8ccC2No5EYS0Pex=Ng3oXjfDB9woOBmMY_k+EgxtODZA@mail.gmail.com>
 <20141116195246.GX22465@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141116195246.GX22465-C3MtFaGISjmo6RMmaWD+6Sb1p8zYI1N1@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Cc: libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, musl-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Nov 16, 2014 11:53 AM, "Rich Felker" <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org> wrote:
>
> On Fri, Nov 14, 2014 at 02:54:19PM +0000, David Drysdale wrote:
> > Hi,
> >
> > Over at the LKML[1] we've been discussing a possible new syscall, e=
xecveat(2),
> > and it would be good to hear a glibc perspective about it (and whet=
her there
> > are any interface changes that would make it easier to use from use=
rspace).
> >
> > The syscall prototype is:
> >   int execveat(int fd, const char *pathname,
> >                       char *const argv[],  char *const envp[],
> >                       int flags); /* AT_EMPTY_PATH, AT_SYMLINK_NOFO=
LLOW */
> > and it works similarly to execve(2) except:
> >  - the executable to run is identified by the combination of fd+pat=
hname, like
> >    other *at(2) syscalls
> >  - there's an extra flags field to control behaviour.
> > (I've attached a text version of the suggested man page below)
> >
> > One particular benefit of this is that it allows an fexecve(3) impl=
ementation
> > that doesn't rely on /proc being accessible, which is useful for sa=
ndboxed
> > applications.  (However, that does only work for non-interpreted pr=
ograms:
> > the name passed to a script interpreter is of the form "/dev/fd/<fd=
>/<path>"
> > or "/dev/fd/<fd>", so the executed interpreter will normally still =
need /proc
> > access to load the script file).
> >
> > How does this sound from a glibc perspective?
>
> I've been following the discussions so far and everything looks mostl=
y
> okay. There are still issues to be resolved with the different
> semantics between Linux O_PATH and what POSIX requires for O_EXEC (an=
d
> O_SEARCH) but as long as the intent is that, once O_EXEC is defined t=
o
> save the permissions at the time of open and cause them to be used in
> place of the current file permissions at the time of execveat

Is something missing here?

=46WIW, I don't understand O_PATH or O_EXEC very well, so from my POV,
help would be appreciated.

>
> One major issue however is FD_CLOEXEC with scripts. Last I checked,
> this didn't work because the file is already closed by the time the
> interpreted runs. The intended usage of fexecve is almost certainly t=
o
> call it with the file descriptor set close-on-exec; otherwise, there
> would be no clean way to close it, since the program being executed
> doesn't know that it's being executed via fexecve. So this is a
> serious problem that needs to be solved if it hasn't already. I have
> some ideas I could offer, but I'm not an expert on the kernel side
> things so I'm not sure they'd be correct.

Bring on the ideas.

=46WIW, I've often thought that interpreter binaries should mark
themselves as such to enable better interactions with the kernel.

--Andy

>
> Rich
>
> > Thanks,
> > David
> >
> > [1] https://lkml.org/lkml/2014/11/7/512, with earlier discussions a=
t
> > https://lkml.org/lkml/2014/11/6/469, https://lkml.org/lkml/2014/10/=
22/275
> > and https://lkml.org/lkml/2014/10/17/428
> >
> > ----
> >
> > EXECVEAT(2)              Linux Programmer's Manual             EXEC=
VEAT(2)
> >
> > NAME
> >        execveat - execute program relative to a directory file desc=
riptor
> >
> > SYNOPSIS
> >        #include <unistd.h>
> >
> >        int execveat(int fd, const char *pathname,
> >                     char *const argv[],  char *const envp[],
> >                     int flags);
> >
> > DESCRIPTION
> >        The  execveat()  system call executes the program pointed to=
 by the
> >        combination of fd and pathname.  The execveat() system  call=
  oper=E2=80=90
> >        ates  in  exactly the same way as execve(2), except for the =
differ=E2=80=90
> >        ences described in this manual page.
> >
> >        If the pathname given in pathname is relative, then  it  is =
 inter=E2=80=90
> >        preted relative to the directory referred to by the file des=
criptor
> >        fd (rather than relative to the current working  directory  =
of  the
> >        calling process, as is done by execve(2) for a relative path=
name).
> >
> >        If  pathname is relative and fd is the special value AT_FDCW=
D, then
> >        pathname is interpreted relative to the current  working  di=
rectory
> >        of the calling process (like execve(2)).
> >
> >        If pathname is absolute, then fd is ignored.
> >
> >        If pathname is an empty string and the AT_EMPTY_PATH flag is=
 speci=E2=80=90
> >        fied, then the file descriptor fd specifies the  file  to  b=
e  exe=E2=80=90
> >        cuted.
> >
> >        flags can either be 0, or include the following flags:
> >
> >        AT_EMPTY_PATH
> >               If pathname is an empty string, operate on the file r=
eferred
> >               to by fd (which may have been  obtained  using  the  =
open(2)
> >               O_PATH flag).
> >
> >        AT_SYMLINK_NOFOLLOW
> >               If  the  file  identified by fd and a non-NULL pathna=
me is a
> >               symbolic link, then the call fails with the error EIN=
VAL.
> >
> > RETURN VALUE
> >        On success, execveat() does not return. On error  -1  is  re=
turned,
> >        and errno is set appropriately.
> >
> > ERRORS
> >        The  same  errors  that  occur  for  execve(2)  can  also oc=
cur for
> >        execveat().   The  following  additional  errors  can   occu=
r   for
> >        execveat():
> >
> >        EBADF  fd is not a valid file descriptor.
> >
> >        ENOENT The  program  identified by fd and pathname requires =
the use
> >               of an interpreter program (such as a  script  startin=
g  with
> >               "#!")  but  the  file  descriptor  fd  was  opened  w=
ith the
> >               O_CLOEXEC flag and so the program file  is  inaccessi=
ble  to
> >               the launched interpreter.
> >
> >        EINVAL Invalid flag specified in flags.
> >
> >        ENOTDIR
> >               pathname  is  relative and fd is a file descriptor re=
ferring
> >               to a file other than a directory.
> >
> > VERSIONS
> >        execveat() was added to Linux in kernel 3.???.
> >
> > NOTES
> >        In addition to the reasons explained in openat(2),  the  exe=
cveat()
> >        system call is also needed to allow fexecve(3) to be impleme=
nted on
> >        systems that do not have the /proc filesystem mounted.
> >
> > SEE ALSO
> >        execve(2), fexecve(3)
> >
> > Linux                           2014-04-02                     EXEC=
VEAT(2)
