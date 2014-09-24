From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2 1/7] selftests: add kselftest framework for uniform
 test reporting
Date: Wed, 24 Sep 2014 16:06:03 -0600
Message-ID: <5423404B.2050400@osg.samsung.com>
References: <cover.1411506121.git.shuahkh@osg.samsung.com> <0b1961bd4d2104beafd2e8c1a17690f6efe14a61.1411506121.git.shuahkh@osg.samsung.com> <1411546144.30630.10.camel@linux-t7sj.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411546144.30630.10.camel-dxKd5G12XOI1EaDjlw0dpg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, thierry-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/24/2014 02:09 AM, Davidlohr Bueso wrote:

>> +/* counters */
>> +static int ksft_pass;
>> +static int ksft_fail;
>> +static int ksft_xfail;
>> +static int ksft_xpass;
>> +static int ksft_xskip;
> 
> unsigned int?

Yes unsigned int is a better choice.

> 
>> +static inline void ksft_inc_pass_cnt(void) { ksft_pass++; }
>> +static inline void ksft_inc_fail_cnt(void) { ksft_fail++; }
>> +static inline void ksft_inc_xfail_cnt(void) { ksft_xfail++; }
>> +static inline void ksft_inc_xpass_cnt(void) { ksft_xpass++; }
>> +static inline void ksft_inc_xskip_cnt(void) { ksft_xskip++; }
> 
> It would probably make sense to have the counters in a structures,
> something like: struct ksft_counter { ... } ksft_cnt;
> 
> Then just pass it around the proposed functions as arguments. That also
> minimizes a bit the global variables and would allow you to easily
> change it in the future.

How does the following look?

struct ksft_count
{
        unsigned int ksft_pass;
        unsigned int ksft_fail;
        unsigned int ksft_xfail;
        unsigned int ksft_xpass;
        unsigned int ksft_xskip;
};

static ksft_count ksft_cnt;

static inline void ksft_inc_pass_cnt(void) { ksft_cnt.ksft_pass++; }
static inline void ksft_inc_fail_cnt(void) { ksft_cnt.ksft_fail++; }
static inline void ksft_inc_xfail_cnt(void) { ksft_cnt.ksft_xfail++; }
static inline void ksft_inc_xpass_cnt(void) { ksft_cnt.ksft_xpass++; }
static inline void ksft_inc_xskip_cnt(void) { ksft_cnt.ksft_xskip++; }

With this approach, tests don't have to define their own counter
variable and pass it in. I am looking to abstract the framework
as much as possible.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
