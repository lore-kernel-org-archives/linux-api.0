From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH V3 1/6] stm class: Add ioctl get_options interface
Date: Fri, 12 Feb 2016 17:18:48 +0200
Message-ID: <87ziv62bzb.fsf@ashishki-desk.ger.corp.intel.com>
References: <1454756672-12790-1-git-send-email-zhang.chunyan@linaro.org>
 <1454756672-12790-2-git-send-email-zhang.chunyan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1454756672-12790-2-git-send-email-zhang.chunyan@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Chunyan Zhang <zhang.chunyan@linaro.org>, mathieu.poirier@linaro.org
Cc: mark.rutland@arm.com, al.grant@arm.com, Michael.Williams@arm.com, corbet@lwn.net, zhang.lyra@gmail.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, tor@ti.com, broonie@kernel.org, mike.leach@arm.com, linux-api@vger.kernel.org, pratikp@codeaurora.org, nicolas.guion@st.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Chunyan Zhang <zhang.chunyan@linaro.org> writes:

> There is already an interface of set_options, but no get_options yet.
> Before setting any options, one would may want to see the current
> status of that option by means of get_options interface. This
> interface has been used in CoreSight STM driver.

I'm not sure I understand the reasoning behind this. If a userspace
program opens a communication channel and wants to configure certain
features on it, why does its choice depend on what has been configured
for this channel previously? It can be anything at all. Most likely,
it's either unconfigured or configured to its default values, but why
does this matter for a new writer?

Regards,
--
Alex
