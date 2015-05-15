From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 10/12] KVM: arm64: guest debug, HW assisted debug
 support
Date: Fri, 15 May 2015 18:01:14 +0100
Message-ID: <20150515170114.GD23652@leverpostej>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
 <1431700035-23479-11-git-send-email-alex.bennee@linaro.org>
 <20150515152346.GB23652@leverpostej>
 <87y4kpke91.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87y4kpke91.fsf@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "agraf@suse.de" <agraf@suse.de>, "drjones@redhat.com" <drjones@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, Russell King <linux@arm.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Gleb Natapov <gleb@kernel.org>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Will Deacon <Will.Deacon@arm.com>, open list <linux-kernel@vger.kernel.org>"open list:ABI/API" <linu>
List-Id: linux-api@vger.kernel.org

> > This gets more fun when you consider the context-aware breakpoints are
> > the highest numbered. So the set of (context-aware) breakpoints might
> > not intersect across all CPUs.
> 
> I didn't see a reference to that in the ARM ARM. It seemed to imply any
> breakpoint could be context aware is .BT was appropriately set and
> linked to the VR.  

The existence of ID_AA64_DFR0_EL1.CTX_CMPs implies otherwise, though I
haven't dug much deeper.

Thanks,
Mark.
