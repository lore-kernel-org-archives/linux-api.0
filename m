From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: For review: documentation of clone3() system call
Date: Thu, 14 Nov 2019 13:29:22 +0100
Message-ID: <20191114122921.37faj6e4blsclx6g@wittgenstein>
References: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
 <20191107151941.dw4gtul5lrtax4se@wittgenstein>
 <2eb2ab4c-b177-29aa-cdc4-420b24cfd7b3@gmail.com>
 <CAG48ez2of684J6suPZpko7JFV6hg5KQsrP0KAn8B8-C3PM9OfQ@mail.gmail.com>
 <090860a8-e57f-d4ea-88d4-086ea32e37d9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <090860a8-e57f-d4ea-88d4-086ea32e37d9@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Jann Horn <jannh@google.com>, Florian Weimer <fweimer@redhat.com>, Christian Brauner <christian@brauner.io>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 14, 2019 at 01:15:58PM +0100, Michael Kerrisk (man-pages) wrote:
> I've fixed the example code in the manual page to use
> mmap(MAP_STACK), rather than malloc(), to allocate the stack.

Thank you!
Christian
