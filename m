From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [PATCH 0/2] selftests/mlock2: Build warning fixes on Debian/m68k 4.0
Date: Mon, 9 Nov 2015 21:43:37 +0100
Message-ID: <CAMuHMdV3cUafEh-_m199ta14RcM4FmyxXMHt_WiL75wtHfVO6g@mail.gmail.com>
References: <1447064069-21469-1-git-send-email-geert@linux-m68k.org>
	<20151109154836.GA28486@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151109154836.GA28486-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Eric,

[CC linux-arch for more architecture-specific breakage]

On Mon, Nov 9, 2015 at 4:48 PM, Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 09 Nov 2015, Geert Uytterhoeven wrote:
>> The following 2 patches are needed to fix build warnings on Debian/m68k
>> 4.0.
>>
>> However, after wiring up the mlock2 syscall, the test fails with:
>>
>> # ./mlock2-tests
>> fread kpageflags: Success
>> #
>>
>> as the fread() call returns 0, not 1.
>
> This would fail is the index into the kpageflags file is not being
> calculated properly.  This tests works on x86_64 (I am in the process of
> testing x86 incase this is a 32bit issue).  I am fairly sure that I
> tested it on x86, but it has been a while.

Found it: /proc/kpageflags is always empty, as m68k doesn't set up max_pfn.

After fixing that, the test is working fine.
Funny how we managed to survive that long without setting it ;-)

Note that several other architectures also don't set max_pfn. Some may
be nommu, and are thus not affected, but others probably are:

    hexagon
    mn10300
    nios2
    score

And a few of the others (e.g. avr32, didn't check all of them) assign to a
local max_pfn variable instead of the global one, so it won't work on those
neither.

>> The original commit description for the test said "Note that the limit
>> test needs to be run a normal user.". But running it as a non-root user
>> also fails:
>
> The original commit says that the on-fault-limit test needs to be run as
> a regular user becuase it relies on enforcing memory limits.
> mlock2-tests has to be run as root to get access to the various files
> under /proc it needs to verify things are working.

Ah, I just used "git log -p" on mlock2-tests.c, and didn't notice the commit
actually added two tests.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
