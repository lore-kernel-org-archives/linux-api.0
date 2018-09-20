From: Szabolcs Nagy <szabolcs.nagy@arm.com>
Subject: Re: [RFC PATCH] glibc: Perform rseq(2) registration at nptl init and
 thread creation
Date: Thu, 20 Sep 2018 11:28:39 +0100
Message-ID: <b0a05883-befc-05f5-0bb7-d59b257238a6@arm.com>
References: <20180919144438.1066-1-mathieu.desnoyers@efficios.com>
 <c58d4d6e-f22a-f5d9-e23a-5bd72cec1a86@arm.com>
 <2052751374.8654.1537390886450.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2052751374.8654.1537390886450.JavaMail.zimbra@efficios.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: nd@arm.com, carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, libc-alpha <libc-alpha@sourceware.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 19/09/18 22:01, Mathieu Desnoyers wrote:
> ----- On Sep 19, 2018, at 1:38 PM, Szabolcs Nagy szabolcs.nagy@arm.com wrote:
>> note that libpthread.so is built with -ftls-model=initial-exec
> 
> Which would indeed make these annotations redundant. I'll remove
> them.
> 
>> (and if it wasn't then you'd want to put the attribute on the
>> declaration in the internal header file, not on the definition,
>> so the actual tls accesses generate the right code)
> 
> This area is one where I'm still uneasy on my comprehension of
> the details, especially that it goes in a different direction than
> what you are recommending.
> 
> I've read through https://www.akkadia.org/drepper/tls.pdf Section 5
> "Linker Optimizations" to try to figure it out, and I end up being
> under the impression that applying the tls_model("initial-exec")
> attribute to a symbol declaration in a header file does not have
> much impact on the accesses that use that variable. Reading through
> that section, it seems that the variable definition is the one that
> matters, and then the compiler/linker/loader are tweaking the sites
> that reference the TLS variable through code rewrite based on the
> most efficient mechanism that each phase knows can be used at each
> stage.
> 
> What am I missing ?

in general if you rely on linker relaxations you may not
get optimal code because the linker cannot remove
instructions, just nop them out.

(e.g. on aarch64 an initial-exec access is 4 instructions
a general dynamic (tlsdesc) access is 6 instructions +
it involves a call, so the return address has to be saved
and restored (+ 3 instructions for stack operations if
there were none otherwise, which the linker cannot change))
