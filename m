From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 0/9] posix_clocks: Prepare syscalls for 64 bit time_t conversion
Date: Fri, 17 Nov 2017 00:42:35 +0100
Message-ID: <CAK8P3a0wxs59T1zW4ahbJXeW6QjStm0mbCFoL_RQexAa6dzh_w@mail.gmail.com>
References: <20171110224259.15930-1-deepa.kernel@gmail.com>
 <CAK8P3a2uD=xV5GKtL+nhVoPckb6uoXztEvXK-iP_OYbct8QvJA@mail.gmail.com>
 <CABeXuvpy1jbqjeUFHHX-MrJXQLA2QNYbAa6OX7qOpPp4q-mQYQ@mail.gmail.com> <alpine.DEB.2.20.1711160958430.2191@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1711160958430.2191@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Deepa Dinamani <deepa.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, y2038 Mailman List <y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, cohuck-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, gerald.schaefer-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, gregkh <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Jan Hoeppner <hoeppner-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>, Julian
List-Id: linux-api@vger.kernel.org

On Thu, Nov 16, 2017 at 10:04 AM, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> On Wed, 15 Nov 2017, Deepa Dinamani wrote:
>> > I had on concern about x32, maybe we should check
>> > for "COMPAT_USE_64BIT_TIME" before zeroing out the tv_nsec
>> > bits.
>>
>> Thanks, I think you are right. I had the check conditional on
>> CONFIG_64BIT_TIME and then removed as I forgot why I added it. :)
>>
>> > Regarding CONFIG_COMPAT_TIME/CONFIG_64BIT_TIME, would
>> > it help to just leave out that part for now and unconditionally
>> > define '__kernel_timespec' as 'timespec' until we are ready to
>> > convert the architectures?
>>
>> Another approach would be to use separate configs:
>>
>> 1. To indicate 64 bit time_t syscall support. This will be dependent
>> on architectures as CONFIG_64BIT_TIME.
>> We can delete this once all architectures have provided support for this.
>>
>> 2. Another config (maybe COMPAT_32BIT_TIME?) to be introduced later,
>> which will compile out all syscalls/ features that use 32 bit time_t.
>> This can help build a y2038 safe kernel later.
>>
>> Would this work for everyone?
>
> Having extra config switches which are selectable by architectures and
> removed when everything is converted is definitely the right way to go.
>
> That allows you to gradually convert stuff w/o inflicting wreckage all over
> the place.

The CONFIG_64BIT_TIME would do that nicely for the new stuff like
the conditional definition of __kernel_timespec, this one would get
removed after we convert all architectures.

A second issue is how to control the compilation of the compat syscalls.
CONFIG_COMPAT_32BIT_TIME handles that and could be defined
in Kconfig as 'def_bool (!64BIT && CONFIG_64BIT_TIME) || COMPAT',
this is then just a more readable way of expressing exactly when the
functions should be built.

For completeness, there may be a third category, depending on how
we handle things like sys_nanosleep(): Here, we want the native
sys_nanosleep on 64-bit architectures, and compat_sys_nanosleep()
to handle the 32-bit time_t variant on both 32-bit and 64-bit targets,
but our plan is to not have a native 32-bit sys_nanosleep on 32-bit
architectures any more, as new glibc should call clock_nanosleep()
with a new syscall number instead. Should we then enclose
sys_nanosleep in "#if !defined(CONFIG_64BIT_TIME) ||
defined(CONFIG_64BIT)", or should we try to come up with another
Kconfig symbol name that expresses this better?

       Arnd
