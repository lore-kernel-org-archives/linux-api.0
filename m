From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 09/10] ARM: dts: introduce MPS2 AN385/AN386
Date: Wed, 17 Feb 2016 16:48:44 +0000
Message-ID: <56C4A46C.50506@arm.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com> <1455617295-23736-10-git-send-email-vladimir.murzin@arm.com> <7562697.iiO7rmWd7c@wuerfel> <56C349E6.2000002@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56C349E6.2000002@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, linux@arm.linux.org.uk, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org, robh+dt@kernel.org, andy.shevchenko@gmail.com, galak@codeaurora.org, linux-serial@vger.kernel.org, u.kleine-koenig@pengutronix.de, tglx@linutronix.de, linux-api@vger.kernel.org, jslaby@suse.cz, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On 16/02/16 16:10, Vladimir Murzin wrote:
> On 16/02/16 11:01, Arnd Bergmann wrote:
>> On Tuesday 16 February 2016 10:08:14 Vladimir Murzin wrote:
>>> +
>>> +       ethernet@40200000 {
>>> +               compatible = "smsc,lan9220", "smsc,lan9115";
>>> +               reg = <0x40200000 0x10000>;
>>> +               interrupts = <13>;
>>> +               interrupt-parent = <&nvic>;
>>> +               smsc,irq-active-high;
>>> +       };
>>> +};
>>> +
>>>
>>
>> This node seems slightly misplaced. Is there some external bus interface
>> that this is connected to? The address suggests that it should be somewhere
>> below the /soc node, and you probably want to list the external bus
>> interface with a "ranges" property that identifies the addresses visibile
>> there, and put the external chip under there.
>>
> 
> I might messed it up since the MAC/PHY connects to the same 16-bit
> interface as the 16MB PSRAM external memory and both connected via AHB.
> 
> Not sure how it should be expressed, so some help form DT camp would be
> appreciated.

Arnd,

Does following fixup address your point on where/how ethernet node
should be placed?

diff --git a/arch/arm/boot/dts/mps2-an385.dts b/arch/arm/boot/dts/an385.dts
index 976f86d..50c8d24 100644
--- a/arch/arm/boot/dts/mps2-an385.dts
+++ b/arch/arm/boot/dts/mps2-an385.dts
@@ -63,14 +63,10 @@
 		device_type = "memory";
 		reg = <0x21000000 0x1000000>;
 	};
+};

-	ethernet@40200000 {
-		compatible = "smsc,lan9220", "smsc,lan9115";
-		reg = <0x40200000 0x10000>;
-		interrupts = <13>;
-		interrupt-parent = <&nvic>;
-		smsc,irq-active-high;
-	};
+&mb {
+	ranges = <0 0x40200000 0x10000>;
 };

 &uart0 {
diff --git a/arch/arm/boot/dts/mps2.dtsi b/arch/arm/boot/dts/mps2.dtsi
index 5d2c539..1673472 100644
--- a/arch/arm/boot/dts/mps2.dtsi
+++ b/arch/arm/boot/dts/mps2.dtsi
@@ -223,5 +223,21 @@
 				default-state = "off";
 			};
 		};
+
+	};
+
+	mb: smb {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		ethernet@0 {
+			compatible = "smsc,lan9220", "smsc,lan9115";
+			reg = <0x0 0x10000>;
+			interrupts = <13>;
+			interrupt-parent = <&nvic>;
+			smsc,irq-active-high;
+		};
 	};
 };

Cheers
Vladimir

> 
> Cheers
> Vladimir
> 
>> 	Arnd
>>
>>
>>
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> 
> 
