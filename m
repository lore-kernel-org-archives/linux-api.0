From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] syscalls: Update the syscall #defines to match uapi
Date: Sun, 11 Aug 2019 17:00:43 -0700
Message-ID: <CALCETrVArr5TTbXayDZ9rz90iGoytGW2bnV5_ZOunhOsPR1u4g@mail.gmail.com>
References: <20190810010758.16407-1-alistair.francis@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190810010758.16407-1-alistair.francis@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alistair Francis <alistair.francis@wdc.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>, alistair23@gmail.com
List-Id: linux-api@vger.kernel.org

On Fri, Aug 9, 2019 at 6:11 PM Alistair Francis
<alistair.francis@wdc.com> wrote:
>
> Update the #defines around sys_fstat64() and sys_fstatat64() to match
> the #defines around the __NR3264_fstatat and __NR3264_fstat definitions
> in include/uapi/asm-generic/unistd.h. This avoids compiler failures if
> one is defined.

What do you mean by "if one is defined"?

The patch seems like it's probably okay, but I can't understand the changelog.

--Andy
