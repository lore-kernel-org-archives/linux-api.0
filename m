From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v3 3/5] selftests/ipc: change test to use ksft framework
Date: Fri, 03 Oct 2014 13:42:46 -0600
Message-ID: <542EFC36.1010306@osg.samsung.com>
References: <cover.1412349412.git.shuahkh@osg.samsung.com> <fb7ed86d44adbc7f97f9e42b314e4fce5616959e.1412349412.git.shuahkh@osg.samsung.com> <1412357993.20838.4.camel@linux-t7sj.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412357993.20838.4.camel-dxKd5G12XOI1EaDjlw0dpg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/03/2014 11:39 AM, Davidlohr Bueso wrote:
> On Fri, 2014-10-03 at 09:36 -0600, Shuah Khan wrote:
>>  	msgque.key = ftok(argv[0], 822155650);
>>  	if (msgque.key == -1) {
>> -		printf("Can't make key\n");
>> -		return -errno;
>> +		printf("Can't make key: %d\n", -errno);
> 
> So printing a numeric value is quite useless when users actually run
> into these errors -- which is why I like err() so much. How about using
> strerror() instead?
> 

Yes. using perror() does give better information. There are other
places in this file that use errno. How about I make that a separate
patch and catch all of them at once to use perror() as a follow-up
change? That way I fix all at once without adding more changes to
this patch.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
