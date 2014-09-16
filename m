From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 1/7] selftests: add header file for test exit code defines
Date: Tue, 16 Sep 2014 11:47:42 -0600
Message-ID: <541877BE.5080903@osg.samsung.com>
References: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com> <1410820442-8774-2-git-send-email-shuahkh@osg.samsung.com> <1410883441.4630.9.camel@linux-t7sj.site> <54187400.10506@osg.samsung.com> <CALCETrUw21Bgd9N4wakP08OiFshxzPS6wBE6=Fd2K=k33RDgXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUw21Bgd9N4wakP08OiFshxzPS6wBE6=Fd2K=k33RDgXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, thierry-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, felipensp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/16/2014 11:40 AM, Andy Lutomirski wrote:
> On Tue, Sep 16, 2014 at 10:31 AM, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:

> 
> I think we will want a framework in the tree, but it can be very
> minimal.  But I also think that using exit(2) for this is wrong.  Why
> not:
> 
> enum ktest_result {
>   KTEST_PASS,
>   ...,
> };
> 
> void ktest_exit(enum ktest_result result);
> 
> With the possibility of further extensions for more than one test (and
> associated result) per execution of the test binary.
> 

Nothing wrong with the approach. It is one of the options I considered
and decided against it primarily because tests need more changes than
the ones needed for return codes. However, maybe it is worth while to
do so. I will play with this and see how extensive the changes are.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
