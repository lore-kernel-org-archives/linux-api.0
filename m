From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH v2 0/5] Add support for O_MAYEXEC
Date: Fri, 06 Sep 2019 14:50:02 -0400
Message-ID: <2989749.1YmIBkDdQn@x2>
References: <20190906152455.22757-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190906152455.22757-1-mic@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@s>
List-Id: linux-api@vger.kernel.org

On Friday, September 6, 2019 11:24:50 AM EDT Mickaël Salaün wrote:
> The goal of this patch series is to control script interpretation.  A
> new O_MAYEXEC flag used by sys_open() is added to enable userspace
> script interpreter to delegate to the kernel (and thus the system
> security policy) the permission to interpret/execute scripts or other
> files containing what can be seen as commands.

The problem is that this is only a gentleman's handshake. If I don't tell the
kernel that what I'm opening is tantamount to executing it, then the security
feature is never invoked. It is simple to strip the flags off of any system
call without needing privileges. For example:

#define _GNU_SOURCE
#include <link.h>
#include <fcntl.h>
#include <string.h>

unsigned int
la_version(unsigned int version)
{
    return version;
}

unsigned int
la_objopen(struct link_map *map, Lmid_t lmid, uintptr_t *cookie)
{
    return LA_FLG_BINDTO | LA_FLG_BINDFROM;
}

typedef int (*openat_t) (int dirfd, const char *pathname, int flags, mode_t mode);
static openat_t real_openat = 0L;
int my_openat(int dirfd, const char *pathname, int flags, mode_t mode)
{
        flags &= ~O_CLOEXEC;
        return real_openat(dirfd, pathname, flags, mode);
}

uintptr_t
la_symbind64(Elf64_Sym *sym, unsigned int ndx, uintptr_t *refcook,
        uintptr_t *defcook, unsigned int *flags, const char *symname)
{
    if (real_openat == 0L && strcmp(symname, "openat") == 0) {
        real_openat = (openat_t) sym->st_value;
        return (uintptr_t) my_openat;
    }
    return sym->st_value;
}

gcc -c -g -Wno-unused-parameter -W -Wall -Wundef -O2 -Wp,-D_GLIBCXX_ASSERTIONS -fexceptions -fPIC  test.c
gcc -o strip-flags.so.0 -shared -Wl,-soname,strip-flags.so.0 -ldl test.o

Now, let's make a test program:

#include <stdio.h>
#include <dirent.h>
#include <fcntl.h>
#include <unistd.h>

int main(void)
{
        int dir_fd, fd;
        DIR *d = opendir("/etc");
        dir_fd = dirfd(d);
        fd = openat(dir_fd, "passwd", O_RDONLY|O_CLOEXEC);
        close (fd);
        closedir(d);
        return 0;
}

gcc -g -W -Wall -Wundef test.c -o test

OK, let's see what happens.
$ strace ./test 2>&1 | grep passwd
openat(3, "passwd", O_RDONLY|O_CLOEXEC) = 4

Now with LD_AUDIT
$ LD_AUDIT=/home/sgrubb/test/openflags/strip-flags.so.0 strace ./test 2>&1 | grep passwd
openat(3, "passwd", O_RDONLY)           = 4

No O_CLOEXEC flag.

-Steve
