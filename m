From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 3/3] selftests/seccomp: Test kernel catches garbage on
 SECCOMP_IOCTL_NOTIF_RECV
Date: Mon, 30 Dec 2019 10:29:13 -0800
Message-ID: <201912301023.CEBE3A5@keescook>
References: <20191229062451.9467-1-sargun@sargun.me>
 <20191229062451.9467-3-sargun@sargun.me>
 <20191229171441.fxif7q32mv2hl3y4@wittgenstein>
 <CAMp4zn_4dN+5U2RxkpYp+m4=X9w2Wef1TuLZ2hRW+g+nK1cXGA@mail.gmail.com>
 <20191229194318.ogsqw5pbjppbtsf7@wittgenstein>
 <CAMp4zn_39bsyZo6BeZ6b+c_EeAHdWmqcJus6qD2xYp84cEcZaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMp4zn_39bsyZo6BeZ6b+c_EeAHdWmqcJus6qD2xYp84cEcZaA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

On Sun, Dec 29, 2019 at 03:42:17PM -0800, Sargun Dhillon wrote:
> On Sun, Dec 29, 2019 at 11:43 AM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > On Sun, Dec 29, 2019 at 11:06:25AM -0800, Sargun Dhillon wrote:
> > > On Sun, Dec 29, 2019 at 12:14 PM Christian Brauner
> > > <christian.brauner@ubuntu.com> wrote:
> > > > Does that even work if no dup() syscall has been made and trapped?
> > > Yes, the first check that occurs is the check which checks if
> > > seccom_notif has been
> > > zeroed out. This happens before any of the other work.
> >
> > Ah, then sure I don't mind doing it this way. Though plumbing it
> > directly into TEST(user_notification_basic) like I did below seems
> > cleaner to me.
> >
> > >
> > > > This looks like it would give you ENOENT...
> > > This ioctl is a blocking ioctl. It'll block until there is a wakeup.
> > > In this case, the wakeup
> > > will never come, but that doesn't mean we get an ENOENT.
> >
> > Yeah, but that wold mean the test will hang weirdly if it bypasses the
> > check. Sure it'll timeout but meh. I think I would prefer to have this
> > done as part of the basic test where we know that there is an event but
> > _shrug_.

I'd like to design the tests to not _depend_ on the timeout to catch bad
behaviors. The timeout is there for us to not break a test runner when
we forget weird corner cases.

> My one worry about this is that the behaviour should be if the input
> (seccomp_notif) is invalid, it should immediately bail out, whether
> or not there is an event waiting. If we add it to basic_test, then
> it would hide the erroneous behaviour if bailout isn't immediate.

I'm not following this paragraph. The ioctl's zero check is immediate,
so this test should fail the EXPECT (but continue to the next "correct"
ioctl) -- it's not an ASSERT (which would stop the test). I think
Christian's test might be a cleaner approach, unless I'm still missing
something here?

-- 
Kees Cook
