From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] selftests/memfd: fix mfd_fail_open() to pass in buf to
 printf
Date: Thu, 04 Sep 2014 09:21:31 -0600
Message-ID: <5408837B.6040008@osg.samsung.com>
References: <1409843242-6596-1-git-send-email-shuahkh@osg.samsung.com> <CAJhHMCCuyC3HUfUktTpkQcxnqJDpA2O0Gqc8wZMq0TwB5PeY6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJhHMCCuyC3HUfUktTpkQcxnqJDpA2O0Gqc8wZMq0TwB5PeY6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "open list:KERNEL SELFTEST F..." <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/04/2014 09:16 AM, Pranith Kumar wrote:
> On Thu, Sep 4, 2014 at 11:07 AM, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>=
 wrote:
>> mfd_fail_open() doesn't pass in the buffer to printf resulting
>> in the following warning:
>>
>> memfd_test.c: In function =E2=80=98mfd_fail_open=E2=80=99:
>> memfd_test.c:208:3: warning: format =E2=80=98%s=E2=80=99 expects a m=
atching =E2=80=98char *=E2=80=99 argument [-Wformat=3D]
>>    printf("open(%s) didn't fail as expected\n");
>>    ^
>>
>> This change fixes the problem.
>>
>> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>=20
> Hi Shuah,
>=20
> I already sent in a patch to fix this:
>=20
> https://lkml.org/lkml/2014/8/31/85
>=20
> Can you please pick that up?

Hi Pranith,

Great. Could you please resend it to me cc'ing linux-api as well.

thanks,
-- Shuah


--=20
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
