From: Carlos O'Donell <codonell-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Including both linux/time.h and linux/input.h causes failure
Date: Wed, 29 Jan 2020 12:16:26 -0500
Message-ID: <88ab5e38-254a-430d-67cf-1840b0e51c35@redhat.com>
References: <CALN7hC+f+D8xsaJBt+MCXDfk51oHCoQeUVmFydNdkW+_DeqTiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALN7hC+f+D8xsaJBt+MCXDfk51oHCoQeUVmFydNdkW+_DeqTiw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Elichai Turkel <elichai.turkel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 1/29/20 10:14 AM, Elichai Turkel wrote:
> Hi,
> The following header: <wrapper.h>:
> ```
> #include <linux/input.h>
> #include <linux/time.h>
> ```
> Will cause the compiler to fail because of redefinition of a lot of
> time related structs, that are declared once in `linux/time.h` and
> then again via `bits/types/struct_timeval.h` which is included through
> `linux/input.h > sys/time.h -> bits/types/struct_timeval.h`
 
This is another header-coordination issue between the kernel and libc.

In this case it's linux/time.h vs. sys/time.h.

"Synchronizing Headers"
https://sourceware.org/glibc/wiki/Synchronizing_Headers
- Just added your case.

It's not immediate clear to me if the UAPI header is clean enough to
use directly in glibc or not, and that's often the simplest way to fix
things.

When you can't just use the kernel header definitions then you have
to work through the conflict and decide if you want to allow both headers
to be potentially included and in which orders to support it.

Why do you need both headers included?

-- 
Cheers,
Carlos.
