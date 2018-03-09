From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3] arm64: signal: Ensure si_code is valid for all fault
 signals
Date: Fri, 9 Mar 2018 13:48:19 +0000
Message-ID: <20180309134818.GE15537@arm.com>
References: <1520530865-26554-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1520530865-26554-1-git-send-email-Dave.Martin@arm.com>
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

Thanks for resending this one separately -- I'll pick it up for 4.17.
Just a minor thing:

On Thu, Mar 08, 2018 at 05:41:05PM +0000, Dave Martin wrote:
> Changes since v2:
> 
>  * Rebased to v4.16-rc4.
> 
>  * Split out the SIGFPE related changes (which impact core/x86 code)
>    into a separate series.
> 
> Original blurb:

In future, please put this sort of stuff ^^ after the '---', otherwise I
have to manually remove it from the commit message when committing and
one day I'll end up forgetting.

Cheers,

Will
