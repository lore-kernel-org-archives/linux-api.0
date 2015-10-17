From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH] glibc: Remove CPU set size checking from affinity functions [BZ #19143]
Date: Sat, 17 Oct 2015 07:48:06 +0200
Message-ID: <87io66kpux.fsf@mid.deneb.enyo.de>
References: <5621126E.5080801@redhat.com> <20151017031003.GE28215@vapier.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-64221-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20151017031003.GE28215@vapier.lan> (Mike Frysinger's message of
	"Fri, 16 Oct 2015 23:10:03 -0400")
To: GNU C Library <libc-alpha@sourceware.org>
Cc: cgroups@vger.kernel.org, kosaki.motohiro@gmail.com, Linux API <linux-api@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
List-Id: linux-api@vger.kernel.org

* Mike Frysinger:

> On 16 Oct 2015 17:06, Florian Weimer wrote:
>> The current situation, briefly stated, is this: glibc tries to guess the
>> kernel CPU set size and rejects attempts to specify an affinity mask
>> which is larger than that, but it does not work, and glibc and the
>> kernel still silently accept CPU affinity masks with invalid bits,
>> without returning an error.  The glibc check does not provide any value
>> to applications, it just adds pointless complexity to the library.
>> Therefore, I want to remove it from glibc.
>
> checking the validty of the cpuset mask at the time of setting attributes
> seems fundamentally wrong to me.  can't the cpuset change too between the
> check and the actual use ?

Yes, unfortunately, that could happen.  There are algorithms that
would benefit if the affinity mask could not be changed from outside
the process.

> patch makes sense to me
>
>> +	  abort ();
>
> why does the test call abort instead of exit ?

It would have to be _exit, because otherwise, the remaining running
threads would block exiting.

> abort writes to stderr.

I don't think so, =E2=80=9CAborted=E2=80=9D is printed by the shell.
