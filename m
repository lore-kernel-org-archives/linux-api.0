From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCHv6 2/3] syscalls,x86: add selftest for execveat(2)
Date: Thu, 6 Nov 2014 10:07:47 -0800
Message-ID: <CAGXu5jLTKo1t5feUcPJgBy3UaMZUpgJRNuUaV8aQ0H4ze7gU6A@mail.gmail.com>
References: <1415290033-15771-1-git-send-email-drysdale@google.com>
	<1415290033-15771-3-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1415290033-15771-3-git-send-email-drysdale@google.com>
Sender: linux-arch-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>, "x86@kernel.org" <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 6, 2014 at 8:07 AM, David Drysdale <drysdale@google.com> wrote:
> Signed-off-by: David Drysdale <drysdale@google.com>
> ---
>  tools/testing/selftests/Makefile        |   1 +
>  tools/testing/selftests/exec/.gitignore |   7 +
>  tools/testing/selftests/exec/Makefile   |  25 +++
>  tools/testing/selftests/exec/execveat.c | 321 ++++++++++++++++++++++++++++++++
>  4 files changed, 354 insertions(+)
>  create mode 100644 tools/testing/selftests/exec/.gitignore
>  create mode 100644 tools/testing/selftests/exec/Makefile
>  create mode 100644 tools/testing/selftests/exec/execveat.c
>
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 36ff2e4c7b6f..210cf68b3511 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -14,6 +14,7 @@ TARGETS += powerpc
>  TARGETS += user
>  TARGETS += sysctl
>  TARGETS += firmware
> +TARGETS += exec
>
>  TARGETS_HOTPLUG = cpu-hotplug
>  TARGETS_HOTPLUG += memory-hotplug
> diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
> new file mode 100644
> index 000000000000..778147d01af9
> --- /dev/null
> +++ b/tools/testing/selftests/exec/.gitignore
> @@ -0,0 +1,7 @@
> +subdir*
> +script*
> +execveat
> +execveat.symlink
> +execveat.moved
> +execveat.ephemeral
> +execveat.denatured
> \ No newline at end of file
> diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
> new file mode 100644
> index 000000000000..c97e0aaea02d
> --- /dev/null
> +++ b/tools/testing/selftests/exec/Makefile
> @@ -0,0 +1,25 @@
> +CC = $(CROSS_COMPILE)gcc
> +CFLAGS = -Wall
> +BINARIES = execveat
> +DEPS = execveat.symlink execveat.denatured script subdir
> +all: $(BINARIES) $(DEPS)
> +
> +subdir:
> +       mkdir -p $@
> +script:
> +       echo '#!/bin/sh' > $@
> +       echo 'exit $$*' >> $@
> +       chmod +x $@
> +execveat.symlink: execveat
> +       ln -s -f $< $@
> +execveat.denatured: execveat
> +       cp $< $@
> +       chmod -x $@
> +%: %.c
> +       $(CC) $(CFLAGS) -o $@ $^
> +
> +run_tests: all
> +       ./execveat
> +
> +clean:
> +       rm -rf $(BINARIES) $(DEPS) subdir.moved execveat.moved
> diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
> new file mode 100644
> index 000000000000..f6ea48176393
> --- /dev/null
> +++ b/tools/testing/selftests/exec/execveat.c
> @@ -0,0 +1,321 @@
> +/*
> + * Copyright (c) 2014 Google, Inc.
> + *
> + * Licensed under the terms of the GNU GPL License version 2
> + *
> + * Selftests for execveat(2).
> + */
> +
> +#define _GNU_SOURCE  /* to get O_PATH, AT_EMPTY_PATH */
> +#include <sys/sendfile.h>
> +#include <sys/stat.h>
> +#include <sys/syscall.h>
> +#include <sys/types.h>
> +#include <sys/wait.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <limits.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +
> +static char *envp[] = { "IN_TEST=yes", NULL, NULL };
> +static char *argv[] = { "execveat", "99", NULL };
> +
> +static int execveat_(int fd, const char *path, char **argv, char **envp,
> +                    int flags)
> +{
> +#ifdef __NR_execveat
> +       return syscall(__NR_execveat, fd, path, argv, envp, flags);
> +#else
> +       errno = -ENOSYS;
> +       return -1;
> +#endif
> +}
> +
> +#define check_execveat_fail(fd, path, flags, errno)    \
> +       _check_execveat_fail(fd, path, flags, errno, #errno)
> +static int _check_execveat_fail(int fd, const char *path, int flags,
> +                               int expected_errno, const char *errno_str)
> +{
> +       int rc;
> +
> +       errno = 0;
> +       printf("Check failure of execveat(%d, '%s', %d) with %s... ",
> +               fd, path?:"(null)", flags, errno_str);
> +       rc = execveat_(fd, path, argv, envp, flags);
> +
> +       if (rc > 0) {
> +               printf("[FAIL] (unexpected success from execveat(2))\n");
> +               return 1;
> +       }
> +       if (errno != expected_errno) {
> +               printf("[FAIL] (expected errno %d (%s) not %d (%s)\n",
> +                       expected_errno, strerror(expected_errno),
> +                       errno, strerror(errno));
> +               return 1;
> +       }
> +       printf("[OK]\n");
> +       return 0;
> +}
> +
> +static int check_execveat_invoked_rc(int fd, const char *path, int flags,
> +                                    int expected_rc)
> +{
> +       int status;
> +       int rc;
> +       pid_t child;
> +
> +       printf("Check success of execveat(%d, '%s', %d)... ",
> +               fd, path?:"(null)", flags);
> +       child = fork();
> +       if (child < 0) {
> +               printf("[FAIL] (fork() failed)\n");
> +               return 1;
> +       }
> +       if (child == 0) {
> +               /* Child: do execveat(). */
> +               rc = execveat_(fd, path, argv, envp, flags);
> +               printf("[FAIL]: execveat() failed, rc=%d errno=%d (%s)\n",
> +                       rc, errno, strerror(errno));
> +               exit(1);  /* should not reach here */
> +       }
> +       /* Parent: wait for & check child's exit status. */
> +       rc = waitpid(child, &status, 0);
> +       if (rc != child) {
> +               printf("[FAIL] (waitpid(%d,...) returned %d)\n", child, rc);
> +               return 1;
> +       }
> +       if (!WIFEXITED(status)) {
> +               printf("[FAIL] (child %d did not exit cleanly, status=%08x)\n",
> +                       child, status);
> +               return 1;
> +       }
> +       if (WEXITSTATUS(status) != expected_rc) {
> +               printf("[FAIL] (child %d exited with %d not %d)\n",
> +                       child, WEXITSTATUS(status), expected_rc);
> +               return 1;
> +       }
> +       printf("[OK]\n");
> +       return 0;
> +}
> +
> +static int check_execveat(int fd, const char *path, int flags)
> +{
> +       return check_execveat_invoked_rc(fd, path, flags, 99);
> +}
> +
> +static char *concat(const char *left, const char *right)
> +{
> +       char *result = malloc(strlen(left) + strlen(right) + 1);
> +
> +       strcpy(result, left);
> +       strcat(result, right);
> +       return result;
> +}
> +
> +static int open_or_die(const char *filename, int flags)
> +{
> +       int fd = open(filename, flags);
> +
> +       if (fd < 0) {
> +               printf("Failed to open '%s'; "
> +                       "check prerequisites are available\n", filename);
> +               exit(1);
> +       }
> +       return fd;
> +}
> +
> +static int run_tests(void)
> +{
> +       int fail = 0;
> +       char *fullname = realpath("execveat", NULL);
> +       char *fullname_script = realpath("script", NULL);
> +       char *fullname_symlink = concat(fullname, ".symlink");
> +       int subdir_dfd = open_or_die("subdir", O_DIRECTORY|O_RDONLY);
> +       int subdir_dfd_ephemeral = open_or_die("subdir.ephemeral",
> +                                              O_DIRECTORY|O_RDONLY);
> +       int dot_dfd = open_or_die(".", O_DIRECTORY|O_RDONLY);
> +       int dot_dfd_path = open_or_die(".", O_DIRECTORY|O_RDONLY|O_PATH);
> +       int dot_dfd_cloexec = open_or_die(".", O_DIRECTORY|O_RDONLY|O_CLOEXEC);
> +       int fd = open_or_die("execveat", O_RDONLY);
> +       int fd_path = open_or_die("execveat", O_RDONLY|O_PATH);
> +       int fd_symlink = open_or_die("execveat.symlink", O_RDONLY);
> +       int fd_denatured = open_or_die("execveat.denatured", O_RDONLY);
> +       int fd_script = open_or_die("script", O_RDONLY);
> +       int fd_ephemeral = open_or_die("execveat.ephemeral", O_RDONLY);
> +       int fd_script_ephemeral = open_or_die("script.ephemeral", O_RDONLY);
> +       int fd_cloexec = open_or_die("execveat", O_RDONLY|O_CLOEXEC);
> +       int fd_script_cloexec = open_or_die("script", O_RDONLY|O_CLOEXEC);
> +
> +       /* Change file position to confirm it doesn't affect anything */
> +       lseek(fd, 10, SEEK_SET);
> +
> +       /* Normal executable file: */
> +       /*   dfd + path */
> +       fail += check_execveat(subdir_dfd, "../execveat", 0);
> +       fail += check_execveat(dot_dfd, "execveat", 0);
> +       fail += check_execveat(dot_dfd_path, "execveat", 0);
> +       /*   absolute path */
> +       fail += check_execveat(AT_FDCWD, fullname, 0);
> +       /*   absolute path with nonsense dfd */
> +       fail += check_execveat(99, fullname, 0);
> +       /*   fd + no path */
> +       fail += check_execveat(fd, "", AT_EMPTY_PATH);
> +       /*   O_CLOEXEC fd + no path */
> +       fail += check_execveat(fd_cloexec, "", AT_EMPTY_PATH);
> +
> +       /* Mess with executable file that's already open: */
> +       /*   fd + no path to a file that's been renamed */
> +       rename("execveat.ephemeral", "execveat.moved");
> +       fail += check_execveat(fd_ephemeral, "", AT_EMPTY_PATH);
> +       /*   fd + no path to a file that's been deleted */
> +       unlink("execveat.moved"); /* remove the file now fd open */
> +       fail += check_execveat(fd_ephemeral, "", AT_EMPTY_PATH);
> +
> +       /* Invalid argument failures */
> +       fail += check_execveat_fail(fd, "", 0, ENOENT);
> +       fail += check_execveat_fail(fd, NULL, AT_EMPTY_PATH, EFAULT);
> +
> +       /* Symlink to executable file: */
> +       /*   dfd + path */
> +       fail += check_execveat(dot_dfd, "execveat.symlink", 0);
> +       fail += check_execveat(dot_dfd_path, "execveat.symlink", 0);
> +       /*   absolute path */
> +       fail += check_execveat(AT_FDCWD, fullname_symlink, 0);
> +       /*   fd + no path, even with AT_SYMLINK_NOFOLLOW (already followed) */
> +       fail += check_execveat(fd_symlink, "", AT_EMPTY_PATH);
> +       fail += check_execveat(fd_symlink, "",
> +                              AT_EMPTY_PATH|AT_SYMLINK_NOFOLLOW);
> +
> +       /* Symlink fails when AT_SYMLINK_NOFOLLOW set: */
> +       /*   dfd + path */
> +       fail += check_execveat_fail(dot_dfd, "execveat.symlink",
> +                                   AT_SYMLINK_NOFOLLOW, ELOOP);
> +       fail += check_execveat_fail(dot_dfd_path, "execveat.symlink",
> +                                   AT_SYMLINK_NOFOLLOW, ELOOP);
> +       /*   absolute path */
> +       fail += check_execveat_fail(AT_FDCWD, fullname_symlink,
> +                                   AT_SYMLINK_NOFOLLOW, ELOOP);
> +
> +       /* Shell script wrapping executable file: */
> +       /*   dfd + path */
> +       fail += check_execveat(subdir_dfd, "../script", 0);
> +       fail += check_execveat(dot_dfd, "script", 0);
> +       fail += check_execveat(dot_dfd_path, "script", 0);
> +       /*   absolute path */
> +       fail += check_execveat(AT_FDCWD, fullname_script, 0);
> +       /*   fd + no path */
> +       fail += check_execveat(fd_script, "", AT_EMPTY_PATH);
> +       fail += check_execveat(fd_script, "",
> +                              AT_EMPTY_PATH|AT_SYMLINK_NOFOLLOW);
> +       /*   O_CLOEXEC fd fails for a script (as script file inaccessible) */
> +       fail += check_execveat_fail(fd_script_cloexec, "", AT_EMPTY_PATH,
> +                                   ENOENT);
> +       fail += check_execveat_fail(dot_dfd_cloexec, "script", 0, ENOENT);
> +
> +       /* Mess with script file that's already open: */
> +       /*   fd + no path to a file that's been renamed */
> +       rename("script.ephemeral", "script.moved");
> +       fail += check_execveat(fd_script_ephemeral, "", AT_EMPTY_PATH);
> +       /*   fd + no path to a file that's been deleted */
> +       unlink("script.moved"); /* remove the file while fd open */
> +       fail += check_execveat(fd_script_ephemeral, "", AT_EMPTY_PATH);
> +
> +       /* Rename a subdirectory in the path: */
> +       rename("subdir.ephemeral", "subdir.moved");
> +       fail += check_execveat(subdir_dfd_ephemeral, "../script", 0);
> +       fail += check_execveat(subdir_dfd_ephemeral, "script", 0);
> +       /* Remove the subdir and its contents */
> +       unlink("subdir.moved/script");
> +       unlink("subdir.moved");
> +       /* Shell loads via deleted subdir OK because name starts with .. */
> +       fail += check_execveat(subdir_dfd_ephemeral, "../script", 0);
> +       fail += check_execveat_fail(subdir_dfd_ephemeral, "script", 0, ENOENT);
> +
> +       /* Flag values other than AT_SYMLINK_NOFOLLOW => EINVAL */
> +       fail += check_execveat_fail(dot_dfd, "execveat", 0xFFFF, EINVAL);
> +       /* Invalid path => ENOENT */
> +       fail += check_execveat_fail(dot_dfd, "no-such-file", 0, ENOENT);
> +       fail += check_execveat_fail(dot_dfd_path, "no-such-file", 0, ENOENT);
> +       fail += check_execveat_fail(AT_FDCWD, "no-such-file", 0, ENOENT);
> +       /* Attempt to execute directory => EACCES */
> +       fail += check_execveat_fail(dot_dfd, "", AT_EMPTY_PATH, EACCES);
> +       /* Attempt to execute non-executable => EACCES */
> +       fail += check_execveat_fail(dot_dfd, "Makefile", 0, EACCES);
> +       fail += check_execveat_fail(fd_denatured, "", AT_EMPTY_PATH, EACCES);
> +       /* Attempt to execute file opened with O_PATH => EBADF */
> +       fail += check_execveat_fail(fd_path, "", AT_EMPTY_PATH, EBADF);
> +       /* Attempt to execute nonsense FD => EBADF */
> +       fail += check_execveat_fail(99, "", AT_EMPTY_PATH, EBADF);
> +       fail += check_execveat_fail(99, "execveat", 0, EBADF);
> +       /* Attempt to execute relative to non-directory => ENOTDIR */
> +       fail += check_execveat_fail(fd, "execveat", 0, ENOTDIR);
> +

I'd add some tests that check PATH_MAX with the /dev/fd/n/filename
off-by-one I noticed. That could catch any regressions there.

-Kees

> +       return fail;
> +}
> +
> +static void exe_cp(const char *src, const char *dest)
> +{
> +       int in_fd = open_or_die(src, O_RDONLY);
> +       int out_fd = open(dest, O_RDWR|O_CREAT|O_TRUNC, 0755);
> +       struct stat info;
> +
> +       fstat(in_fd, &info);
> +       sendfile(out_fd, in_fd, NULL, info.st_size);
> +       close(in_fd);
> +       close(out_fd);
> +}
> +
> +static void prerequisites(void)
> +{
> +       int fd;
> +       const char *script = "#!/bin/sh\nexit $*\n";
> +
> +       /* Create ephemeral copies of files */
> +       exe_cp("execveat", "execveat.ephemeral");
> +       exe_cp("script", "script.ephemeral");
> +       mkdir("subdir.ephemeral", 0755);
> +
> +       fd = open("subdir.ephemeral/script", O_RDWR|O_CREAT|O_TRUNC, 0755);
> +       write(fd, script, strlen(script));
> +       close(fd);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +       int ii;
> +       int rc;
> +       const char *verbose = getenv("VERBOSE");
> +
> +       if (argc >= 2) {
> +               /* If we are invoked with an argument, don't run tests. */
> +               const char *in_test = getenv("IN_TEST");
> +
> +               if (verbose) {
> +                       printf("  invoked with:");
> +                       for (ii = 0; ii < argc; ii++)
> +                               printf(" [%d]='%s'", ii, argv[ii]);
> +                       printf("\n");
> +               }
> +
> +               /* Check expected environment transferred. */
> +               if (!in_test || strcmp(in_test, "yes") != 0) {
> +                       printf("[FAIL] (no IN_TEST=yes in env)\n");
> +                       return 1;
> +               }
> +
> +               /* Use the final argument as an exit code. */
> +               rc = atoi(argv[argc - 1]);
> +               fflush(stdout);
> +       } else {
> +               prerequisites();
> +               if (verbose)
> +                       envp[1] = "VERBOSE=1";
> +               rc = run_tests();
> +               if (rc > 0)
> +                       printf("%d tests failed\n", rc);
> +       }
> +       return rc;
> +}
> --
> 2.1.0.rc2.206.gedb03e5
>



-- 
Kees Cook
Chrome OS Security
