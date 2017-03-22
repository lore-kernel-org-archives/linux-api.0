From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v4 1/4] syscalls: Restore address limit after a syscall
Date: Wed, 22 Mar 2017 13:54:10 -0700
Message-ID: <5c59808f-6518-f51b-ee71-891b71404fc8@zytor.com>
References: <20170322203834.67556-1-thgarnie@google.com>
 <CALCETrV6K8iSfAwojMFyLrbb3CG2aF4k5hPWc7EDV4ErPDq64w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CALCETrV6K8iSfAwojMFyLrbb3CG2aF4k5hPWc7EDV4ErPDq64w@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andy Lutomirski <luto@amacapital.net>, Thomas Garnier <thgarnie@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?Q?Ren=c3=a9_Nyffenegger?= <mail@renenyffenegger.ch>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, X86 ML <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>, Rik van Riel <riel@redhat.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Kees
List-Id: linux-api@vger.kernel.org

On 03/22/17 13:44, Andy Lutomirski wrote:
> 
> While it's possible that silently papering over the bug is slightly
> faster than BUGging, it will allow bugs to continue to exist
> undetected.
> 

It would also allow the test to be inlined (at least on architectures
which have a one-site implementation) and have only the failure case out
of line, with a __noreturn annotation (which allows it to be jumped to
rather than called, which is usually available as a conditional
operation whereas call often isn't.)

That is...

extern void __noreturn __pre_usermode_state_invalid(void);

static void verify_pre_usermode_state(void)
{
	if (unlikely(!segment_eq(get_fs(), USER_DS))
		__pre_usermode_state_invalid();
}

	-hpa
