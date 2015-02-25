From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] coresight-stm: adding driver for CoreSight STM component
Date: Wed, 25 Feb 2015 17:16:58 +0000
Message-ID: <20150225171658.GF8656@n2100.arm.linux.org.uk>
References: <1423088550-15780-1-git-send-email-mathieu.poirier@linaro.org>
 <1423135651.27378.32.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1423135651.27378.32.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: mathieu.poirier@linaro.org, al.grant@arm.com, linux-doc@vger.kernel.org, jeenu.viswambharan@arm.com, gregkh@linuxfoundation.org, corbet@lwn.net, liviu.dudau@arm.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, pratikp@codeaurora.org, linux-arm-kernel@lists.infradead.org, kaixu.xia@linaro.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 05, 2015 at 12:27:31PM +0100, Paul Bolle wrote:
> I'm _guessing_ that CPU_32v4 and CPU_32v4T are needed for the ldrd and
> strd assembler instructions. If that's right a next _guess_ would be
> that you also need to mention CPU_32v3 here.

No.  Double word instructions are available in some ARMv5 (ARMv5TE and
up) and from ARMv6.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
