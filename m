From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 1/2] open: add close_range()
Date: Fri, 24 May 2019 12:31:39 +0200
Message-ID: <20190524103137.otw7tbmagiqnf6u6@brauner.io>
References: <20190522155259.11174-1-christian@brauner.io>
 <67e4458a-9cc4-d1aa-608c-73ebe9e2f7a3@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <67e4458a-9cc4-d1aa-608c-73ebe9e2f7a3@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, torvalds@linux-foundation.org, fweimer@redhat.com, jannh@google.com, oleg@redhat.com, tglx@linutronix.de, arnd@arndb.de, shuah@kernel.org, dhowells@redhat.com, tkjos@android.com, ldv@altlinux.org, miklos@szeredi.hu, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-arch@vger.kernel.org, linux-kselftest@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, May 23, 2019 at 07:22:17PM +0300, Konstantin Khlebnikov wrote:
> On 22.05.2019 18:52, Christian Brauner wrote:> This adds the close_range() syscall. It allows to efficiently close a range
> > of file descriptors up to all file descriptors of a calling task.
> >
> > The syscall came up in a recent discussion around the new mount API and
> > making new file descriptor types cloexec by default. During this
> > discussion, Al suggested the close_range() syscall (cf. [1]). Note, a
> > syscall in this manner has been requested by various people over time.
> >
> > First, it helps to close all file descriptors of an exec()ing task. This
> > can be done safely via (quoting Al's example from [1] verbatim):
> >
> >          /* that exec is sensitive */
> >          unshare(CLONE_FILES);
> >          /* we don't want anything past stderr here */
> >          close_range(3, ~0U);
> >          execve(....);
> >
> > The code snippet above is one way of working around the problem that file
> > descriptors are not cloexec by default. This is aggravated by the fact that
> > we can't just switch them over without massively regressing userspace. For
> > a whole class of programs having an in-kernel method of closing all file
> > descriptors is very helpful (e.g. demons, service managers, programming
> > language standard libraries, container managers etc.).
> > (Please note, unshare(CLONE_FILES) should only be needed if the calling
> >   task is multi-threaded and shares the file descriptor table with another
> >   thread in which case two threads could race with one thread allocating
> >   file descriptors and the other one closing them via close_range(). For the
> >   general case close_range() before the execve() is sufficient.)
> >
> > Second, it allows userspace to avoid implementing closing all file
> > descriptors by parsing through /proc/<pid>/fd/* and calling close() on each
> > file descriptor. From looking at various large(ish) userspace code bases
> > this or similar patterns are very common in:
> > - service managers (cf. [4])
> > - libcs (cf. [6])
> > - container runtimes (cf. [5])
> > - programming language runtimes/standard libraries
> >    - Python (cf. [2])
> >    - Rust (cf. [7], [8])
> > As Dmitry pointed out there's even a long-standing glibc bug about missing
> > kernel support for this task (cf. [3]).
> > In addition, the syscall will also work for tasks that do not have procfs
> > mounted and on kernels that do not have procfs support compiled in. In such
> > situations the only way to make sure that all file descriptors are closed
> > is to call close() on each file descriptor up to UINT_MAX or RLIMIT_NOFILE,
> > OPEN_MAX trickery (cf. comment [8] on Rust).
> >
> > The performance is striking. For good measure, comparing the following
> > simple close_all_fds() userspace implementation that is essentially just
> > glibc's version in [6]:
> >
> > static int close_all_fds(void)
> > {
> >          int dir_fd;
> >          DIR *dir;
> >          struct dirent *direntp;
> >
> >          dir = opendir("/proc/self/fd");
> >          if (!dir)
> >                  return -1;
> >          dir_fd = dirfd(dir);
> >          while ((direntp = readdir(dir))) {
> >                  int fd;
> >                  if (strcmp(direntp->d_name, ".") == 0)
> >                          continue;
> >                  if (strcmp(direntp->d_name, "..") == 0)
> >                          continue;
> >                  fd = atoi(direntp->d_name);
> >                  if (fd == dir_fd || fd == 0 || fd == 1 || fd == 2)
> >                          continue;
> >                  close(fd);
> >          }
> >          closedir(dir);
> >          return 0;
> > }
> >
> > to close_range() yields:
> > 1. closing 4 open files:
> >     - close_all_fds(): ~280 us
> >     - close_range():    ~24 us
> >
> > 2. closing 1000 open files:
> >     - close_all_fds(): ~5000 us
> >     - close_range():   ~800 us
> >
> > close_range() is designed to allow for some flexibility. Specifically, it
> > does not simply always close all open file descriptors of a task. Instead,
> > callers can specify an upper bound.
> > This is e.g. useful for scenarios where specific file descriptors are
> > created with well-known numbers that are supposed to be excluded from
> > getting closed.
> > For extra paranoia close_range() comes with a flags argument. This can e.g.
> > be used to implement extension. Once can imagine userspace wanting to stop
> > at the first error instead of ignoring errors under certain circumstances.
> 
> > There might be other valid ideas in the future. In any case, a flag
> > argument doesn't hurt and keeps us on the safe side.
> 
> Here is another strange but real-live scenario: crash handler for dumping core.
> 
> If applications has network connections it would be better to close them all,
> otherwise clients will wait until end of dumping process or timeout.
> Also closing normal files might be a good idea for releasing locks.
> 
> But simple closing might race with other threads - closed fd will be reused
> while some code still thinks it refers to original file.
> 
> Our solution closes files without freeing fd: it opens /dev/null and
> replaces all opened descriptors using dup2.
> 
> So, special flag for close_range() could close files without clearing bitmap.
> Effect should be the same - fd wouldn't be reused.
> 
> Actually two flags for two phases: closing files and releasing fd.

Konstantin, I'm sorry, I totally missed that part of your mail
yesterday.
Without speaking to the feasibility of this it's at least a good
illustration that people really do have the possible need for a flag
argument.

Thanks!
Christian
