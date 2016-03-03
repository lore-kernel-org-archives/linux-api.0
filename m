From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] selftests: add a new test for Media Controller API
Date: Thu, 3 Mar 2016 08:49:40 -0300
Message-ID: <20160303084940.6897009e@recife.lan>
References: <1455327594-8498-1-git-send-email-shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455327594-8498-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-media@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Em Fri, 12 Feb 2016 18:39:54 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> This test opens user specified Media Device and calls
> MEDIA_IOC_DEVICE_INFO ioctl in a loop once every 10
> seconds. This test is for detecting errors in device
> removal path.
> 
> Usage:
>     sudo ./media_devkref_test -d /dev/mediaX
> 
> While test is running, remove the device and
> ensure there are no use after free errors and
> other Oops in the dmesg. Enable KaSan kernel
> config option for use-after-free error detection.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

Looks good to me.

Reviewed-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

> ---
>  tools/testing/selftests/media_tests/.gitignore     |  1 +
>  tools/testing/selftests/media_tests/Makefile       |  7 ++
>  .../selftests/media_tests/media_device_test.c      | 94 ++++++++++++++++++++++
>  3 files changed, 102 insertions(+)
>  create mode 100644 tools/testing/selftests/media_tests/.gitignore
>  create mode 100644 tools/testing/selftests/media_tests/Makefile
>  create mode 100644 tools/testing/selftests/media_tests/media_device_test.c
> 
> diff --git a/tools/testing/selftests/media_tests/.gitignore b/tools/testing/selftests/media_tests/.gitignore
> new file mode 100644
> index 0000000..1c07117
> --- /dev/null
> +++ b/tools/testing/selftests/media_tests/.gitignore
> @@ -0,0 +1 @@
> +media_device_test
> diff --git a/tools/testing/selftests/media_tests/Makefile b/tools/testing/selftests/media_tests/Makefile
> new file mode 100644
> index 0000000..7071bcc
> --- /dev/null
> +++ b/tools/testing/selftests/media_tests/Makefile
> @@ -0,0 +1,7 @@
> +TEST_PROGS := media_device_test
> +all: $(TEST_PROGS)
> +
> +include ../lib.mk
> +
> +clean:
> +	rm -fr media_device_test
> diff --git a/tools/testing/selftests/media_tests/media_device_test.c b/tools/testing/selftests/media_tests/media_device_test.c
> new file mode 100644
> index 0000000..a47880b
> --- /dev/null
> +++ b/tools/testing/selftests/media_tests/media_device_test.c
> @@ -0,0 +1,94 @@
> +/*
> + * media_devkref_test.c - Media Controller Device Kref API Test
> + *
> + * Copyright (c) 2016 Shuah Khan <shuahkh@osg.samsung.com>
> + * Copyright (c) 2016 Samsung Electronics Co., Ltd.
> + *
> + * This file is released under the GPLv2.
> + */
> +
> +/*
> + * This file adds a test for Media Controller API.
> + * This test should be run as root and should not be
> + * included in the Kselftest run. This test should be
> + * run when hardware and driver that makes use Media
> + * Controller API are present in the system.
> + *
> + * This test opens user specified Media Device and calls
> + * MEDIA_IOC_DEVICE_INFO ioctl in a loop once every 10
> + * seconds.
> + *
> + * Usage:
> + *	sudo ./media_devkref_test -d /dev/mediaX
> + *
> + *	While test is running, remove the device and
> + *	ensure there are no use after free errors and
> + *	other Oops in the dmesg. Enable KaSan kernel
> + *	config option for use-after-free error detection.
> +*/
> +
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <errno.h>
> +#include <string.h>
> +#include <fcntl.h>
> +#include <sys/ioctl.h>
> +#include <sys/stat.h>
> +#include <linux/media.h>
> +
> +int main(int argc, char **argv)
> +{
> +	int opt;
> +	char media_device[256];
> +	int count = 0;
> +	struct media_device_info mdi;
> +	int ret;
> +	int fd;
> +
> +	if (argc < 2) {
> +		printf("Usage: %s [-d </dev/mediaX>]\n", argv[0]);
> +		exit(-1);
> +	}
> +
> +	/* Process arguments */
> +	while ((opt = getopt(argc, argv, "d:")) != -1) {
> +		switch (opt) {
> +		case 'd':
> +			strncpy(media_device, optarg, sizeof(media_device) - 1);
> +			media_device[sizeof(media_device)-1] = '\0';
> +			break;
> +		default:
> +			printf("Usage: %s [-d </dev/mediaX>]\n", argv[0]);
> +			exit(-1);
> +		}
> +	}
> +
> +	if (getuid() != 0) {
> +		printf("Please run the test as root - Exiting.\n");
> +		exit(-1);
> +	}
> +
> +	/* Open Media device and keep it open */
> +	fd = open(media_device, O_RDWR);
> +	if (fd == -1) {
> +		printf("Media Device open errno %s\n", strerror(errno));
> +		exit(-1);
> +	}
> +
> +	printf("\nNote:\n"
> +	       "While test is running, remove the device and\n"
> +	       "ensure there are no use after free errors and\n"
> +	       "other Oops in the dmesg. Enable KaSan kernel\n"
> +	       "config option for use-after-free error detection.\n\n");
> +
> +	while (count < 100) {
> +		ret = ioctl(fd, MEDIA_IOC_DEVICE_INFO, &mdi);
> +		if (ret < 0)
> +			printf("Media Device Info errno %s\n", strerror(errno));
> +		printf("Media device model %s driver %s\n",
> +			mdi.model, mdi.driver);
> +		sleep(10);
> +		count++;
> +	}
> +}


-- 
Thanks,
Mauro
