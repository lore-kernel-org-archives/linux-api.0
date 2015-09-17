From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: Re: [PATCH 11/13] Always define MAX_RAW_MINORS as 65535 in userspace
Date: Wed, 16 Sep 2015 20:08:26 -0700 (PDT)
Message-ID: <55fa2eaa.ca39440a.feaa1.36f5@mx.google.com>
References: <55F882C7.4080304@zytor.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <55F882C7.4080304@zytor.com>
Sender: linux-arch-owner@vger.kernel.org
To: hpa@zytor.com
Cc: arnd@arndb.de, dhowells@redhat.com, viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 15 Sep 2015 13:42:47 PDT (-0700), hpa@zytor.com wrote:
> On 09/14/2015 03:50 PM, Palmer Dabbelt wrote:
>> While I don't think this was ever meant to be exposed to userspace, if
>> anyone is using it then this will at least provide a correct (if
>> unlikely) definition.
>>
>> MAX_RAW_MINORS used to be used in the kernel, where it's been replaced
>> with CONFIG_MAX_RAW_MINORS.
>>
>> Note that there's a checkpatch.pl warning about a split config string
>> here, but I've left that alone.
>
> From a UAPI perspective I would think the right value would be 2^20.

Wow, I'm super surprised.  For some reason I thought major/minor
numbers were 16 bits, but according to glibc I just have no idea what
I'm doing :).

Thanks for catching this!
