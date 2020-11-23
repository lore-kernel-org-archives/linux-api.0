Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6700C83012
	for <linux-api@archiver.kernel.org>; Mon, 23 Nov 2020 18:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9751D20731
	for <linux-api@archiver.kernel.org>; Mon, 23 Nov 2020 18:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732692AbgKWS40 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 23 Nov 2020 13:56:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728971AbgKWS40 (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Mon, 23 Nov 2020 13:56:26 -0500
Received: from gaia (unknown [95.146.230.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29A7420729;
        Mon, 23 Nov 2020 18:56:23 +0000 (UTC)
Date:   Mon, 23 Nov 2020 18:56:20 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Evgenii Stepanov <eugenis@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        linux-api@vger.kernel.org, Helge Deller <deller@gmx.de>,
        David Spickett <david.spickett@linaro.org>
Subject: Re: [PATCH v21 2/2] arm64: expose FAR_EL1 tag bits in siginfo
Message-ID: <20201123185620.GD2438@gaia>
References: <13cf24d00ebdd8e1f55caf1821c7c29d54100191.1605904350.git.pcc@google.com>
 <0010296597784267472fa13b39f8238d87a72cf8.1605904350.git.pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0010296597784267472fa13b39f8238d87a72cf8.1605904350.git.pcc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Nov 20, 2020 at 12:33:46PM -0800, Peter Collingbourne wrote:
> The kernel currently clears the tag bits (i.e. bits 56-63) in the fault
> address exposed via siginfo.si_addr and sigcontext.fault_address. However,
> the tag bits may be needed by tools in order to accurately diagnose
> memory errors, such as HWASan [1] or future tools based on the Memory
> Tagging Extension (MTE).
> 
> Expose these bits via the arch_untagged_si_addr mechanism, so that
> they are only exposed to signal handlers with the SA_EXPOSE_TAGBITS
> flag set.
> 
> [1] http://clang.llvm.org/docs/HardwareAssistedAddressSanitizerDesign.html
> 
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Link: https://linux-review.googlesource.com/id/Ia8876bad8c798e0a32df7c2ce1256c4771c81446

Applied to arm64 (for-next/signal-tag-bits), thanks!

[2/2] arm64: expose FAR_EL1 tag bits in siginfo
      https://git.kernel.org/arm64/c/dceec3ff7807

-- 
Catalin
