From: Madars Vitolins <m@silodev.com>
Subject: Re: [PATCH] epoll: restrict EPOLLEXCLUSIVE to POLLIN and POLLOUT
Date: Fri, 05 Feb 2016 11:49:47 +0200
Message-ID: <994cbd84457a4986e03ad0c4369600fa@silodev.com>
References: <1454600344-23655-1-git-send-email-jbaron@akamai.com>
 <00ac7df620d4d0500b18af4a30034815@silodev.com>
 <20160204145952.53f536f5d4cdef96844104b7@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160204145952.53f536f5d4cdef96844104b7-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, hagen-GvnIQ6b/HdU@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Andrew Morton @ 2016-02-05 00:59 rakst=C4=ABja:
> On Thu, 04 Feb 2016 23:44:05 +0200 Madars Vitolins <m@silodev.com>=20
> wrote:
>=20
>> Hi Jason,
>>=20
>>=20
>> Just run off the original tests with this patch (eventpoll.c from
>> 4.5-rc2 + patch bellow). Got the same good results, no regression.
>>=20
>> $ time ./bankcl
>> Account balance is: 1359856158.04 USD
>> Account balance is: 1359856158.04 USD
>> Account balance is: 1359856158.04 USD
>> Account balance is: 1359856158.04 USD
>> Account balance is: 1359856158.04 USD
>> Account balance is: 1359856158.04 USD
>> Account balance is: 1359856158.04 USD
>> Account balance is: 1359856158.04 USD
>> Account balance is: 1359856158.04 USD
>> Account balance is: 101528948.40 USD
>>=20
>> real	0m41.826s
>> user	0m29.513s
>> sys	0m6.490s
>>=20
>>=20
>> Test case:
>> https://mvitolin.wordpress.com/2015/12/05/endurox-testing-epollexclu=
sive-flag/
>>=20
>> PS,
>>=20
>> Original cases 0m24.953s vs 0m41.826s now probably is related with m=
y=20
>> pc
>> setup. As I just now re-run test with original patch, got the same ~=
41
>> sec.
>>=20
>> So I am fine with this patch!
>>=20
>=20
> Thanks, I shall add your Tested-by:
>=20
> One thing we're sorely missing is an epoll test suite, in
> tools/testing/selftests.  If anyone has anything which we can use to
> kick things off, please hand it over ;)

Not bad idea, probably we need a "tools/testing/selftests/eventpoll"=20
folder under which we should have test cases for various epoll scenario=
s=20
with common "run.sh". In spare time I can try to build a case for=20
EXCLUSIVE flag (with queues & multiple processes :) ).

Thanks,
Madars
