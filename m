From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] coresight-stm: adding driver for CoreSight STM
 component
Date: Thu, 26 Feb 2015 22:58:53 +0000
Message-ID: <20150226225853.GM8656@n2100.arm.linux.org.uk>
References: <1424907152-18808-1-git-send-email-mathieu.poirier@linaro.org>
 <CAL_Jsq+JYc5DBXqEcpJ0O=RdO-uuz_-GR99YsgVqT=uG6CLqJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+JYc5DBXqEcpJ0O=RdO-uuz_-GR99YsgVqT=uG6CLqJg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>, Will Deacon <will.deacon@arm.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 26, 2015 at 04:24:53PM -0600, Rob Herring wrote:
> We really shouldn't do private implementation here. It there really
> any reason not to allow readq/writeq generically for 32-bit or just
> for arm32?

My argument has always been that drivers should do the emulation of
64-bit accesses when there is no native support.

IO registers tend to have side effects when read/written.  How do we
know whether the low-half or the high-half should be written first?
This isn't something that an architecture can really dictate.  What
may be right for one hardware device may not be correct for another.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
