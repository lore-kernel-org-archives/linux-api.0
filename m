From: Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: new ELF marking
Date: Wed, 9 Aug 2017 10:07:54 -0700
Message-ID: <CAGXu5jL2iY8=VhWyqhhUqxAs1akywodrWezU77rnrq-Ksbzwow__278.714233036403$1502298492$gmane$org@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, binutils-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

I'd like to be able to mark an ELF binary in such a way that Linux's
binfmt_elf.c will collapse a PIE text area into the mmap region
(currently they are separately randomized in memory). This is desired
by AddressSanitizer to avoid having an ASan-built binary have its text
area moving into an unexpected location[1] (ASLR is still desired, but
doesn't need to have a PIE/mmap split).

I see a few ways:

- Add parsing for NOTE program headers and add a new NOTE type
(NT_GNU_EXEC_FLAGS), though notes tend to be strings...

- Add a new Program Header (GNU_EXEC_FLAGS), which is similar to how
GNU_STACK and GNU_RELRO were handled. This could sort of be like NOTE
except just lots of bit flags.

- Use a filesystem xattr. This is fragile, in the case of copying
binaries between systems or filesystems.

Thoughts?

-Kees

[1] https://lkml.org/lkml/2017/8/7/770

-- 
Kees Cook
Pixel Security
