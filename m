From: Adam Borowski <kilobyte@angband.pl>
Subject: Re: Official Linux system wrapper library?
Date: Wed, 14 Nov 2018 13:03:48 +0100
Message-ID: <20181114120348.or5id3hzrmltkyvb@angband.pl>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
 <20181111081725.GA30248@1wt.eu>
 <3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com>
 <20181111111143.GB4189@1wt.eu>
 <87zhufvntw.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87zhufvntw.fsf@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 11, 2018 at 12:46:35PM +0100, Florian Weimer wrote:
> A lot of multi-threaded applications assume that most high-level
> functionality remains usable even after fork in a multi-threaded
> process.

How would this be even possible?  Currently fork kills all threads
(save for the caller).

Glibc's manpage also warns:

# After a fork() in a multithreaded program, the child can safely call only
# async-signal-safe functions (see signal-safety(7)) until such time as it
# calls execve(2).

Which makes sense as its malloc uses a mutex, and you can't take a breath
without a library call using malloc somewhere (or in C++, the language
itself).

So any functionality remaining usable after fork is pretty strictly
limited...


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ I've read an article about how lively happy music boosts
⣾⠁⢰⠒⠀⣿⡁ productivity. You can read it, too, you just need the
⢿⡄⠘⠷⠚⠋⠀ right music while doing so. I recommend Skepticism
⠈⠳⣄⠀⠀⠀⠀ (funeral doom metal).
