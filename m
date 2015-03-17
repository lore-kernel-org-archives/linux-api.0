From: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v0 01/11] stm class: Introduce an abstraction for System Trace Module devices
Date: Tue, 17 Mar 2015 12:13:47 +0200
Message-ID: <87pp88dj8k.fsf@ashishki-desk.ger.corp.intel.com>
References: <1425728161-164217-1-git-send-email-alexander.shishkin@linux.intel.com> <1425728161-164217-2-git-send-email-alexander.shishkin@linux.intel.com> <1425767192.2300.37.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425767192.2300.37.camel@x220>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org> writes:

> On Sat, 2015-03-07 at 13:35 +0200, Alexander Shishkin wrote:
>>  Documentation/ABI/testing/configfs-stp-policy    |  44 ++
>
> git am whined about this file when I tried to apply this patch:
>     Applying: stm class: Introduce an abstraction for System Trace Module devices
>     [...]/.git/rebase-apply/patch:77: new blank line at EOF.
>
>>  Documentation/ABI/testing/sysfs-class-stm        |  14 +
>>  Documentation/ABI/testing/sysfs-class-stm_source |  11 +
>>  Documentation/trace/stm.txt                      |  77 +++
>>  drivers/Kconfig                                  |   2 +
>>  drivers/Makefile                                 |   1 +
>>  drivers/stm/Kconfig                              |   8 +
>>  drivers/stm/Makefile                             |   3 +
>>  drivers/stm/core.c                               | 839 +++++++++++++++++++++++
>>  drivers/stm/policy.c                             | 470 +++++++++++++
>>  drivers/stm/stm.h                                |  77 +++
>>  include/linux/stm.h                              |  87 +++
>>  include/uapi/linux/stm.h                         |  47 ++
>
>> --- /dev/null
>> +++ b/drivers/stm/Kconfig
>> @@ -0,0 +1,8 @@
>> +config STM
>> +	tristate "System Trace Module devices"
>> +	help
>> +	  A System Trace Module (STM) is a device exporting data in System
>> +	  Trace Protocol (STP) format as defined by MIPI STP standards.
>> +	  Examples of such devices are Intel Trace Hub and Coresight STM.
>> +
>> +	  Say Y here to enable System Trace Module device support.
>> diff --git a/drivers/stm/Makefile b/drivers/stm/Makefile
>> new file mode 100644
>> index 0000000000..adec701649
>> --- /dev/null
>> +++ b/drivers/stm/Makefile
>> @@ -0,0 +1,3 @@
>> +obj-$(CONFIG_STM)	+= stm_core.o
>> +
>> +stm_core-y		:= core.o policy.o
>
> I tried to compile this as a module:
>     $ make -C ../.. M=$PWD CONFIG_STM=m stm_core.ko
>     make: Entering directory `[...]'
>       LD [M]  [...]/drivers/stm/stm_core.o
>     [...]/drivers/stm/policy.o: In function `stp_configfs_init':
>     policy.c:(.text+0x5f0): multiple definition of `init_module'
>     [...]/drivers/stm/core.o:core.c:(.init.text+0x0): first defined here
>     make[1]: *** [[...]/drivers/stm/stm_core.o] Error 1
>     make: *** [stm_core.ko] Error 2
>     make: Leaving directory `[...]'
>
> I think that's because
>     postcore_initcall(stm_core_init);
>
> in core.c becomes
>     module_init(stm_core_init);
>
> if this driver is compiled as a module. And that will clash with
>     module_init(stp_configfs_init);
>
> in policy.c. Am I missing something obvious or should STM not be a
> tristate symbol?

My mistake, I think I fancied the policy to be a separate module in the
beginning. But I don't see why STM shouldn't be a tristate after the
above is fixed.

Thanks,
--
Alex
