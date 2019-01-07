From: Kees Cook <keescook@chromium.org>
Subject: Re: [RESEND PATCH v3 0/2] sysctl: handle overflow for file-max
Date: Mon, 7 Jan 2019 15:16:42 -0800
Message-ID: <CAGXu5jJQgZDec1+WnsU6ttVaMb6j5oqtJ7Zw_YYn4RgWgvc0SA@mail.gmail.com>
References: <20190107222700.15954-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190107222700.15954-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, Waiman Long <longman@redhat.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 7, 2019 at 2:27 PM Christian Brauner <christian@brauner.io> wrote:
>
> Hey,
>
> Here is v3 of this patchset. Changelogs are in the individual commits.

Andrew, can you take these? I've already Acked them.

-Kees

>
> Currently, when writing
>
> echo 18446744073709551616 > /proc/sys/fs/file-max
>
> /proc/sys/fs/file-max will overflow and be set to 0. That quickly
> crashes the system.
>
> The first version of this patch intended to detect the overflow and cap
> at ULONG_MAX. However, we should not do this and rather return EINVAL on
> overflow. The reasons are:
> - this aligns with other sysctl handlers that simply reject overflows
>   (cf. [1], [2], and a bunch of others)
> - we already do a partial fail on overflow right now
>   Namely, when the TMPBUFLEN is exceeded. So we already reject values
>   such as 184467440737095516160 (21 chars) but accept values such as
>   18446744073709551616 (20 chars) but both are overflows. So we should
>   just always reject 64bit overflows and not special-case this based on
>   the number of chars.
>
> (This patchset is in reference to https://lkml.org/lkml/2018/10/11/585.)
>
> Thanks!
> Christian
>
> [1]: fb910c42cceb ("sysctl: check for UINT_MAX before unsigned int min/max")
> [2]: 196851bed522 ("s390/topology: correct topology mode proc handler")
>
> Christian Brauner (2):
>   sysctl: handle overflow in proc_get_long
>   sysctl: handle overflow for file-max
>
>  kernel/sysctl.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 46 insertions(+), 1 deletion(-)
>
> --
> 2.19.1
>


-- 
Kees Cook
