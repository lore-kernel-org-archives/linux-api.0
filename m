From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH] y2038: fix socket.h header inclusion
Date: Mon, 18 Mar 2019 14:12:57 +0100
Message-ID: <877ecwwckm.fsf@mid.deneb.enyo.de>
References: <20190311153857.563743-1-arnd@arndb.de>
        <87k1h1fgkk.fsf@mid.deneb.enyo.de>
        <CAK8P3a1r8GRC7GTHHqWY-PUn=9rWB-7+Qo=7txanbEjGZ-wppw@mail.gmail.com>
        <87a7hvded7.fsf@mid.deneb.enyo.de>
        <CABeXuvrEecSAkBuN-SmAbGwhLWNCC+bA1=X78fm8xMyw8=hm6Q@mail.gmail.com>
        <CAK8P3a22n5L45Gknqd=2zinVGqRovkk0OABmGLJbGcmg8xXd+A@mail.gmail.com>
        <87o968y1uv.fsf@mid.deneb.enyo.de>
        <CAK8P3a1DzRhiuNxBeQaTYSX1NhCaN6+B0Ya7aeGfxUGj35LFhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a1DzRhiuNxBeQaTYSX1NhCaN6+B0Ya7aeGfxUGj35LFhw@mail.gmail.com>
        (Arnd Bergmann's message of "Mon, 18 Mar 2019 13:56:37 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, "David S . Miller" <davem@davemloft.net>, Willem de Bruijn <willemb@google.com>, alpha <linux-alpha@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-mips@vger.kernel.org, Parisc List <linux-parisc@vger.kernel.org>, sparclinux <sparclinux@vger.kernel.org>, Laura Abbott <labbott@redhat.com>, Networking <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jeff Law <law@redhat.com>
List-Id: linux-api@vger.kernel.org

* Arnd Bergmann:

> On Mon, Mar 18, 2019 at 10:25 AM Florian Weimer <fw@deneb.enyo.de> wrote:
>>
>> * Arnd Bergmann:
>>
>> > Should we just remove __kernel_fd_set from the exported headers and
>> > define the internal fd_set directly in include/linux/types.h? (Adding the
>> > folks from the old thread to Cc).
>>
>> The type is used in the sanitizers, but incorrectly.  They assume that
>> FD_SETSIZE is always 1024.  (The existence of __kernel_fd_set is
>> itself somewhat questionable because it leads to such bugs.)
>> Moving around the type could cause a build failure in the sanitizers, but I'm
>> not entirely clear how the UAPI headers are included there.
>
> It looks like sanitizer_platform_limits_posix.cc includes
> linux/posix_types.h to ensure that __kernel_fd_set is the same
> size as __sanitizer___kernel_fd_set, and then it uses the
> latter afterwards.
>
> What I don't see here is what kind of operation is actually done
> on the data, I only see a cast to void.

I think it is used to assert that the select family of system calls
writes to the 1024 bits for each of the passed pointers.  Which is not
actually true—the write size is controlled by the file descriptor
count argument.

> If libsanitizer actually does
> anything interesting here, we should definitely fix it to use the
> correct size, especially since this is actually something that
> can trigger a buffer overflow in subtle ways when used carelessly.
> See for example [1], which we still have not addressed

The footnote is missing.

> For this specific use (and probably others like it), renaming the
> fds_bits member to __kernel_fds_bits or something like that
> would keep user space still compiling. That would only break
> if someone was using __kernel_fd_set, and actually doing
> bit operations on it. glibc uses '__fds_bits' unless __USE_XOPEN
> is set, so maybe we should use use that name unconditionally.

Please use something that is more obviously Linux-specific.
