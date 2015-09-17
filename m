From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: Re: [PATCH 03/13] Move COMPAT_ATM_ADDPARTY to net/atm/svc.c
Date: Thu, 17 Sep 2015 13:53:16 -0700 (PDT)
Message-ID: <55fb283c.f039440a.427ff.fffff187@mx.google.com>
References: <15268.1442483832@warthog.procyon.org.uk>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <15268.1442483832@warthog.procyon.org.uk>
Sender: linux-arch-owner@vger.kernel.org
Cc: dhowells@redhat.com, arnd@arndb.de, viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 17 Sep 2015 02:57:12 PDT (-0700), dhowells@redhat.com wrote:
> Palmer Dabbelt <palmer@dabbelt.com> wrote:
>
>> +#ifdef CONFIG_COMPAT
>> +/* It actually takes struct sockaddr_atmsvc, not struct atm_iobuf */
>> +#define COMPAT_ATM_ADDPARTY _IOW('a', ATMIOC_SPECIAL+4, struct compat_atm_iobuf)
>> +#endif
>
> I wonder if it would hurt to ditch the conditionals entirely.  It only eats
> cpp namespace, not C namespace so it won't affect the output if it is not used
> because the code that uses it is compiled out.

Makes sense to me.
