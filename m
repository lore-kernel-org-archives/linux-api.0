From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v0 01/11] stm class: Introduce an abstraction for System
 Trace Module devices
Date: Sat, 07 Mar 2015 23:26:32 +0100
Message-ID: <1425767192.2300.37.camel@x220>
References: <1425728161-164217-1-git-send-email-alexander.shishkin@linux.intel.com>
	 <1425728161-164217-2-git-send-email-alexander.shishkin@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425728161-164217-2-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, Pratik Patel <pratikp@codeaurora.org>, mathieu.poirier@linaro.org, peter.lachner@intel.com, norbert.schulz@intel.com, keven.boell@intel.com, yann.fouassier@intel.com, laurent.fert@intel.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, 2015-03-07 at 13:35 +0200, Alexander Shishkin wrote:
>  Documentation/ABI/testing/configfs-stp-policy    |  44 ++

git am whined about this file when I tried to apply this patch:
    Applying: stm class: Introduce an abstraction for System Trace Module devices
    [...]/.git/rebase-apply/patch:77: new blank line at EOF.

>  Documentation/ABI/testing/sysfs-class-stm        |  14 +
>  Documentation/ABI/testing/sysfs-class-stm_source |  11 +
>  Documentation/trace/stm.txt                      |  77 +++
>  drivers/Kconfig                                  |   2 +
>  drivers/Makefile                                 |   1 +
>  drivers/stm/Kconfig                              |   8 +
>  drivers/stm/Makefile                             |   3 +
>  drivers/stm/core.c                               | 839 +++++++++++++++++++++++
>  drivers/stm/policy.c                             | 470 +++++++++++++
>  drivers/stm/stm.h                                |  77 +++
>  include/linux/stm.h                              |  87 +++
>  include/uapi/linux/stm.h                         |  47 ++

> --- /dev/null
> +++ b/drivers/stm/Kconfig
> @@ -0,0 +1,8 @@
> +config STM
> +	tristate "System Trace Module devices"
> +	help
> +	  A System Trace Module (STM) is a device exporting data in System
> +	  Trace Protocol (STP) format as defined by MIPI STP standards.
> +	  Examples of such devices are Intel Trace Hub and Coresight STM.
> +
> +	  Say Y here to enable System Trace Module device support.
> diff --git a/drivers/stm/Makefile b/drivers/stm/Makefile
> new file mode 100644
> index 0000000000..adec701649
> --- /dev/null
> +++ b/drivers/stm/Makefile
> @@ -0,0 +1,3 @@
> +obj-$(CONFIG_STM)	+= stm_core.o
> +
> +stm_core-y		:= core.o policy.o

I tried to compile this as a module:
    $ make -C ../.. M=$PWD CONFIG_STM=m stm_core.ko
    make: Entering directory `[...]'
      LD [M]  [...]/drivers/stm/stm_core.o
    [...]/drivers/stm/policy.o: In function `stp_configfs_init':
    policy.c:(.text+0x5f0): multiple definition of `init_module'
    [...]/drivers/stm/core.o:core.c:(.init.text+0x0): first defined here
    make[1]: *** [[...]/drivers/stm/stm_core.o] Error 1
    make: *** [stm_core.ko] Error 2
    make: Leaving directory `[...]'

I think that's because
    postcore_initcall(stm_core_init);

in core.c becomes
    module_init(stm_core_init);

if this driver is compiled as a module. And that will clash with
    module_init(stp_configfs_init);

in policy.c. Am I missing something obvious or should STM not be a
tristate symbol?


Paul Bolle
