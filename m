From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH -mm] selftests/capabilities: Add tests for capability evolution
Date: Mon, 24 Aug 2015 16:40:57 -0700
Message-ID: <CAGXu5jK=Kei9TBwU9dV3XgqkiVYS8CdYcVyXovziABGenEc7Qw@mail.gmail.com>
References: <2d98ecd81eb807d576dcb4acaa62e70aa5d65e70.1440456948.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2d98ecd81eb807d576dcb4acaa62e70aa5d65e70.1440456948.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 24, 2015 at 4:03 PM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> This test focuses on ambient capabilities.  It requires either root
> or the ability to create user namespaces.  Some of the test cases
> will be skipped for nonroot users.
>
> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Looks great! Thanks for this!

Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

-Kees

> ---
>
> I took taking advantage of the extra week to make my test case work :)
>
>  tools/testing/selftests/capabilities/.gitignore    |   2 +
>  tools/testing/selftests/capabilities/Makefile      |  19 +
>  tools/testing/selftests/capabilities/test_execve.c | 427 +++++++++++++++++++++
>  .../testing/selftests/capabilities/validate_cap.c  |  73 ++++
>  4 files changed, 521 insertions(+)
>  create mode 100644 tools/testing/selftests/capabilities/.gitignore
>  create mode 100644 tools/testing/selftests/capabilities/Makefile
>  create mode 100644 tools/testing/selftests/capabilities/test_execve.c
>  create mode 100644 tools/testing/selftests/capabilities/validate_cap.c
>
> diff --git a/tools/testing/selftests/capabilities/.gitignore b/tools/testing/selftests/capabilities/.gitignore
> new file mode 100644
> index 000000000000..b732dd0d4738
> --- /dev/null
> +++ b/tools/testing/selftests/capabilities/.gitignore
> @@ -0,0 +1,2 @@
> +test_execve
> +validate_cap
> diff --git a/tools/testing/selftests/capabilities/Makefile b/tools/testing/selftests/capabilities/Makefile
> new file mode 100644
> index 000000000000..5b90ed14cccb
> --- /dev/null
> +++ b/tools/testing/selftests/capabilities/Makefile
> @@ -0,0 +1,19 @@
> +all:
> +
> +include ../lib.mk
> +
> +.PHONY: all clean
> +
> +TARGETS := validate_cap test_execve
> +TEST_PROGS := test_execve
> +
> +CFLAGS := -O2 -g -std=gnu99 -Wall -lcap-ng
> +
> +all: $(TARGETS)
> +
> +clean:
> +       $(RM) $(TARGETS)
> +
> +$(TARGETS): %: %.c
> +       $(CC) -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
> +
> diff --git a/tools/testing/selftests/capabilities/test_execve.c b/tools/testing/selftests/capabilities/test_execve.c
> new file mode 100644
> index 000000000000..10a21a958aaf
> --- /dev/null
> +++ b/tools/testing/selftests/capabilities/test_execve.c
> @@ -0,0 +1,427 @@
> +#define _GNU_SOURCE
> +
> +#include <cap-ng.h>
> +#include <err.h>
> +#include <linux/capability.h>
> +#include <stdbool.h>
> +#include <string.h>
> +#include <stdio.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <stdarg.h>
> +#include <sched.h>
> +#include <sys/mount.h>
> +#include <limits.h>
> +#include <libgen.h>
> +#include <malloc.h>
> +#include <sys/wait.h>
> +#include <sys/prctl.h>
> +#include <sys/stat.h>
> +
> +#ifndef PR_CAP_AMBIENT
> +#define PR_CAP_AMBIENT                 47
> +# define PR_CAP_AMBIENT_IS_SET         1
> +# define PR_CAP_AMBIENT_RAISE          2
> +# define PR_CAP_AMBIENT_LOWER          3
> +# define PR_CAP_AMBIENT_CLEAR_ALL      4
> +#endif
> +
> +static int nerrs;
> +
> +static void vmaybe_write_file(bool enoent_ok, char *filename, char *fmt, va_list ap)
> +{
> +       char buf[4096];
> +       int fd;
> +       ssize_t written;
> +       int buf_len;
> +
> +       buf_len = vsnprintf(buf, sizeof(buf), fmt, ap);
> +       if (buf_len < 0) {
> +               err(1, "vsnprintf failed");
> +       }
> +       if (buf_len >= sizeof(buf)) {
> +               errx(1, "vsnprintf output truncated");
> +       }
> +
> +       fd = open(filename, O_WRONLY);
> +       if (fd < 0) {
> +               if ((errno == ENOENT) && enoent_ok)
> +                       return;
> +               err(1, "open of %s failed", filename);
> +       }
> +       written = write(fd, buf, buf_len);
> +       if (written != buf_len) {
> +               if (written >= 0) {
> +                       errx(1, "short write to %s", filename);
> +               } else {
> +                       err(1, "write to %s failed", filename);
> +               }
> +       }
> +       if (close(fd) != 0) {
> +               err(1, "close of %s failed", filename);
> +       }
> +}
> +
> +static void maybe_write_file(char *filename, char *fmt, ...)
> +{
> +       va_list ap;
> +
> +       va_start(ap, fmt);
> +       vmaybe_write_file(true, filename, fmt, ap);
> +       va_end(ap);
> +}
> +
> +static void write_file(char *filename, char *fmt, ...)
> +{
> +       va_list ap;
> +
> +       va_start(ap, fmt);
> +       vmaybe_write_file(false, filename, fmt, ap);
> +       va_end(ap);
> +}
> +
> +static bool create_and_enter_ns(uid_t inner_uid)
> +{
> +       uid_t outer_uid;
> +       gid_t outer_gid;
> +       int i;
> +       bool have_outer_privilege;
> +
> +       outer_uid = getuid();
> +       outer_gid = getgid();
> +
> +       /*
> +        * TODO: If we're already root, we could skip creating the userns.
> +        */
> +
> +       if (unshare(CLONE_NEWNS) == 0) {
> +               printf("[NOTE]\tUsing global UIDs for tests\n");
> +               if (prctl(PR_SET_KEEPCAPS, 1, 0, 0, 0) != 0)
> +                       err(1, "PR_SET_KEEPCAPS");
> +               if (setresuid(inner_uid, inner_uid, -1) != 0)
> +                       err(1, "setresuid");
> +
> +               // Re-enable effective caps
> +               capng_get_caps_process();
> +               for (i = 0; i < CAP_LAST_CAP; i++)
> +                       if (capng_have_capability(CAPNG_PERMITTED, i))
> +                               capng_update(CAPNG_ADD, CAPNG_EFFECTIVE, i);
> +               if (capng_apply(CAPNG_SELECT_CAPS) != 0)
> +                       err(1, "capng_apply");
> +
> +               have_outer_privilege = true;
> +       } else if (unshare(CLONE_NEWUSER | CLONE_NEWNS) == 0) {
> +               printf("[NOTE]\tUsing a user namespace for tests\n");
> +               maybe_write_file("/proc/self/setgroups", "deny");
> +               write_file("/proc/self/uid_map", "%d %d 1", inner_uid, outer_uid);
> +               write_file("/proc/self/gid_map", "0 %d 1", outer_gid);
> +
> +               have_outer_privilege = false;
> +       } else {
> +               errx(1, "must be root or be able to create a userns");
> +       }
> +
> +       if (mount("none", "/", NULL, MS_REC | MS_PRIVATE, NULL) != 0)
> +               err(1, "remount everything private");
> +
> +       return have_outer_privilege;
> +}
> +
> +static void chdir_to_tmpfs(void)
> +{
> +       char cwd[PATH_MAX];
> +       if (getcwd(cwd, sizeof(cwd)) != cwd)
> +               err(1, "getcwd");
> +
> +       if (mount("private_tmp", ".", "tmpfs", 0, "mode=0777") != 0)
> +               err(1, "mount private tmpfs");
> +
> +       if (chdir(cwd) != 0)
> +               err(1, "chdir to private tmpfs");
> +
> +       if (umount2(".", MNT_DETACH) != 0)
> +               err(1, "detach private tmpfs");
> +}
> +
> +static void copy_fromat_to(int fromfd, const char *fromname, const char *toname)
> +{
> +       int from = openat(fromfd, fromname, O_RDONLY);
> +       if (from == -1)
> +               err(1, "open copy source");
> +
> +       int to = open(toname, O_CREAT | O_WRONLY | O_EXCL, 0700);
> +
> +       while (true) {
> +               char buf[4096];
> +               ssize_t sz = read(from, buf, sizeof(buf));
> +               if (sz == 0)
> +                       break;
> +               if (sz < 0)
> +                       err(1, "read");
> +
> +               if (write(to, buf, sz) != sz)
> +                       err(1, "write");        /* no short writes on tmpfs */
> +       }
> +
> +       close(from);
> +       close(to);
> +}
> +
> +static bool fork_wait(void)
> +{
> +       pid_t child = fork();
> +       if (child == 0) {
> +               nerrs = 0;
> +               return true;
> +       } else if (child > 0) {
> +               int status;
> +               if (waitpid(child, &status, 0) != child ||
> +                   !WIFEXITED(status)) {
> +                       printf("[FAIL]\tChild died\n");
> +                       nerrs++;
> +               } else if (WEXITSTATUS(status) != 0) {
> +                       printf("[FAIL]\tChild failed\n");
> +                       nerrs++;
> +               } else {
> +                       printf("[OK]\tChild succeeded\n");
> +               }
> +
> +               return false;
> +       } else {
> +               err(1, "fork");
> +       }
> +}
> +
> +static void exec_other_validate_cap(const char *name,
> +                                   bool eff, bool perm, bool inh, bool ambient)
> +{
> +       execl(name, name, (eff ? "1" : "0"),
> +             (perm ? "1" : "0"), (inh ? "1" : "0"), (ambient ? "1" : "0"),
> +             NULL);
> +       err(1, "execl");
> +}
> +
> +static void exec_validate_cap(bool eff, bool perm, bool inh, bool ambient)
> +{
> +       exec_other_validate_cap("./validate_cap", eff, perm, inh, ambient);
> +}
> +
> +static int do_tests(int uid, const char *our_path)
> +{
> +       bool have_outer_privilege = create_and_enter_ns(uid);
> +
> +       int ourpath_fd = open(our_path, O_RDONLY | O_DIRECTORY);
> +       if (ourpath_fd == -1)
> +               err(1, "open '%s'", our_path);
> +
> +       chdir_to_tmpfs();
> +
> +       copy_fromat_to(ourpath_fd, "validate_cap", "validate_cap");
> +
> +       if (have_outer_privilege) {
> +               uid_t gid = getegid();
> +
> +               copy_fromat_to(ourpath_fd, "validate_cap",
> +                              "validate_cap_suidroot");
> +               if (chown("validate_cap_suidroot", 0, -1) != 0)
> +                       err(1, "chown");
> +               if (chmod("validate_cap_suidroot", S_ISUID | 0700) != 0)
> +                       err(1, "chmod");
> +
> +               copy_fromat_to(ourpath_fd, "validate_cap",
> +                              "validate_cap_suidnonroot");
> +               if (chown("validate_cap_suidnonroot", uid + 1, -1) != 0)
> +                       err(1, "chown");
> +               if (chmod("validate_cap_suidnonroot", S_ISUID | 0700) != 0)
> +                       err(1, "chmod");
> +
> +               copy_fromat_to(ourpath_fd, "validate_cap",
> +                              "validate_cap_sgidroot");
> +               if (chown("validate_cap_sgidroot", -1, 0) != 0)
> +                       err(1, "chown");
> +               if (chmod("validate_cap_sgidroot", S_ISGID | 0710) != 0)
> +                       err(1, "chmod");
> +
> +               copy_fromat_to(ourpath_fd, "validate_cap",
> +                              "validate_cap_sgidnonroot");
> +               if (chown("validate_cap_sgidnonroot", -1, gid + 1) != 0)
> +                       err(1, "chown");
> +               if (chmod("validate_cap_sgidnonroot", S_ISGID | 0710) != 0)
> +                       err(1, "chmod");
> +}
> +
> +       capng_get_caps_process();
> +
> +       /* Make sure that i starts out clear */
> +       capng_update(CAPNG_DROP, CAPNG_INHERITABLE, CAP_NET_BIND_SERVICE);
> +       if (capng_apply(CAPNG_SELECT_CAPS) != 0)
> +               err(1, "capng_apply");
> +
> +       if (uid == 0) {
> +               printf("[RUN]\tRoot => ep\n");
> +               if (fork_wait())
> +                       exec_validate_cap(true, true, false, false);
> +       } else {
> +               printf("[RUN]\tNon-root => no caps\n");
> +               if (fork_wait())
> +                       exec_validate_cap(false, false, false, false);
> +       }
> +
> +       printf("[OK]\tCheck cap_ambient manipulation rules\n");
> +
> +       /* We should not be able to add ambient caps yet. */
> +       if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_NET_BIND_SERVICE, 0, 0, 0) != -1 || errno != EPERM) {
> +               if (errno == EINVAL)
> +                       printf("[FAIL]\tPR_CAP_AMBIENT_RAISE isn't supported\n");
> +               else
> +                       printf("[FAIL]\tPR_CAP_AMBIENT_RAISE should have failed eith EPERM on a non-inheritable cap\n");
> +               return 1;
> +       }
> +       printf("[OK]\tPR_CAP_AMBIENT_RAISE failed on non-inheritable cap\n");
> +
> +       capng_update(CAPNG_ADD, CAPNG_INHERITABLE, CAP_NET_RAW);
> +       capng_update(CAPNG_DROP, CAPNG_PERMITTED, CAP_NET_RAW);
> +       capng_update(CAPNG_DROP, CAPNG_EFFECTIVE, CAP_NET_RAW);
> +       if (capng_apply(CAPNG_SELECT_CAPS) != 0)
> +               err(1, "capng_apply");
> +       if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_NET_RAW, 0, 0, 0) != -1 || errno != EPERM) {
> +               printf("[FAIL]\tPR_CAP_AMBIENT_RAISE should have failed on a non-permitted cap\n");
> +               return 1;
> +       }
> +       printf("[OK]\tPR_CAP_AMBIENT_RAISE failed on non-permitted cap\n");
> +
> +       capng_update(CAPNG_ADD, CAPNG_INHERITABLE, CAP_NET_BIND_SERVICE);
> +       if (capng_apply(CAPNG_SELECT_CAPS) != 0)
> +               err(1, "capng_apply");
> +       if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_NET_BIND_SERVICE, 0, 0, 0) != 0) {
> +               printf("[FAIL]\tPR_CAP_AMBIENT_RAISE should have succeeded\n");
> +               return 1;
> +       }
> +       printf("[OK]\tPR_CAP_AMBIENT_RAISE worked\n");
> +
> +       if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_IS_SET, CAP_NET_BIND_SERVICE, 0, 0, 0) != 1) {
> +               printf("[FAIL]\tPR_CAP_AMBIENT_IS_SET is broken\n");
> +               return 1;
> +       }
> +
> +       if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_CLEAR_ALL, 0, 0, 0, 0) != 0)
> +               err(1, "PR_CAP_AMBIENT_CLEAR_ALL");
> +
> +       if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_IS_SET, CAP_NET_BIND_SERVICE, 0, 0, 0) != 0) {
> +               printf("[FAIL]\tPR_CAP_AMBIENT_CLEAR_ALL didn't work\n");
> +               return 1;
> +       }
> +
> +       if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_NET_BIND_SERVICE, 0, 0, 0) != 0)
> +               err(1, "PR_CAP_AMBIENT_RAISE");
> +
> +       capng_update(CAPNG_DROP, CAPNG_INHERITABLE, CAP_NET_BIND_SERVICE);
> +       if (capng_apply(CAPNG_SELECT_CAPS) != 0)
> +               err(1, "capng_apply");
> +
> +       if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_IS_SET, CAP_NET_BIND_SERVICE, 0, 0, 0) != 0) {
> +               printf("[FAIL]\tDropping I should have dropped A\n");
> +               return 1;
> +       }
> +
> +       printf("[OK]\tBasic manipulation appears to work\n");
> +
> +       capng_update(CAPNG_ADD, CAPNG_INHERITABLE, CAP_NET_BIND_SERVICE);
> +       if (capng_apply(CAPNG_SELECT_CAPS) != 0)
> +               err(1, "capng_apply");
> +       if (uid == 0) {
> +               printf("[RUN]\tRoot +i => eip\n");
> +               if (fork_wait())
> +                       exec_validate_cap(true, true, true, false);
> +       } else {
> +               printf("[RUN]\tNon-root +i => i\n");
> +               if (fork_wait())
> +                       exec_validate_cap(false, false, true, false);
> +       }
> +
> +       if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_NET_BIND_SERVICE, 0, 0, 0) != 0)
> +               err(1, "PR_CAP_AMBIENT_RAISE");
> +
> +       printf("[RUN]\tUID %d +ia => eipa\n", uid);
> +       if (fork_wait())
> +               exec_validate_cap(true, true, true, true);
> +
> +       /* The remaining tests need real privilege */
> +
> +       if (!have_outer_privilege) {
> +               printf("[SKIP]\tSUID/SGID tests (needs privilege)\n");
> +               goto done;
> +       }
> +
> +       if (uid == 0) {
> +               printf("[RUN]\tRoot +ia, suidroot => eipa\n");
> +               if (fork_wait())
> +                       exec_other_validate_cap("./validate_cap_suidroot",
> +                                               true, true, true, true);
> +
> +               printf("[RUN]\tRoot +ia, suidnonroot => ip\n");
> +               if (fork_wait())
> +                       exec_other_validate_cap("./validate_cap_suidnonroot",
> +                                               false, true, true, false);
> +
> +               printf("[RUN]\tRoot +ia, sgidroot => eipa\n");
> +               if (fork_wait())
> +                       exec_other_validate_cap("./validate_cap_sgidroot",
> +                                               true, true, true, true);
> +
> +               if (fork_wait()) {
> +                       printf("[RUN]\tRoot, gid != 0, +ia, sgidroot => eip\n");
> +                       if (setresgid(1, 1, 1) != 0)
> +                               err(1, "setresgid");
> +                       exec_other_validate_cap("./validate_cap_sgidroot",
> +                                               true, true, true, false);
> +               }
> +
> +               printf("[RUN]\tRoot +ia, sgidnonroot => eip\n");
> +               if (fork_wait())
> +                       exec_other_validate_cap("./validate_cap_sgidnonroot",
> +                                               true, true, true, false);
> +       } else {
> +               printf("[RUN]\tNon-root +ia, sgidnonroot => i\n");
> +               exec_other_validate_cap("./validate_cap_sgidnonroot",
> +                                               false, false, true, false);
> +
> +               if (fork_wait()) {
> +                       printf("[RUN]\tNon-root +ia, sgidroot => i\n");
> +                       if (setresgid(1, 1, 1) != 0)
> +                               err(1, "setresgid");
> +                       exec_other_validate_cap("./validate_cap_sgidroot",
> +                                               false, false, true, false);
> +               }
> +       }
> +
> +done:
> +       return nerrs ? 1 : 0;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +       char *tmp1, *tmp2, *our_path;
> +
> +       /* Find our path */
> +       tmp1 = strdup(argv[0]);
> +       if (!tmp1)
> +               err(1, "strdup");
> +       tmp2 = dirname(tmp1);
> +       our_path = strdup(tmp2);
> +       if (!our_path)
> +               err(1, "strdup");
> +       free(tmp1);
> +
> +       if (fork_wait()) {
> +               printf("[RUN]\t+++ Tests with uid == 0 +++\n");
> +               return do_tests(0, our_path);
> +       }
> +
> +       if (fork_wait()) {
> +               printf("[RUN]\t+++ Tests with uid != 0 +++\n");
> +               return do_tests(1, our_path);
> +       }
> +
> +       return nerrs ? 1 : 0;
> +}
> diff --git a/tools/testing/selftests/capabilities/validate_cap.c b/tools/testing/selftests/capabilities/validate_cap.c
> new file mode 100644
> index 000000000000..dd3c45f7b23c
> --- /dev/null
> +++ b/tools/testing/selftests/capabilities/validate_cap.c
> @@ -0,0 +1,73 @@
> +#include <cap-ng.h>
> +#include <err.h>
> +#include <linux/capability.h>
> +#include <stdbool.h>
> +#include <string.h>
> +#include <stdio.h>
> +#include <sys/prctl.h>
> +#include <sys/auxv.h>
> +
> +#ifndef PR_CAP_AMBIENT
> +#define PR_CAP_AMBIENT                 47
> +# define PR_CAP_AMBIENT_IS_SET         1
> +# define PR_CAP_AMBIENT_RAISE          2
> +# define PR_CAP_AMBIENT_LOWER          3
> +# define PR_CAP_AMBIENT_CLEAR_ALL      4
> +#endif
> +
> +#if __GLIBC__ > 2 || (__GLIBC__ == 2 && __GLIBC_MINOR__ >= 19)
> +# define HAVE_GETAUXVAL
> +#endif
> +
> +static bool bool_arg(char **argv, int i)
> +{
> +       if (!strcmp(argv[i], "0"))
> +               return false;
> +       else if (!strcmp(argv[i], "1"))
> +               return true;
> +       else
> +               errx(1, "wrong argv[%d]", i);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +       const char *atsec = "";
> +
> +       /*
> +        * Be careful just in case a setgid or setcapped copy of this
> +        * helper gets out.
> +        */
> +
> +       if (argc != 5)
> +               errx(1, "wrong argc");
> +
> +#ifdef HAVE_GETAUXVAL
> +       if (getauxval(AT_SECURE))
> +               atsec = " (AT_SECURE is set)";
> +       else
> +               atsec = " (AT_SECURE is not set)";
> +#endif
> +
> +       capng_get_caps_process();
> +
> +       if (capng_have_capability(CAPNG_EFFECTIVE, CAP_NET_BIND_SERVICE) != bool_arg(argv, 1)) {
> +               printf("[FAIL]\tWrong effective state%s\n", atsec);
> +               return 1;
> +       }
> +       if (capng_have_capability(CAPNG_PERMITTED, CAP_NET_BIND_SERVICE) != bool_arg(argv, 2)) {
> +               printf("[FAIL]\tWrong permitted state%s\n", atsec);
> +               return 1;
> +       }
> +       if (capng_have_capability(CAPNG_INHERITABLE, CAP_NET_BIND_SERVICE) != bool_arg(argv, 3)) {
> +               printf("[FAIL]\tWrong inheritable state%s\n", atsec);
> +               return 1;
> +       }
> +
> +       if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_IS_SET, CAP_NET_BIND_SERVICE, 0, 0, 0) != bool_arg(argv, 4)) {
> +               printf("[FAIL]\tWrong ambient state%s\n", atsec);
> +               return 1;
> +       }
> +
> +       printf("[OK]\tCapabilities after execve were correct\n");
> +       return 0;
> +}
> --
> 2.4.3
>



-- 
Kees Cook
Chrome OS Security
