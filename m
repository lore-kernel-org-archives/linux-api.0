From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH v8 1/1] man-pages: seccomp.2: document syscall
Date: Wed, 25 Jun 2014 19:54:49 +0200
Message-ID: <CAKgNAkgU+igKYKtzk3u83ZTcR-ov7kq_J9mbTeHuOt7Zkbpy6Q@mail.gmail.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
 <20140624205615.GW5412@outflux.net> <20140625140440.6870eac1@alan.etchedpixels.co.uk>
 <CAGXu5j+99NOtJq2-TWYm8mwNw1ki0y3rRH21wX66MVM8=jz1bQ@mail.gmail.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+99NOtJq2-TWYm8mwNw1ki0y3rRH21wX66MVM8=jz1bQ@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 25, 2014 at 5:10 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Jun 25, 2014 at 6:04 AM, One Thousand Gnomes
> <gnomes@lxorguk.ukuu.org.uk> wrote:
>> On Tue, 24 Jun 2014 13:56:15 -0700
>> Kees Cook <keescook@chromium.org> wrote:
>>
>>> Combines documentation from prctl, in-kernel seccomp_filter.txt and
>>> dropper.c, along with details specific to the new syscall.
>>
>> What is the license on the example ? Probably you want to propogate the
>> minimal form of the text in seccomp/dropper into the document example to
>> avoid confusion ?
>
> What is the license of the other code examples in man-pages?

Typically, just the same as the rest if the page text. Perhaps that
should be rethought for future examples. I haven't thought about it at
length, but, at first glance, I'm not against having separate licenses
for the page text and the code sample.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
