From: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v3 5/9] eeprom: Add bindings for simple eeprom framework
Date: Wed, 25 Mar 2015 08:10:06 +0100
Message-ID: <20150325071006.GC4946@pengutronix.de>
References: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1427236230-18751-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1427236230-18751-1-git-send-email-srinivas.kandagatla@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, arnd@arndb.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Brown <broonie@kernel.org>, sboyd@codeaurora.org, linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Maxime Ripard <maxime.ripard@free-electrons.com>, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 24, 2015 at 10:30:30PM +0000, Srinivas Kandagatla wrote:
> This patch adds bindings for simple eeprom framework which allows eeprom
> consumers to talk to eeprom providers to get access to eeprom cell data.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> [Maxime Ripard: intial version of eeprom framework]
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
>  .../devicetree/bindings/eeprom/eeprom.txt          | 70 ++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/eeprom/eeprom.txt
> 
> diff --git a/Documentation/devicetree/bindings/eeprom/eeprom.txt b/Documentation/devicetree/bindings/eeprom/eeprom.txt
> new file mode 100644
> index 0000000..8348d18
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/eeprom/eeprom.txt
> @@ -0,0 +1,70 @@
> += EEPROM Data Device Tree Bindings =
> +
> +This binding is intended to represent the location of hardware
> +configuration data stored in EEPROMs.
> +
> +On a significant proportion of boards, the manufacturer has stored
> +some data on an EEPROM-like device, for the OS to be able to retrieve
> +these information and act upon it. Obviously, the OS has to know
> +about where to retrieve these data from, and where they are stored on
> +the storage device.
> +
> +This document is here to document this.
> +
> += Data providers =
> +Contains bindings specific to provider drivers and data cells as children
> +to this node.
> +
> += Data cells =
> +These are the child nodes of the provider which contain data cell
> +information like offset and size in eeprom provider.
> +
> +Required properties:
> +reg:	specifies the offset in byte within that storage device, and the length
> +	in bytes of the data we care about.
> +	There could be more then one offset-length pairs in this property.
> +
> +Optional properties:
> +As required by specific data parsers/interpreters.
> +
> +For example:
> +
> +	/* Provider */
> +	qfprom: qfprom@00700000 {
> +		compatible 	= "qcom,qfprom";
> +		reg		= <0x00700000 0x1000>;
> +		...
> +
> +		/* Data cells */
> +		tsens_calibration: calib@404 {
> +			reg = <0x404 0x10>;
> +		};
> +
> +		serial_number: sn {
> +			reg = <0x104 0x4>, <0x204 0x4>, <0x30c 0x4>;
> +
> +		};
> +		...
> +	};
> +
> += Data consumers =
> +Are device nodes which consume eeprom data cells.
> +
> +Required properties:
> +
> +eeproms: List of phandle and data cell the device might be interested in.
> +
> +Optional properties:
> +
> +eeprom-names: List of data cell name strings sorted in the same order
> +	      as the eeproms property. Consumers drivers will use
> +	      eeprom-names to differentiate between multiple cells,
> +	      and hence being able to know what these cells are for.
> +
> +For example:
> +
> +	tsens {
> +		...
> +		eeproms = <&tsens_calibration>;
> +		eeprom-names = "calibration";
> +	};

This is somewhat complicated. Also having 'eeprom' in the binding is not
nice since it could be FRAM or something else. How about:

	tsens {
		calibration = <&tsens_calibration>;
	};


Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
