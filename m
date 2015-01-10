From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for execveat(2)
Date: Sat, 10 Jan 2015 08:13:55 +0100
Message-ID: <54B0D133.4020101@gmail.com>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>	<1416830039-21952-6-git-send-email-drysdale@google.com>	<54AFF813.7050604@gmail.com>	<20150109161302.GQ4574@brightrain.aerifal.cx>	<CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>	<20150109204815.GR4574@brightrain.aerifal.cx>	<20150109205626.GK22149@ZenIV.linux.org.uk>	<20150109205926.GT4574@brightrain.aerifal.cx>	<20150109210941.GL22149@ZenIV.linux.org.uk>	<20150109212852.GU4574@brightrain.aerifal.cx> <87lhlbvbzs.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <87lhlbvbzs.fsf@x220.int.ebiederm.org>
Sender: linux-arch-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Rich Felker <dalias@aerifal.cx>
Cc: mtk.manpages@gmail.com, Al Viro <viro@ZenIV.linux.org.uk>, David Drysdale <drysdale@google.com>, Andy Lutomirski <luto@amacapital.net>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/09/2015 11:13 PM, Eric W. Biederman wrote:
> Rich Felker <dalias@aerifal.cx> writes:
>=20
>> On Fri, Jan 09, 2015 at 09:09:41PM +0000, Al Viro wrote:
>=20
>> The "magic open-once magic symlink" approach is really the cleanest
>> solution I can find. In the case where the interpreter does not open
>> the script, nothing terribly bad happens; the magic symlink just
>> sticks around until _exit or exec. In the case where the interpreter
>> opens it more than once, you get a failure, but as far as I know
>> existing interpreters don't do this, and it's arguably bad design. I=
n
>> any case it's a caught error.
>=20
> And it doesn't work without introducing security vulnerabilities into
> the kernel, because it breaks close-on-exec semantics.
>=20
> All you have to do is pick a file descriptor, good canidates are 0 an=
d
> 255 and make it a convention that that file descriptor is used for
> fexecve.  At least when you want to support scripts.  Otherwise you c=
an
> set close-on-exec.
>=20
> That results in no accumulation of file descriptors  because everyone
> always uses the same file descriptor.
>=20
> Regardless you don't have a patch and you aren't proposing code and t=
he
> code isn't actually broken so please go away.

Eric,

This style of response isn't helpful. Suggesting that people must have
a patch in hand in order to have a conversation about kernel developmen=
t
means a lot of clever people are going to be excluded from important
conversations. Those clever people are some user-space developers
who develop the software that the kernel interacts with--you know, the
user-space that is the kernel's raison-d'=EAtre.

Rich, as far as I've seen, is one of those clever people--he implemente=
d
and maintains a (pretty much complete?) standard C library, so when he
comes to a conversation like this, I think it's best to start with
the assumption that he's thought long and hard about the problem, and=20
seemingly hostile responses as you (and Al) make above don't do much=20
to advance the conversation to a solution.

And there is a problem [*] and nothing I've seen so far in this
conversation seems to provide a solution within the current=20
kernel implementation (but, maybe I am not clever enough to see it).

=3D=3D

[*] A summary of the problem for bystanders:

[0.a] Some people want a solution to implementing fexecve()=20
      (http://man7.org/linux/man-pages/man3/fexecve.3.html )
      in the absence of /proc (which is currently used for=20
      the implementation). The new execveat() is a stepping
      stone to that solution.

[0.b] POSIX permits, but does not require, the FD_CLOEXEC
      (close-on-exec) file descriptor flag to be set on the
      file descriptor passed to fexecve().

[1]   The sequence:
          * Open a script file, to get a descriptor, 'fd'
          * Set the close-on-exec flag on 'fd'
	  * execveat(fd, NULL, argv, envp, AT_EMPTY_PATH)

      fails in the execveat() because by the time the script=20
      interpreter has been loaded, 'fd' has been closed because
      of the close-on-exec flag.

[2]   Omitting the use of close-on-exec on the FD given to
      fexecve()/execveat() means that the execed script
      receives a superfluous file descriptor that refers to the
      script file. The script cannot determine that there is such=20
      an FD or which FD it is without some some messy special-case
      hacking to inspect its environment (and that hacking must be
      based on /proc, AFAICT!)

[3]   Scripts won't do the check in [2], with the result that
      that there'll be descriptor leaks in some cases where
      fexecve()/execveat() is used repeatedly.

[4]   (As Rich points out in a reply to the parent message, the
      solution suggested above of using a fixed file descriptor=20
      for fexecve() does not solve the problem either.)

=46or an example of the leak, consider the following simple program=20
and script. The program is just a simple command-line interface to=20
exercise execveat():

=3D=3D=3D=3D=3D
/* t_execveat.c
*/
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>

#define __NR_execveat 322 /* x86-64 */

static int execveat(int dirfd, const char *pathname, char *const argv[]=
,
                    char *const envp[], int flags)
{
            return syscall(__NR_execveat, dirfd, pathname, argv, envp, =
flags);
}

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

extern char **environ;

int
main(int argc, char *argv[])
{
    int flags, dirfd;
    char *path;

    flags =3D 0;

    if (argc < 4) {
        fprintf(stderr, "%s dirfd-path path argv0 [argvN...]\n", argv[0=
]);
        fprintf(stderr, "\tSpecify 'dirfd' as '-' to get AT_FDCWD\n");
        fprintf(stderr, "\tSpecify 'path' as an empty string to get "
                "AT_EMPTY_PATH\n");
        exit(EXIT_FAILURE);
    }

    if (argv[1][0] =3D=3D '-')
        dirfd =3D AT_FDCWD;
    else {
        dirfd =3D open(argv[1], O_RDONLY);
        if (dirfd =3D=3D -1)
            errExit("open");
    }

    path =3D argv[2];
    if (strlen(path) =3D=3D 0)
        flags =3D AT_EMPTY_PATH;

    execveat(dirfd, path, &argv[3], environ, flags);
    errExit("execveat");

    exit(EXIT_SUCCESS);
}
=3D=3D=3D=3D=3D

And then a simple script (necho.sh) that recursively invokes itself usi=
ng
the above program demonstrates the problem.

=3D=3D=3D=3D=3D
#!/bin/sh
echo=20
echo '$0 =3D' $0
ls -l /proc/$$/fd
=2E/t_execveat ./necho.sh "" arg1 # $arg
=3D=3D=3D=3D=3D

When we run this script, we see:

=3D=3D=3D=3D=3D

# chmod +x necho.sh
# ./t_execveat ./necho.sh "" arg1

$0 =3D /dev/fd/3
total 0
lrwx------. 1 root root 64 Jan 10 07:59 0 -> /dev/pts/0
lrwx------. 1 root root 64 Jan 10 07:59 1 -> /dev/pts/0
lr-x------. 1 root root 64 Jan 10 07:59 199 -> /home/mtk/necho.sh
lrwx------. 1 root root 64 Jan 10 07:59 2 -> /dev/pts/0
lr-x------. 1 root root 64 Jan 10 07:59 3 -> /home/mtk/necho.sh

$0 =3D /dev/fd/4
total 0
lrwx------. 1 root root 64 Jan 10 07:59 0 -> /dev/pts/0
lrwx------. 1 root root 64 Jan 10 07:59 1 -> /dev/pts/0
lr-x------. 1 root root 64 Jan 10 07:59 199 -> /home/mtk/necho.sh
lrwx------. 1 root root 64 Jan 10 07:59 2 -> /dev/pts/0
lr-x------. 1 root root 64 Jan 10 07:59 3 -> /home/mtk/necho.sh
lr-x------. 1 root root 64 Jan 10 07:59 4 -> /home/mtk/necho.sh

$0 =3D /dev/fd/5
total 0
lrwx------. 1 root root 64 Jan 10 07:59 0 -> /dev/pts/0
lrwx------. 1 root root 64 Jan 10 07:59 1 -> /dev/pts/0
lr-x------. 1 root root 64 Jan 10 07:59 199 -> /home/mtk/necho.sh
lrwx------. 1 root root 64 Jan 10 07:59 2 -> /dev/pts/0
lr-x------. 1 root root 64 Jan 10 07:59 3 -> /home/mtk/necho.sh
lr-x------. 1 root root 64 Jan 10 07:59 4 -> /home/mtk/necho.sh
lr-x------. 1 root root 64 Jan 10 07:59 5 -> /home/mtk/necho.sh

$0 =3D /dev/fd/6
total 0
lrwx------. 1 root root 64 Jan 10 07:59 0 -> /dev/pts/0
lrwx------. 1 root root 64 Jan 10 07:59 1 -> /dev/pts/0
lr-x------. 1 root root 64 Jan 10 07:59 199 -> /home/mtk/necho.sh
lrwx------. 1 root root 64 Jan 10 07:59 2 -> /dev/pts/0
lr-x------. 1 root root 64 Jan 10 07:59 3 -> /home/mtk/necho.sh
lr-x------. 1 root root 64 Jan 10 07:59 4 -> /home/mtk/necho.sh
lr-x------. 1 root root 64 Jan 10 07:59 5 -> /home/mtk/necho.sh
lr-x------. 1 root root 64 Jan 10 07:59 6 -> /home/mtk/necho.sh

$0 =3D /dev/fd/7
total 0
lrwx------. 1 root root 64 Jan 10 07:59 0 -> /dev/pts/0
lrwx------. 1 root root 64 Jan 10 07:59 1 -> /dev/pts/0
lr-x------. 1 root root 64 Jan 10 07:59 199 -> /home/mtk/necho.sh
lrwx------. 1 root root 64 Jan 10 07:59 2 -> /dev/pts/0
lr-x------. 1 root root 64 Jan 10 07:59 3 -> /home/mtk/necho.sh
lr-x------. 1 root root 64 Jan 10 07:59 4 -> /home/mtk/necho.sh
lr-x------. 1 root root 64 Jan 10 07:59 5 -> /home/mtk/necho.sh
lr-x------. 1 root root 64 Jan 10 07:59 6 -> /home/mtk/necho.sh
lr-x------. 1 root root 64 Jan 10 07:59 7 -> /home/mtk/necho.sh


[and so on until we run out of file descriptors]
=3D=3D=3D=3D=3D

(I think the FD 199 in the above output is some bash(1) artifact, unrel=
ated=20
to the  conversation at hand.)

Thanks,

Michael

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
