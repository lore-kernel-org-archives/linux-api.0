From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 08/10] KVM: arm64: guest debug, HW assisted debug
 support
Date: Tue, 14 Apr 2015 12:23:45 +0200
Message-ID: <20150414102345.GV6186@cbox>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-9-git-send-email-alex.bennee@linaro.org>
 <20150410122520.GA3227@hawk.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150410122520.GA3227@hawk.usersys.redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 10, 2015 at 02:25:21PM +0200, Andrew Jones wrote:

[...]

> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -196,16 +196,49 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
> >   * - If the dirty bit is set, save guest registers, restore host
> >   *   registers and clear the dirty bit. This ensure that the host can
> >   *   now use the debug registers.
> > + *
> > + * We also use this mechanism to set-up the debug registers for guest
> setup

since I'm in this mood:

setup: noun or adjective
set-up: noun derived from the phrasal verb, example "Run! It's a set-up."
set up: verb

-Christoffer
