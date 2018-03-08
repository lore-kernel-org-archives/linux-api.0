From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 3/3] arm64: signal: Ensure si_code is valid for all
 fault signals
Date: Thu, 8 Mar 2018 16:37:14 +0000
Message-ID: <20180308163713.GD9573@arm.com>
References: <1519926248-12591-1-git-send-email-Dave.Martin@arm.com>
 <1519926248-12591-4-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1519926248-12591-4-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, linux-api@vger.kernel.org, James Morse <james.morse@arm.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Hi Dave,

On Thu, Mar 01, 2018 at 05:44:08PM +0000, Dave Martin wrote:
> Currently, as reported by Eric, an invalid si_code value 0 is
> passed in many signals delivered to userspace in response to faults
> and other kernel errors.  Typically 0 is passed when the fault is
> insufficiently diagnosable or when there does not appear to be any
> sensible alternative value to choose.

This looks good to me. Please could you rebase it on top of for-next/core,
so that I can apply it for 4.17? The other two patches in the series need
an Ack for the core changes, so it would be worth dealing with those
separately imo.

Cheers,

Will
