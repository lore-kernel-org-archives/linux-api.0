From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 1/4] syscalls: Restore address limit after a syscall
Date: Wed, 8 Mar 2017 21:58:15 +0000
Message-ID: <20170308215814.GG21222@n2100.armlinux.org.uk>
References: <20170308213844.131877-1-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170308213844.131877-1-thgarnie@google.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Thomas Garnier <thgarnie@google.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Frederic Weisbecker <fweisbec@gmail.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Alexander Potapenko <glider@google.com>, Jan Beulich <JBeulich@suse.com>, "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Chris Metcalf <cmetcalf@mellanox.com>, Helge Deller <deller@gmx.de>, x86@kernel.org, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Catalin Marinas <catalin.marinas@arm.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>, Petr Mladek <pmladek@suse.com>, Rik
List-Id: linux-api@vger.kernel.org

On Wed, Mar 08, 2017 at 01:38:41PM -0800, Thomas Garnier wrote:
> This patch prevents a syscall to modify the address limit of the
> caller. The address limit is kept by the syscall wrapper and restored
> just after the syscall ends.

I would much rather architectures were given the opportunity to code up
checks like this efficiently (iow, inline in the exit path assembly),
rather than having to unconditionally call an additional function on
every syscall, with its register saving overheads.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
