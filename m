From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH glibc 2.31 1/5] glibc: Perform rseq(2) registration at C startup and thread creation (v12)
Date: Wed, 11 Sep 2019 21:54:23 +0200
Message-ID: <877e6er4ls.fsf@oldenburg2.str.redhat.com>
References: <20190807142726.2579-1-mathieu.desnoyers@efficios.com>
        <20190807142726.2579-2-mathieu.desnoyers@efficios.com>
        <8736h2sn8y.fsf@oldenburg2.str.redhat.com>
        <7db64714-3dc5-b322-1edc-736b08ee7d63@redhat.com>
        <87ef0mr6qj.fsf@oldenburg2.str.redhat.com>
        <4a6f6326-ea82-e031-0fe0-7263ed97e797@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4a6f6326-ea82-e031-0fe0-7263ed97e797@redhat.com> (Carlos
        O'Donell's message of "Wed, 11 Sep 2019 15:45:14 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Carlos O'Donell <carlos@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Carlos O'Donell:

> On 9/11/19 3:08 PM, Florian Weimer wrote:
>> * Carlos O'Donell:
>> 
>>> It would be easier to merge the patch set if it were just an unconditional
>>> registration like we do for set_robust_list().
>> 
>> Note that this depends on the in-tree system call numbers list, which I
>> still need to finish according to Joseph's specifications.
>
> Which work is this? Do you have a URL reference to WIP?

  <https://sourceware.org/ml/libc-alpha/2019-05/msg00630.html>
  <https://sourceware.org/ml/libc-alpha/2019-06/msg00015.html>

I think realistically this is needed for the Y2038 work as well if we
want to support building glibc with older kernel headers.  “glibc 2.31
will have Y2038 support and rseq support, but only if it runs on a
current and it happens to have been built against sufficiently recent
kernel headers” is a bit difficult to explain.  The current kernel part
is easy enough to understand, but the impact of the kernel headers on
the feature set has always been tough to explain.  Especially if you
factor in vendor kernels with system call backports.

Thanks,
Florian
