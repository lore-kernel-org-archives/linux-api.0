From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Seccomp implications for glibc wrapper function changes
Date: Thu, 9 Nov 2017 08:17:50 +0100
Message-ID: <CAKgNAkhLsBNVO9axSxwH8VNxBW1QPWjaEOS_ubu-nUZ7_gsn7w@mail.gmail.com>
References: <CAKgNAkixA6T7J_1Gs=5+riq6i=dr9XP4ZCGu67YVcuDNg3cT4g@mail.gmail.com>
 <0049d6a8-de25-ff02-31ef-38a7db05b878@redhat.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <libc-alpha-return-86933-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <0049d6a8-de25-ff02-31ef-38a7db05b878@redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>, Linux API <linux-api@vger.kernel.org>, Adhemerval Zanella <adhemerval.zanella@linaro.org>
List-Id: linux-api@vger.kernel.org

Hi Florian,

On 8 November 2017 at 07:24, Florian Weimer <fweimer@redhat.com> wrote:
> On 11/07/2017 09:35 PM, Michael Kerrisk (man-pages) wrote:
>>
>> This change broke my code that was doing seccomp filtering for the
>> open() system call number (__NR_open). The breakage in question is not
>> serious, since this was really just demonstration code. However, I
>> want to raise awareness that these sorts of changes have the potential
>> to possibly cause breakages for some code using seccomp, and note that
>> I think such changes should not be made lightly or gratuitously.
>
>
> I have the opposite view: We should make such changes as often as possible,
> to remind people that seccomp filters (and certain SELinux and AppArmor
> policies) are incompatible with the GNU/Linux model, where everything is
> developed separately and not maintained within a single source tree (unlike
> say OpenBSD).  This means that you really can't deviate from the upstream
> Linux userspace ABI (in the broadest possible sense) and still expect things
> to work.
>
> I know that people like to slap seccomp filters on everything today, but
> without careful examination, that is likely to introduce bugs (particularly
> on rarely used code paths).  It can also cause the process to switch to
> legacy interfaces with known issues (e.g., reading from /dev/urandom instead
> of getrandom, without waiting for the kernel to signal initialization of the
> pool).

Thanks. The above is a good summary of the counterpoints to my initial argument.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
