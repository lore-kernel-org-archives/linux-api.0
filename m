From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Thu, 4 May 2017 20:46:49 -0700
Message-ID: <CA+55aFy1SokNNUgxBnFLdA1PRyeG13BqyYNg5xVrW-tNGqh2Bg@mail.gmail.com>
References: <20170429220414.GT29622@ZenIV.linux.org.uk> <CAG48ez0wccvQ5i+XN_Q_yA9_ZwSaGb-W+zky0KQb_GU=9G+MSw@mail.gmail.com>
 <20170505003030.GM29622@ZenIV.linux.org.uk> <CAG48ez1jzNvxB+bfOBnERFGp=oMM0vHWuLD6EULmne3R6xa53w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez1jzNvxB+bfOBnERFGp=oMM0vHWuLD6EULmne3R6xa53w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, May 4, 2017 at 7:47 PM, Jann Horn <jannh@google.com> wrote:
>
> Thread 1 starts an AT_BENEATH path walk using an O_PATH fd
> pointing to /srv/www/example.org/foo; the path given to the syscall is
> "bar/../../../../etc/passwd". The path walk enters the "bar" directory.
> Thread 2 moves /srv/www/example.org/foo/bar to
> /srv/www/example.org/bar.
> Thread 1 processes the rest of the path ("../../../../etc/passwd"), never
> hitting /srv/www/example.org/foo in the process.
>
> I'm not really familiar with the VFS internals, but from a coarse look
> at the patch, it seems like it wouldn't block this?

I think you're right.

I guess it would be safe for the RCU case due to the sequence number
check, but not the non-RCU case.

Al?

                 Linus
