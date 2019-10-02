From: Helge Deller <deller@gmx.de>
Subject: Re: [RFC][PATCH] sysctl: Remove the sysctl system call
Date: Wed, 2 Oct 2019 20:52:22 +0200
Message-ID: <1dc9f6c4-d1ff-8add-4d42-1c2d1ae685f6@gmx.de>
References: <8736gcjosv.fsf@x220.int.ebiederm.org>
 <201910011140.EA0181F13@keescook> <87imp8hyc8.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87imp8hyc8.fsf@x220.int.ebiederm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>, Cong Wang <xiyou.wangcong@gmail.com>, Luis Chamberlain <mcgrof@kernel.org>, Apelete Seketeli <apelete@seketeli.net>, Arnd Bergmann <arnd@arndb.de>, Chee Nouk Phoon <cnphoon@altera.com>, Chris Zankel <chris@zankel.net>, Christian Ruppert <christian.ruppert@abilis.com>, Greg Ungerer <gerg@uclinux.org>, Hongliang Tao <taohl@lemote.com>, Huacai Chen <chenhc@lemote.com>, Jonas Jensen <jonas.jensen@gmail.com>, Josh Boyer <jwboyer@gmail.com>, Jun Nie <jun.nie@linaro.org>, Lars-Peter Clausen <lars@metafoo.de>, Ley Foon Tan <lftan@altera.com>Lin
List-Id: linux-api@vger.kernel.org

On 02.10.19 00:53, Eric W. Biederman wrote:
> Kees Cook <keescook@chromium.org> writes:
>>> As there appear to be no users of the sysctl system call, remove the
>>> code....>...
> I copied everyone who had put this into a defconfig and I will wait a
> little more to see if anyone screams.  I think it is a safe guess that
> several of the affected configurations are dead (or at least
> unmaintained) as I received 17 bounces when copying everyone.

  arch/parisc/configs/c8000_defconfig         |    1 -
  arch/parisc/configs/generic-32bit_defconfig |    1 -

I'm not aware that we require the sysctl syscall somewhere on parisc,
so I think it's safe to remove the code.

Helge
