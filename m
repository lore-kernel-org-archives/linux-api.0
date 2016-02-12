From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: Re: [PATCH 1/4] selftests: Add test for sigaltstack(SS_DISABLE)
 inside sighandler
Date: Fri, 12 Feb 2016 19:17:02 +0300
Message-ID: <56BE057E.4050101@list.ru>
References: <56AE3369.2090709@list.ru> <56AE33D7.1090708@list.ru>
 <56BE046D.4080203@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BE046D.4080203-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

12.02.2016 19:12, Shuah Khan =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On 01/31/2016 09:18 AM, Stas Sergeev wrote:
>>
>> sigaltstack needs to be disabled before the signal handler can
>> safely use swapcontext(). Unfortunately linux implementation of
>> sigaltstack() returns EPERM in that case.
>> Re-enabling is also needed and tested.
>>
>> CC: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>>
>> Signed-off-by: Stas Sergeev <stsp-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
>=20
> Hi Stas,
>=20
> Is this patch v4 or Patch 1/4. Confirming to see if
> I am missing 3 patches or this is supposed to be
> version 4 of a single patch.
Hi, I used get_maintainer.pl for the CC list, so you indeed
were CCed with just this patch, which is one of 4.
The series were however rejected, and I am planning to submit
another one later.
