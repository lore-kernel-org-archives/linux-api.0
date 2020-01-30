From: Elichai Turkel <elichai.turkel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Including both linux/time.h and linux/input.h causes failure
Date: Thu, 30 Jan 2020 16:12:31 +0200
Message-ID: <CALN7hCKre=Fkp35UAN_ao09yGwk4uMxpt9NpGHaHt2yXZFzvow@mail.gmail.com>
References: <CALN7hC+f+D8xsaJBt+MCXDfk51oHCoQeUVmFydNdkW+_DeqTiw@mail.gmail.com>
 <88ab5e38-254a-430d-67cf-1840b0e51c35@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <88ab5e38-254a-430d-67cf-1840b0e51c35-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Mostly I need the uid_t type for syscalls(getuid/setuid)
Which is defined in sys/types.h but that header also includes time
related stuff.

For context I'm writing a libc equivilant library (in rust).

Thanks,
Elichai.

On Wed, Jan 29, 2020 at 7:16 PM Carlos O'Donell <codonell-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 1/29/20 10:14 AM, Elichai Turkel wrote:
> > Hi,
> > The following header: <wrapper.h>:
> > ```
> > #include <linux/input.h>
> > #include <linux/time.h>
> > ```
> > Will cause the compiler to fail because of redefinition of a lot of
> > time related structs, that are declared once in `linux/time.h` and
> > then again via `bits/types/struct_timeval.h` which is included through
> > `linux/input.h > sys/time.h -> bits/types/struct_timeval.h`
>
> This is another header-coordination issue between the kernel and libc.
>
> In this case it's linux/time.h vs. sys/time.h.
>
> "Synchronizing Headers"
> https://sourceware.org/glibc/wiki/Synchronizing_Headers
> - Just added your case.
>
> It's not immediate clear to me if the UAPI header is clean enough to
> use directly in glibc or not, and that's often the simplest way to fix
> things.
>
> When you can't just use the kernel header definitions then you have
> to work through the conflict and decide if you want to allow both headers
> to be potentially included and in which orders to support it.
>
> Why do you need both headers included?
>
> --
> Cheers,
> Carlos.
>


-- 
PGP: 5607C93B5F86650C
