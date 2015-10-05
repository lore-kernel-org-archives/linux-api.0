From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 0/4] SysFS driver for QEMU fw_cfg device
Date: Mon, 5 Oct 2015 13:23:33 +0100
Message-ID: <20151005122332.GK19064@leverpostej>
References: <1443914889-9619-1-git-send-email-somlo@cmu.edu>
	<20151005100035.GA19064@leverpostej> <561263A4.2020304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <561263A4.2020304@redhat.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: peter.maydell@linaro.org, paul@pwsan.com, zajec5@gmail.com, catalin.marinas@arm.com, jordan.l.justen@intel.com, kernelnewbies@kernelnewbies.org, gregkh@linuxfoundation.org, "Gabriel L. Somlo" <somlo@cmu.edu>, galak@codeaurora.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, leif.lindholm@linaro.org, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, matt.fleming@intel.com, mst@redhat.com, hanjun.guo@linaro.org, agross@codeaurora.org, linux-api@vger.kernel.org, lersek@redhat.com, kraxel@redhat.com
List-Id: linux-api@vger.kernel.org

On Mon, Oct 05, 2015 at 01:48:52PM +0200, Paolo Bonzini wrote:
> 
> 
> On 05/10/2015 12:00, Mark Rutland wrote:
> > Some of the keys in the example look like they'd come from other sources
> > (e.g. the *-tables entries), while others look like kernel/bootloader
> > configuration options (e.g. etc/boot-fail-wait, bootorder) -- I'm
> > concerned about redundancy here.
> 
> The redundancy is because the firmware and the bootloader actually
> _consume_ these fw_cfg strings to produce the others (the ACPI tables,
> the kernel configuration options).
> 
> On the other hand, hiding some strings just because they ought to have
> been consumed already makes little sense.

Sure. However, I'm concerned that providing redundant interfaces for
those could lead to people grabbing information from here (because it's
convenient) rather than the existing canonical locations, which means we
get more software that works on fewer systems for no good reason.

What I couldn't figure out was what _additional_ information this
provided; it looked like a mixed bag of details we could already get
from disparate sources. If that's all it does, then it seems to me like
it doesn't add any benefit and potentially makes things worse.

So what do we get from this interface that we cannot get elsewhere, and
why is this the best way of exposing it?

Mark.
