From: Rich Felker <dalias@libc.org>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl
 init and thread creation
Date: Mon, 26 Nov 2018 12:10:45 -0500
Message-ID: <20181126171045.GQ23599@brightrain.aerifal.cx>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com>
 <20181123142843.GJ23599@brightrain.aerifal.cx>
 <1150466925.11664.1542992720871.JavaMail.zimbra@efficios.com>
 <20181123173019.GK23599@brightrain.aerifal.cx>
 <865273158.11687.1542995541389.JavaMail.zimbra@efficios.com>
 <20181123183558.GM23599@brightrain.aerifal.cx>
 <1758017676.12041.1543007347347.JavaMail.zimbra@efficios.com>
 <87bm6cqm31.fsf@oldenburg.str.redhat.com>
 <688718071.12798.1543247469553.JavaMail.zimbra@efficios.com>
 <874lc3omh5.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-97553-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <874lc3omh5.fsf@oldenburg.str.redhat.com>
Sender: Rich Felker <dalias@aerifal.cx>
To: Florian Weimer <fweimer@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 26, 2018 at 05:03:02PM +0100, Florian Weimer wrote:
> * Mathieu Desnoyers:
> 
> > So let's make __rseq_abi and __rseq_refcount strong symbols then ?
> 
> Yes, please.  (But I'm still not sure we need the reference counter.)

The reference counter is needed for out-of-libc implementations
interacting and using the dtor hack. An in-libc implementation doesn't
need to inspect/honor the reference counter, but it does seem to need
to indicate that it has a reference, if you want it to be compatible
with out-of-libc implementations, so that the out-of-libc one will not
unregister the rseq before libc is done with it.

Alternatively another protocol could be chosen for this purpose, but
if has to be something stable and agreed upon, since things would
break badly if libc and the library providing rseq disagreed.

Rich
