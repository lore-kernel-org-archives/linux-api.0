From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH v3 3/5] selftests/ipc: change test to use ksft framework
Date: Fri, 03 Oct 2014 13:01:07 -0700
Message-ID: <1412366467.20838.5.camel@linux-t7sj.site>
References: <cover.1412349412.git.shuahkh@osg.samsung.com>
	 <fb7ed86d44adbc7f97f9e42b314e4fce5616959e.1412349412.git.shuahkh@osg.samsung.com>
	 <1412357993.20838.4.camel@linux-t7sj.site>
	 <542EFC36.1010306@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <542EFC36.1010306-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2014-10-03 at 13:42 -0600, Shuah Khan wrote:
> On 10/03/2014 11:39 AM, Davidlohr Bueso wrote:
> > On Fri, 2014-10-03 at 09:36 -0600, Shuah Khan wrote:
> >>  	msgque.key = ftok(argv[0], 822155650);
> >>  	if (msgque.key == -1) {
> >> -		printf("Can't make key\n");
> >> -		return -errno;
> >> +		printf("Can't make key: %d\n", -errno);
> > 
> > So printing a numeric value is quite useless when users actually run
> > into these errors -- which is why I like err() so much. How about using
> > strerror() instead?
> > 
> 
> Yes. using perror() does give better information. There are other
> places in this file that use errno. How about I make that a separate
> patch and catch all of them at once to use perror() as a follow-up
> change? That way I fix all at once without adding more changes to
> this patch.

Sounds good.
