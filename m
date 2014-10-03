From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH v3 3/5] selftests/ipc: change test to use ksft framework
Date: Fri, 03 Oct 2014 10:39:53 -0700
Message-ID: <1412357993.20838.4.camel@linux-t7sj.site>
References: <cover.1412349412.git.shuahkh@osg.samsung.com>
	 <fb7ed86d44adbc7f97f9e42b314e4fce5616959e.1412349412.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fb7ed86d44adbc7f97f9e42b314e4fce5616959e.1412349412.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org, colin.king@canonical.com, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 2014-10-03 at 09:36 -0600, Shuah Khan wrote:
>  	msgque.key = ftok(argv[0], 822155650);
>  	if (msgque.key == -1) {
> -		printf("Can't make key\n");
> -		return -errno;
> +		printf("Can't make key: %d\n", -errno);

So printing a numeric value is quite useless when users actually run
into these errors -- which is why I like err() so much. How about using
strerror() instead?

Thanks,
Davidlohr
