From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Subject: [PATCH v5 1/5] Documentation: DT: Renamed of-serial.txt to 8250.txt
Date: Fri, 16 Jan 2015 18:00:07 +0800
Message-ID: <1421402411-3479-2-git-send-email-chunyan.zhang@spreadtrum.com>
References: <sc9836-v5>
 <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: gregkh@linuxfoundation.org, mark.rutland@arm.com, arnd@arndb.de, gnomes@lxorguk.ukuu.org.uk, broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, will.deacon@arm.com, catalin.marinas@arm.com, jslaby@suse.cz, jason@lakedaemon.net, heiko@sntech.de, florian.vaussard@epfl.ch, andrew@lunn.ch, rrichter@cavium.com, hytszk@gmail.com, grant.likely@linaro.org, antonynpavlov@gmail.com, Joel.Schopp@amd.com, Suravee.Suthikulpanit@amd.com, shawn.guo@linaro.org, lea.yan@linaro.org, jorge.ramirez-ortiz@linaro.org, lee.jones@linaro.org, orsonzhai@gmail.com, geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com, wei.qiao@spreadtrum.com
Cc: devicetree@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The file of-serial.txt was only for 8250 compatible UART implementations,
so renamed it to 8250.txt to avoid confusing other persons.
This is suggested by Arnd, see:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/291455.html

Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
 .../bindings/serial/{of-serial.txt => 8250.txt}    |    0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/devicetree/bindings/serial/{of-serial.txt => 8250.txt} (100%)

diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/8250.txt
similarity index 100%
rename from Documentation/devicetree/bindings/serial/of-serial.txt
rename to Documentation/devicetree/bindings/serial/8250.txt
-- 
1.7.9.5
