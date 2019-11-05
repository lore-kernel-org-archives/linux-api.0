From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] clone3: validate stack arguments
Date: Tue, 5 Nov 2019 21:23:49 +0100
Message-ID: <CAKgNAkg4aktVXU1m0_MKt6zitqVOgqF_LJjEnGVa-5Mtb5pkdA@mail.gmail.com>
References: <20191031113608.20713-1-christian.brauner@ubuntu.com> <CAK8P3a2P0djkhfHhQUGdO3YX7QGtLeF2OH1HaJmbmRq5Nuojbg@mail.gmail.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2P0djkhfHhQUGdO3YX7QGtLeF2OH1HaJmbmRq5Nuojbg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>, GNU C Library <libc-alpha@sourceware.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>, "# 3.4.x" <stable@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 5 Nov 2019 at 15:25, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Thu, Oct 31, 2019 at 12:36 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > Validate the stack arguments and setup the stack depening on whether or not
> > it is growing down or up.
> >
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

and
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
