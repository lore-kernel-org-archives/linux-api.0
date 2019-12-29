From: Sargun Dhillon <sargun@sargun.me>
Subject: Re: [PATCH v3 3/3] selftests/seccomp: Test kernel catches garbage on SECCOMP_IOCTL_NOTIF_RECV
Date: Sun, 29 Dec 2019 11:06:25 -0800
Message-ID: <CAMp4zn_4dN+5U2RxkpYp+m4=X9w2Wef1TuLZ2hRW+g+nK1cXGA@mail.gmail.com>
References: <20191229062451.9467-1-sargun@sargun.me> <20191229062451.9467-3-sargun@sargun.me>
 <20191229171441.fxif7q32mv2hl3y4@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191229171441.fxif7q32mv2hl3y4@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Aleksa Sarai <cyphar@cyphar.com>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

On Sun, Dec 29, 2019 at 12:14 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Sat, Dec 28, 2019 at 10:24:51PM -0800, Sargun Dhillon wrote:
> > Add a self-test to make sure that the kernel returns EINVAL, if any
> > of the fields in seccomp_notif are set to non-null.
> >
> > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > ---
> >  tools/testing/selftests/seccomp/seccomp_bpf.c | 23 +++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> >
> > diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> > index f53f14971bff..379391a7fa41 100644
> > --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> > +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> > @@ -3601,6 +3601,29 @@ TEST(user_notification_continue)
> >       }
> >  }
> >
> > +TEST(user_notification_garbage)
> > +{
> > +     /*
> > +      * intentionally set pid to a garbage value to make sure the kernel
> > +      * catches it
> > +      */
> > +     struct seccomp_notif req = {
> > +             .pid    = 1,
> > +     };
> > +     int ret, listener;
> > +
> > +     ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
> > +     ASSERT_EQ(0, ret) {
> > +             TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
> > +     }
> > +
> > +     listener = user_trap_syscall(__NR_dup, SECCOMP_FILTER_FLAG_NEW_LISTENER);
> > +     ASSERT_GE(listener, 0);
> > +
> > +     EXPECT_EQ(-1, ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req));
> > +     EXPECT_EQ(EINVAL, errno);
>
> Does that even work if no dup() syscall has been made and trapped?
Yes, the first check that occurs is the check which checks if
seccom_notif has been
zeroed out. This happens before any of the other work.

> This looks like it would give you ENOENT...
This ioctl is a blocking ioctl. It'll block until there is a wakeup.
In this case, the wakeup
will never come, but that doesn't mean we get an ENOENT.

>
> If you want a simple solution just do:
>
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> index 6944b898bb53..4c73ae8679ea 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -3095,7 +3095,7 @@ TEST(user_notification_basic)
>         pid_t pid;
>         long ret;
>         int status, listener;
> -       struct seccomp_notif req = {};
> +       struct seccomp_notif req;
>         struct seccomp_notif_resp resp = {};
>         struct pollfd pollfd;
>
> @@ -3158,6 +3158,13 @@ TEST(user_notification_basic)
>         EXPECT_GT(poll(&pollfd, 1, -1), 0);
>         EXPECT_EQ(pollfd.revents, POLLIN);
>
> +       /* Test that we can't pass garbage to the kernel. */
> +       memset(&req, 0, sizeof(req));
> +       req.pid = -1;
> +       EXPECT_EQ(-1, ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req));
> +       EXPECT_EQ(EINVAL, errno);
> +
> +       req.pid = 0;
>         EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
>
>         pollfd.fd = listener
>
>
> If you want a complete separate test then you can do:
I can do this, but given that the seccomp_notif datastructure should
always be copied
and checked before doing the actual evaluation of the syscall, this
test should pass
even if the trap is not triggered. The basic test should check if the
inverse holds.

If the kernel is broken the self-test harness will stall, and the
alarm timeout will
kick in.
>
> TEST(user_notification_garbage_recv)
> {
>         pid_t pid;
>         long ret;
>         int status, listener;
>         struct seccomp_notif req;
>         struct seccomp_notif_resp resp = {};
>         struct pollfd pollfd;
>
>         ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
>         ASSERT_EQ(0, ret) {
>                 TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
>         }
>
>         listener = user_trap_syscall(__NR_getppid,
>                                      SECCOMP_FILTER_FLAG_NEW_LISTENER);
>         ASSERT_GE(listener, 0);
>
>         pid = fork();
>         ASSERT_GE(pid, 0);
>
>         if (pid == 0) {
>                 ret = syscall(__NR_getppid);
>                 exit(ret != USER_NOTIF_MAGIC);
>         }
>
>         pollfd.fd = listener;
>         pollfd.events = POLLIN | POLLOUT;
>
>         EXPECT_GT(poll(&pollfd, 1, -1), 0);
>         EXPECT_EQ(pollfd.revents, POLLIN);
>
>         memset(&req, 0, sizeof(req));
>         req.pid = -1;
>         EXPECT_EQ(-1, ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req));
>         EXPECT_EQ(EINVAL, errno);
>
>         req.pid = 0;
>         EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
>
>         pollfd.fd = listener;
>         pollfd.events = POLLIN | POLLOUT;
>
>         EXPECT_GT(poll(&pollfd, 1, -1), 0);
>         EXPECT_EQ(pollfd.revents, POLLOUT);
>
>         EXPECT_EQ(req.data.nr,  __NR_getppid);
>
>         memset(&resp, 0, sizeof(resp));
>         resp.id = req.id;
>         resp.error = 0;
>         resp.val = USER_NOTIF_MAGIC;
>         EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);
>
>         EXPECT_EQ(waitpid(pid, &status, 0), pid);
>         EXPECT_EQ(true, WIFEXITED(status));
>         EXPECT_EQ(0, WEXITSTATUS(status));
> }
>
> Christian
