From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2 2/3] arm64: fpsimd: Fix bad si_code for undiagnosed
 SIGFPE
Date: Thu, 15 Mar 2018 16:13:02 -0500
Message-ID: <87vadxyrdt.fsf@xmission.com>
References: <1519926248-12591-1-git-send-email-Dave.Martin@arm.com>
 <1519926248-12591-3-git-send-email-Dave.Martin@arm.com>
 <20180308171153.GD14918@arm.com> <87o9jymbsj.fsf@xmission.com>
 <20180309131017.GB20370@arm.com>
 <20180309142557.GT32331@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180309142557.GT32331@e103592.cambridge.arm.com> (Dave Martin's
 message of "Fri, 9 Mar 2018 14:25:57 +0000")
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
Cc: linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Dave Martin <Dave.Martin@arm.com> writes:

> On Fri, Mar 09, 2018 at 01:10:18PM +0000, Will Deacon wrote:
>> Hi Eric,
>> 
>> On Thu, Mar 08, 2018 at 04:40:12PM -0600, Eric W. Biederman wrote:
>> > Will Deacon <will.deacon@arm.com> writes:
>> > > Happy to take this patch once the dependency on FPE_FLTUNK in core code is
>> > > resolved.
>> > 
>> > Would it help for me to take the FPE_FLTUNK patch into my siginfo-next
>> > branch?   So that there is a common branch with the code so we don't
>> > need to worry about conflicts.  If so I will look at that on Monday.
>> 
>> Yes please, that would be helpful actually. I can then pull that into
>> arm64 if you give me a stable branch or tag. Alternatively, I can define
>> FPE_FLTUNK locally and remove it at -rc1.
>
> OK Eric, let me know if you need me to rebase anything for the first 2
> patches.

The first patch is now in my siginfo-next tree and avialable at:

git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git siginfo-next
HEAD: 266da65e9156d93e1126e185259a4aae68188d0e signal: Add FPE_FLTUNK si_code for undiagnosable fp exceptions

I will not rebase this branch, so please fee free to merge it into other
trees.

Eric
