From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Seccomp implications for glibc wrapper function changes
Date: Wed, 8 Nov 2017 07:24:04 +0100
Message-ID: <0049d6a8-de25-ff02-31ef-38a7db05b878@redhat.com>
References: <CAKgNAkixA6T7J_1Gs=5+riq6i=dr9XP4ZCGu67YVcuDNg3cT4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkixA6T7J_1Gs=5+riq6i=dr9XP4ZCGu67YVcuDNg3cT4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Adhemerval Zanella <adhemerval.zanella-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/07/2017 09:35 PM, Michael Kerrisk (man-pages) wrote:
> This change broke my code that was doing seccomp filtering for the
> open() system call number (__NR_open). The breakage in question is not
> serious, since this was really just demonstration code. However, I
> want to raise awareness that these sorts of changes have the potential
> to possibly cause breakages for some code using seccomp, and note that
> I think such changes should not be made lightly or gratuitously.

I have the opposite view: We should make such changes as often as 
possible, to remind people that seccomp filters (and certain SELinux and 
AppArmor policies) are incompatible with the GNU/Linux model, where 
everything is developed separately and not maintained within a single 
source tree (unlike say OpenBSD).  This means that you really can't 
deviate from the upstream Linux userspace ABI (in the broadest possible 
sense) and still expect things to work.

I know that people like to slap seccomp filters on everything today, but 
without careful examination, that is likely to introduce bugs 
(particularly on rarely used code paths).  It can also cause the process 
to switch to legacy interfaces with known issues (e.g., reading from 
/dev/urandom instead of getrandom, without waiting for the kernel to 
signal initialization of the pool).

Thanks,
Florian
