From: Alistair Francis <alistair23@gmail.com>
Subject: Re: [PATCH] syscalls: Update the syscall #defines to match uapi
Date: Sun, 11 Aug 2019 20:04:22 -0700
Message-ID: <CAKmqyKN58BfEr2R+W=08r795zRKAT1nK_G2v6U2kQSANr+90Vg@mail.gmail.com>
References: <20190810010758.16407-1-alistair.francis@wdc.com> <CALCETrVArr5TTbXayDZ9rz90iGoytGW2bnV5_ZOunhOsPR1u4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVArr5TTbXayDZ9rz90iGoytGW2bnV5_ZOunhOsPR1u4g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Alistair Francis <alistair.francis@wdc.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>
List-Id: linux-api@vger.kernel.org

On Sun, Aug 11, 2019 at 5:00 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Fri, Aug 9, 2019 at 6:11 PM Alistair Francis
> <alistair.francis@wdc.com> wrote:
> >
> > Update the #defines around sys_fstat64() and sys_fstatat64() to match
> > the #defines around the __NR3264_fstatat and __NR3264_fstat definitions
> > in include/uapi/asm-generic/unistd.h. This avoids compiler failures if
> > one is defined.
>
> What do you mean by "if one is defined"?

Yeah, I guess that isn't clear. What I mean is that if
__ARCH_WANT_NEW_STAT is defined but __ARCH_WANT_STAT64 isn't currently
it will fail to build.

>
> The patch seems like it's probably okay, but I can't understand the changelog.

I can send a v2 with an updated commit message.

Alistair

>
> --Andy
