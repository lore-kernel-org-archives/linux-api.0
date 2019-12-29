From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v3 3/3] selftests/seccomp: Test kernel catches garbage on
 SECCOMP_IOCTL_NOTIF_RECV
Date: Sun, 29 Dec 2019 20:43:20 +0100
Message-ID: <20191229194318.ogsqw5pbjppbtsf7@wittgenstein>
References: <20191229062451.9467-1-sargun@sargun.me>
 <20191229062451.9467-3-sargun@sargun.me>
 <20191229171441.fxif7q32mv2hl3y4@wittgenstein>
 <CAMp4zn_4dN+5U2RxkpYp+m4=X9w2Wef1TuLZ2hRW+g+nK1cXGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMp4zn_4dN+5U2RxkpYp+m4=X9w2Wef1TuLZ2hRW+g+nK1cXGA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Aleksa Sarai <cyphar@cyphar.com>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

On Sun, Dec 29, 2019 at 11:06:25AM -0800, Sargun Dhillon wrote:
> On Sun, Dec 29, 2019 at 12:14 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > On Sat, Dec 28, 2019 at 10:24:51PM -0800, Sargun Dhillon wrote:
> > > Add a self-test to make sure that the kernel returns EINVAL, if any
> > > of the fields in seccomp_notif are set to non-null.
> > >
> > > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > > Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > ---
> > >  tools/testing/selftests/seccomp/seccomp_bpf.c | 23 +++++++++++++++++++
> > >  1 file changed, 23 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> > > index f53f14971bff..379391a7fa41 100644
> > > --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> > > +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> > > @@ -3601,6 +3601,29 @@ TEST(user_notification_continue)
> > >       }
> > >  }
> > >
> > > +TEST(user_notification_garbage)
> > > +{
> > > +     /*
> > > +      * intentionally set pid to a garbage value to make sure the kernel
> > > +      * catches it
> > > +      */
> > > +     struct seccomp_notif req = {
> > > +             .pid    = 1,
> > > +     };
> > > +     int ret, listener;
> > > +
> > > +     ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
> > > +     ASSERT_EQ(0, ret) {
> > > +             TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
> > > +     }
> > > +
> > > +     listener = user_trap_syscall(__NR_dup, SECCOMP_FILTER_FLAG_NEW_LISTENER);
> > > +     ASSERT_GE(listener, 0);
> > > +
> > > +     EXPECT_EQ(-1, ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req));
> > > +     EXPECT_EQ(EINVAL, errno);
> >
> > Does that even work if no dup() syscall has been made and trapped?
> Yes, the first check that occurs is the check which checks if
> seccom_notif has been
> zeroed out. This happens before any of the other work.

Ah, then sure I don't mind doing it this way. Though plumbing it
directly into TEST(user_notification_basic) like I did below seems
cleaner to me.

> 
> > This looks like it would give you ENOENT...
> This ioctl is a blocking ioctl. It'll block until there is a wakeup.
> In this case, the wakeup
> will never come, but that doesn't mean we get an ENOENT.

Yeah, but that wold mean the test will hang weirdly if it bypasses the
check. Sure it'll timeout but meh. I think I would prefer to have this
done as part of the basic test where we know that there is an event but
_shrug_.

Christian
