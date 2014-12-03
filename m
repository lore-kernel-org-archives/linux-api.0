From: Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
Subject: Re: [PATCH v4] selftest: size: Add size test for Linux kernel
Date: Tue, 2 Dec 2014 19:31:58 -0800
Message-ID: <547E842E.7030202@sonymobile.com>
References: <5476A82B.2060903@sonymobile.com> <20141127060409.GB2773@thin>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141127060409.GB2773@thin>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 11/26/2014 10:04 PM, Josh Triplett wrote:
> On Wed, Nov 26, 2014 at 08:27:23PM -0800, Tim Bird wrote:
>> --- /dev/null
>> +++ b/tools/testing/selftests/size/Makefile
> [...]
>> +LIBGCC=$(shell $(CC) -print-libgcc-file-name)
>> +
>> +get_size: get_size.c
>> +	$(CC) --static -ffreestanding -nostartfiles \
>> +		-Wl,--entry=_start get_size.c $(LIBGCC) \
>> +		-o get_size
> 
> You don't need -Wl,--entry=_start; that's the default.
OK - it works without this.  Thanks.

> You shouldn't need to manually find libgcc, either; the compiler should
> do that for you.  What goes wrong if you don't include that?  If you're
> trying to link libgcc statically, try -static-libgcc.
> 
> Also, static is normally spelled -static, not --static.

Hmm.  Not sure where I got --static from, but it worked.
But if -static is the norm I'm fine changing to that.

Upon experimentation, I don't need the explicit libgcc or for that
matter the -static-libgcc either.

>> --- /dev/null
>> +++ b/tools/testing/selftests/size/get_size.c
> [...]
>> +int print(const char *s)
> 
> This function, and all the others apart from _start, should be declared
> static.

OK will do.

>> +void num_to_str(unsigned long num, char *s)
> 
> Likewise, static.
OK

>> +{
>> +	unsigned long long temp, div;
>> +	int started;
>> +
>> +	temp = num;
>> +	div = 1000000000000000000LL;
>> +	started = 0;
>> +	while (div) {
>> +		if (temp/div || started) {
>> +			*s++ = (unsigned char)(temp/div + '0');
>> +			started = 1;
>> +		}
>> +		temp -= (temp/div)*div;
>> +		div /= 10;
>> +	}
>> +	*s = 0;
>> +}
> 
> You'd probably end up with significantly smaller code (and no divisions,
> and thus no corner cases on architectures that need a special function
> to do unsigned long long division) if you print in hex.  You could also
> drop the "no leading zeros" logic, and just *always* print a 64-bit
> value as 16 hex digits.

I'd like to keep base-10 output.  As far as size is concerned, the
code is now at well under 2 pages (8k), which is much smaller than
any actually useful program.  The only noticeable change in size would
be if I got it under 4096, but I don't want to sacrifice too many
features to get there (as that's still only 1 page difference in
memory usage.)

BTW - using sstrip, I can get it to 4096 already, as is.

Unfortunately, 'sstrip -z', which gets it to 2061, makes
it not work.  I need to check out what the problem is there.
Also, the ELF file still has an unneeded note section.  I think
easier reductions, without sacrificing functionality, are available
by tweaking the ELF header (ie fixing sstrip, for those that
want to use it).
 
>> +int print_num(unsigned long num)
> 
> Likewise, static.

OK

>> +{
>> +	char num_buf[30];
>> +
>> +	num_to_str(num, num_buf);
>> +	return print(num_buf);
>> +}
>> +
>> +int print_k_value(const char *s, unsigned long num, unsigned long units)
>> +{
>> +	unsigned long long temp;
>> +	int ccode;
>> +
>> +	print(s);
>> +
>> +	temp = num;
>> +	temp = (temp * units)/1024;
>> +	num = temp;
>> +	ccode = print_num(num);
>> +	print("\n");
>> +	return ccode;
>> +}
> 
> I'd suggest dropping this entirely, and just always printing the exact
> values returned by sysinfo.  Drop the multiply, too, and just print
> info.mem_unit as well.  It's easy to post-process the value in a more
> capable environment.

I'd prefer to keep the output easily human-readable.
 
>> +/* this program has no main(), as startup libraries are not used */
>> +void _start(void)
>> +{
>> +	int ccode;
>> +	struct sysinfo info;
>> +	unsigned long used;
>> +
>> +	print("Testing system size.\n");
>> +	print("1..1\n");
>> +
>> +	ccode = sysinfo(&info);
>> +	if (ccode < 0) {
>> +		print("not ok 1 get size runtime size\n");
> 
> Shouldn't the "not ok" here and the "ok" below have the same test
> description?
Yes.  Thanks.  Good catch.
 
>> +		print("# could not get sysinfo\n");
>> +		_exit(ccode);
>> +	}
>> +	/* ignore cache complexities for now */
>> +	used = info.totalram - info.freeram - info.bufferram;
>> +	print_k_value("ok 1 get runtime memory use # size = ", used,
>> +		info.mem_unit);
>> +
>> +	print("# System runtime memory report (units in Kilobytes):\n");
>> +	print_k_value("#   Total:  ", info.totalram, info.mem_unit);
>> +	print_k_value("#   Free:   ", info.freeram, info.mem_unit);
>> +	print_k_value("#   Buffer: ", info.bufferram, info.mem_unit);
>> +	print_k_value("#   In use: ", used, info.mem_unit);
>> +
>> +	_exit(0);
>> +}
>> -- 
>> 1.8.2.2

OK - look for a new version shortly (maybe not today, though).
 -- Tim
