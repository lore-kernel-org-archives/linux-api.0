From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v4 2/6] arm64: HWCAP: encapsulate elf_hwcap
Date: Wed, 3 Apr 2019 14:42:51 +0100
Message-ID: <6721d1c3-e506-dcbf-d939-4195a34e2baa@arm.com>
References: <20190403105628.39798-1-andrew.murray@arm.com>
 <20190403105628.39798-3-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-101163-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20190403105628.39798-3-andrew.murray@arm.com>
To: andrew.murray@arm.com, catalin.marinas@arm.com, will.deacon@arm.com
Cc: Szabolcs.Nagy@arm.com, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, pb@pbcl.net, libc-alpha@sourceware.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 04/03/2019 11:56 AM, Andrew Murray wrote:
> The introduction of AT_HWCAP2 introduced accessors which ensure that
> hwcap features are set and tested appropriately.
> 
> Let's now mandate access to elf_hwcap via these accessors by making
> elf_hwcap static within cpufeature.c.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
