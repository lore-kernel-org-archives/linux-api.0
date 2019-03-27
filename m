From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 4/4] tests: add pidfd_open() tests
Date: Wed, 27 Mar 2019 21:55:38 +0100
Message-ID: <20190327205536.xa47wrwgwfqqnocg@brauner.io>
References: <20190327162147.23198-1-christian@brauner.io>
 <20190327162147.23198-5-christian@brauner.io>
 <CAGXu5jL-3XbFzT-1qzEiXE+DTPi_xi7dEtyAMTwBJU0BqrFeKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jL-3XbFzT-1qzEiXE+DTPi_xi7dEtyAMTwBJU0BqrFeKQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, bl0pbl33p@gmail.com, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, nagarathnam.muthusamy@oracle.com, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Joel Fernandes <joel@joelfernandes.org>, Daniel
List-Id: linux-api@vger.kernel.org

On Wed, Mar 27, 2019 at 12:36:46PM -0700, Kees Cook wrote:
> On Wed, Mar 27, 2019 at 9:22 AM Christian Brauner <christian@brauner.io> wrote:
> >
> > This adds a simple test case for pidfd_open().
> 
> Thank you for the tests. :) It might be nice to see more extensive
> negative testing -- making sure pids aren't reachable from mismatched

There'll be more tests for sure! Once people say that they are happy
with the design I can put in the effort to expand the tests to more
elaborate scenarios. :)

> pid namespaces, etc, but this gets us basic regression testing. Also,
> you might save some copy/paste code using kselftest_harness.h's
> interfaces.
> 
> -- 
> Kees Cook
