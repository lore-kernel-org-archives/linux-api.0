From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH v4] selftest: size: Add size test for Linux kernel
Date: Wed, 26 Nov 2014 22:04:09 -0800
Message-ID: <20141127060409.GB2773@thin>
References: <5476A82B.2060903@sonymobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5476A82B.2060903-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 26, 2014 at 08:27:23PM -0800, Tim Bird wrote:
> --- /dev/null
> +++ b/tools/testing/selftests/size/Makefile
[...]
> +LIBGCC=$(shell $(CC) -print-libgcc-file-name)
> +
> +get_size: get_size.c
> +	$(CC) --static -ffreestanding -nostartfiles \
> +		-Wl,--entry=_start get_size.c $(LIBGCC) \
> +		-o get_size

You don't need -Wl,--entry=_start; that's the default.

You shouldn't need to manually find libgcc, either; the compiler should
do that for you.  What goes wrong if you don't include that?  If you're
trying to link libgcc statically, try -static-libgcc.

Also, static is normally spelled -static, not --static.

> --- /dev/null
> +++ b/tools/testing/selftests/size/get_size.c
[...]
> +int print(const char *s)

This function, and all the others apart from _start, should be declared
static.

> +void num_to_str(unsigned long num, char *s)

Likewise, static.

> +{
> +	unsigned long long temp, div;
> +	int started;
> +
> +	temp = num;
> +	div = 1000000000000000000LL;
> +	started = 0;
> +	while (div) {
> +		if (temp/div || started) {
> +			*s++ = (unsigned char)(temp/div + '0');
> +			started = 1;
> +		}
> +		temp -= (temp/div)*div;
> +		div /= 10;
> +	}
> +	*s = 0;
> +}

You'd probably end up with significantly smaller code (and no divisions,
and thus no corner cases on architectures that need a special function
to do unsigned long long division) if you print in hex.  You could also
drop the "no leading zeros" logic, and just *always* print a 64-bit
value as 16 hex digits.

> +int print_num(unsigned long num)

Likewise, static.

> +{
> +	char num_buf[30];
> +
> +	num_to_str(num, num_buf);
> +	return print(num_buf);
> +}
> +
> +int print_k_value(const char *s, unsigned long num, unsigned long units)
> +{
> +	unsigned long long temp;
> +	int ccode;
> +
> +	print(s);
> +
> +	temp = num;
> +	temp = (temp * units)/1024;
> +	num = temp;
> +	ccode = print_num(num);
> +	print("\n");
> +	return ccode;
> +}

I'd suggest dropping this entirely, and just always printing the exact
values returned by sysinfo.  Drop the multiply, too, and just print
info.mem_unit as well.  It's easy to post-process the value in a more
capable environment.

> +/* this program has no main(), as startup libraries are not used */
> +void _start(void)
> +{
> +	int ccode;
> +	struct sysinfo info;
> +	unsigned long used;
> +
> +	print("Testing system size.\n");
> +	print("1..1\n");
> +
> +	ccode = sysinfo(&info);
> +	if (ccode < 0) {
> +		print("not ok 1 get size runtime size\n");

Shouldn't the "not ok" here and the "ok" below have the same test
description?

> +		print("# could not get sysinfo\n");
> +		_exit(ccode);
> +	}
> +	/* ignore cache complexities for now */
> +	used = info.totalram - info.freeram - info.bufferram;
> +	print_k_value("ok 1 get runtime memory use # size = ", used,
> +		info.mem_unit);
> +
> +	print("# System runtime memory report (units in Kilobytes):\n");
> +	print_k_value("#   Total:  ", info.totalram, info.mem_unit);
> +	print_k_value("#   Free:   ", info.freeram, info.mem_unit);
> +	print_k_value("#   Buffer: ", info.bufferram, info.mem_unit);
> +	print_k_value("#   In use: ", used, info.mem_unit);
> +
> +	_exit(0);
> +}
> -- 
> 1.8.2.2
> 
